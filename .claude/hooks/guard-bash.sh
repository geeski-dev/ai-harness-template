#!/usr/bin/env bash
# PreToolUse guard for Claude Code's Bash tool.
# stdin: hook JSON {tool_name, tool_input:{command}, cwd, agent_type?, ...}
# exit 0 = allow, exit 2 = block (stderr is shown to Claude as the reason). Exit 1 is NOT a block.
set -u

# Fail closed: without jq we can't read the command, and silently allowing everything is the worst outcome.
command -v jq >/dev/null 2>&1 || { echo 'guard-bash: jq is not installed; blocking all Bash until it is (brew install jq)' >&2; exit 2; }

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

deny() { printf 'guard-bash: blocked: %s\n  command: %s\n' "$1" "$cmd" >&2; exit 2; }

# Regexes avoid \b (not portable to macOS grep) and never cross a pipe/semicolon/& ([^|;&]*).
# Deliberately over-broad: a false block costs one rephrased command; a false allow costs a bad commit.

# 1. Skipping git hooks or signing.
if printf '%s' "$cmd" | grep -Eq 'git[^|;&]*[[:space:]](commit|push|merge|rebase)[^|;&]*(--no-verify|--no-gpg-sign|[[:space:]]-n([[:space:]]|$))'; then
  deny 'git --no-verify / --no-gpg-sign / -n is not allowed; fix the code so the hook passes'
fi
# 2. Editing or re-pointing git hooks.
if printf '%s' "$cmd" | grep -Eq 'core\.hooksPath|\.git/hooks|hooks/pre-commit|husky'; then
  deny 'editing or re-pointing git hooks is not allowed (read hook sources with the Read tool, not Bash)'
fi
# 3. Bypassing pnpm's one-day minimum release age (DECISIONS.md D4).
if printf '%s' "$cmd" | grep -Eq -- '--ignore-min-release-age'; then
  deny "bypassing pnpm's minimum release age is not allowed; ask the human"
fi
# 4. rm -rf aimed outside the working tree.
if printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|])rm[[:space:]]+(-[a-zA-Z]*[rRf][a-zA-Z]*[[:space:]]+)+(/|~|\.\.|\$HOME|\*)'; then
  deny 'rm -rf outside the working tree'
fi
# 5. Destructive git.
if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(push[[:space:]][^|;&]*(--force|-f([[:space:]]|$))|reset[[:space:]]+--hard|clean[[:space:]]+-[a-zA-Z]*f)'; then
  deny 'destructive git command; ask the human to run it'
fi

exit 0
