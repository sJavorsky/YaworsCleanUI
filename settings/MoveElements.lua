local category = YaworsCleanUI.settingsCategories.move
local addCheckbox = YaworsCleanUI.addCheckbox
local addSectionHeader = YaworsCleanUI.addSectionHeader

local screenHeight = math.floor(GetScreenHeight())
local screenWidth = math.floor(GetScreenWidth())

local function apply()
    YaworsCleanUI.MoveElements.applySettings()
end

local function addSlider(variable, key, name, default, minValue, maxValue, tooltip)
    local setting = Settings.RegisterProxySetting(
        category,
        variable,
        Settings.VarType.Number,
        name,
        default,
        function() return YaworsCleanUIDB.moveElements[key] end,
        function(value)
            YaworsCleanUIDB.moveElements[key] = value
            apply()
        end
    )
    local options = Settings.CreateSliderOptions(minValue, maxValue, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, setting, options, tooltip)
end

addSectionHeader(category, "Queue eye")
addCheckbox(category, "moveElements", "queueEye", "Queue Eye",
    "Moves the queue status eye onto the minimap. Use the sliders below to position it.", apply)
-- Minimap is 198px wide, so its radius is 99px; allow a little past the edge.
addSlider("YaworsCleanUI_moveElementsEyeDistance", "eyeDistance",
    "Eye distance", 0, 0, 130,
    "Distance of the queue eye from the minimap center (0 = center, 99 = edge).")
addSlider("YaworsCleanUI_moveElementsEyeAngle", "eyeAngle",
    "Eye angle", 0, 0, 360,
    "Angle of the queue eye around the minimap (0 = right, 90 = top, 180 = left, 270 = bottom).")

addSectionHeader(category, "Battle.net toast")
addCheckbox(category, "moveElements", "bnetToast", "BNET Toast",
    "Moves the Battle.net toast popup. Use the sliders below to position it (starts at screen center).", apply)
addCheckbox(category, "moveElements", "toastPreview", "Toggle preview",
    "Shows a blue placeholder box the size of the toast where it will land, so you can position it exactly.", apply)
addSlider("YaworsCleanUI_moveElementsToastOffsetY", "toastOffsetY",
    "Vertical offset", 0, -screenHeight, screenHeight,
    "Vertical offset of the Battle.net toast from screen center.")
addSlider("YaworsCleanUI_moveElementsToastOffsetX", "toastOffsetX",
    "Horizontal offset", 0, -screenWidth, screenWidth,
    "Horizontal offset of the Battle.net toast from screen center.")
