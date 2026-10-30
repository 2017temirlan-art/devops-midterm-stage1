#!/bin/bash
# run_part1.sh - executes Part 1 (Linux) inside the project. Run from the unpacked archive root, AFTER personalize.sh.
# Usage: ./run_part1.sh        (output is the terminal evidence; copy/screenshot it)
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJ="$(find "$ROOT" -maxdepth 1 -type d -name '*-student-api' | head -1)"
base="$(basename "$PROJ")"; w1="${base%%-*}"; rest="${base#*-}"; w2="${rest%%-*}"
W1="${w1^}"; W2="${w2^}"
cd "$PROJ"
SCRIPT="scripts/${W1}_${W2}_system_report.sh"; LOG="logs/${W1}_${W2}_system_report.log"

echo "### 1.1 tree and required files"
(command -v tree >/dev/null && tree -a -I '.git|.gradle|build' .) || find . -not -path './.git*' | sort
for f in scripts logs backups src Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md "$SCRIPT" "$LOG"; do
  [ -e "$f" ] && echo "OK      $f" || { echo "MISSING $f"; exit 1; }
done

echo "### 1.2/1.3 chmod 755, run script"
chmod 755 "$SCRIPT"
"./$SCRIPT"

echo "### 1.3 backup of README.md"
cp README.md "backups/README_${W1}_${W2}_backup.md"
ls -l "$SCRIPT" "backups/README_${W1}_${W2}_backup.md"
diff README.md "backups/README_${W1}_${W2}_backup.md" && echo "Backup contents identical to README.md"

echo "### 1.4 processes / Java"
ps aux | head -5
ps aux | grep -i '[j]ava' || echo "No Java process is running"
echo "--- last 5 lines of log"; tail -n 5 "$LOG"
echo "--- grep surname -> analysis file"
grep -n "$W1" "$LOG" > "logs/${W1}_${W2}_log_analysis.txt" || true
cat "logs/${W1}_${W2}_log_analysis.txt"
echo "'>' overwrites a file, '>>' appends to it (see handoff/EXPLANATIONS.md)."
