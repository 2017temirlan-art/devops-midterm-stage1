#!/bin/bash
# run_part2_git.sh - executes Git tasks 2.1-2.4 (init, feature branch, conflict, tag, optional push).
# Usage: ./run_part2_git.sh "you@example.com" [GITHUB_USER]
#   With GITHUB_USER and the `gh` CLI logged in (gh auth login) the GitHub repo is created and everything is pushed.
set -euo pipefail
EMAIL="${1:?Usage: $0 email [github_user]}"; GHUSER="${2:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJ="$(find "$ROOT" -maxdepth 1 -type d -name '*-student-api' | head -1)"
base="$(basename "$PROJ")"; w1="${base%%-*}"; rest="${base#*-}"; w2="${rest%%-*}"
W1="${w1^}"; W2="${w2^}"; NAME="$W1 $W2"; P="$ROOT/handoff/feature_patches"
cd "$PROJ"
[ -d .git ] && { echo ".git already exists - aborting"; exit 1; }

git init -q -b main
git config user.name "$NAME"; git config user.email "$EMAIL"
[ -f .env ] || cp .env.example .env            # local secret file, ignored by git
git add .
git status --short | grep -q '\.env$' && { echo "ERROR: .env staged"; exit 1; }
git check-ignore -v .env
git commit -q -m "Initial commit: $NAME Student API"

git switch -q -c "feature/${w1}-${w2}-crud"
for p in 0001-add-validation-to-create-and-update 0002-add-validation-tests; do git apply "$P/$p.patch"; done
git add -A src build.gradle; git commit -q -m "Add input validation to create and update student operations ($NAME)"
cat >> README.md <<EOT

## Change log

- $NAME: added Bean Validation (\`@NotBlank\`, \`@Email\`) to the create (POST) and update (PUT) operations. Invalid requests now return HTTP 400 with a JSON error message.
EOT
sed -i 's/^Status: .*/Status: validation added to create and update operations./' README.md
git add -A; git commit -q -m "Update README with $NAME and description of the validation change"
git switch -q main; git merge -q --no-ff "feature/${w1}-${w2}-crud" -m "Merge feature/${w1}-${w2}-crud into main ($NAME)"

git switch -q -c "feature/${w1}-${w2}-documentation" main
sed -i 's/^Status: .*/Status: documentation branch - API documentation extended by '"$NAME"'./' README.md
git commit -q -am "docs: change README status line on documentation branch ($NAME)"
git switch -q main; git switch -q -c "feature/${w1}-${w2}-readme-status"
sed -i 's/^Status: .*/Status: ready for Docker and Jenkins stages - updated by '"$NAME"'./' README.md
git commit -q -am "docs: change README status line on readme-status branch ($NAME)"
git switch -q main
git merge -q "feature/${w1}-${w2}-documentation"
git merge "feature/${w1}-${w2}-readme-status" || echo ">>> expected conflict in README.md"
sed -i '/^<<<<<<< /d;/^=======$/d;/^>>>>>>> /d' README.md
sed -i '/^Status: documentation branch/d; s/^Status: ready for Docker.*/Status: documentation and readme status merged by '"$NAME"'./' README.md
! grep -nE '^(<<<<<<<|=======|>>>>>>>)' README.md
git add README.md
git commit -q -m "Resolve README.md merge conflict between documentation and readme-status branches ($NAME)"
git tag -a "v1.0-${w1}-${w2}" -m "Release v1.0 - $NAME Student API"
git log --oneline --graph --decorate --all; git branch -a; git tag

if [ -n "$GHUSER" ]; then
  gh repo create "$base" --public --source=. --remote=origin
  git push -u origin main --follow-tags
  git push origin "feature/${w1}-${w2}-crud" "feature/${w1}-${w2}-documentation" "feature/${w1}-${w2}-readme-status"
  git remote -v; echo "https://github.com/$GHUSER/$base"
else
  echo "No GitHub user given: create the repo and push manually (see README.md section 'Publish')."
fi
