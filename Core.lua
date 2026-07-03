YaworsCleanUI = {}

local DEFAULTS = {
    hideElements = {
        looting = false,
        bags = false,
        groupIndicator = false,
    },
    moveElements = {
        queueEye = false,
        eyeDistance = 0,
        eyeAngle = 0,
        bnetToast = false,
        toastPreview = false,
        toastOffsetX = 0,
        toastOffsetY = 0,
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
        evokerEssence = false,
        rogueComboPoints = false,
        monkChi = false,
        warlockSoulShards = false,
        mageArcaneCharges = false,
        paladinHolyPower = false,
    },
    classResourceBars = {
        fancyTextures = false,
        offsetY = 0,
        offsetX = 0,
        scale = 100,
        deathKnightRunicPower = false,
        druidEnergy = false,
        druidRage = false,
        druidAstralPower = false,
        evokerEbonMight = false,
        warriorRage = false,
        hunterFocus = false,
        rogueEnergy = false,
        priestInsanity = false,
        shamanMaelstrom = false,
        monkEnergy = false,
        demonHunterFury = false,
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
        minZoom = 5,
    },
    cursorPosition = {
        enabled = false,
        combatOnly = false,
        outerColor = { r = 1, g = 1, b = 1 },
        innerColor = { r = 0, g = 0, b = 0 },
        outerTrackerWidth = 4,
        outerTrackerColor = { r = 1, g = 0.8, b = 0.1 },
        innerTrackerWidth = 4,
        innerTrackerColor = { r = 0.6, g = 0.2, b = 1 },
        size = 65,
        width = 4,
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
