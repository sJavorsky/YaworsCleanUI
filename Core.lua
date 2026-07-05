YaworsCleanUI = {}

local DEFAULTS = {
    hideElements = {
        looting = false,
        bags = false,
        groupIndicator = false,
    },
    moveElements = {
        queueEye = false,
        eyeDistance = 105,
        eyeAngle = 25,
        bnetToast = false,
        toastPreview = false,
        toastOffsetX = 915,
        toastOffsetY = -550,
    },
    filterChat = {
        talentSpam = false,
    },
    classResourcePoints = {
        offsetY = -80,
        offsetX = 0,
        scale = 200,
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
        fancyTextures = true,
        offsetY = -195,
        offsetX = 0,
        scale = 120,
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
        combatOnly = true,
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
        combatOnly = true,
        previewTrackers = false,
        size = 65,
        outerWidth = 4,
        outerColor = { r = 0, g = 0, b = 0 },
        innerWidth = 3,
        innerColor = { r = 1, g = 1, b = 1 },
        outerTrackerWidth = 5,
        outerTrackerColor = { r = 0.7333, g = 0.7333, b = 0.7333 },
        outerTrackerSource = "cast",
        innerTrackerWidth = 5,
        innerTrackerColor = { r = 0.7333, g = 0.7333, b = 0.7333 },
        innerTrackerSource = "gcd",
    },
}

YaworsCleanUI.DEFAULTS = DEFAULTS

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
