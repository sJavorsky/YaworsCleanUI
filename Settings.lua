local category       = Settings.RegisterVerticalLayoutCategory("Yawor's Clean UI")
local hideCategory   = Settings.RegisterVerticalLayoutSubcategory(category, "Hide UI elements")
local chatCategory   = Settings.RegisterVerticalLayoutSubcategory(category, "Filter chat")
local pointsCategory = Settings.RegisterVerticalLayoutSubcategory(category, "Points Class Resources")
local barsCategory   = Settings.RegisterVerticalLayoutSubcategory(category, "Bars Class Resources")
local posCategory    = Settings.RegisterVerticalLayoutSubcategory(category, "Player Position")

YaworsCleanUI.settingsCategories = {
    hide     = hideCategory,
    chat     = chatCategory,
    points   = pointsCategory,
    bars     = barsCategory,
    position = posCategory,
}

function YaworsCleanUI.addCheckbox(category, group, key, name, tooltip, callback)
    -- RegisterProxySetting delegates storage to our own getter/setter rather
    -- than a CVar; the key must be globally unique across all addons.
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. group .. "_" .. key,
        Settings.VarType.Boolean,
        name,
        false,
        function() return YaworsCleanUIDB[group][key] end,
        function(value)
            YaworsCleanUIDB[group][key] = value
            callback()
        end
    )
    Settings.CreateCheckbox(category, setting, tooltip)
end

function YaworsCleanUI.addColorPicker(category, group, colorKey, name, tooltip, defaultHex, callback)
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

-- Defer registration until ADDON_LOADED so that settings/ sub-files, which are
-- listed after this file in the TOC, have all run and added their controls first.
local registrationFrame = CreateFrame("Frame")
registrationFrame:RegisterEvent("ADDON_LOADED")
registrationFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= "YaworsCleanUI" then return end
    Settings.RegisterAddOnCategory(category)
    Settings.RegisterAddOnCategory(hideCategory)
    Settings.RegisterAddOnCategory(chatCategory)
    Settings.RegisterAddOnCategory(pointsCategory)
    Settings.RegisterAddOnCategory(barsCategory)
    Settings.RegisterAddOnCategory(posCategory)
    self:UnregisterEvent("ADDON_LOADED")
end)
