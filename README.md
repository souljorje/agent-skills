# Agent Skills 🤖

A personal collection of [Agent Skills](https://agentskills.io/home) crafted by [Georgii Bukharov](https://github.com/souljorje).

No scripts, just pure markdown.

## Skills

| Name | Score* | Description |
| --- | --- | --- |
| agentic-markdown | 9.5 | Use when restructuring agent-readable Markdown into deterministic context trees with required frontmatter, explicit `Source:` child links, external context tables, and lazy traversal. |
| skill-autoresearch | - | Use when building or revising a skill and you need iterative executor runs, scored confusion logs, targeted fixes, and reruns against multiple briefs until stop criteria are met. |
| socratic-mode | 9.5 | Use for clarification through Socratic dialogue: neutral, one-question-at-a-time exploration with no solutions until motives, assumptions, constraints, or goals are clearer. |

\* [Skill Autoresearch](#skill-autoresearch) average score

## Install

```bash
npx skills add souljorje/agent-skills
```

```bash
bunx skills add souljorje/agent-skills
```

```bash
pnpm dlx skills add souljorje/agent-skills
```

## Skill Autoresearch

Each skill is evaluated and improved by with [skill-autoresearch](./skills/skill-autoresearch/SKILL.md). It's workflow was inspired by [Karpathy's autoresearch](https://autoresearch.lol/).

Autoresearch evals are stable test scenarios for a skill: realistic inputs, intentional gaps, edge cases, expected outcomes. They exist to measure whether a skill actually works end to end, not just whether the instructions sound good on paper.

How it works:

- generate briefs simulating real user input
- subagents run briefs
- collect a per-step confusion log, output quality, and tool success
- fix the skill, rerun, repeat until stop criteria are met
