# YaworsCleanUI

WoW retail addon. This folder is the project root. Do NOT create a wrapping subfolder.

## Project

A personal UI cleanup addon replacing functionality previously handled by WeakAuras (which lost support in The War Within / Midnight transition). Focuses on hiding specific UI elements and filtering chat spam, with settings integrated directly into the Blizzard Interface Options panel (not a separate window).

## Structure

Modular — one file per feature/concern. New features get their own file, registered in the TOC.

```
YaworsCleanUI.toc       -- addon manifest
Core.lua                -- addon table, SavedVariables init, event backbone
Settings.lua            -- Blizzard Interface Options panel registration
modules/
  HideElements.lua      -- hiding loot window, bag icons, etc.
  ChatFilter.lua        -- filtering chat spam (spell learned/unlearned, etc.)
```

Add new modules under `modules/`. Register them in the TOC after Core.lua and Settings.lua.

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
- **Module pattern**: Each module file declares a local table, attaches it to `YaworsCleanUI`, and returns nothing.

```lua
local mod = {}
YaworsCleanUI.HideElements = mod

function mod.init()
  -- ...
end
```

- **No libraries**: No AceAddon, LibStub, or external dependencies. Pure Lua + Blizzard API only.

## Comments

Code should be self-explanatory through naming and structure.

WoW API calls may be commented freely — even when the usage is readable, it's fine to note what an API call does or how it behaves. This is reference documentation, not noise.

For non-API code: Do not narrate code. Comments only when:
- The reason isn't obvious
- A workaround exists for a Blizzard quirk
- Something looks wrong but is intentional

Do NOT comment what code does. Comment why it does it, only when that isn't obvious.

## Settings

Use `Settings.RegisterAddOnCategory` (retail API, TWW+). Settings panel must appear inside the standard Blizzard Interface Options. No separate popup window, no minimap button.

Changes that can apply instantly should apply instantly via callback. If a reload is required, enable a "Reload UI" button only when pending changes exist.

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

## Addons references

- **Sensei Class Resource Bar**: cloned locally in `../external/SenseiClassResourceBar-main/`

  When implementing class resource tracking (rage, energy, etc), review this addon's approach for reference on API usage and event handling.

- **MoveAnything**: cloned locally in `../external/MoveAnything/`

  When implementing frame moving or repositioning functionality, review this addon's approach for reference on how to hook, anchor, and reposition default UI frames.

- **Dialogue UI** cloned locally in `../external/YUI-Dialogue-main/`
