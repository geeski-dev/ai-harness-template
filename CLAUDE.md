# <project>

<One or two sentences: what this is and who it's for.>

Stack: Vite + React + TypeScript (strict) frontend, Hono API. Vitest, ESLint + Prettier, Zod. pnpm.

## Commands
- `pnpm install --frozen-lockfile` — install. Never `pnpm add <pkg>`; see Dependencies.
- `pnpm test` · `pnpm lint` · `pnpm typecheck` — all three must pass before any commit.
- `pnpm test <file>` — run one test file.
- `pnpm dev` — frontend + API.
- `pnpm run install-hooks` — install the git pre-commit hook (once per clone).

## Verify before you say done
Run tests, lint and typecheck and show the output. Never commit with failures.
Never use `--no-verify` or edit git hooks; a hook blocks both. Fix the code instead.
If a test cannot pass after two honest attempts, stop and report the failing assertion, what you tried,
and your best hypothesis. Never weaken, skip or delete a test, or widen a type to `any`, to get green.

## Workflow
- Plan: `/grill-me` → `/to-spec` → `/to-tickets`. Specs and tickets live in `.scratch/<feature>/`.
- Build: `/implement <ticket path>`. One ticket per session. After its commit, stop so the human can `/clear`;
  do not start the next ticket.
- When `code-review` reports, stop and wait for the human to say which findings to fix before committing.
- Read `DECISIONS.md` before any architectural change (module boundary, data model, external dependency).
  The skills look for `docs/adr/`; this repo uses `DECISIONS.md` instead (D2). Propose an entry for any
  contested decision; the human approves it before it is committed.

## Conventions the code does not show
- Anything with logic: write the failing test, see it fail, then implement.
- Pure logic lives in modules with no I/O; I/O (HTTP, DB, model calls, processes) stays at the edges.
- Style is the formatter/linter's job; its config file is authoritative. Run `pnpm lint`; don't hand-format.

## Dependencies
Propose a new dependency with name, version, why, and the alternative considered. The human runs the install.

## Commits
Conventional commits, one logical change per commit.
- Title: `type(scope): what changed`, imperative ("add", not "added"), about 60 characters max. Scope optional.
  Types: `feat`, `fix`, `test`, `refactor` (no behaviour change), `docs`, `chore` (setup, tooling).
- Body: 1–3 sentences on why, plus references (ticket path, DECISIONS.md entry, upstream source).

## Agent skills

### Issue tracker
Local markdown files under `.scratch/<feature>/`. See `docs/agents/issue-tracker.md`.

### Triage labels
Default five-role vocabulary, recorded as a `Status:` line in each ticket. See `docs/agents/triage-labels.md`.

### Domain docs
Single-context layout. See `docs/agents/domain.md`.
