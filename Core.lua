YaworsCleanUI = {}

local DEFAULTS = {
    hideElements = {
        looting = true,
        bags = true,
        groupIndicator = true,
    },
    moveElements = {
        queueEye = true,
        eyeDistance = 105,
        eyeAngle = 25,
        bnetToast = true,
        toastOffsetX = 915,
        toastOffsetY = -550,
    },
    filterChat = {
        talentSpam = true,
    },
    classResourcePoints = {
        enabled = true,
        offsetY = -120,
        offsetX = 0,
        scale = 175,
        deathKnightRunes = true,
        druidComboPoints = true,
        evokerEssence = true,
        rogueComboPoints = true,
        monkChi = true,
        warlockSoulShards = true,
        mageArcaneCharges = true,
        paladinHolyPower = true,
    },
    classResourceBars = {
        enabled = true,
        fancyTextures = true,
        offsetY = -200,
        offsetX = 0,
        scale = 120,
        deathKnightRunicPower = true,
        druidEnergy = true,
        druidRage = true,
        druidAstralPower = true,
        evokerEbonMight = true,
        warriorRage = true,
        hunterFocus = true,
        rogueEnergy = true,
        priestInsanity = true,
        shamanMaelstrom = true,
        monkEnergy = true,
        demonHunterFury = true,
        demonHunterSoulFragments = true,
    },
    playerPosition = {
        enabled = true,
        combatOnly = true,
        innerColor = { r = 1, g = 1, b = 1 },
        borderColor = { r = 0, g = 0, b = 0 },
        height = 40,
        width = 40,
        thickness = 2,
        positionMode = "dynamic",
        offsetY = 0,
        offsetX = 0,
        minZoom = 20,
    },
    cursorPosition = {
        enabled = true,
        combatOnly = true,
        size = 65,
        twoToneRing = true,
        ringWidth = 7,
        ringColor = { r = 1, g = 1, b = 1 },
        showOuterTracker = true,
        showInnerTracker = true,
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
        YaworsCleanUIDB = { settingsVersion = YaworsCleanUI.Migrations.SETTINGS_VERSION }
    end
    -- Before applyDefaults, so migrations see the save as written, not padded with defaults
    YaworsCleanUI.Migrations.migrate(YaworsCleanUIDB)
    applyDefaults(YaworsCleanUIDB, DEFAULTS)

    for _, mod in ipairs(registeredModules) do
        mod.init()
    end

    -- No other addons to wait for; stop listening
    self:UnregisterEvent("ADDON_LOADED")
end)
