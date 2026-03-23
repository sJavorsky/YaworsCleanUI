-- Settings.RegisterVerticalLayoutCategory returns the category and its layout.
-- The layout's AddInitializer is used for section headers; the category is
-- passed to Settings.Create* functions and RegisterAddOnCategory.
local category, layout = Settings.RegisterVerticalLayoutCategory("Yawor's Clean UI")

local function addCheckBox(key, name, tooltip, callback)
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
            callback()
        end
    )
    Settings.CreateCheckbox(category, setting, tooltip)
end

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Hide UI elements"))

addCheckBox("hideLooting", "Hide looting window", "Hides the loot frame when looting.", function()
    YaworsCleanUI.HideElements.applySettings()
end)
addCheckBox("hideBags", "Hide bag icons", "Hides the bag bar icons.", function()
    YaworsCleanUI.HideElements.applySettings()
end)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Points Class Resources"))

local offsetYSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourcePointsOffsetY",
    Settings.VarType.Number,
    "Vertical offset",
    0,
    function() return YaworsCleanUIDB.classResourcePointsOffsetY end,
    function(value)
        YaworsCleanUIDB.classResourcePointsOffsetY = value
        YaworsCleanUI.CombatResources.applySettings()
    end
)
local screenHeight = math.floor(GetScreenHeight())
local offsetYOptions = Settings.CreateSliderOptions(-screenHeight, screenHeight, 1)
offsetYOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, offsetYSetting, offsetYOptions, "Vertical offset for class resource frames.")

local offsetXSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourcePointsOffsetX",
    Settings.VarType.Number,
    "Horizontal offset",
    0,
    function() return YaworsCleanUIDB.classResourcePointsOffsetX end,
    function(value)
        YaworsCleanUIDB.classResourcePointsOffsetX = value
        YaworsCleanUI.CombatResources.applySettings()
    end
)
local screenWidth = math.floor(GetScreenWidth())
local offsetXOptions = Settings.CreateSliderOptions(-screenWidth, screenWidth, 1)
offsetXOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, offsetXSetting, offsetXOptions, "Horizontal offset for class resource frames.")

local scaleSetting = Settings.RegisterProxySetting(
    category,
    "YaworsCleanUI_classResourcePointsScale",
    Settings.VarType.Number,
    "Scale",
    100,
    function() return YaworsCleanUIDB.classResourcePointsScale end,
    function(value)
        YaworsCleanUIDB.classResourcePointsScale = value
        YaworsCleanUI.CombatResources.applySettings()
    end
)
local scaleOptions = Settings.CreateSliderOptions(1, 1000, 1)
scaleOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
Settings.CreateSlider(category, scaleSetting, scaleOptions, "Scale of class resource frames (percentage).")

addCheckBox("deathKnightRunes", "Death Knight runes", "Move the Death Knight runes to the center of the screen.", function()
    YaworsCleanUI.CombatResources.applySettings()
end)

-- RegisterAddOnCategory places the category under the AddOns section of the
-- Blizzard Interface Options panel.
Settings.RegisterAddOnCategory(category)
