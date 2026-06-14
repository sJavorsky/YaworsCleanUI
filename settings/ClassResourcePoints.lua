local category = YaworsCleanUI.settingsCategories.points
local addCheckbox = YaworsCleanUI.addCheckbox

local screenHeight = math.floor(GetScreenHeight())
local screenWidth = math.floor(GetScreenWidth())

local offsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourcePointsOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.classResourcePoints.offsetY end,
    function(value)
        YaworsCleanUIDB.classResourcePoints.offsetY = value
        YaworsCleanUI.ClassResourcePoints.applySettings()
    end
)
local offsetYOptions = Settings.CreateSliderOptions(-screenHeight, screenHeight, 1)
offsetYOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, offsetYSetting, offsetYOptions, "Vertical offset for class resource frames.")

local offsetXSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourcePointsOffsetX",
    Settings.VarType.Number,
    "Horizontal offset",
    0,
    function() return YaworsCleanUIDB.classResourcePoints.offsetX end,
    function(value)
        YaworsCleanUIDB.classResourcePoints.offsetX = value
        YaworsCleanUI.ClassResourcePoints.applySettings()
    end
)
local offsetXOptions = Settings.CreateSliderOptions(-screenWidth, screenWidth, 1)
offsetXOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, offsetXSetting, offsetXOptions, "Horizontal offset for class resource frames.")

local scaleSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourcePointsScale",
    Settings.VarType.Number,
    "Scale",
    100,
    function() return YaworsCleanUIDB.classResourcePoints.scale end,
    function(value)
        YaworsCleanUIDB.classResourcePoints.scale = value
        YaworsCleanUI.ClassResourcePoints.applySettings()
    end
)
local scaleOptions = Settings.CreateSliderOptions(1, 1000, 1)
scaleOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, scaleSetting, scaleOptions, "Scale of class resource frames (percentage).")

addCheckbox(category, "classResourcePoints", "deathKnightRunes",
    "Death Knight Runes", "Move the Death Knight Runes to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckbox(category, "classResourcePoints", "druidComboPoints",
    "Druid Combo Points", "Move the Druid combo points bar to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckbox(category, "classResourcePoints", "evokerEssence",
    "Evoker Essence", "Move the Evoker Essence to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckbox(category, "classResourcePoints", "rogueComboPoints",
    "Rogue Combo Points", "Move the Rogue combo points bar to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckbox(category, "classResourcePoints", "monkChi",
    "Monk Chi", "Move the Monk Chi bar to the center of the screen (Windwalker only).", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckbox(category, "classResourcePoints", "warlockSoulShards",
    "Warlock Soul Shards", "Move the Warlock Soul Shards to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckbox(category, "classResourcePoints", "mageArcaneCharges",
    "Mage Arcane Charges", "Move the Mage Arcane Charges to the center of the screen (Arcane only).", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckbox(category, "classResourcePoints", "paladinHolyPower",
    "Paladin Holy Power", "Move the Paladin Holy Power to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
