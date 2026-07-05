local category = YaworsCleanUI.settingsCategories.cursor
local addCheckbox = YaworsCleanUI.addCheckbox
local addColorPicker = YaworsCleanUI.addColorPicker
local addSlider = YaworsCleanUI.addSlider
local addSectionHeader = YaworsCleanUI.addSectionHeader

local function apply()
    YaworsCleanUI.CursorPosition.applySettings()
end

local createDropdown = Settings.CreateDropdown or Settings.CreateDropDown

local function addTrackerSource(variable, key, name, tooltip)
    local setting = Settings.RegisterProxySetting(
        category,
        variable,
        Settings.VarType.String,
        name,
        YaworsCleanUI.DEFAULTS.cursorPosition[key],
        function() return YaworsCleanUIDB.cursorPosition[key] end,
        function(value)
            YaworsCleanUIDB.cursorPosition[key] = value
            apply()
        end
    )
    local function options()
        local container = Settings.CreateControlTextContainer()
        container:Add("cast", "Spell cast")
        container:Add("gcd", "Global cooldown")
        return container:GetData()
    end
    createDropdown(category, setting, options, tooltip)
end

addCheckbox(category, "cursorPosition", "enabled",
    "Show position circle", "Draws a circle at the cursor to mark its position.", apply)

addCheckbox(category, "cursorPosition", "combatOnly",
    "Show only in combat", "Hides the position circle when not in combat.", apply)

addCheckbox(category, "cursorPosition", "previewTrackers",
    "Preview trackers", "Loops both trackers through a demo fill so you can see and configure them; turn off for live cast/GCD tracking.", apply)

addSlider(category, "cursorPosition", "size",
    "Size", "Diameter of the position circle.", 10, 300, apply)

addSectionHeader(category, "Outer ring")
addColorPicker(category, "cursorPosition", "outerColor",
    "Color", "Color of the outer ring.", apply)
addSlider(category, "cursorPosition", "outerWidth",
    "Width", "Thickness of the outer ring.", 1, 75, apply)

addSectionHeader(category, "Inner ring")
addColorPicker(category, "cursorPosition", "innerColor",
    "Color", "Color of the inner ring.", apply)
addSlider(category, "cursorPosition", "innerWidth",
    "Width", "Thickness of the inner ring.", 1, 75, apply)

addSectionHeader(category, "Outer tracker")
addColorPicker(category, "cursorPosition", "outerTrackerColor",
    "Color", "Color of the outer tracker ring.", apply)
addSlider(category, "cursorPosition", "outerTrackerWidth",
    "Width", "Thickness of the outer tracker ring (0 hides it).", 0, 75, apply)
addTrackerSource("YaworsCleanUI_cursorPositionOuterTrackerSource", "outerTrackerSource",
    "Source", "What the outer tracker ring fills for.")

addSectionHeader(category, "Inner tracker")
addColorPicker(category, "cursorPosition", "innerTrackerColor",
    "Color", "Color of the inner tracker ring.", apply)
addSlider(category, "cursorPosition", "innerTrackerWidth",
    "Width", "Thickness of the inner tracker ring (0 hides it).", 0, 75, apply)
addTrackerSource("YaworsCleanUI_cursorPositionInnerTrackerSource", "innerTrackerSource",
    "Source", "What the inner tracker ring fills for.")
