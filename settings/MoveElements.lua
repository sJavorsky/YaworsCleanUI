local category = YaworsCleanUI.settingsCategories.move
local addCheckbox = YaworsCleanUI.addCheckbox
local addSlider = YaworsCleanUI.addSlider
local addSectionHeader = YaworsCleanUI.addSectionHeader

local screenHeight = math.floor(GetScreenHeight()*0.9)
local screenWidth = math.floor(GetScreenWidth()*0.9)

local function apply()
    YaworsCleanUI.MoveElements.applySettings()
end

addSectionHeader(category, "Queue eye")
addCheckbox(category, "moveElements", "queueEye", "Queue Eye",
    "Moves the queue status eye onto the minimap. Use the sliders below to position it.", apply)
-- Minimap is 198px wide, so its radius is 99px; allow a little past the edge.
addSlider(category, "moveElements", "eyeDistance",
    "Eye distance", "Distance of the queue eye from the minimap center (0 = center, 99 = edge).",
    0, 130, apply)
addSlider(category, "moveElements", "eyeAngle",
    "Eye angle", "Angle of the queue eye around the minimap (0 = right, 90 = top, 180 = left, 270 = bottom).",
    0, 360, apply)

addSectionHeader(category, "Battle.net toast")
addCheckbox(category, "moveElements", "bnetToast", "BNET Toast",
    "Moves the Battle.net toast popup. Use the sliders below to position it (starts at screen center).", apply)
addCheckbox(category, "moveElements", "toastPreview", "Toggle preview",
    "Shows a blue placeholder box the size of the toast where it will land, so you can position it exactly.", apply)
addSlider(category, "moveElements", "toastOffsetY",
    "Vertical offset", "Vertical offset of the Battle.net toast from screen center.",
    -screenHeight, screenHeight, apply)
addSlider(category, "moveElements", "toastOffsetX",
    "Horizontal offset", "Horizontal offset of the Battle.net toast from screen center.",
    -screenWidth, screenWidth, apply)
