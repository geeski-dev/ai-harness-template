#!/usr/bin/env bash
# Tests guard-bash.sh both ways. Each case: expected_exit|command  ('|' delimiter; no command may contain '|').
# Run: bash .claude/hooks/guard-bash.test.sh   (exit 0 = all pass)
set -u
h="$(cd "$(dirname "$0")" && pwd)/guard-bash.sh"; fail=0; n=0
while IFS='|' read -r want cmd; do
  [ -z "$want" ] && continue
  n=$((n+1)); got=0
  printf '{"tool_name":"Bash","tool_input":{"command":%s}}' "$(printf '%s' "$cmd" | jq -Rs .)" | bash "$h" 2>/dev/null || got=$?
  [ "$got" = "$want" ] || { echo "FAIL want=$want got=$got :: $cmd"; fail=1; }
done <<'CASES'
2|git commit -m x --no-verify
2|git commit --no-verify -m x
2|git -c user.name=x commit -n -m x
2|git push --no-verify
2|git commit --no-gpg-sign -m x
2|git config core.hooksPath /dev/null
2|chmod -x .git/hooks/pre-commit
2|pnpm add left-pad --ignore-min-release-age
2|rm -rf /
2|rm -rf ~/
2|rm -fr ../other-project
2|git push -f origin main
2|git push --force origin main
2|git reset --hard HEAD~1
2|git clean -fd
0|git commit -m "feat(x): y"
0|git log --oneline -n 5
0|git push origin main
0|grep -n foo src/a.ts
0|pnpm test
0|pnpm test src/a.test.ts
0|rm -rf node_modules/.cache
0|rm -rf dist
CASES
[ "$fail" = 0 ] && echo "guard-bash: all $n cases pass"
exit $fail
