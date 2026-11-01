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
    [[ "$key" == "DEST" ]] && DEST="$value"
done < "$CONFIG"

if [[ -z "$DEST" ]]; then
    echo "Error: DEST not found in deploy.conf"
    exit 1
fi

SRC="$DIR/.."

rm -rf "$DEST"
mkdir -p "$DEST/modules"
mkdir -p "$DEST/settings"
mkdir -p "$DEST/textures"

VERSION="$(git -C "$SRC" describe --tags --abbrev=7 --dirty 2>/dev/null || echo dev)"
sed "s/@project-version@/$VERSION/" "$SRC/YaworsCleanUI.toc" > "$DEST/YaworsCleanUI.toc"
cp "$SRC/Core.lua"          "$DEST/"
cp "$SRC/Migrations.lua"    "$DEST/"
cp "$SRC/Settings.lua"      "$DEST/"
cp "$SRC"/modules/*.lua     "$DEST/modules/"
cp "$SRC"/settings/*.lua    "$DEST/settings/"
cp "$SRC"/textures/*        "$DEST/textures/"

echo "Done."
