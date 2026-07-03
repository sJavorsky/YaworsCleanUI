local category = YaworsCleanUI.settingsCategories.cursor
local addCheckbox = YaworsCleanUI.addCheckbox
local addColorPicker = YaworsCleanUI.addColorPicker
local addSectionHeader = YaworsCleanUI.addSectionHeader

local function apply()
    YaworsCleanUI.CursorPosition.applySettings()
end

local function addSlider(variable, key, name, default, minValue, maxValue, tooltip)
    local setting = Settings.RegisterProxySetting(
        category,
        variable,
        Settings.VarType.Number,
        name,
        default,
        function() return YaworsCleanUIDB.cursorPosition[key] end,
        function(value)
            YaworsCleanUIDB.cursorPosition[key] = value
            apply()
        end
    )
    local options = Settings.CreateSliderOptions(minValue, maxValue, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, setting, options, tooltip)
end

local createDropdown = Settings.CreateDropdown or Settings.CreateDropDown

local function addTrackerSource(variable, key, name, tooltip)
    local setting = Settings.RegisterProxySetting(
        category,
        variable,
        Settings.VarType.String,
        name,
        "cast",
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

addSlider("YaworsCleanUI_cursorPositionSize", "size",
    "Size", 65, 10, 300, "Diameter of the position circle.")

addSectionHeader(category, "Outer ring")
addColorPicker(category, "cursorPosition", "outerColor",
    "Color", "Color of the outer ring.", "ffffffff", apply)
addSlider("YaworsCleanUI_cursorPositionOuterWidth", "outerWidth",
    "Width", 4, 1, 75, "Thickness of the outer ring.")

addSectionHeader(category, "Inner ring")
addColorPicker(category, "cursorPosition", "innerColor",
    "Color", "Color of the inner ring.", "ff000000", apply)
addSlider("YaworsCleanUI_cursorPositionInnerWidth", "innerWidth",
    "Width", 4, 1, 75, "Thickness of the inner ring.")

addSectionHeader(category, "Outer tracker")
addColorPicker(category, "cursorPosition", "outerTrackerColor",
    "Color", "Color of the outer tracker ring.", "ffbbbbbb", apply)
addSlider("YaworsCleanUI_cursorPositionOuterTrackerWidth", "outerTrackerWidth",
    "Width", 4, 0, 75, "Thickness of the outer tracker ring (0 hides it).")
addTrackerSource("YaworsCleanUI_cursorPositionOuterTrackerSource", "outerTrackerSource",
    "Source", "What the outer tracker ring fills for.")

addSectionHeader(category, "Inner tracker")
addColorPicker(category, "cursorPosition", "innerTrackerColor",
    "Color", "Color of the inner tracker ring.", "ffbbbbbb", apply)
addSlider("YaworsCleanUI_cursorPositionInnerTrackerWidth", "innerTrackerWidth",
    "Width", 4, 0, 75, "Thickness of the inner tracker ring (0 hides it).")
addTrackerSource("YaworsCleanUI_cursorPositionInnerTrackerSource", "innerTrackerSource",
    "Source", "What the inner tracker ring fills for.")
