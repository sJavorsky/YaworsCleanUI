YaworsCleanUI = {}

local DEFAULTS = {
    hideLooting = false,
    hideBags = false,
    centerDKRunes = false,
}

local registeredModules = {}

function YaworsCleanUI.registerModule(mod)
    table.insert(registeredModules, mod)
end

local frame = CreateFrame("Frame")
-- ADDON_LOADED fires once per addon when its saved variables are ready
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= "YaworsCleanUI" then return end

    if not YaworsCleanUIDB then
        YaworsCleanUIDB = {}
    end
    for key, default in pairs(DEFAULTS) do
        if YaworsCleanUIDB[key] == nil then
            YaworsCleanUIDB[key] = default
        end
    end

    for _, mod in ipairs(registeredModules) do
        mod.init()
    end

    -- No other addons to wait for; stop listening
    self:UnregisterEvent("ADDON_LOADED")
end)
