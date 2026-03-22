-- Settings.RegisterVerticalLayoutCategory creates a category with a vertical
-- initializer layout, which is required for Settings.CreateCheckBox to work.
local category = Settings.RegisterVerticalLayoutCategory("YaworsCleanUI")

local function addCheckBox(key, name, tooltip)
    -- RegisterProxySetting delegates storage to our own getter/setter rather
    -- than a CVar; the key must be globally unique across all addons.
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. key,
        Settings.VarType.Boolean,
        name,
        false,
        function() return YaworsCleanUIDB[key] end,
        function(value)
            YaworsCleanUIDB[key] = value
            YaworsCleanUI.HideElements.applySettings()
        end
    )
    Settings.CreateCheckbox(category, setting, tooltip)
end

addCheckBox("hideLooting", "Hide looting window", "Hides the loot frame when looting.")
addCheckBox("hideBags", "Hide bag icons", "Hides the bag bar icons.")

local centerDKRunesSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_centerDKRunes",
    Settings.VarType.Boolean,
    "Center DK rune bar",
    false,
    function() return YaworsCleanUIDB.centerDKRunes end,
    function(value)
        YaworsCleanUIDB.centerDKRunes = value
        YaworsCleanUI.CombatResources.applySettings()
    end
)
Settings.CreateCheckbox(category, centerDKRunesSetting, "Move the Death Knight rune bar to the center of the screen.")

-- RegisterAddOnCategory places the category under the AddOns section of the
-- Blizzard Interface Options panel.
Settings.RegisterAddOnCategory(category)
