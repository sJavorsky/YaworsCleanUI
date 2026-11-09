local category = YaworsCleanUI.settingsCategories.cursor
local addCheckbox = YaworsCleanUI.addCheckbox
local addColorPicker = YaworsCleanUI.addColorPicker
local addSlider = YaworsCleanUI.addSlider
local addDropdown = YaworsCleanUI.addDropdown
local addSectionHeader = YaworsCleanUI.addSectionHeader
local addButton = YaworsCleanUI.addButton

local function apply()
    YaworsCleanUI.CursorPosition.applySettings()
end

local TRACKER_SOURCES = {{"cast", "Spell cast"}, {"gcd", "Global cooldown"}}
local SETTINGS_MODES = {{"common", "Common"}, {"role", "Role specific"}}
local SET_HEADERS = {
    {"common", "Common settings"}, {"melee", "Melee settings"}, {"range", "Range settings"},
    {"tank", "Tank settings"}, {"healer", "Healer settings"},
}

local function getActiveSettings()
    return YaworsCleanUI.CursorPosition.getActiveSettings()
end

-- Controls read and write whichever set is active, so one row serves all five sets
local ACTIVE_SET_GROUP = {
    id = "cursorPosition",
    defaults = YaworsCleanUI.DEFAULTS.cursorPosition.settings.common,
    getValues = getActiveSettings,
}

local function isTwoTone()
    return getActiveSettings().twoToneRing
end

local function isSingleColor()
    return not getActiveSettings().twoToneRing
end

local function isOuterTrackerShown()
    return getActiveSettings().showOuterTracker
end

local function isInnerTrackerShown()
    return getActiveSettings().showInnerTracker
end

-- Hides every row of a section, header included, while isShown returns false.
-- The panel redraws on every setting change, so sections toggle immediately.
local function showWhile(isShown, ...)
    for _, row in ipairs({...}) do
        row:AddShownPredicate(isShown)
    end
end

addDropdown(category, "cursorPosition", "mode", "Use settings",
    "Common uses one set of settings for every role. Role specific keeps a separate set for melee, range, tank and healer.",
    SETTINGS_MODES, apply)

-- One header per title because a section header's text is fixed once created
for _, header in ipairs(SET_HEADERS) do
    local setKey, title = header[1], header[2]
    showWhile(function() return YaworsCleanUI.CursorPosition.getActiveSetKey() == setKey end,
        addSectionHeader(category, title))
end

addCheckbox(category, ACTIVE_SET_GROUP, "enabled", "Show position circle",
    "Draws a circle at the cursor to mark its position.", apply)

addCheckbox(category, ACTIVE_SET_GROUP, "combatOnly", "Show only in combat",
    "Hides the position circle when not in combat.", apply)

addSlider(category, ACTIVE_SET_GROUP, "size", "Size", "Diameter of the position circle.", 10, 300, apply)

addSectionHeader(category, "Components")
addCheckbox(category, ACTIVE_SET_GROUP, "twoToneRing", "Two-tone ring",
    "Splits the ring into an outer and an inner band, each with its own color and width. Off draws a single-color ring.",
    apply)
addCheckbox(category, ACTIVE_SET_GROUP, "showInnerTracker", "Inner tracker",
    "Shows a tracker ring along the inside of the circle.", apply)
addCheckbox(category, ACTIVE_SET_GROUP, "showOuterTracker", "Outer tracker",
    "Shows a tracker ring around the outside of the circle.", apply)
showWhile(function() return isInnerTrackerShown() or isOuterTrackerShown() end,
    addButton(category, "Preview trackers",
        "Loops the trackers through a demo fill so you can see and configure them. Stops when you close the options.",
        function() YaworsCleanUI.CursorPosition.toggleTrackerPreview() end))

showWhile(isSingleColor, addSectionHeader(category, "Ring"),
    addColorPicker(category, ACTIVE_SET_GROUP, "ringColor", "Color", "Color of the ring.", apply),
    addSlider(category, ACTIVE_SET_GROUP, "ringWidth", "Width", "Thickness of the ring.", 1, 75, apply))

showWhile(isTwoTone, addSectionHeader(category, "Inner ring"),
    addColorPicker(category, ACTIVE_SET_GROUP, "innerColor", "Color", "Color of the inner ring.", apply), addSlider(
        category, ACTIVE_SET_GROUP, "innerWidth", "Width", "Thickness of the inner ring.", 1, 75, apply))
showWhile(isTwoTone, addSectionHeader(category, "Outer ring"),
    addColorPicker(category, ACTIVE_SET_GROUP, "outerColor", "Color", "Color of the outer ring.", apply), addSlider(
        category, ACTIVE_SET_GROUP, "outerWidth", "Width", "Thickness of the outer ring.", 1, 75, apply))

showWhile(isInnerTrackerShown, addSectionHeader(category, "Inner tracker"), addColorPicker(category, ACTIVE_SET_GROUP,
    "innerTrackerColor", "Color", "Color of the inner tracker ring.", apply),
    addSlider(category, ACTIVE_SET_GROUP, "innerTrackerWidth", "Width",
        "Thickness of the inner tracker ring (0 hides it).", 0, 75, apply),
    addDropdown(category, ACTIVE_SET_GROUP, "innerTrackerSource", "Source", "What the inner tracker ring fills for.",
        TRACKER_SOURCES, apply))

showWhile(isOuterTrackerShown, addSectionHeader(category, "Outer tracker"), addColorPicker(category, ACTIVE_SET_GROUP,
    "outerTrackerColor", "Color", "Color of the outer tracker ring.", apply),
    addSlider(category, ACTIVE_SET_GROUP, "outerTrackerWidth", "Width",
        "Thickness of the outer tracker ring (0 hides it).", 0, 75, apply),
    addDropdown(category, ACTIVE_SET_GROUP, "outerTrackerSource", "Source", "What the outer tracker ring fills for.",
        TRACKER_SOURCES, apply))
