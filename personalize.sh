#!/bin/bash
# personalize.sh - replaces the example name "Asan Abai" with the student's real name everywhere.
#
# Usage (from the unpacked ZIP root, BEFORE running `git init`):
#   ./personalize.sh <Word1> <Word2>
#
# Word1 Word2 keep the same order as in the example "Asan Abai" (Asan = Word1, Abai = Word2),
# so file names become Word1_Word2_system_report.sh, repository word1-word2-student-api, etc.
# Only ASCII letters are allowed (Latin transliteration of the name).
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <Word1> <Word2>" >&2
    exit 1
fi

W1="$1"; W2="$2"
for w in "$W1" "$W2"; do
    if ! [[ "$w" =~ ^[A-Za-z]+$ ]]; then
        echo "Error: '$w' must contain ASCII letters only." >&2
        exit 1
    fi
done

OLD1="Asan"; OLD2="Abai"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OLD_DIR="$ROOT/asan-abai-student-api"
if [ ! -d "$OLD_DIR" ]; then
    echo "Error: $OLD_DIR not found (already personalized?)." >&2
    exit 1
fi
if [ -d "$ROOT/.git" ] || [ -d "$OLD_DIR/.git" ]; then
    echo "Error: a .git directory exists. Run this script before git init." >&2
    exit 1
fi

W1_LOWER="${W1,,}"; W2_LOWER="${W2,,}"
W1_UPPER="${W1^^}"; W2_UPPER="${W2^^}"
# Title-case the words the way the user typed them
SED_EXPR="s/${OLD1}/${W1}/g; s/${OLD2}/${W2}/g; s/asan/${W1_LOWER}/g; s/abai/${W2_LOWER}/g; s/ASAN/${W1_UPPER}/g; s/ABAI/${W2_UPPER}/g"

# 1) replace text inside files (everything in the project + handoff docs and patches, except this script and HANDOFF_1.md)
mapfile -t FILES < <(find "$OLD_DIR" "$ROOT/handoff" -type f \( -name "*.java" -o -name "*.md" -o -name "*.sh" -o -name "*.properties" -o -name "*.gradle" -o -name "*.yml" -o -name "*.patch" -o -name "Dockerfile" -o -name "Jenkinsfile" -o -name ".env.example" -o -name ".gitignore" -o -name ".dockerignore" \))
for f in "${FILES[@]}"; do
    sed -i -E "$SED_EXPR" "$f"
done

# 2) rename files whose names contain the example name
while IFS= read -r f; do
    new="$(dirname "$f")/$(basename "$f" | sed -E "$SED_EXPR")"
    [ "$f" != "$new" ] && mv "$f" "$new"
done < <(find "$OLD_DIR" -type f -name "*Asan*")

# 3) rename the project directory
NEW_DIR="$ROOT/${W1_LOWER}-${W2_LOWER}-student-api"
mv "$OLD_DIR" "$NEW_DIR"

echo "Done. Project directory: $NEW_DIR"
echo "Script:  $NEW_DIR/scripts/${W1}_${W2}_system_report.sh"
echo "Remaining manual edits: student identifier / email in src/main/resources/application.properties"
echo "                        and in StudentControllerTest.java if you want a real student ID instead of ${W1_UPPER}-${W2_UPPER}-001."
