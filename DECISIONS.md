# Decisions

Only contested or easily-overturned decisions go here. Accepted entries are not edited; supersede them with a new entry.
Format: decision / why / cost / rejected alternative / revisit when.
Agents: read this before any architectural change. An agent may draft an entry; the human approves it before it is committed. Append, never rewrite.

## D1 — Commit `.scratch/` (specs and tickets) and `evals/RESULTS.md`
- **Date / status:** 2026-11-05 / accepted
- **Decision:** `.scratch/<feature>/` (spec.md and issues/NN-*.md from the vendored local-markdown tracker) is committed, not gitignored. `evals/RESULTS.md` is committed once it exists. `traces/` stays ignored.
- **Why:** Claude Code's search tools are ripgrep-based and skip gitignored files by default, so skills that search for a spec or ticket (e.g. `code-review` looking under `.scratch/` for the branch's spec) could miss it if the folder were ignored. Committed specs also sit next to the code they produced, for anyone reading the repo. `evals/RESULTS.md` is the before/after evidence for prompt changes; `traces/` holds raw prompts and model output and is summarized instead.
- **Cost:** History gets noisy: every ticket `Status:` change and disposable ticket file lands in commits.
- **Rejected alternative:** Ignore all of `.scratch/` (clean history; tickets are disposable) — rejected for v1 because of the search risk above, unverified. Commit specs but ignore `issues/` — a reasonable middle ground, deferred until the search behaviour is checked.
- **Revisit when:** After v1. Check whether Claude Code's Grep/Glob find files under an ignored `.scratch/`; if they do, prefer ignoring `issues/` (or all of `.scratch/`) to keep history clean.

## D2 — `DECISIONS.md` is the decision log, not Pocock's `docs/adr/`
- **Date / status:** 2026-11-05 / accepted (v1)
- **Decision:** Contested decisions are recorded in this single file, in the decision / why / cost / rejected alternative / revisit-when format. `CLAUDE.md` tells agents to read it before architectural changes. No `docs/adr/` folder for now.
- **Why:** The research makes the rejected alternative mandatory, because a stateless agent will silently overturn a choice it doesn't know was deliberate; Pocock's ADR template makes it optional. One file is also faster to read whole than a folder.
- **Cost:** The vendored skills (`to-spec`, `to-tickets`, `tdd`, via `docs/agents/domain.md`) look for `docs/adr/` and `GLOSSARY.md` and skip silently when absent, so they never read this file on their own. The only pointer is the `CLAUDE.md` line; if an agent skips it, decisions go unread.
- **Rejected alternative:** Adopt Pocock's `docs/adr/NNNN-slug.md` layout (the skills would read decisions automatically) — deferred, not rejected outright, because it means either loosening our required fields or adding them to his template.
- **Revisit when:** After v1. Options: switch to `docs/adr/` with our fields as the template; or point `docs/agents/domain.md` at `DECISIONS.md` (that edits a vendored file, which `VENDORED.md` forbids, so it would need its own entry).
