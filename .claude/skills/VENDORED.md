# Vendored skills

These skill folders are copied verbatim from https://github.com/mattpocock/skills
at commit `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` (2026-10-31). MIT licence: `LICENSE-mattpocock-skills`.

| Skill | Upstream path | Role in the harness |
|---|---|---|
| grill-me | skills/productivity/grill-me | `/grill-me`: entry point; hands off to `grilling` |
| grilling | skills/productivity/grilling | the interview itself (rounds, recommended answers) |
| to-spec | skills/engineering/to-spec | `/to-spec`: conversation → `.scratch/<feature>/spec.md` |
| to-tickets | skills/engineering/to-tickets | `/to-tickets`: spec → `.scratch/<feature>/issues/NN-*.md` |
| implement | skills/engineering/implement | `/implement`: one ticket, via `tdd`, ends with `code-review` |
| tdd | skills/engineering/tdd | red → green at agreed seams (called by `implement`) |
| code-review | skills/engineering/code-review | standards + spec review in fresh sub-agents |
| codebase-design | skills/engineering/codebase-design | vocabulary reference `tdd` calls when an interface is unclear |

`docs/agents/*.md` are upstream's `setup-matt-pocock-skills` seed files, copied verbatim, configured for the
local-markdown tracker (`issue-tracker-local.md` → `issue-tracker.md`). We do not vendor the setup skill itself.

Not copied: each skill's `agents/openai.yaml` (Codex metadata).

Rules:
- Do not edit these files in place. Our changes go in CLAUDE.md, settings, hooks, or our own skills.
- To update: re-copy from a newer upstream commit, diff, and record the change in `DECISIONS.md`.
