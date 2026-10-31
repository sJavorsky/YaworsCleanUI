local category = YaworsCleanUI.settingsCategories.bars
local addCheckbox = YaworsCleanUI.addCheckbox
local addSlider = YaworsCleanUI.addSlider
local addSectionHeader = YaworsCleanUI.addSectionHeader

local screenHeightHalf = math.floor(GetScreenHeight()*0.8)
local screenWidthHalf = math.floor(GetScreenWidth()*0.9)

local function apply()
    YaworsCleanUI.ClassResourceBars.applySettings()
end

addCheckbox(category, "classResourceBars", "enabled",
    "Enable", "Show class resource bars at the center of the screen. Turn off to hide them all.", apply)

addSlider(category, "classResourceBars", "offsetY",
    "Vertical offset", "Vertical offset for class bar frames.",
    -screenHeightHalf, screenHeightHalf, apply)
addSlider(category, "classResourceBars", "offsetX",
    "Horizontal offset", "Horizontal offset for class bar frames.",
    -screenWidthHalf, screenWidthHalf, apply)
addSlider(category, "classResourceBars", "scale",
    "Scale", "Scale of class bar frames (percentage).",
    1, 1000, apply)
addCheckbox(category, "classResourceBars", "fancyTextures",
    "Fancy textures", "Show bars with their spec's fancy fill texture (Astral Power, Maelstrom, Insanity, Ebon Might, Fury). Applies to all class bars.", apply)

addSectionHeader(category, "Resources by class")
addCheckbox(category, "classResourceBars", "deathKnightRunicPower",
    "Death Knight Runic Power", "Add the Death Knight Runic Power bar to the center of the screen.", apply)
addCheckbox(category, "classResourceBars", "druidEnergy",
    "Druid Energy", "Show the Druid Energy bar at the center of the screen (Cat Form only).", apply)
addCheckbox(category, "classResourceBars", "druidRage",
    "Druid Rage", "Show the Druid Rage bar at the center of the screen (Bear Form only).", apply)
addCheckbox(category, "classResourceBars", "druidAstralPower",
    "Druid Astral Power", "Show the Druid Astral Power bar at the center of the screen (Balance spec, outside animal forms).", apply)
addCheckbox(category, "classResourceBars", "evokerEbonMight",
    "Evoker Ebon Might", "Show the Evoker Ebon Might duration bar at the center of the screen (Augmentation only).", apply)
addCheckbox(category, "classResourceBars", "demonHunterFury",
    "Demon Hunter Fury", "Show the Demon Hunter Fury bar at the center of the screen.", apply)
addCheckbox(category, "classResourceBars", "demonHunterSoulFragments",
    "Demon Hunter Soul Fragments", "Show the Demon Hunter Soul Fragments bar stacked with the Fury bar (Devourer only).", apply)
addCheckbox(category, "classResourceBars", "hunterFocus",
    "Hunter Focus", "Show the Hunter Focus bar at the center of the screen.", apply)
addCheckbox(category, "classResourceBars", "monkEnergy",
    "Monk Energy", "Show the Monk Energy bar at the center of the screen (Windwalker and Brewmaster only).", apply)
addCheckbox(category, "classResourceBars", "priestInsanity",
    "Priest Insanity", "Show the Priest Insanity bar at the center of the screen (Shadow only).", apply)
addCheckbox(category, "classResourceBars", "rogueEnergy",
    "Rogue Energy", "Show the Rogue Energy bar at the center of the screen.", apply)
addCheckbox(category, "classResourceBars", "shamanMaelstrom",
    "Shaman Maelstrom", "Show the Shaman Maelstrom bar at the center of the screen (Elemental only).", apply)
addCheckbox(category, "classResourceBars", "warriorRage",
    "Warrior Rage", "Show the Warrior Rage bar at the center of the screen.", apply)
