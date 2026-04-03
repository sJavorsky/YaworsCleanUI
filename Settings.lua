-- Settings.RegisterVerticalLayoutCategory returns the category and its layout.
-- The layout's AddInitializer is used for section headers; the category is
-- passed to Settings.Create* functions and RegisterAddOnCategory.
local category, layout = Settings.RegisterVerticalLayoutCategory("Yawor's Clean UI")

local function addCheckBox(key, name, tooltip, callback)
    -- RegisterProxySetting delegates storage to our own getter/setter rather
    -- than a CVar; the key must be globally unique across all addons.
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. key,
        Settings.VarType.Boolean,
        name,
        false,
        function() return YaworsCleanUIDB[key] end,
        function(value)
            YaworsCleanUIDB[key] = value
            callback()
        end
    )
    Settings.CreateCheckbox(category, setting, tooltip)
end

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Hide UI elements"))

addCheckBox("hideLooting", "Hide looting window", "Hides the loot frame when looting.", function()
    YaworsCleanUI.HideElements.applySettings()
end)
addCheckBox("hideBags", "Hide bag icons", "Hides the bag bar icons.", function()
    YaworsCleanUI.HideElements.applySettings()
end)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Points Class Resources"))

local offsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourcePointsOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.classResourcePointsOffsetY end,
    function(value)
        YaworsCleanUIDB.classResourcePointsOffsetY = value
        YaworsCleanUI.CombatResources.applySettings()
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
    function() return YaworsCleanUIDB.classResourcePointsOffsetX end,
    function(value)
        YaworsCleanUIDB.classResourcePointsOffsetX = value
        YaworsCleanUI.CombatResources.applySettings()
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
    function() return YaworsCleanUIDB.classResourcePointsScale end,
    function(value)
        YaworsCleanUIDB.classResourcePointsScale = value
        YaworsCleanUI.CombatResources.applySettings()
    end
)
local scaleOptions = Settings.CreateSliderOptions(1, 1000, 1)
scaleOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, scaleSetting, scaleOptions, "Scale of class resource frames (percentage).")

addCheckBox("deathKnightRunes", "Death Knight Runes", "Move the Death Knight Runes to the center of the screen.", function()
    YaworsCleanUI.CombatResources.applySettings()
end)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Bars Class Resources"))

local barsOffsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourceBarsOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.classResourceBarsOffsetY end,
    function(value)
        YaworsCleanUIDB.classResourceBarsOffsetY = value
        YaworsCleanUI.BarClassResources.applySettings()
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
    function() return YaworsCleanUIDB.classResourceBarsOffsetX end,
    function(value)
        YaworsCleanUIDB.classResourceBarsOffsetX = value
        YaworsCleanUI.BarClassResources.applySettings()
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
    function() return YaworsCleanUIDB.classResourceBarsScale end,
    function(value)
        YaworsCleanUIDB.classResourceBarsScale = value
        YaworsCleanUI.BarClassResources.applySettings()
    end
)
local barsScaleOptions = Settings.CreateSliderOptions(1, 1000, 1)
barsScaleOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, barsScaleSetting, barsScaleOptions, "Scale of class bar frames (percentage).")

addCheckBox("deathKnightRunicPower", "Death Knight Runic Power", "Add the Death Knight Runic Power bar to the center of the screen.", function()
    YaworsCleanUI.BarClassResources.applySettings()
end)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Player Position"))

addCheckBox("playerPositionEnabled", "Show position cross", "Draws a cross at the center of the screen to mark your character's position.", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

addCheckBox("playerPositionCombatOnly", "Show only in combat", "Hides the position cross when not in combat.", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

local playerOffsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_playerPositionOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.playerPositionOffsetY end,
    function(value)
        YaworsCleanUIDB.playerPositionOffsetY = value
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
    function() return YaworsCleanUIDB.playerPositionOffsetX end,
    function(value)
        YaworsCleanUIDB.playerPositionOffsetX = value
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
    function() return YaworsCleanUIDB.playerPositionHeight end,
    function(value)
        YaworsCleanUIDB.playerPositionHeight = value
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
    function() return YaworsCleanUIDB.playerPositionWidth end,
    function(value)
        YaworsCleanUIDB.playerPositionWidth = value
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
    function() return YaworsCleanUIDB.playerPositionThickness end,
    function(value)
        YaworsCleanUIDB.playerPositionThickness = value
        YaworsCleanUI.PlayerPosition.applySettings()
    end
)
local playerThicknessOptions = Settings.CreateSliderOptions(1, 20, 1)
playerThicknessOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, playerThicknessSetting, playerThicknessOptions, "Thickness of the cross lines; border scales with it.")

local function addColorPicker(key, name, tooltip, defaultHex, rKey, gKey, bKey)
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. key,
        Settings.VarType.String,
        name,
        defaultHex,
        function()
            return CreateColor(
                YaworsCleanUIDB[rKey],
                YaworsCleanUIDB[gKey],
                YaworsCleanUIDB[bKey]
            ):GenerateHexColor()
        end,
        function(value)
            local color = CreateColorFromHexString(value)
            YaworsCleanUIDB[rKey] = color.r
            YaworsCleanUIDB[gKey] = color.g
            YaworsCleanUIDB[bKey] = color.b
            YaworsCleanUI.PlayerPosition.applySettings()
        end
    )
    Settings.CreateColorSwatch(category, setting, tooltip)
end

addColorPicker("playerPositionInnerColor", "Inner cross color",
    "Color of the inner cross lines.",
    "ffffffff",
    "playerPositionInnerR", "playerPositionInnerG", "playerPositionInnerB")

addColorPicker("playerPositionBorderColor", "Border color",
    "Color of the cross border outline.",
    "ff000000",
    "playerPositionBorderR", "playerPositionBorderG", "playerPositionBorderB")

-- RegisterAddOnCategory places the category under the AddOns section of the
-- Blizzard Interface Options panel.
Settings.RegisterAddOnCategory(category)
