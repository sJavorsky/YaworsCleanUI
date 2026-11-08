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
local ROLE_HEADERS = {
    {"MELEE", "Melee settings"}, {"RANGE", "Range settings"}, {"TANK", "Tank settings"}, {"HEALER", "Healer settings"},
}

-- Blizzard's role token is only "DAMAGER", so range is told apart by spec ID
local RANGE_DAMAGE_SPEC_IDS = {
    62, 63, 64,    -- Mage: Arcane, Fire, Frost
    102,           -- Druid: Balance
    253, 254,      -- Hunter: Beast Mastery, Marksmanship
    258,           -- Priest: Shadow
    262,           -- Shaman: Elemental
    265, 266, 267, -- Warlock: Affliction, Demonology, Destruction
    1467, 1473,    -- Evoker: Devastation, Augmentation
    1480,          -- Demon Hunter: Devourer
}

-- Used before a character has chosen a spec. Mixed classes follow their starting playstyle.
local NEW_CHARACTER_SPEC_INDEX = 5
local RANGE_CLASSES = {"DRUID", "EVOKER", "HUNTER", "MAGE", "PRIEST", "SHAMAN", "WARLOCK"}

local function isRoleSpecific()
    return YaworsCleanUIDB.cursorPosition.settingsMode == "role"
end

local function getPlayerRole()
    -- GetSpecialization returns the active spec's index, nil when none is learned
    -- and 5 for newly created characters
    local specIndex = C_SpecializationInfo.GetSpecialization()
    if not specIndex or specIndex == NEW_CHARACTER_SPEC_INDEX then
        -- UnitClassBase returns the locale-independent class token, e.g. "DRUID"
        return tContains(RANGE_CLASSES, UnitClassBase("player")) and "RANGE" or "MELEE"
    end
    -- Returns specID first and the role token ("DAMAGER", "TANK" or "HEALER") fifth
    local specID, _, _, _, role = C_SpecializationInfo.GetSpecializationInfo(specIndex)
    if role == "TANK" or role == "HEALER" then
        return role
    end
    return tContains(RANGE_DAMAGE_SPEC_IDS, specID) and "RANGE" or "MELEE"
end

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

addDropdown(category, "cursorPosition", "settingsMode", "Use settings",
    "Common uses one set of settings for every role. Role specific keeps a separate set for melee, range, tank and healer.",
    SETTINGS_MODES, apply)

-- One header per title because a section header's text is fixed once created
showWhile(function() return not isRoleSpecific() end, addSectionHeader(category, "Common settings"))
for _, roleHeader in ipairs(ROLE_HEADERS) do
    local role, title = roleHeader[1], roleHeader[2]
    showWhile(function() return isRoleSpecific() and getPlayerRole() == role end, addSectionHeader(category, title))
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
