# YaworsCleanUI

WoW retail addon. This folder is the project root. Do NOT create a wrapping subfolder.

## Project

A personal UI cleanup addon replacing functionality previously handled by WeakAuras (which lost support in The War Within / Midnight transition). Focuses on hiding specific UI elements and filtering chat spam, with settings integrated directly into the Blizzard Interface Options panel (not a separate window).

## Structure

Each feature is split across two parallel files with the same base name:

- `modules/<Feature>.lua` — the logic. Registers events, manipulates frames, and exposes `applySettings()`.
- `settings/<Feature>.lua` — the Blizzard options UI for that feature. Registers checkboxes/sliders/color swatches whose setters write to SavedVariables and call the module's `applySettings()`.

```
YaworsCleanUI.toc            -- addon manifest, load order
Core.lua                     -- global table, SavedVariables defaults, module registry, ADDON_LOADED backbone
Settings.lua                 -- root options category + subcategories, shared control helpers
modules/
  HideElements.lua           -- hide loot window / bag icons
  MoveElements.lua           -- reposition queue eye, BNet toast
  FilterChat.lua             -- chat spam filtering
  ClassResourcePoints.lua    -- discrete point resources (combo points, runes, holy power, ...)
  ClassResourceBars.lua      -- continuous bar resources (rage, energy, runic power, ...)
  PlayerPosition.lua         -- player position indicator
  CursorPosition.lua         -- cursor-following rings + radial spell-cast/GCD trackers
settings/                    -- one options file per module, same base names
textures/                    -- bar fill masks / atlases, addon icon
media/                       -- CurseForge logo and screenshots (not deployed)
deploy/                      -- scripts to copy the addon into the live WoW AddOns folder
reference/                   -- other addons cloned for API reference (gitignored, read-only)
```

Adding a feature: create `modules/X.lua` and `settings/X.lua`, register both in the TOC (settings files before module files — see load order below), add a subcategory in Settings.lua plus an entry in `settingsCategories`, add its defaults in Core.lua's `DEFAULTS`, and update the deploy scripts if you add a new top-level file or folder.

**Load order** (from the TOC): `Core.lua` → `Settings.lua` → `settings/*.lua` → `modules/*.lua`. Settings files load before modules but only reference module tables inside callbacks (which run later), so the ordering is safe.

## Lua conventions

- **Indentation**: 4 spaces
- **Naming**:
  - Addon namespace/table: `YaworsCleanUI` (single global, used as the addon table)
  - Module tables: PascalCase (`HideElements`, `ChatFilter`)
  - Functions: camelCase (`hideDefaultBags`, `onEvent`)
  - Local variables: camelCase (`isHidden`, `savedVars`)
  - Constants: UPPER_SNAKE_CASE (`DEFAULT_HIDE_BAGS`)
  - WoW API calls follow Blizzard's own casing (they already use PascalCase/mixed — don't fight it)
- **Locals**: Always `local`. Minimize globals — only `YaworsCleanUI` should be global.
- **No abbreviations**: Use full words. Not `mod`, `db`, `f`, `fn`, `cb` — use `module`, `database`, `frame`, `callback`, etc. Only shorten if the full name collides with a Lua or WoW API reserved word.
- **Module pattern**: Each module file declares a local table named `module`, attaches it to `YaworsCleanUI`, and registers itself for init. It returns nothing.
- **No libraries**: No AceAddon, LibStub, or external dependencies. Pure Lua + Blizzard API only.

## Module lifecycle

Core.lua owns SavedVariables and a module registry. On `ADDON_LOADED` it creates `YaworsCleanUIDB` if missing, deep-merges `DEFAULTS` into it, then calls `init()` on every registered module.

A module attaches itself to the namespace and registers for init:

```lua
local module = {}
YaworsCleanUI.MyFeature = module
YaworsCleanUI.registerModule(module)

function module.init()
    module.applySettings()
end

function module.applySettings()
    -- read YaworsCleanUIDB.myFeature.* and apply it to the live UI
end
```

`applySettings()` is the single entry point for (re)applying state — called once at init and again from every settings control's setter, so toggles take effect instantly. Keep it idempotent. One-time setup (creating frames, hooking `SetPoint`, registering events) belongs in `init()`.

## Comments

Code should be self-explanatory through naming and structure.

WoW API calls may be commented freely — even when the usage is readable, it's fine to note what an API call does or how it behaves. This is reference documentation, not noise.

For non-API code: Do not narrate code. Comments only when:
- The reason isn't obvious
- A workaround exists for a Blizzard quirk
- Something looks wrong but is intentional

Do NOT comment what code does. Comment why it does it, only when that isn't obvious.

## Settings

Settings.lua builds the panel with `Settings.RegisterVerticalLayoutCategory` (root) and one `Settings.RegisterVerticalLayoutSubcategory` per feature, exposed via `YaworsCleanUI.settingsCategories`. Category registration is deferred to `ADDON_LOADED` so all `settings/*.lua` controls are added first. The panel lives inside the standard Blizzard options (Interface Options → AddOns) — no separate window, no minimap button.

Shared control helpers in Settings.lua:

- `YaworsCleanUI.addCheckbox(category, group, key, name, tooltip, callback)`
- `YaworsCleanUI.addColorPicker(category, group, colorKey, name, tooltip, callback)`
- `YaworsCleanUI.addSlider(category, group, key, name, tooltip, minValue, maxValue, callback)`
- `YaworsCleanUI.addSectionHeader(category, name)` — a subheader within a category, for grouping controls

These build on `Settings.RegisterProxySetting` (storage delegated to our own getter/setter, not a CVar). The proxy key must be globally unique across all addons, hence the `YaworsCleanUI_<group>_<key>` prefix. Each control's framework default (used for reset-to-default and the "modified" indicator) is derived from `YaworsCleanUI.DEFAULTS[group][key]` in Core.lua — the single source of truth — so defaults are never repeated at the call site.

Every setter writes to `YaworsCleanUIDB` and then calls the owning module's `applySettings()`. Everything applies instantly; there is no reload-required path or Reload UI button today. If a future setting genuinely needs a reload, enable a "Reload UI" button only when pending changes exist.

## Deploy

`deploy/linux-deploy.sh` and `deploy/windows-deploy.bat` copy the addon into the live WoW AddOns folder for testing. The destination path is read from `deploy/deploy.conf` (gitignored; copy from `deploy.conf.example`). The scripts mirror the TOC, `Core.lua`, `Settings.lua`, and the `modules/`, `settings/`, `textures/` folders — keep them in sync when adding new top-level files or folders.

## Debugging frame names

If unsure what a UI element's frame is called, ask the user to hover over it in-game and run `/fstack` — it lists all frames under the cursor.

## Target version

Retail WoW, current version. TOC: `## Interface: 120001`. Single number is fine for retail-only addons.

## SavedVariables

Named `YaworsCleanUIDB`. Initialized in Core.lua with defaults before any module reads them.

## WoW API Reference

When implementing or modifying addon features, consult these resources for accurate API usage:

- **WoW API index**: https://warcraft.wiki.gg/wiki/World_of_Warcraft_API
- **Events**: https://warcraft.wiki.gg/wiki/Events
- **Lua functions (WoW 5.1 subset)**: https://warcraft.wiki.gg/wiki/Lua_functions
- **BlizzardInterfaceResources (enums, templates, globals)**: https://github.com/Ketho/BlizzardInterfaceResources

Do not guess API function signatures, event names, or enum values. If unsure whether a function exists or what arguments it takes, say so rather than fabricating a plausible-looking call.
