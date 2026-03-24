local module = {}
YaworsCleanUI.BarClassResources = module
YaworsCleanUI.registerModule(module)

local BAR_TEXTURE = "Legionfall_BarFrame-Glow"
local BAR_WIDTH   = 300
local BAR_HEIGHT  = 30

-- One entry per supported class. Add new classes here.
-- settingKey: key in YaworsCleanUIDB that controls visibility
-- powerType:  Enum.PowerType value for UnitPower calls
-- powerToken: string token for UNIT_POWER_UPDATE filtering
-- color:      {r, g, b} foreground tint applied over the desaturated texture
local classConfigs = {
    DEATHKNIGHT = {
        settingKey = "deathKnightRunicPower",
        powerType  = Enum.PowerType.RunicPower,
        powerToken = "RUNIC_POWER",
        color      = {0, 0.855, 1},
    },
}

-- Populated in init() with the config for the logged-in character's class
local activeConfig = nil

-- The bar frame and foreground status bar, created once in init()
local barFrame = nil
local statusBar = nil

local function updateBarValue()
    local current = UnitPower("player", activeConfig.powerType)
    local maximum = UnitPowerMax("player", activeConfig.powerType)
    if maximum > 0 then
        statusBar:SetMinMaxValues(0, maximum)
        statusBar:SetValue(current)
    end
end

local function createBar(config)
    local frame = CreateFrame("Frame", "YaworsCleanUI_BarClassResource", UIParent)
    frame:SetSize(BAR_WIDTH, BAR_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    -- CreateFrame shows frames by default; start hidden so applySettings() controls visibility
    frame:Hide()

    -- Background uses the same texture at full value, darkened, so the shape matches the foreground
    local background = CreateFrame("StatusBar", nil, frame)
    background:SetAllPoints()
    -- Must be below the foreground bar; child frames share the parent level by default
    background:SetFrameLevel(frame:GetFrameLevel())
    background:SetStatusBarTexture(BAR_TEXTURE)
    background:GetStatusBarTexture():SetDesaturated(true)
    background:SetStatusBarColor(0.1, 0.1, 0.1)
    background:SetMinMaxValues(0, 100)
    background:SetValue(100)

    local bar = CreateFrame("StatusBar", nil, frame)
    bar:SetAllPoints()
    bar:SetFrameLevel(frame:GetFrameLevel() + 1)
    -- SetStatusBarTexture names a texture from the game files by its atlas/path key
    bar:SetStatusBarTexture(BAR_TEXTURE)
    -- Desaturate to grayscale first so the vertex color is the sole source of hue
    bar:GetStatusBarTexture():SetDesaturated(true)
    bar:SetStatusBarColor(config.color[1], config.color[2], config.color[3])
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(0)

    return frame, bar
end

function module.applySettings()
    if not barFrame then return end

    if not YaworsCleanUIDB[activeConfig.settingKey] then
        barFrame:Hide()
        return
    end

    barFrame:Show()
    barFrame:ClearAllPoints()
    -- UIParent spans the full screen; its center is the screen center
    barFrame:SetPoint("CENTER", UIParent, "CENTER",
        YaworsCleanUIDB.classResourceBarsOffsetX,
        YaworsCleanUIDB.classResourceBarsOffsetY)
    barFrame:SetScale(YaworsCleanUIDB.classResourceBarsScale / 100)
end

function module.init()
    local class = UnitClassBase("player")
    activeConfig = classConfigs[class]
    if not activeConfig then return end

    barFrame, statusBar = createBar(activeConfig)

    local eventFrame = CreateFrame("Frame")
    -- RegisterUnitEvent filters to the specified unit automatically
    eventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
    eventFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
    -- PLAYER_ENTERING_WORLD fires on login and every zone transition
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:SetScript("OnEvent", function(self, event, unitToken, powerToken)
        if event == "PLAYER_ENTERING_WORLD" then
            updateBarValue()
            module.applySettings()
            return
        end
        -- UNIT_POWER_UPDATE: filter to this class's power token
        if event == "UNIT_POWER_UPDATE" and powerToken ~= activeConfig.powerToken then return end
        updateBarValue()
    end)

    module.applySettings()
end
