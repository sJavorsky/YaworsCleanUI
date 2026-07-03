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

addColorPicker(category, "cursorPosition", "outerTrackerColor",
    "Outer tracker color", "Color of the outer tracker ring.", "ffffcc1a", function()
    YaworsCleanUI.CursorPosition.applySettings()
end)

addColorPicker(category, "cursorPosition", "innerTrackerColor",
    "Inner tracker color", "Color of the inner tracker ring.", "ff9933ff", function()
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

local outerTrackerWidthSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_cursorPositionOuterTrackerWidth",
    Settings.VarType.Number,
    "Outer tracker width",
    4,
    function() return YaworsCleanUIDB.cursorPosition.outerTrackerWidth end,
    function(value)
        YaworsCleanUIDB.cursorPosition.outerTrackerWidth = value
        YaworsCleanUI.CursorPosition.applySettings()
    end
)
local outerTrackerWidthOptions = Settings.CreateSliderOptions(0, 75, 1)
outerTrackerWidthOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, outerTrackerWidthSetting, outerTrackerWidthOptions, "Thickness of the outer tracker ring (0 hides it).")

local innerTrackerWidthSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_cursorPositionInnerTrackerWidth",
    Settings.VarType.Number,
    "Inner tracker width",
    4,
    function() return YaworsCleanUIDB.cursorPosition.innerTrackerWidth end,
    function(value)
        YaworsCleanUIDB.cursorPosition.innerTrackerWidth = value
        YaworsCleanUI.CursorPosition.applySettings()
    end
)
local innerTrackerWidthOptions = Settings.CreateSliderOptions(0, 75, 1)
innerTrackerWidthOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, innerTrackerWidthSetting, innerTrackerWidthOptions, "Thickness of the inner tracker ring (0 hides it).")
