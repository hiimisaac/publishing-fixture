#!/bin/sh
# Runs as repo code inside the Packages check and the release check. Prints where a GitHub
# credential could be found, never a value. Does nothing outside CodeBuild.
[ -n "$CODEBUILD_BUILD_ID" ] || exit 0

pattern='gh[opsu]_[A-Za-z0-9]{30}|github_pat_[A-Za-z0-9_]{30}|x-access-token:[^@[:space:]]+@|extraheader|authorization: *basic +[A-Za-z0-9+/=]{16}|https://[^/@[:space:]]+:[^/@[:space:]]+@github\.com'
say() { echo "PROBE $*"; }
here=$(pwd)

say "start: $CODEBUILD_BUILD_ID in $here"
say "refs fetched before the scrub: $(git for-each-ref --format='%(refname)' refs/publishing | tr '\n' ' ')"
say "remotes left: [$(git remote -v | tr '\n' ' ')]"
say "worktrees: $(git worktree list | wc -l | tr -d ' ')"

git config --list --show-origin 2>/dev/null |
  grep -Ei 'credential|extraheader|insteadof|askpass|token' |
  sed 's/=.*/=<hidden>/' | while read -r line; do say "FOUND git setting: $line"; done

for f in "$HOME/.gitconfig" "$HOME/.config/git/config" /etc/gitconfig \
  "$HOME/.git-credentials" "$HOME/.config/git/credentials" "$HOME/.netrc" \
  "$HOME/.config/gh/hosts.yml" "$here/.git/config"; do
  if [ -r "$f" ] && grep -Eiq "$pattern" "$f"; then say "FOUND in $f"; fi
done

env | cut -d= -f1 | grep -Ei 'token|github|git_|connection|credential' |
  while read -r name; do say "environment name: $name"; done
if env | grep -Eiq "$pattern"; then say "FOUND in this environment"; fi

for p in /proc/[0-9]*; do
  if grep -Eaiqs "$pattern" "$p/environ"; then
    say "FOUND in the environment of process ${p#/proc/}: $(tr '\0' ' ' < "$p/cmdline" | cut -c1-80)"
  fi
done

grep -rEIil --exclude-dir=node_modules --exclude-dir=.bun --exclude-dir=_cacache "$pattern" \
  "$HOME" /codebuild /tmp /etc 2>/dev/null | grep -v /scripts/probe.sh | sort -u | head -40 |
  while read -r f; do say "FOUND in file: $f"; done

if GIT_TERMINAL_PROMPT=0 GIT_ASKPASS=/bin/false git push --quiet --dry-run \
  https://github.com/hiimisaac/publishing-fixture.git HEAD:refs/heads/probe-push >/dev/null 2>&1; then
  say "FOUND: git push by URL was allowed"
else
  say "git push by URL refused"
fi

if aws secretsmanager get-secret-value --secret-id packages/github-token \
  --query Name --output text >/dev/null 2>&1; then
  say "FOUND: the bot token secret is readable"
else
  say "bot token secret refused"
fi

say "end"
exit 0
