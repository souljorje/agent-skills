#!/usr/bin/env node
import fs from "node:fs/promises";
import path from "node:path";

const args = process.argv.slice(2);
const rootArg = args.find((arg) => !arg.startsWith("--")) ?? "index.md";

const checkUnreferenced = args.includes("--check-unreferenced");
const checkAllEntrypoints = args.includes("--check-all-entrypoints");

const rootFile = path.resolve(process.cwd(), rootArg);
const scanDir = path.dirname(rootFile);

const EXTERNAL_LINK = /^(https?:|mailto:|tel:|urn:|data:|ftp:)/i;
const AGENT_CONTROL_FILES = new Set([
  "SKILL.md",
  "AGENTS.md",
  "CLAUDE.md",
  "GEMINI.md",
  "CURSOR.md",
  ".cursorrules",
]);

/**
 * @typedef {{
 *   severity: "error" | "warn",
 *   rule: string,
 *   file: string,
 *   line: number,
 *   message: string
 * }} Issue
 */

/** @type {Issue[]} */
const issues = [];

/** @type {Map<string, string>} */
const contentsByFile = new Map();

/** @type {Map<string, string[]>} */
const sourceEdges = new Map();

/** @type {Map<string, Set<string>>} */
const localInbound = new Map();

function rel(file) {
  return path.relative(process.cwd(), file) || ".";
}

function addIssue(severity, rule, file, line, message) {
  issues.push({ severity, rule, file, line, message });
}

async function exists(file) {
  try {
    await fs.access(file);
    return true;
  } catch {
    return false;
  }
}

async function statMaybe(file) {
  try {
    return await fs.stat(file);
  } catch {
    return null;
  }
}

async function walk(dir) {
  const out = [];

  for (const entry of await fs.readdir(dir, { withFileTypes: true })) {
    if (
      entry.name === ".git" ||
      entry.name === "node_modules" ||
      entry.name === "dist" ||
      entry.name === "build" ||
      entry.name === ".next" ||
      entry.name === "coverage"
    ) {
      continue;
    }

    const full = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      out.push(...(await walk(full)));
    } else if (entry.isFile() && entry.name.endsWith(".md")) {
      out.push(full);
    }
  }

  return out;
}

