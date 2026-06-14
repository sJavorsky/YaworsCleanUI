local module = {}
YaworsCleanUI.ClassResourceBars = module
YaworsCleanUI.registerModule(module)

local BAR_TEXTURE = "Legionfall_BarFrame-Glow"
local BAR_WIDTH   = 300
local BAR_HEIGHT  = 36

-- Schema for classConfigs entries:
-- bars: array of bar configs, each with:
--   settingKey:    key in YaworsCleanUIDB.classResourceBars controlling visibility
--   powerType:     Enum.PowerType value for UnitPower calls
--   powerToken:    string token for UNIT_POWER_FREQUENT / UNIT_MAXPOWER filtering
--   color:         {r, g, b} foreground tint applied over the desaturated texture
--   shouldShow:    optional function(); if present, bar is hidden when it returns false
--   valueProvider: optional function() returning current, maximum, text. When
--                  present it replaces the UnitPower/UnitPowerMax lookup and the
--                  bar refreshes on an OnUpdate timer instead of power events,
--                  allowing continuously-changing non-power resources (e.g. a
--                  counting-down aura duration) to drive the bar.
-- extraEvents: optional array of additional event names to register
local classConfigs = {
    DEATHKNIGHT = {
        bars = {
            {
                settingKey = "deathKnightRunicPower",
                powerType  = Enum.PowerType.RunicPower,
                powerToken = "RUNIC_POWER",
                color      = {0, 0.85, 1},
            },
        },
    },
    DRUID = {
        bars = {
            {
                settingKey = "druidEnergy",
                powerType  = Enum.PowerType.Energy,
                powerToken = "ENERGY",
                color      = {1, 0.9, 0},
                shouldShow = function()
                    return GetShapeshiftFormID() == DRUID_CAT_FORM
                end,
            },
            {
                settingKey = "druidRage",
                powerType  = Enum.PowerType.Rage,
                powerToken = "RAGE",
                color      = {1, 0, 0},
                shouldShow = function()
                    return GetShapeshiftFormID() == DRUID_BEAR_FORM
                end,
            },
            {
                settingKey = "druidAstralPower",
                powerType  = Enum.PowerType.LunarPower,
                powerToken = "LUNAR_POWER",
                color      = {0.6, 0.4, 1.0},
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
    EVOKER = {
        bars = {
            {
                settingKey = "evokerEbonMight",
                color      = {1.0, 0.85, 0.25},
                -- Ebon Might is a buff, not a power; track its remaining duration.
                -- 20s is the base duration; talents/extensions can exceed it, which
                -- would briefly overfill the bar's ratio until it ticks back under.
                valueProvider = function()
                    -- C_UnitAuras.GetPlayerAuraBySpellID returns the player's own
                    -- Ebon Might aura (the self-buff cast alongside the party buff)
                    local auraData = C_UnitAuras.GetPlayerAuraBySpellID(395296)
                    local remaining = auraData and (auraData.expirationTime - GetTime()) or 0
                    if remaining < 0 then remaining = 0 end
                    return remaining, 20, string.format("%.1f", remaining)
                end,
                shouldShow = function()
                    local spec = C_SpecializationInfo.GetSpecialization()
                    if not spec then return false end
                    -- 1473 = Augmentation
                    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
                    return specID == 1473
                end,
            },
        },
        extraEvents = { "PLAYER_SPECIALIZATION_CHANGED" },
    },
    ROGUE = {
        bars = {
            {
                settingKey = "rogueEnergy",
                powerType  = Enum.PowerType.Energy,
                powerToken = "ENERGY",
                color      = {1, 0.9, 0},
            },
        },
    },
    WARRIOR = {
        bars = {
            {
                settingKey = "warriorRage",
                powerType  = Enum.PowerType.Rage,
                powerToken = "RAGE",
                color      = {1, 0, 0},
            },
        },
    },
    DEMONHUNTER = {
        bars = {
            {
                settingKey = "demonHunterFury",
                powerType  = Enum.PowerType.Fury,
                powerToken = "FURY",
                color      = {0.79, 0.26, 0.99},
                shouldShow = function()
                    local spec = C_SpecializationInfo.GetSpecialization()
                    if not spec then return false end
                    -- 577 = Havoc, 581 = Vengeance; the third spec's behavior is
                    -- unknown, so only show Fury for these two.
                    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
                    return specID == 577 or specID == 581
                end,
            },
        },
        extraEvents = { "PLAYER_SPECIALIZATION_CHANGED" },
    },
    HUNTER = {
        bars = {
            {
                settingKey = "hunterFocus",
                powerType  = Enum.PowerType.Focus,
                powerToken = "FOCUS",
                color      = {1.0, 0.5, 0.1},
            },
        },
    },
    MONK = {
        bars = {
            {
                settingKey = "monkEnergy",
                powerType  = Enum.PowerType.Energy,
                powerToken = "ENERGY",
                color      = {1, 0.9, 0},
                shouldShow = function()
                    local spec = C_SpecializationInfo.GetSpecialization()
                    if not spec then return false end
                    -- 268 = Brewmaster, 269 = Windwalker; Mistweaver uses mana
                    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
                    return specID == 268 or specID == 269
                end,
            },
        },
        extraEvents = { "PLAYER_SPECIALIZATION_CHANGED" },
    },
    PRIEST = {
        bars = {
            {
                settingKey = "priestInsanity",
                powerType  = Enum.PowerType.Insanity,
                powerToken = "INSANITY",
                color      = {0.5, 0.1, 0.75},
                shouldShow = function()
                    local spec = C_SpecializationInfo.GetSpecialization()
                    if not spec then return false end
                    -- 258 = Shadow; only Shadow uses Insanity
                    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
                    return specID == 258
                end,
            },
        },
        extraEvents = { "PLAYER_SPECIALIZATION_CHANGED" },
    },
    SHAMAN = {
        bars = {
            {
                settingKey = "shamanMaelstrom",
                powerType  = Enum.PowerType.Maelstrom,
                powerToken = "MAELSTROM",
                color      = {0.4, 0.7, 1.0},
                shouldShow = function()
                    local spec = C_SpecializationInfo.GetSpecialization()
                    if not spec then return false end
                    -- 262 = Elemental; only Elemental uses Maelstrom
                    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
                    return specID == 262
                end,
            },
        },
        extraEvents = { "PLAYER_SPECIALIZATION_CHANGED" },
    },
}

local wrapperFrame = nil
local activeBars = {}

local function createStatusBar(parent, levelOffset, color, initialValue, blendMode)
    local statusBar = CreateFrame("StatusBar", nil, parent)
    statusBar:SetAllPoints()
    statusBar:SetFrameLevel(parent:GetFrameLevel() + levelOffset)
    statusBar:SetStatusBarTexture(BAR_TEXTURE)
    -- Desaturate to grayscale so the vertex color is the sole source of hue
    statusBar:GetStatusBarTexture():SetDesaturated(true)
    statusBar:SetStatusBarColor(color[1], color[2], color[3])
    -- ADD blend lets the glow texture's highlights light up over the background,
    -- giving the bar the same luminous "glow" the original WeakAura had
    if blendMode then
        statusBar:GetStatusBarTexture():SetBlendMode(blendMode)
    end
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
    local statusBar = createStatusBar(frame, 1, config.color, 0, "ADD")

    -- Parent to the foreground bar so the text draws above both status textures
    local valueText = statusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    local fontFile, _, fontFlags = valueText:GetFont()
    valueText:SetFont(fontFile, 18, fontFlags)
    valueText:SetPoint("CENTER", frame, "CENTER", 0, 0)

    return frame, statusBar, valueText
end

local function updateBarValue(activeBar)
    local config = activeBar.config
    local current, maximum, text
    if config.valueProvider then
        current, maximum, text = config.valueProvider()
    else
        current = UnitPower("player", config.powerType)
        maximum = UnitPowerMax("player", config.powerType)
        text = current
    end
    if maximum and maximum > 0 then
        activeBar.statusBar:SetMinMaxValues(0, maximum)
        activeBar.statusBar:SetValue(current)
    end
    activeBar.valueText:SetText(text)
end

local function updateAllBars()
    for _, activeBar in ipairs(activeBars) do
        updateBarValue(activeBar)
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
            updateBarValue(activeBar)
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
        local frame, statusBar, valueText = createBar(barConfig, wrapperFrame)
        local activeBar = { frame = frame, statusBar = statusBar, valueText = valueText, config = barConfig }
        table.insert(activeBars, activeBar)

        -- valueProvider bars (e.g. counting-down buffs) refresh on a timer instead
        -- of power events. OnUpdate only fires while the frame is shown, so the
        -- timer naturally stops when applySettings() hides the bar.
        if barConfig.valueProvider then
            local elapsed = 0
            frame:SetScript("OnUpdate", function(_, delta)
                elapsed = elapsed + delta
                if elapsed >= 0.1 then
                    elapsed = 0
                    updateBarValue(activeBar)
                end
            end)
        end
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
