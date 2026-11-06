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

## D3 — TS-first template; Python support deferred
- **Date / status:** 2026-11-05 / accepted (v1)
- **Decision:** The template targets TypeScript/Node projects. Everything downstream (CLAUDE.md commands, permission rules, git hooks) calls `package.json` script names (`test`, `lint`, `typecheck`, `dev`, `setup`), never tool names, so swapping tools inside the JS ecosystem changes only the stack line in CLAUDE.md and the project's `package.json`.
- **Why:** Most planned projects use this stack. The skills, `.scratch/`, `DECISIONS.md`, git guardrails and commit convention are already language-neutral; only commands, permission rules and the pre-commit hook are tied to the package manager.
- **Cost:** A Python project would need those three places rewritten by hand.
- **Rejected alternative:** A `make`/`just` task-runner contract (one template for any language; extra layer to learn and debug, allow rules written against `make` instead of real tools). Separate per-language templates (simpler files, but two copies that drift). Both deferred, not rejected.
- **Revisit when:** The first non-Node project starts.

## D4 — pnpm is the package manager
- **Date / status:** 2026-11-05 / accepted. Supersedes the `setup` script name in D3 (now `install-hooks`).
- **Decision:** Projects from this template use pnpm (12.x at time of writing). Commands are `pnpm install --frozen-lockfile`, `pnpm test`, `pnpm lint`, `pnpm typecheck`, `pnpm dev`, `pnpm run install-hooks`.
- **Why:** Three defaults that matter with an agent installing code: dependency install scripts are blocked until approved (checked on 12.18: adding `esbuild` stops with `ERR_PNPM_IGNORED_BUILDS`), so a hallucinated or typosquatted package cannot run code on install; versions published less than a day ago are not resolved (default since pnpm 11), a defence against freshly published malicious releases; strict `node_modules`, so code can only import declared dependencies. Also faster installs and less disk.
- **Cost:** pnpm must be installed on each machine (`npm i -g pnpm`). The first install of a Vite project stops at `esbuild`'s build script until `pnpm approve-builds` is run. `npx` becomes `pnpm dlx`/`pnpm exec`; some docs and tools assume npm. `pnpm setup` is a built-in pnpm command, so the hook-installer script is named `install-hooks` and must be called with `pnpm run`.
- **Rejected alternative:** npm (the default everyone knows; none of the three protections without extra configuration). Bun/Yarn not evaluated.
- **Revisit when:** A project needs a tool that does not work under pnpm's strict `node_modules`, or the defaults above change.
