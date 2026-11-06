#!/usr/bin/env bash
# `pnpm run install-hooks` — copies versioned git hooks into .git/hooks and makes harness scripts executable.
# Copies rather than symlinks: .git/hooks is outside the tracked tree, so a copy can't be changed by editing a tracked file.
set -eu
root=$(git rev-parse --show-toplevel)
if [ -n "$(git -C "$root" config --get core.hooksPath || true)" ]; then
  echo "install-hooks: core.hooksPath is set ($(git -C "$root" config --get core.hooksPath)); git will ignore .git/hooks." >&2
  echo "install-hooks: unset it (git config --unset core.hooksPath, or --global) and re-run." >&2
  exit 1
fi
install -m 0755 "$root/scripts/hooks/pre-commit" "$root/.git/hooks/pre-commit"
chmod +x "$root"/.claude/hooks/*.sh
echo 'install-hooks: pre-commit installed'
