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
    return Settings.CreateCheckbox(category, setting, tooltip)
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
    return Settings.CreateColorSwatch(category, setting, tooltip)
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
    return Settings.CreateSlider(category, setting, options, tooltip)
end

-- choices is a list of { value, label } pairs, shown in that order
function YaworsCleanUI.addDropdown(category, group, key, name, tooltip, choices, callback)
    local setting = Settings.RegisterProxySetting(
        category,
        "YaworsCleanUI_" .. group .. "_" .. key,
        Settings.VarType.String,
        name,
        YaworsCleanUI.DEFAULTS[group][key],
        function() return YaworsCleanUIDB[group][key] end,
        function(value)
            YaworsCleanUIDB[group][key] = value
            callback()
        end
    )
    local function getOptions()
        local container = Settings.CreateControlTextContainer()
        for _, choice in ipairs(choices) do
            container:Add(choice[1], choice[2])
        end
        return container:GetData()
    end
    return Settings.CreateDropdown(category, setting, getOptions, tooltip)
end

-- A button row for actions that aren't settings, so nothing is saved
function YaworsCleanUI.addButton(category, buttonText, tooltip, onClick)
    -- An empty name makes Blizzard drop the label and anchor the button on the left,
    -- where the label would sit. The final true adds buttonText as a search tag.
    local initializer = CreateSettingsButtonInitializer("", buttonText, onClick, tooltip, true)
    SettingsPanel:GetLayout(category):AddInitializer(initializer)
    return initializer
end

-- Adds a section subheader within a category, rendered smaller than the category
-- title. Appends at the current position, so call it between controls to group them.
function YaworsCleanUI.addSectionHeader(category, name)
    local layout = SettingsPanel:GetLayout(category)
    local initializer = CreateSettingsListSectionHeaderInitializer(name)
    layout:AddInitializer(initializer)
    return initializer
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