function stripCodeFencesKeepingLines(text) {
  let inFence = false;

  return text
    .split(/\r?\n/)
    .map((line) => {
      if (/^\s*(```|~~~)/.test(line)) {
        inFence = !inFence;
        return "";
      }

      return inFence ? "" : line;
    })
    .join("\n");
}

function parseFrontmatter(text) {
  const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
  if (!match) return null;

  const data = {};

  for (const line of match[1].split(/\r?\n/)) {
    const field = line.match(/^([A-Za-z_][\w-]*):\s*(.*)$/);
    if (!field) continue;

    data[field[1]] = field[2].trim();
  }

  return data;
}

function slugifyHeading(text) {
  return text
    .trim()
    .toLowerCase()
    .replace(/`([^`]+)`/g, "$1")
    .replace(/[^\p{L}\p{N}\s-]/gu, "")
    .replace(/\s+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function headingAnchors(text) {
  const anchors = new Set();
  const clean = stripCodeFencesKeepingLines(text);

  for (const line of clean.split(/\r?\n/)) {
    const match = line.match(/^#{1,6}\s+(.+)$/);
    if (match) {
      anchors.add(slugifyHeading(match[1]));
    }
  }

  return anchors;
}

function parseMarkdownLinks(line) {
  const links = [];
  const regex = /(!?)\[([^\]\n]+)\]\(([^)\n]+)\)/g;

  let match;
  while ((match = regex.exec(line))) {
    if (match[1] === "!") continue;

    links.push({
      label: match[2].trim(),
      target: match[3].trim(),
      column: match.index + 1,
    });
  }

  return links;
}

function splitTarget(rawTarget) {
  const trimmed = rawTarget.trim().replace(/^<|>$/g, "");
  const hashIndex = trimmed.indexOf("#");

  let pathPart = hashIndex === -1 ? trimmed : trimmed.slice(0, hashIndex);
  const anchor = hashIndex === -1 ? "" : trimmed.slice(hashIndex + 1);

  pathPart = pathPart.split("?")[0];

  try {
    pathPart = decodeURIComponent(pathPart);
  } catch {
    // Keep raw path if decoding fails.
  }

  return { pathPart, anchor };
}

async function resolveLocalTarget(fromFile, rawTarget) {
  const { pathPart, anchor } = splitTarget(rawTarget);

  if (EXTERNAL_LINK.test(pathPart)) {
    return { kind: "external" };
  }

  if (!pathPart && !anchor) {
    return { kind: "empty" };
  }

  const base = pathPart ? path.resolve(path.dirname(fromFile), pathPart) : fromFile;
  const stat = await statMaybe(base);

  let targetFile = null;

  if (stat?.isFile()) {
    targetFile = base;
  } else if (stat?.isDirectory()) {
    const indexFile = path.join(base, "index.md");
    if (await exists(indexFile)) {
      targetFile = indexFile;
    }
  } else if (!path.extname(base)) {
    const mdFile = `${base}.md`;
    if (await exists(mdFile)) {
      targetFile = mdFile;
    }
  }

  if (!targetFile) {
    return { kind: "missing", pathPart, anchor, attemptedPath: base };
  }

  if (anchor && targetFile.endsWith(".md")) {
    let targetText = contentsByFile.get(targetFile);

    if (!targetText) {
      targetText = await fs.readFile(targetFile, "utf8");
      contentsByFile.set(targetFile, targetText);
    }

    const anchors = headingAnchors(targetText);
    const normalizedAnchor = slugifyHeading(anchor);

    if (!anchors.has(normalizedAnchor)) {
      return { kind: "missing-anchor", pathPart, anchor, targetFile };
    }
  }

  return { kind: "ok", pathPart, anchor, targetFile };
}

function previousNonEmptyLine(lines, index) {
  for (let i = index - 1; i >= 0; i--) {
    if (lines[i].trim()) {
      return { text: lines[i], index: i };
    }
  }

  return null;
}

function hasSectionHeaderBefore(lines, index) {
  for (let i = index - 1; i >= 0; i--) {
    const line = lines[i].trim();

    if (!line) continue;
    if (/^#{2,6}\s+/.test(line)) return true;
    if (/^#\s+/.test(line)) return false;
  }

  return false;
}

function isAgentControlFile(file) {
  return AGENT_CONTROL_FILES.has(path.basename(file));
}

function checkFrontmatterAndHeading(file, text) {
  const clean = stripCodeFencesKeepingLines(text);
  const h1s = [...clean.matchAll(/^#\s+(.+)$/gm)];

  if (!isAgentControlFile(file)) {
    const frontmatter = parseFrontmatter(text);

    if (!frontmatter) {
      addIssue("error", "frontmatter", file, 1, "Missing leading frontmatter block.");
    } else {
      if (!frontmatter.title) {
        addIssue("error", "frontmatter", file, 1, "Missing required `title`.");
      }

      if (!("tags" in frontmatter)) {
        addIssue("error", "frontmatter", file, 1, "Missing required `tags`.");
      } else if (!/^\[.*\]$/.test(frontmatter.tags)) {
        addIssue(
          "error",
          "frontmatter",
          file,
          1,
          "`tags` must be an inline list, for example `tags: [docs, guide]`."
        );
      }

      if (frontmatter.title && h1s.length === 1) {
        const heading = h1s[0][1].trim();
        const title = frontmatter.title.replace(/^["']|["']$/g, "").trim();

        if (heading !== title) {
          addIssue(
            "warn",
            "heading",
            file,
            1,
            `Frontmatter title and # heading differ: "${title}" vs "${heading}".`
          );
        }
      }
    }
  }

  if (h1s.length !== 1) {
    addIssue("error", "heading", file, 1, `Expected exactly one top-level # heading, found ${h1s.length}.`);
  }
}

async function checkDeadLinksAndSource(file, text) {
  const clean = stripCodeFencesKeepingLines(text);
  const lines = clean.split(/\r?\n/);
  const sourceTargets = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const lineNo = i + 1;

    for (const link of parseMarkdownLinks(line)) {
      const resolved = await resolveLocalTarget(file, link.target);

      if (resolved.kind === "missing") {
        addIssue("error", "dead-link", file, lineNo, `Broken link to "${link.target}".`);
      }

      if (resolved.kind === "missing-anchor") {
        addIssue("error", "dead-link", file, lineNo, `Broken anchor in "${link.target}".`);
      }

      if (resolved.kind === "ok" && resolved.targetFile.endsWith(".md") && resolved.targetFile !== file) {
        if (!localInbound.has(resolved.targetFile)) {
          localInbound.set(resolved.targetFile, new Set());
        }

        localInbound.get(resolved.targetFile).add(file);
      }
    }

    const sourceMatch = line.match(/^\s*Source:\s*(.*)$/);
    if (!sourceMatch) continue;

    const sourceBody = sourceMatch[1].trim();
    const sourceLinks = parseMarkdownLinks(sourceBody);

    if (sourceLinks.length !== 1) {
      addIssue("error", "source", file, lineNo, "`Source:` must contain exactly one readable Markdown link.");
      continue;
    }

    if (!hasSectionHeaderBefore(lines, i)) {
      addIssue("error", "source", file, lineNo, "`Source:` must appear under a section heading.");
    }

    const previous = previousNonEmptyLine(lines, i);
    if (!previous || /^#{1,6}\s+/.test(previous.text.trim()) || previous.text.trim().length < 8) {
      addIssue("warn", "source", file, lineNo, "`Source:` should have a useful one- or two-line description before it.");
    }

    const target = sourceLinks[0].target;
    const { pathPart, anchor } = splitTarget(target);

    if (!pathPart || EXTERNAL_LINK.test(pathPart) || anchor) {
      addIssue("error", "source", file, lineNo, "`Source:` must point to a relative Markdown entrypoint, not a URL or anchor.");
      continue;
    }

    const resolved = await resolveLocalTarget(file, target);

    if (resolved.kind !== "ok") {
      continue;
    }

    if (!resolved.targetFile.endsWith(".md")) {
      addIssue("error", "source", file, lineNo, "`Source:` must point to a Markdown unit entrypoint.");
      continue;
    }

    sourceTargets.push(resolved.targetFile);
  }

  sourceEdges.set(file, sourceTargets);
}

function unitKeyFor(file) {
  const parsed = path.parse(file);

  if (parsed.base === "index.md") {
    return parsed.dir;
  }

  return path.join(parsed.dir, parsed.name);
}

function checkDuplicateEntrypoints(files) {
  const byUnitKey = new Map();

  for (const file of files) {
    const key = unitKeyFor(file);

    if (!byUnitKey.has(key)) {
      byUnitKey.set(key, []);
    }

    byUnitKey.get(key).push(file);
  }

  for (const group of byUnitKey.values()) {
    if (group.length <= 1) continue;

    const names = group.map(rel).join(", ");

    for (const file of group) {
      addIssue(
        "error",
        "duplicate-entrypoint",
        file,
        1,
        `Duplicate unit entrypoints detected: ${names}. Keep exactly one of name.md or name/index.md.`
      );
    }
  }
}

function reachableSourceFilesFromRoot() {
  const reachable = new Set();
  const stack = [rootFile];

  while (stack.length) {
    const file = stack.pop();
    if (!file || reachable.has(file)) continue;

    reachable.add(file);

    for (const target of sourceEdges.get(file) ?? []) {
      stack.push(target);
    }
  }

  return reachable;
}

function checkSourceCycles() {
  const visiting = new Set();
  const visited = new Set();
  const stack = [];

  function dfs(file) {
    if (visiting.has(file)) {
      const start = stack.indexOf(file);
      const cycle = [...stack.slice(start), file].map(rel).join(" -> ");

      addIssue("error", "source-cycle", file, 1, `Cycle in Source graph: ${cycle}`);
      return;
    }

    if (visited.has(file)) return;

    visiting.add(file);
    stack.push(file);

    for (const target of sourceEdges.get(file) ?? []) {
      dfs(target);
    }

    stack.pop();
    visiting.delete(file);
    visited.add(file);
  }

  for (const file of sourceEdges.keys()) {
    dfs(file);
  }
}

function checkUnreferencedFiles(files) {
  for (const file of files) {
    if (file === rootFile) continue;
    if (isAgentControlFile(file)) continue;

    const inbound = localInbound.get(file);
    if (!inbound || inbound.size === 0) {
      addIssue("warn", "unreferenced-file", file, 1, "No inbound Markdown links from scanned files.");
    }
  }
}

function sortIssues() {
  const priority = (issue) => {
    if (issue.rule === "dead-link") return 0;
    if (issue.rule === "source") return 1;
    if (issue.rule === "source-cycle") return 2;
    if (issue.rule === "duplicate-entrypoint") return 3;
    if (issue.severity === "error") return 4;
    return 5;
  };

  issues.sort((a, b) => {
    return (
      priority(a) - priority(b) ||
      a.file.localeCompare(b.file) ||
      a.line - b.line ||
      a.rule.localeCompare(b.rule)
    );
  });
}

async function main() {
  if (!(await exists(rootFile))) {
    console.error(`Root entrypoint does not exist: ${rel(rootFile)}`);
    process.exit(1);
  }

  if (!rootFile.endsWith(".md")) {
    console.error(`Root entrypoint must be a Markdown file: ${rel(rootFile)}`);
    process.exit(1);
  }

  const files = await walk(scanDir);

  for (const file of files) {
    contentsByFile.set(file, await fs.readFile(file, "utf8"));
  }

  // Dead links first, plus Source shape/target extraction.
  for (const [file, text] of contentsByFile) {
    await checkDeadLinksAndSource(file, text);
  }

  checkDuplicateEntrypoints(files);
  checkSourceCycles();

  const filesToValidate = checkAllEntrypoints ? new Set(files) : reachableSourceFilesFromRoot();

  for (const file of filesToValidate) {
    let text = contentsByFile.get(file);

    if (!text && (await exists(file))) {
      text = await fs.readFile(file, "utf8");
      contentsByFile.set(file, text);
    }

    if (text) {
      checkFrontmatterAndHeading(file, text);
    }
  }

  if (checkUnreferenced) {
    checkUnreferencedFiles(files);
  }

  sortIssues();

  for (const issue of issues) {
    const label = issue.severity.toUpperCase().padEnd(5);
    console.log(`${label} ${issue.rule.padEnd(20)} ${rel(issue.file)}:${issue.line} ${issue.message}`);
  }

  const errorCount = issues.filter((issue) => issue.severity === "error").length;
  const warnCount = issues.filter((issue) => issue.severity === "warn").length;

  if (issues.length === 0) {
    console.log("No issues found.");
  } else {
    console.log(`\n${errorCount} error(s), ${warnCount} warning(s)`);
  }

  process.exit(errorCount > 0 ? 1 : 0);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});