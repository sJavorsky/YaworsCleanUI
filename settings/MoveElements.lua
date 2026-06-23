local category = YaworsCleanUI.settingsCategories.move
local addCheckbox = YaworsCleanUI.addCheckbox

local screenHeight = math.floor(GetScreenHeight())
local screenWidth = math.floor(GetScreenWidth())

addCheckbox(category, "moveElements", "queueEye", "Queue Eye", "Moves the queue status eye onto the minimap. Use the sliders below to position it.", function()
    YaworsCleanUI.MoveElements.applySettings()
end)

-- Minimap is 198px wide, so its radius is 99px; allow a little past the edge.
local eyeDistanceSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_moveElementsEyeDistance",
    Settings.VarType.Number,
    "Eye distance",
    0,
    function() return YaworsCleanUIDB.moveElements.eyeDistance end,
    function(value)
        YaworsCleanUIDB.moveElements.eyeDistance = value
        YaworsCleanUI.MoveElements.applySettings()
    end
)
local eyeDistanceOptions = Settings.CreateSliderOptions(0, 130, 1)
eyeDistanceOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, eyeDistanceSetting, eyeDistanceOptions, "Distance of the queue eye from the minimap center (0 = center, 99 = edge).")

local eyeAngleSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_moveElementsEyeAngle",
    Settings.VarType.Number,
    "Eye angle",
    0,
    function() return YaworsCleanUIDB.moveElements.eyeAngle end,
    function(value)
        YaworsCleanUIDB.moveElements.eyeAngle = value
        YaworsCleanUI.MoveElements.applySettings()
    end
)
local eyeAngleOptions = Settings.CreateSliderOptions(0, 360, 1)
eyeAngleOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, eyeAngleSetting, eyeAngleOptions, "Angle of the queue eye around the minimap (0 = right, 90 = top, 180 = left, 270 = bottom).")

addCheckbox(category, "moveElements", "bnetToast", "BNET Toast", "Moves the Battle.net toast popup. Use the sliders below to position it (starts at screen center).", function()
    YaworsCleanUI.MoveElements.applySettings()
end)
addCheckbox(category, "moveElements", "toastPreview", "Toggle preview", "Shows a blue placeholder box the size of the toast where it will land, so you can position it exactly.", function()
    YaworsCleanUI.MoveElements.applySettings()
end)

local toastOffsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_moveElementsToastOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.moveElements.toastOffsetY end,
    function(value)
        YaworsCleanUIDB.moveElements.toastOffsetY = value
        YaworsCleanUI.MoveElements.applySettings()
    end
)
local toastOffsetYOptions = Settings.CreateSliderOptions(-screenHeight, screenHeight, 1)
toastOffsetYOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, toastOffsetYSetting, toastOffsetYOptions, "Vertical offset of the Battle.net toast from screen center.")

local toastOffsetXSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_moveElementsToastOffsetX",
    Settings.VarType.Number,
    "Horizontal offset",
    0,
    function() return YaworsCleanUIDB.moveElements.toastOffsetX end,
    function(value)
        YaworsCleanUIDB.moveElements.toastOffsetX = value
        YaworsCleanUI.MoveElements.applySettings()
    end
)
local toastOffsetXOptions = Settings.CreateSliderOptions(-screenWidth, screenWidth, 1)
toastOffsetXOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, toastOffsetXSetting, toastOffsetXOptions, "Horizontal offset of the Battle.net toast from screen center.")
