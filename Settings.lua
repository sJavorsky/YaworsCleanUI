local category       = Settings.RegisterVerticalLayoutCategory("Yawor's Clean UI")
local hideCategory   = Settings.RegisterVerticalLayoutSubcategory(category, "Hide UI elements")
local moveCategory   = Settings.RegisterVerticalLayoutSubcategory(category, "Move UI elements")
local chatCategory   = Settings.RegisterVerticalLayoutSubcategory(category, "Filter chat")
local pointsCategory = Settings.RegisterVerticalLayoutSubcategory(category, "Points Class Resources")
local barsCategory   = Settings.RegisterVerticalLayoutSubcategory(category, "Bars Class Resources")
local posCategory    = Settings.RegisterVerticalLayoutSubcategory(category, "Player Position")
local cursorCategory = Settings.RegisterVerticalLayoutSubcategory(category, "Cursor Position")

YaworsCleanUI.settingsCategories = {
    hide     = hideCategory,
    move     = moveCategory,
    chat     = chatCategory,
    points   = pointsCategory,
    bars     = barsCategory,
    position = posCategory,
    cursor   = cursorCategory,
}

function YaworsCleanUI.addCheckbox(category, group, key, name, tooltip, callback)
    -- RegisterProxySetting delegates storage to our own getter/setter rather
    -- than a CVar; the key must be globally unique across all addons.
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. group .. "_" .. key,
        Settings.VarType.Boolean,
        name,
        YaworsCleanUI.DEFAULTS[group][key],
        function() return YaworsCleanUIDB[group][key] end,
        function(value)
            YaworsCleanUIDB[group][key] = value
            callback()
        end
    )
    Settings.CreateCheckbox(category, setting, tooltip)
end

function YaworsCleanUI.addColorPicker(category, group, colorKey, name, tooltip, callback)
    local defaultColor = YaworsCleanUI.DEFAULTS[group][colorKey]
    local defaultHex = CreateColor(defaultColor.r, defaultColor.g, defaultColor.b):GenerateHexColor()
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. group .. "_" .. colorKey,
        Settings.VarType.String,
        name,
        defaultHex,
        function()
            local colorTable = YaworsCleanUIDB[group][colorKey]
            return CreateColor(colorTable.r, colorTable.g, colorTable.b):GenerateHexColor()
        end,
        function(value)
            local color = CreateColorFromHexString(value)
            local colorTable = YaworsCleanUIDB[group][colorKey]
            colorTable.r = color.r
            colorTable.g = color.g
            colorTable.b = color.b
            callback()
        end
    )
    Settings.CreateColorSwatch(category, setting, tooltip)
end

function YaworsCleanUI.addSlider(category, group, key, name, tooltip, minValue, maxValue, callback)
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. group .. "_" .. key,
        Settings.VarType.Number,
        name,
        YaworsCleanUI.DEFAULTS[group][key],
        function() return YaworsCleanUIDB[group][key] end,
        function(value)
            YaworsCleanUIDB[group][key] = value
            callback()
        end
    )
    local options = Settings.CreateSliderOptions(minValue, maxValue, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, setting, options, tooltip)
end

-- Adds a section subheader within a category, rendered smaller than the category
-- title. Appends at the current position, so call it between controls to group them.
function YaworsCleanUI.addSectionHeader(category, name)
    local layout = SettingsPanel:GetLayout(category)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(name))
end

-- Defer registration until ADDON_LOADED so that settings/ sub-files, which are
-- listed after this file in the TOC, have all run and added their controls first.
local registrationFrame = CreateFrame("Frame")
registrationFrame:RegisterEvent("ADDON_LOADED")
registrationFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= "YaworsCleanUI" then return end
    Settings.RegisterAddOnCategory(category)
    Settings.RegisterAddOnCategory(hideCategory)
    Settings.RegisterAddOnCategory(moveCategory)
    Settings.RegisterAddOnCategory(chatCategory)
    Settings.RegisterAddOnCategory(pointsCategory)
    Settings.RegisterAddOnCategory(barsCategory)
    Settings.RegisterAddOnCategory(posCategory)
    Settings.RegisterAddOnCategory(cursorCategory)
    self:UnregisterEvent("ADDON_LOADED")
end)
