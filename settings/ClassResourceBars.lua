local category = YaworsCleanUI.settingsCategories.bars
local addCheckbox = YaworsCleanUI.addCheckbox

local screenHeight = math.floor(GetScreenHeight())
local screenWidth = math.floor(GetScreenWidth())

-- Global toggle, kept above the per-class checkboxes so it does not get lost.
addCheckbox(category, "classResourceBars", "fancyTextures",
    "Fancy textures", "Show bars with their spec's fancy fill texture (Astral Power, Maelstrom, Insanity, Ebon Might, Fury). Applies to all class bars.", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)

local barsOffsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourceBarsOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.classResourceBars.offsetY end,
    function(value)
        YaworsCleanUIDB.classResourceBars.offsetY = value
        YaworsCleanUI.ClassResourceBars.applySettings()
    end
)
local barsOffsetYOptions = Settings.CreateSliderOptions(-screenHeight, screenHeight, 1)
barsOffsetYOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, barsOffsetYSetting, barsOffsetYOptions, "Vertical offset for class bar frames.")

local barsOffsetXSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourceBarsOffsetX",
    Settings.VarType.Number,
    "Horizontal offset",
    0,
    function() return YaworsCleanUIDB.classResourceBars.offsetX end,
    function(value)
        YaworsCleanUIDB.classResourceBars.offsetX = value
        YaworsCleanUI.ClassResourceBars.applySettings()
    end
)
local barsOffsetXOptions = Settings.CreateSliderOptions(-screenWidth, screenWidth, 1)
barsOffsetXOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, barsOffsetXSetting, barsOffsetXOptions, "Horizontal offset for class bar frames.")

local barsScaleSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourceBarsScale",
    Settings.VarType.Number,
    "Scale",
    100,
    function() return YaworsCleanUIDB.classResourceBars.scale end,
    function(value)
        YaworsCleanUIDB.classResourceBars.scale = value
        YaworsCleanUI.ClassResourceBars.applySettings()
    end
)
local barsScaleOptions = Settings.CreateSliderOptions(1, 1000, 1)
barsScaleOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, barsScaleSetting, barsScaleOptions, "Scale of class bar frames (percentage).")

addCheckbox(category, "classResourceBars", "deathKnightRunicPower",
    "Death Knight Runic Power", "Add the Death Knight Runic Power bar to the center of the screen.", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "druidEnergy",
    "Druid Energy", "Show the Druid Energy bar at the center of the screen (Cat Form only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "druidRage",
    "Druid Rage", "Show the Druid Rage bar at the center of the screen (Bear Form only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "druidAstralPower",
    "Druid Astral Power", "Show the Druid Astral Power bar at the center of the screen (Balance spec, outside animal forms).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "evokerEbonMight",
    "Evoker Ebon Might", "Show the Evoker Ebon Might duration bar at the center of the screen (Augmentation only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "demonHunterFury",
    "Demon Hunter Fury", "Show the Demon Hunter Fury bar at the center of the screen (Havoc and Vengeance only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "hunterFocus",
    "Hunter Focus", "Show the Hunter Focus bar at the center of the screen.", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "monkEnergy",
    "Monk Energy", "Show the Monk Energy bar at the center of the screen (Windwalker and Brewmaster only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "priestInsanity",
    "Priest Insanity", "Show the Priest Insanity bar at the center of the screen (Shadow only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "rogueEnergy",
    "Rogue Energy", "Show the Rogue Energy bar at the center of the screen.", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "shamanMaelstrom",
    "Shaman Maelstrom", "Show the Shaman Maelstrom bar at the center of the screen (Elemental only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckbox(category, "classResourceBars", "warriorRage",
    "Warrior Rage", "Show the Warrior Rage bar at the center of the screen.", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
