#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$(cd "$DIR/.." && pwd)"
OUT="$SRC/dist"

VERSION="$(sed -n 's/^## Version:[[:space:]]*//p' "$SRC/YaworsCleanUI.toc" | tr -d '\r')"
if [[ -z "$VERSION" ]]; then
    echo "Error: ## Version not found in YaworsCleanUI.toc"
    exit 1
fi

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# CurseForge expects the addon folder at the zip root.
ADDON="$STAGE/YaworsCleanUI"
mkdir -p "$ADDON/modules"
mkdir -p "$ADDON/settings"
mkdir -p "$ADDON/textures"

cp "$SRC/YaworsCleanUI.toc" "$ADDON/"
cp "$SRC/Core.lua"          "$ADDON/"
cp "$SRC/Settings.lua"      "$ADDON/"
cp "$SRC/LICENSE"           "$ADDON/"
cp "$SRC/CHANGELOG.md"      "$ADDON/"
cp "$SRC"/modules/*.lua     "$ADDON/modules/"
cp "$SRC"/settings/*.lua    "$ADDON/settings/"
cp "$SRC"/textures/*        "$ADDON/textures/"

ZIP="$OUT/YaworsCleanUI-$VERSION.zip"
mkdir -p "$OUT"
rm -f "$ZIP"

if command -v zip >/dev/null; then
    (cd "$STAGE" && zip -rq "$ZIP" YaworsCleanUI)
elif command -v bsdtar >/dev/null; then
    bsdtar --format zip -cf "$ZIP" -C "$STAGE" YaworsCleanUI
else
    echo "Error: neither zip nor bsdtar is installed"
    exit 1
fi

echo "Done: $ZIP"
