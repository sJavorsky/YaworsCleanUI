local category = YaworsCleanUI.settingsCategories.cursor
local addCheckbox = YaworsCleanUI.addCheckbox
local addColorPicker = YaworsCleanUI.addColorPicker

addCheckbox(category, "cursorPosition", "enabled",
    "Show position circle", "Draws a circle at the cursor to mark its position.", function()
    YaworsCleanUI.CursorPosition.applySettings()
end)

addCheckbox(category, "cursorPosition", "combatOnly",
    "Show only in combat", "Hides the position circle when not in combat.", function()
    YaworsCleanUI.CursorPosition.applySettings()
end)

addColorPicker(category, "cursorPosition", "outerColor",
    "Outer circle color", "Color of the outer ring.", "ffffffff", function()
    YaworsCleanUI.CursorPosition.applySettings()
end)

addColorPicker(category, "cursorPosition", "innerColor",
    "Inner circle color", "Color of the inner ring.", "ff3399ff", function()
    YaworsCleanUI.CursorPosition.applySettings()
end)

local cursorSizeSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_cursorPositionSize",
    Settings.VarType.Number,
    "Size",
    50,
    function() return YaworsCleanUIDB.cursorPosition.size end,
    function(value)
        YaworsCleanUIDB.cursorPosition.size = value
        YaworsCleanUI.CursorPosition.applySettings()
    end
)
local cursorSizeOptions = Settings.CreateSliderOptions(10, 300, 1)
cursorSizeOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, cursorSizeSetting, cursorSizeOptions, "Diameter of the position circle.")

local cursorWidthSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_cursorPositionWidth",
    Settings.VarType.Number,
    "Width",
    10,
    function() return YaworsCleanUIDB.cursorPosition.width end,
    function(value)
        YaworsCleanUIDB.cursorPosition.width = value
        YaworsCleanUI.CursorPosition.applySettings()
    end
)
local cursorWidthOptions = Settings.CreateSliderOptions(1, 75, 1)
cursorWidthOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, cursorWidthSetting, cursorWidthOptions, "Thickness of the circle's ring.")
