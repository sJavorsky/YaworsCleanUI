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
Migrations.lua               -- versioned SavedVariables migrations, run by Core.lua on load
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
deploy/                      -- dev.sh (copy into live AddOns folder) and deploy.sh (build the release zip locally; CI uploads the real one)
dist/                        -- zips built by deploy.sh (gitignored)
.github/workflows/           -- release.yml: CurseForge packaging and upload (see Deploy)
.pkgmeta                     -- packager config: package name, changelog file, ignored paths
reference/                   -- other addons cloned for API reference (gitignored, read-only)
```

Adding a feature: create `modules/X.lua` and `settings/X.lua`, register both in the TOC (settings files before module files — see load order below), add a subcategory in Settings.lua plus an entry in `settingsCategories`, add its defaults in Core.lua's `DEFAULTS`, and update the dev and deploy scripts if you add a new top-level file or folder.

**Load order** (from the TOC): `Core.lua` → `Migrations.lua` → `Settings.lua` → `settings/*.lua` → `modules/*.lua`. Settings files load before modules but only reference module tables inside callbacks (which run later), so the ordering is safe.

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
- `YaworsCleanUI.addDropdown(category, group, key, name, tooltip, choices, callback)` — `choices` is a list of `{ value, label }` pairs
- `YaworsCleanUI.addButton(category, buttonText, tooltip, onClick)` — a left-aligned action button with no label that saves nothing (used for previews, which hide when the panel closes)
- `YaworsCleanUI.addSectionHeader(category, name)` — a subheader within a category, for grouping controls

Every helper returns its row's initializer. Call `initializer:AddShownPredicate(function)` on it to hide the row while the function returns false. The panel redraws on every setting change, so the row appears or vanishes immediately.

These build on `Settings.RegisterProxySetting` (storage delegated to our own getter/setter, not a CVar). The proxy key must be globally unique across all addons, hence the `YaworsCleanUI_<group>_<key>` prefix. Each control's framework default (used for reset-to-default and the "modified" indicator) is derived from `YaworsCleanUI.DEFAULTS[group][key]` in Core.lua — the single source of truth — so defaults are never repeated at the call site.

Every setter writes to `YaworsCleanUIDB` and then calls the owning module's `applySettings()`. Everything applies instantly; there is no reload-required path or Reload UI button today. If a future setting genuinely needs a reload, enable a "Reload UI" button only when pending changes exist.

## Deploy

`deploy/dev.sh` copies the addon into the live WoW AddOns folder for testing. The destination path is read from `DEST` in `deploy/deploy.conf` (gitignored; copy from `deploy.conf.example`).

Releases are uploaded to CurseForge (project `1740029`) by `.github/workflows/release.yml`, which runs the BigWigsMods packager. The git tag is the version: the TOC says `## Version: @project-version@` and the packager fills it in. Triggers:

- **Push to `main` (a merged PR):** CI reads the version from the top `## x.y.z` heading of `CHANGELOG.md`. If that tag doesn't exist yet, CI creates it as an annotated tag on the merge commit and uploads it to CurseForge as a release in the same run. No GitHub release is created. A tag pushed by a workflow wouldn't start a run of its own. If the tag already exists, the push releases nothing.
- **Push to `develop`:** uploads an alpha named `<last tag>-<commits>-g<hash>`. If the head commit is tagged, the push is skipped, so the tag's run alone uploads it.
- **Manual tag push** (e.g. `1.2.0-beta1`): uploads a release, or a beta or alpha if the tag contains that word.

The packager reads `.pkgmeta` (package name, changelog file, ignored paths) and skips dotfiles. CI writes `.changelog-latest.md` as the CurseForge file's changelog. For a tagged commit, it's the newest `## ` section of `CHANGELOG.md`. For an alpha, it's the commit subjects since the last tag. Both end with a link to the full `CHANGELOG.md` on GitHub. The full file ships in the zip. The token is the `CF_API_KEY` repo secret. `README.html` is the CurseForge project description (pasted by hand; HTML keeps the spoiler section working). It is not shipped or synced.

Release checklist:

1. On `develop`, set the new version in `CHANGELOG.md` (see Changelog below). For a patch, bump the top heading. For a minor or major version, add a new section at the top. Do this only when you're ready to release, because the next merge to `main` releases it.
2. Merge `develop` into `main` with a PR. CI tags the merge commit and uploads the release.
3. Fast-forward `develop` to `main` and push it: `git checkout develop && git merge --ff-only origin/main && git push`. Without this, `develop` can't see the tag, and alphas get named from an older one. The push uploads nothing, because its head commit is tagged.
4. If the README changed, paste `README.html` into CurseForge by hand.

`deploy/deploy.sh` builds the same zip locally at `dist/YaworsCleanUI-<version>.zip`, with the version from `git describe --tags`. It's for checking a package without uploading. The zip has a `YaworsCleanUI/` folder at its root and also includes `LICENSE`, `CHANGELOG.md` and `README.md`. Both scripts replace `@project-version@` in the copied TOC.

Both scripts mirror the TOC, `Core.lua`, `Migrations.lua`, `Settings.lua`, and the `modules/`, `settings/`, `textures/` folders. Keep them in sync when adding new top-level files or folders, and add anything that must not ship to `ignore` in `.pkgmeta`.

## Changelog

`CHANGELOG.md` is hand-written for players, newest version first, with Added / Changed / Fixed lists. There is one section per minor version. A minor or major release (`1.3.0`, `2.0.0`) adds a new section at the top. Patches accumulate in it: on each patch release, bump the section's heading to the new patch version and date (`## 1.2.0 - ...` becomes `## 1.2.1 - ...`), and add that patch's user-visible changes to its lists. Skip internal-only changes. The top heading's version is the one CI tags on merge, and CI uploads the whole top section as the CurseForge changelog, so players see everything since the minor version started.

## Debugging frame names

If unsure what a UI element's frame is called, ask the user to hover over it in-game and run `/fstack` — it lists all frames under the cursor.

## Target version

Retail WoW, current version. TOC: `## Interface: 120100, 120105` (live plus the upcoming patch, so the addon isn't flagged out of date on patch day). Drop old values once a patch goes live.

## SavedVariables

Named `YaworsCleanUIDB`. Initialized in Core.lua with defaults before any module reads them.

Migrations: `YaworsCleanUIDB.settingsVersion` holds the addon version (e.g. `"1.1.0"`) of the last migration applied to the save. When a release renames or reshapes a saved key, append `{ version = "<release version>", migrate = function(database) ... end }` to `MIGRATIONS` in Migrations.lua, in ascending order. On load, every migration newer than the save runs in order, before defaults are applied. Releases without an entry are skipped. Adding a new key needs no migration.

## WoW API Reference

When implementing or modifying addon features, consult these resources for accurate API usage:

- **WoW API index**: https://warcraft.wiki.gg/wiki/World_of_Warcraft_API
- **Events**: https://warcraft.wiki.gg/wiki/Events
- **Lua functions (WoW 5.1 subset)**: https://warcraft.wiki.gg/wiki/Lua_functions
- **BlizzardInterfaceResources (enums, templates, globals)**: https://github.com/Ketho/BlizzardInterfaceResources

Do not guess API function signatures, event names, or enum values. If unsure whether a function exists or what arguments it takes, say so rather than fabricating a plausible-looking call.
