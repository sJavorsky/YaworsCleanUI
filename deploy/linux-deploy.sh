#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$DIR/deploy.conf"

if [[ ! -f "$CONFIG" ]]; then
    echo "Error: $CONFIG not found. Copy deploy.conf.example to deploy.conf and set your paths."
    exit 1
fi

DEST=""
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    key="${line%%=*}"
    value="${line#*=}"
    [[ "$key" == "LINUX_DEST" ]] && DEST="$value"
done < "$CONFIG"

if [[ -z "$DEST" ]]; then
    echo "Error: LINUX_DEST not found in deploy.conf"
    exit 1
fi

SRC="$DIR/.."

rm -rf "$DEST"
mkdir -p "$DEST/modules"

cp "$SRC/YaworsCleanUI.toc" "$DEST/"
cp "$SRC/Core.lua"         "$DEST/"
cp "$SRC/Settings.lua"     "$DEST/"
cp "$SRC"/modules/*.lua    "$DEST/modules/"

echo "Done."
