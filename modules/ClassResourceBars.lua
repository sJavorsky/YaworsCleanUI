local module = {}
YaworsCleanUI.ClassResourceBars = module
YaworsCleanUI.registerModule(module)

local BAR_TEXTURE = "Legionfall_BarFrame-Glow"
local BAR_WIDTH   = 300
local BAR_HEIGHT  = 30

-- One entry per supported class. Add new classes here.
-- bars: array of bar configs, each with:
--   settingKey: key in YaworsCleanUIDB.classResourceBars controlling visibility
--   powerType:  Enum.PowerType value for UnitPower calls
--   powerToken: string token for UNIT_POWER_UPDATE / UNIT_MAXPOWER filtering
--   color:      {r, g, b} foreground tint applied over the desaturated texture
--   shouldShow: optional function(); if present, bar is hidden when it returns false
-- extraEvents: optional array of additional event names to register
local classConfigs = {
    DEATHKNIGHT = {
        bars = {
            {
                settingKey = "deathKnightRunicPower",
                powerType  = Enum.PowerType.RunicPower,
                powerToken = "RUNIC_POWER",
                color      = {0, 0.855, 1},
            },
        },
    },
    DRUID = {
        bars = {
            {
                settingKey = "druidEnergy",
                powerType  = Enum.PowerType.Energy,
                powerToken = "ENERGY",
                color      = {1, 0.82, 0},
                -- Only visible in Cat Form
                shouldShow = function()
                    return GetShapeshiftFormID() == DRUID_CAT_FORM
                end,
            },
            {
                settingKey = "druidRage",
                powerType  = Enum.PowerType.Rage,
                powerToken = "RAGE",
                color      = {0.78, 0.25, 0.25},
                -- Only visible in Bear Form
                shouldShow = function()
                    return GetShapeshiftFormID() == DRUID_BEAR_FORM
                end,
            },
            {
                settingKey = "druidAstralPower",
                powerType  = Enum.PowerType.LunarPower,
                powerToken = "LUNAR_POWER",
                color      = {0.3, 0.1, 0.9},
                -- Visible when specced Balance and not in Cat or Bear Form
                shouldShow = function()
                    local formID = GetShapeshiftFormID()
                    if formID == DRUID_CAT_FORM or formID == DRUID_BEAR_FORM then
                        return false
                    end
                    local spec = C_SpecializationInfo.GetSpecialization()
                    if not spec then return false end
                    -- GetSpecializationInfo returns specID as first value; 102 = Balance
                    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
                    return specID == 102
                end,
            },
        },
        -- Form and spec changes require re-evaluating shouldShow on all bars
        extraEvents = { "UPDATE_SHAPESHIFT_FORM", "PLAYER_SPECIALIZATION_CHANGED" },
    },
}

-- Single named wrapper frame; always "YaworsCleanUI_BarClassResource" regardless of class.
-- Individual bar frames are children of this wrapper and fill it completely.
-- Position, scale, and top-level visibility are controlled via the wrapper.
local wrapperFrame = nil

-- Populated in init() with {frame, statusBar, config} for each bar of this character's class
local activeBars = {}

local function updateBarValue(statusBar, config)
    local current = UnitPower("player", config.powerType)
    local maximum = UnitPowerMax("player", config.powerType)
    if maximum > 0 then
        statusBar:SetMinMaxValues(0, maximum)
        statusBar:SetValue(current)
    end
end

local function createBar(config, parent)
    local frame = CreateFrame("Frame", nil, parent)
    -- Fill the wrapper completely; position and size are inherited from it
    frame:SetAllPoints()
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
    if not wrapperFrame then return end

    local anyVisible = false
    for _, activeBar in ipairs(activeBars) do
        local config = activeBar.config
        local enabled = YaworsCleanUIDB.classResourceBars[config.settingKey]
        local shouldBeVisible = enabled and (not config.shouldShow or config.shouldShow())
        if shouldBeVisible then
            activeBar.frame:Show()
            anyVisible = true
        else
            activeBar.frame:Hide()
        end
    end

    if anyVisible then
        wrapperFrame:Show()
        wrapperFrame:ClearAllPoints()
        -- UIParent spans the full screen; its center is the screen center
        wrapperFrame:SetPoint("CENTER", UIParent, "CENTER",
            YaworsCleanUIDB.classResourceBars.offsetX,
            YaworsCleanUIDB.classResourceBars.offsetY)
        wrapperFrame:SetScale(YaworsCleanUIDB.classResourceBars.scale / 100)
    else
        wrapperFrame:Hide()
    end
end

function module.init()
    local class = UnitClassBase("player")
    local classConfig = classConfigs[class]
    if not classConfig then return end

    wrapperFrame = CreateFrame("Frame", "YaworsCleanUI_BarClassResource", UIParent)
    wrapperFrame:SetSize(BAR_WIDTH, BAR_HEIGHT)
    wrapperFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    wrapperFrame:Hide()

    for _, barConfig in ipairs(classConfig.bars) do
        local frame, statusBar = createBar(barConfig, wrapperFrame)
        table.insert(activeBars, { frame = frame, statusBar = statusBar, config = barConfig })
    end

    local eventFrame = CreateFrame("Frame")
    -- RegisterUnitEvent filters to the specified unit automatically
    -- UNIT_POWER_FREQUENT fires every client frame for actively-regenerating resources (e.g. Energy),
    -- matching Blizzard's own bar update rate; UNIT_POWER_UPDATE is throttled and causes visible ticks
    eventFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
    eventFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
    -- PLAYER_ENTERING_WORLD fires on login and every zone transition
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    for _, event in ipairs(classConfig.extraEvents or {}) do
        eventFrame:RegisterEvent(event)
    end

    eventFrame:SetScript("OnEvent", function(self, event, unitToken, powerToken)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UPDATE_SHAPESHIFT_FORM"
        or event == "PLAYER_SPECIALIZATION_CHANGED" then
            for _, activeBar in ipairs(activeBars) do
                updateBarValue(activeBar.statusBar, activeBar.config)
            end
            module.applySettings()
            return
        end
        -- UNIT_POWER_FREQUENT / UNIT_MAXPOWER: powerToken is arg3 (arg2 is unitToken)
        for _, activeBar in ipairs(activeBars) do
            if powerToken == activeBar.config.powerToken then
                updateBarValue(activeBar.statusBar, activeBar.config)
            end
        end
    end)

    module.applySettings()
end
