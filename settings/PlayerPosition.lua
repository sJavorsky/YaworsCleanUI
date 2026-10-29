local category = YaworsCleanUI.settingsCategories.position
local addCheckbox = YaworsCleanUI.addCheckbox
local addColorPicker = YaworsCleanUI.addColorPicker
local addSlider = YaworsCleanUI.addSlider
local addSectionHeader = YaworsCleanUI.addSectionHeader
local addDropdown = YaworsCleanUI.addDropdown

local screenHeightHalf = math.floor(GetScreenHeight()*0.8)
local screenWidthHalf = math.floor(GetScreenWidth()*0.8)

local function apply()
    YaworsCleanUI.PlayerPosition.applySettings()
end

addCheckbox(category, "playerPosition", "enabled",
    "Show position cross", "Draws a cross at the center of the screen to mark your character's position.", apply)

addCheckbox(category, "playerPosition", "combatOnly",
    "Show only in combat", "Hides the position cross when not in combat.", apply)

addDropdown(category, "playerPosition", "positionMode",
    "Position",
    "Dynamic follows your character as the camera zooms. Manual pins the cross at a fixed offset from screen center.",
    { { "dynamic", "Dynamic" }, { "manual", "Manual" } },
    apply)

local function isManualPosition()
    return YaworsCleanUIDB.playerPosition.positionMode == "manual"
end

-- The panel redraws on every setting change, so these rows appear and vanish
-- as soon as the dropdown changes
addSlider(category, "playerPosition", "offsetY",
    "Vertical offset", "Vertical offset for the position cross.",
    -screenHeightHalf, screenHeightHalf, apply):AddShownPredicate(isManualPosition)
addSlider(category, "playerPosition", "offsetX",
    "Horizontal offset", "Horizontal offset for the position cross.",
    -screenWidthHalf, screenWidthHalf, apply):AddShownPredicate(isManualPosition)

addSectionHeader(category, "Cross customization")
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
    "Min Zoom", "Hide the cross when the camera zoom is closer than this. Only applies when Position is Dynamic.",
    0, 40, apply)
