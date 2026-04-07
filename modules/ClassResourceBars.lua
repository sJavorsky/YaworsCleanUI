local module = {}
YaworsCleanUI.ClassResourceBars = module
YaworsCleanUI.registerModule(module)

local BAR_TEXTURE = "Legionfall_BarFrame-Glow"
local BAR_WIDTH   = 300
local BAR_HEIGHT  = 30

-- Schema for classConfigs entries:
-- bars: array of bar configs, each with:
--   settingKey: key in YaworsCleanUIDB.classResourceBars controlling visibility
--   powerType:  Enum.PowerType value for UnitPower calls
--   powerToken: string token for UNIT_POWER_FREQUENT / UNIT_MAXPOWER filtering
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
                shouldShow = function()
                    return GetShapeshiftFormID() == DRUID_CAT_FORM
                end,
            },
            {
                settingKey = "druidRage",
                powerType  = Enum.PowerType.Rage,
                powerToken = "RAGE",
                color      = {0.78, 0.25, 0.25},
                shouldShow = function()
                    return GetShapeshiftFormID() == DRUID_BEAR_FORM
                end,
            },
            {
                settingKey = "druidAstralPower",
                powerType  = Enum.PowerType.LunarPower,
                powerToken = "LUNAR_POWER",
                color      = {0.3, 0.1, 0.9},
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

local wrapperFrame = nil
local activeBars = {}

local function createStatusBar(parent, levelOffset, color, initialValue)
    local statusBar = CreateFrame("StatusBar", nil, parent)
    statusBar:SetAllPoints()
    statusBar:SetFrameLevel(parent:GetFrameLevel() + levelOffset)
    statusBar:SetStatusBarTexture(BAR_TEXTURE)
    -- Desaturate to grayscale so the vertex color is the sole source of hue
    statusBar:GetStatusBarTexture():SetDesaturated(true)
    statusBar:SetStatusBarColor(color[1], color[2], color[3])
    statusBar:SetMinMaxValues(0, 100)
    statusBar:SetValue(initialValue)
    return statusBar
end

local function createBar(config, parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetAllPoints()
    -- Start hidden; applySettings() controls visibility
    frame:Hide()

    -- Background: full-value darkened copy provides the bar track shape
    createStatusBar(frame, 0, {0.1, 0.1, 0.1}, 100)
    local statusBar = createStatusBar(frame, 1, config.color, 0)

    return frame, statusBar
end

local function updateBarValue(statusBar, config)
    local current = UnitPower("player", config.powerType)
    local maximum = UnitPowerMax("player", config.powerType)
    if maximum > 0 then
        statusBar:SetMinMaxValues(0, maximum)
        statusBar:SetValue(current)
    end
end

local function updateAllBars()
    for _, activeBar in ipairs(activeBars) do
        updateBarValue(activeBar.statusBar, activeBar.config)
    end
end

local function onEvent(_, event, _, powerToken)
    if event == "PLAYER_ENTERING_WORLD"
    or event == "UPDATE_SHAPESHIFT_FORM"
    or event == "PLAYER_SPECIALIZATION_CHANGED" then
        updateAllBars()
        module.applySettings()
        return
    end
    for _, activeBar in ipairs(activeBars) do
        if powerToken == activeBar.config.powerToken then
            updateBarValue(activeBar.statusBar, activeBar.config)
        end
    end
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
    -- UNIT_POWER_FREQUENT fires every client frame for regenerating resources,
    -- matching Blizzard's own bar update rate; UNIT_POWER_UPDATE is throttled
    eventFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
    eventFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    for _, event in ipairs(classConfig.extraEvents or {}) do
        eventFrame:RegisterEvent(event)
    end
    eventFrame:SetScript("OnEvent", onEvent)

    module.applySettings()
end
