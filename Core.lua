YaworsCleanUI = {}

local DEFAULTS = {
    hideElements = {
        looting = false,
        bags = false,
    },
    filterChat = {
        talentSpam = false,
    },
    classResourcePoints = {
        offsetY = 0,
        offsetX = 0,
        scale = 100,
        deathKnightRunes = false,
        druidComboPoints = false,
    },
    classResourceBars = {
        offsetY = 0,
        offsetX = 0,
        scale = 100,
        deathKnightRunicPower = false,
        druidEnergy = false,
        druidRage = false,
        druidAstralPower = false,
        warriorRage = false,
        paladinHolyPower = false,
        hunterFocus = false,
        rogueEnergy = false,
        priestInsanity = false,
        shamanMaelstrom = false,
        mageArcaneCharges = false,
        warlockSoulShards = false,
        monkEnergy = false,
        demonHunterFury = false,
        evokerEssence = false,
    },
    playerPosition = {
        enabled = false,
        combatOnly = false,
        innerColor = { r = 1, g = 1, b = 1 },
        borderColor = { r = 0, g = 0, b = 0 },
        height = 40,
        width = 40,
        thickness = 2,
        manualOffset = false,
        offsetY = 0,
        offsetX = 0,
    },
    cursorPosition = {
        enabled = false,
        combatOnly = false,
        innerColor = { r = 1, g = 1, b = 1 },
        outerColor = { r = 0, g = 0, b = 0 },
        size = 50,
        width = 10,
    },
}

local function applyDefaults(target, defaults)
    for key, default in pairs(defaults) do
        if type(default) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            applyDefaults(target[key], default)
        elseif target[key] == nil then
            target[key] = default
        end
    end
end

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
    applyDefaults(YaworsCleanUIDB, DEFAULTS)

    for _, mod in ipairs(registeredModules) do
        mod.init()
    end

    -- No other addons to wait for; stop listening
    self:UnregisterEvent("ADDON_LOADED")
end)
