-- Settings.RegisterVerticalLayoutCategory returns the category and its layout.
-- The layout's AddInitializer is used for section headers; the category is
-- passed to Settings.Create* functions and RegisterAddOnCategory.
local category, layout = Settings.RegisterVerticalLayoutCategory("Yawor's Clean UI")

local function addCheckBox(group, key, name, tooltip, callback)
    -- RegisterProxySetting delegates storage to our own getter/setter rather
    -- than a CVar; the key must be globally unique across all addons.
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. group .. "_" .. key,
        Settings.VarType.Boolean,
        name,
        false,
        function() return YaworsCleanUIDB[group][key] end,
        function(value)
            YaworsCleanUIDB[group][key] = value
            callback()
        end
    )
    Settings.CreateCheckbox(category, setting, tooltip)
end

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Hide UI elements"))

addCheckBox("hideElements", "looting", "Hide looting window", "Hides the loot frame when looting.", function()
    YaworsCleanUI.HideElements.applySettings()
end)
addCheckBox("hideElements", "bags", "Hide bag icons", "Hides the bag bar icons.", function()
    YaworsCleanUI.HideElements.applySettings()
end)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Filter chat"))

addCheckBox("filterChat", "talentSpam",
    "Mute talent swap spam",
    "Suppresses the 'You have learned/unlearned' chat spam when switching talent loadouts.",
    function()
        YaworsCleanUI.FilterChat.applySettings()
    end
)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Points Class Resources"))

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
local screenHeight = math.floor(GetScreenHeight())
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
local screenWidth = math.floor(GetScreenWidth())
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

addCheckBox("classResourcePoints", "deathKnightRunes",
    "Death Knight Runes", "Move the Death Knight Runes to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)
addCheckBox("classResourcePoints", "druidComboPoints",
    "Druid Combo Points", "Move the Druid combo points bar to the center of the screen.", function()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Bars Class Resources"))

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

addCheckBox("classResourceBars", "deathKnightRunicPower",
    "Death Knight Runic Power", "Add the Death Knight Runic Power bar to the center of the screen.", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "druidEnergy",
    "Druid Energy", "Show the Druid Energy bar at the center of the screen (Cat Form only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "druidRage",
    "Druid Rage", "Show the Druid Rage bar at the center of the screen (Bear Form only).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "druidAstralPower",
    "Druid Astral Power", "Show the Druid Astral Power bar at the center of the screen (Balance spec, outside animal forms).", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "demonHunterFury",
    "Demon Hunter Fury", "Show the Demon Hunter Fury bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "evokerEssence",
    "Evoker Essence", "Show the Evoker Essence bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "hunterFocus",
    "Hunter Focus", "Show the Hunter Focus bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "mageArcaneCharges",
    "Mage Arcane Charges", "Show the Mage Arcane Charges bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "monkEnergy",
    "Monk Energy", "Show the Monk Energy bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "paladinHolyPower",
    "Paladin Holy Power", "Show the Paladin Holy Power bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "priestInsanity",
    "Priest Insanity", "Show the Priest Insanity bar at the center of the screen (Shadow only). (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "rogueEnergy",
    "Rogue Energy", "Show the Rogue Energy bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "shamanMaelstrom",
    "Shaman Maelstrom", "Show the Shaman Maelstrom bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "warlockSoulShards",
    "Warlock Soul Shards", "Show the Warlock Soul Shards bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)
addCheckBox("classResourceBars", "warriorRage",
    "Warrior Rage", "Show the Warrior Rage bar at the center of the screen. (Not yet implemented)", function()
    YaworsCleanUI.ClassResourceBars.applySettings()
end)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Player Position"))

addCheckBox("playerPosition", "enabled",
    "Show position cross", "Draws a cross at the center of the screen to mark your character's position.", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

addCheckBox("playerPosition", "combatOnly",
    "Show only in combat", "Hides the position cross when not in combat.", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

local playerOffsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_playerPositionOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.playerPosition.offsetY end,
    function(value)
        YaworsCleanUIDB.playerPosition.offsetY = value
        YaworsCleanUI.PlayerPosition.applySettings()
    end
)
local playerOffsetYOptions = Settings.CreateSliderOptions(-500, 500, 1)
playerOffsetYOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, playerOffsetYSetting, playerOffsetYOptions, "Vertical offset for the position cross.")

local playerOffsetXSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_playerPositionOffsetX",
    Settings.VarType.Number,
    "Horizontal offset",
    0,
    function() return YaworsCleanUIDB.playerPosition.offsetX end,
    function(value)
        YaworsCleanUIDB.playerPosition.offsetX = value
        YaworsCleanUI.PlayerPosition.applySettings()
    end
)
local playerOffsetXOptions = Settings.CreateSliderOptions(-200, 200, 1)
playerOffsetXOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, playerOffsetXSetting, playerOffsetXOptions, "Horizontal offset for the position cross.")

local playerHeightSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_playerPositionHeight",
    Settings.VarType.Number,
    "Height",
    40,
    function() return YaworsCleanUIDB.playerPosition.height end,
    function(value)
        YaworsCleanUIDB.playerPosition.height = value
        YaworsCleanUI.PlayerPosition.applySettings()
    end
)
local playerHeightOptions = Settings.CreateSliderOptions(10, 200, 1)
playerHeightOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, playerHeightSetting, playerHeightOptions, "Height of the vertical arm of the cross.")

local playerWidthSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_playerPositionWidth",
    Settings.VarType.Number,
    "Width",
    40,
    function() return YaworsCleanUIDB.playerPosition.width end,
    function(value)
        YaworsCleanUIDB.playerPosition.width = value
        YaworsCleanUI.PlayerPosition.applySettings()
    end
)
local playerWidthOptions = Settings.CreateSliderOptions(10, 200, 1)
playerWidthOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, playerWidthSetting, playerWidthOptions, "Width of the horizontal arm of the cross.")

local playerThicknessSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_playerPositionThickness",
    Settings.VarType.Number,
    "Thickness",
    2,
    function() return YaworsCleanUIDB.playerPosition.thickness end,
    function(value)
        YaworsCleanUIDB.playerPosition.thickness = value
        YaworsCleanUI.PlayerPosition.applySettings()
    end
)
local playerThicknessOptions = Settings.CreateSliderOptions(1, 20, 1)
playerThicknessOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, playerThicknessSetting, playerThicknessOptions, "Thickness of the cross lines; border scales with it.")

local function addColorPicker(group, colorKey, name, tooltip, defaultHex, callback)
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. group .. "_" .. colorKey,
        Settings.VarType.String,
        name,
        defaultHex,
        function()
            local colorTable = YaworsCleanUIDB[group][colorKey]
            return CreateColor(colorTable.r, colorTable.g, colorTable.b):GenerateHexColor()
        end,
        function(value)
            local color = CreateColorFromHexString(value)
            local colorTable = YaworsCleanUIDB[group][colorKey]
            colorTable.r = color.r
            colorTable.g = color.g
            colorTable.b = color.b
            callback()
        end
    )
    Settings.CreateColorSwatch(category, setting, tooltip)
end

addColorPicker("playerPosition", "innerColor",
    "Inner cross color", "Color of the inner cross lines.", "ffffffff", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

addColorPicker("playerPosition", "borderColor",
    "Border color", "Color of the cross border outline.", "ff000000", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

-- RegisterAddOnCategory places the category under the AddOns section of the
-- Blizzard Interface Options panel.
Settings.RegisterAddOnCategory(category)
