#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$DIR/deploy.conf"

if [[ ! -f "$CONFIG" ]]; then
    echo "Error: $CONFIG not found. Copy deploy.conf.example to deploy.conf and set your paths."
    exit 1
fi

RETAIL=""
FOREVER=""
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    key="${line%%=*}"
    value="${line#*=}"
    [[ "$key" == "RETAIL" ]] && RETAIL="$value"
    [[ "$key" == "FOREVER" ]] && FOREVER="$value"
done < "$CONFIG"

if [[ -z "$RETAIL" && -z "$FOREVER" ]]; then
    echo "Error: neither RETAIL nor FOREVER found in deploy.conf"
    exit 1
fi

SRC="$DIR/.."
VERSION="$(git -C "$SRC" describe --tags --abbrev=7 2>/dev/null || echo dev)_$(date '+%F_%H:%M')"

# Both games get the same files, like the release zip; each client picks its own TOC.
copy_addon() {
    local dest="$1"
    rm -rf "$dest"
    mkdir -p "$dest/modules"
    mkdir -p "$dest/settings"
    mkdir -p "$dest/textures"

    sed "s/@project-version@/$VERSION/" "$SRC/YaworsCleanUI.toc"         > "$dest/YaworsCleanUI.toc"
    sed "s/@project-version@/$VERSION/" "$SRC/YaworsCleanUI_Camelot.toc" > "$dest/YaworsCleanUI_Camelot.toc"
    cp "$SRC/Core.lua"          "$dest/"
    cp "$SRC/Retail.lua"        "$dest/"
    cp "$SRC/Utils.lua"         "$dest/"
    cp "$SRC/Migrations.lua"    "$dest/"
    cp "$SRC/Settings.lua"      "$dest/"
    cp "$SRC"/modules/*.lua     "$dest/modules/"
    cp "$SRC"/settings/*.lua    "$dest/settings/"
    cp "$SRC"/textures/*        "$dest/textures/"
    echo "Copied to $dest"
}

[[ -n "$RETAIL" ]] && copy_addon "$RETAIL"
[[ -n "$FOREVER" ]] && copy_addon "$FOREVER"

echo "Done."
