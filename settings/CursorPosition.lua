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

local function isTwoTone()
    return YaworsCleanUIDB.cursorPosition.twoToneRing
end

local function isSingleColor()
    return not YaworsCleanUIDB.cursorPosition.twoToneRing
end

local function isOuterTrackerShown()
    return YaworsCleanUIDB.cursorPosition.showOuterTracker
end

local function isInnerTrackerShown()
    return YaworsCleanUIDB.cursorPosition.showInnerTracker
end

-- Hides every row of a section, header included, while isShown returns false.
-- The panel redraws on every setting change, so sections toggle immediately.
local function showWhile(isShown, ...)
    for i = 1, select("#", ...) do
        select(i, ...):AddShownPredicate(isShown)
    end
end

addCheckbox(category, "cursorPosition", "enabled", "Show position circle",
    "Draws a circle at the cursor to mark its position.", apply)

addCheckbox(category, "cursorPosition", "combatOnly", "Show only in combat",
    "Hides the position circle when not in combat.", apply)

addSlider(category, "cursorPosition", "size", "Size", "Diameter of the position circle.", 10, 300, apply)

addSectionHeader(category, "Components")
addCheckbox(category, "cursorPosition", "twoToneRing", "Two-tone ring",
    "Splits the ring into an outer and an inner band, each with its own color and width. Off draws a single-color ring.",
    apply)
addCheckbox(category, "cursorPosition", "showInnerTracker", "Inner tracker",
    "Shows a tracker ring along the inside of the circle.", apply)
addCheckbox(category, "cursorPosition", "showOuterTracker", "Outer tracker",
    "Shows a tracker ring around the outside of the circle.", apply)
showWhile(function() return isInnerTrackerShown() or isOuterTrackerShown() end,
    addButton(category, "Preview trackers",
        "Loops the trackers through a demo fill so you can see and configure them. Stops when you close the options.",
        function() YaworsCleanUI.CursorPosition.toggleTrackerPreview() end))

showWhile(isSingleColor, addSectionHeader(category, "Ring"),
    addColorPicker(category, "cursorPosition", "ringColor", "Color", "Color of the ring.", apply),
    addSlider(category, "cursorPosition", "ringWidth", "Width", "Thickness of the ring.", 1, 75, apply))

showWhile(isTwoTone, addSectionHeader(category, "Inner ring"),
    addColorPicker(category, "cursorPosition", "innerColor", "Color", "Color of the inner ring.", apply), addSlider(
        category, "cursorPosition", "innerWidth", "Width", "Thickness of the inner ring.", 1, 75, apply))
showWhile(isTwoTone, addSectionHeader(category, "Outer ring"),
    addColorPicker(category, "cursorPosition", "outerColor", "Color", "Color of the outer ring.", apply), addSlider(
        category, "cursorPosition", "outerWidth", "Width", "Thickness of the outer ring.", 1, 75, apply))

showWhile(isInnerTrackerShown, addSectionHeader(category, "Inner tracker"), addColorPicker(category, "cursorPosition",
    "innerTrackerColor", "Color", "Color of the inner tracker ring.", apply),
    addSlider(category, "cursorPosition", "innerTrackerWidth", "Width",
        "Thickness of the inner tracker ring (0 hides it).", 0, 75, apply),
    addDropdown(category, "cursorPosition", "innerTrackerSource", "Source", "What the inner tracker ring fills for.",
        TRACKER_SOURCES, apply))

showWhile(isOuterTrackerShown, addSectionHeader(category, "Outer tracker"), addColorPicker(category, "cursorPosition",
    "outerTrackerColor", "Color", "Color of the outer tracker ring.", apply),
    addSlider(category, "cursorPosition", "outerTrackerWidth", "Width",
        "Thickness of the outer tracker ring (0 hides it).", 0, 75, apply),
    addDropdown(category, "cursorPosition", "outerTrackerSource", "Source", "What the outer tracker ring fills for.",
        TRACKER_SOURCES, apply))
