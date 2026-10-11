local category = YaworsCleanUI.settingsCategories.position
local addCheckbox = YaworsCleanUI.addCheckbox
local addColorPicker = YaworsCleanUI.addColorPicker
local addSlider = YaworsCleanUI.addSlider

local screenHeightHalf = math.floor(GetScreenHeight()*0.8)
local screenWidthHalf = math.floor(GetScreenWidth()*0.8)

local function apply()
    YaworsCleanUI.PlayerPosition.applySettings()
end

addCheckbox(category, "playerPosition", "enabled",
    "Show position cross", "Draws a cross at the center of the screen to mark your character's position.", apply)

addCheckbox(category, "playerPosition", "combatOnly",
    "Show only in combat", "Hides the position cross when not in combat.", apply)

addColorPicker(category, "playerPosition", "innerColor",
    "Inner cross color", "Color of the inner cross lines.", apply)

addColorPicker(category, "playerPosition", "borderColor",
    "Border color", "Color of the cross border outline.", apply)

addSlider(category, "playerPosition", "height",
    "Height", "Height of the vertical arm of the cross.", 10, 200, apply)
addSlider(category, "playerPosition", "width",
    "Width", "Width of the horizontal arm of the cross.", 10, 200, apply)
addSlider(category, "playerPosition", "thickness",
    "Thickness", "Thickness of the cross lines; border scales with it.", 1, 20, apply)
addSlider(category, "playerPosition", "minZoom",
    "Min Zoom", "Hide the cross when the camera zoom is closer than this. Only applies in dynamic mode (Manual offset disabled).",
    0, 40, apply)

addCheckbox(category, "playerPosition", "manualOffset",
    "Manual offset",
    "Use the offset sliders below to manually position the cross. When disabled, offset sliders are ignored.",
    apply)

addSlider(category, "playerPosition", "offsetY",
    "Vertical offset", "Vertical offset for the position cross.",
    -screenHeightHalf, screenHeightHalf, apply)
addSlider(category, "playerPosition", "offsetX",
    "Horizontal offset", "Horizontal offset for the position cross.",
    -screenWidthHalf, screenWidthHalf, apply)
