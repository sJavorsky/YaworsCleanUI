local category = YaworsCleanUI.settingsCategories.position
local addCheckbox = YaworsCleanUI.addCheckbox
local addColorPicker = YaworsCleanUI.addColorPicker

addCheckbox(category, "playerPosition", "enabled",
    "Show position cross", "Draws a cross at the center of the screen to mark your character's position.", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

addCheckbox(category, "playerPosition", "combatOnly",
    "Show only in combat", "Hides the position cross when not in combat.", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

addColorPicker(category, "playerPosition", "innerColor",
    "Inner cross color", "Color of the inner cross lines.", "ffffffff", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

addColorPicker(category, "playerPosition", "borderColor",
    "Border color", "Color of the cross border outline.", "ff000000", function()
    YaworsCleanUI.PlayerPosition.applySettings()
end)

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

addCheckbox(category, "playerPosition", "manualOffset",
    "Manual offset",
    "Use the offset sliders below to manually position the cross. When disabled, offset sliders are ignored.",
    function()
        YaworsCleanUI.PlayerPosition.applySettings()
    end
)

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
