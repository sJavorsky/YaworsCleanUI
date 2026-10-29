local module = {}
YaworsCleanUI.ClassResourceBars = module
YaworsCleanUI.registerModule(module)

local BAR_TEXTURE = "Legionfall_BarFrame-Glow"
local BAR_WIDTH   = 300
local BAR_HEIGHT  = 36

-- Hard-alpha mask baked from the Legionfall_BarBackground atlas (rounded
-- silhouette in its alpha, padded to the glow atlas's geometry). Cuts the
-- rectangular fancy fill atlas to the bar's rounded shape.
local MASK_TEXTURE = [[Interface\AddOns\YaworsCleanUI\textures\legionfall-bar-mask.png]]

-- Schema for classConfigs entries:
-- bars: array of bar configs, each with:
--   settingKey:    key in YaworsCleanUIDB.classResourceBars controlling visibility
--   powerType:     Enum.PowerType value for UnitPower calls
--   powerToken:    string token for UNIT_POWER_FREQUENT / UNIT_MAXPOWER filtering
--   color:         {r, g, b} foreground tint applied over the desaturated texture
--   fillAtlas:     optional Blizzard fill atlas name (e.g. "Unit_Priest_Insanity_Fill").
--                  When present AND the global fancyTextures setting is on, this
--                  atlas (masked to the rounded silhouette) is layered over the
--                  simple-color glow fill, which remains as the glow base. Without
--                  the setting, or without a fillAtlas, the bar shows the plain
--                  desaturate-and-tint fill.
--   stacked:       optional; bars default to filling the wrapper frame, so a class
--                  showing several of them only ever has one visible at a time. A
--                  stacked bar instead sits one bar height away from the wrapper, for
--                  specs that show two bars at once. It shares the wrapper's position
--                  and scale, so both bars always move and size together.
--   shouldShow:    optional function(); if present, bar is hidden when it returns false
--   valueProvider: optional function() returning current, maximum, text. When
--                  present it replaces the UnitPower/UnitPowerMax lookup and the
--                  bar refreshes on an OnUpdate timer instead of power events,
--                  allowing continuously-changing non-power resources (e.g. a
--                  counting-down aura duration) to drive the bar.
--   appearanceProvider: optional function() returning {r, g, b}, fillAtlas. Only
--                  useful alongside valueProvider, since it is re-evaluated on the
--                  same timer. Lets a bar recolor and swap its fancy atlas while
--                  visible, for resources that change appearance mid-combat. The
--                  config's own color/fillAtlas stay the starting state.
-- extraEvents: optional array of additional event names to register

-- Hoisted out of the appearance provider below, which runs on a 10 Hz timer and
-- would otherwise allocate a fresh table on every tick.
local SOUL_FRAGMENTS_COLOR = {0.35, 0.16, 1.0}
local COLLAPSING_STAR_COLOR = {0.065, 0.39, 1.0}

local classConfigs = {
    DEATHKNIGHT = {
        bars = {
            {
                settingKey = "deathKnightRunicPower",
                powerType  = Enum.PowerType.RunicPower,
                powerToken = "RUNIC_POWER",
                color      = {0, 0.82, 1},
            },
        },
    },
    DRUID = {
        bars = {
            {
                settingKey = "druidEnergy",
                powerType  = Enum.PowerType.Energy,
                powerToken = "ENERGY",
                color      = {1, 1, 0},
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
                color      = {0.3, 0.52, 0.9},
                fillAtlas  = "Unit_Druid_AstralPower_Fill",
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
                fillAtlas  = "Unit_Evoker_EbonMight_Fill",
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
                color      = {1, 1, 0},
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
                fillAtlas  = "Unit_DemonHunter_Fury_Fill",
            },
            {
                settingKey = "demonHunterSoulFragments",
                stacked    = true,
                color      = SOUL_FRAGMENTS_COLOR,
                fillAtlas  = "UF-DDH-VoidMeta-Bar",
                -- Soul Fragments are aura stacks, not a power, so nothing fires an
                -- event when they change; the bar polls instead.
                valueProvider = function()
                    -- 1225789 = Soul Fragments; it is replaced by 1227702
                    -- (Collapsing Star) for the duration of Void Metamorphosis
                    local auraData = C_UnitAuras.GetPlayerAuraBySpellID(1225789)
                        or C_UnitAuras.GetPlayerAuraBySpellID(1227702)
                    local current = auraData and auraData.applications or 0
                    local maximum
                    -- Void Metamorphosis caps Collapsing Star lower than the
                    -- baseline fragment cap. Keyed on the meta aura rather than on
                    -- which fragment aura is present, so an empty bar out of meta
                    -- still reports the baseline cap.
                    if C_UnitAuras.GetPlayerAuraBySpellID(1217607) then
                        maximum = 30
                    else
                        -- 1247534 = Soul Glutton, which lowers the cap. Read every
                        -- tick so a talent swap needs no event of its own.
                        maximum = C_SpellBook.IsSpellKnown(1247534) and 35 or 50
                    end
                    -- Entering meta carries fragments over above the lower Collapsing
                    -- Star cap, so the aura can report more stacks than are spendable.
                    if current > maximum then
                        current = maximum
                    end
                    return current, maximum, current
                end,
                -- Void Metamorphosis turns the fragments into Collapsing Star, which
                -- reads as a different resource, so the bar changes look with it
                appearanceProvider = function()
                    -- 1217607 = Void Metamorphosis
                    if C_UnitAuras.GetPlayerAuraBySpellID(1217607) then
                        return COLLAPSING_STAR_COLOR, "UF-DDH-CollapsingStar-Bar"
                    end
                    return SOUL_FRAGMENTS_COLOR, "UF-DDH-VoidMeta-Bar"
                end,
                shouldShow = function()
                    local spec = C_SpecializationInfo.GetSpecialization()
                    if not spec then return false end
                    -- 1480 = Devourer; only it tracks Soul Fragments
                    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
                    return specID == 1480
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
                color      = {1.0, 0.5, 0.25},
            },
        },
    },
    MONK = {
        bars = {
            {
                settingKey = "monkEnergy",
                powerType  = Enum.PowerType.Energy,
                powerToken = "ENERGY",
                color      = {1, 1, 0},
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
                color      = {0.4, 0, 0.8},
                fillAtlas  = "Unit_Priest_Insanity_Fill",
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
                color      = {0, 0.5, 1},
                fillAtlas  = "Unit_Shaman_Maelstrom_Fill",
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
    -- Stacked bars are anchored by applySettings, which picks the side to sit on
    if config.stacked then
        frame:SetSize(BAR_WIDTH, BAR_HEIGHT)
    else
        frame:SetAllPoints()
    end
    -- Start hidden; applySettings() controls visibility
    frame:Hide()

    -- Background: full-value darkened copy provides the bar track shape
    createStatusBar(frame, 0, {0.1, 0.1, 0.1}, 100)
    -- Simple-color fill; also the glow base when the fancy atlas is layered on
    local statusBar = createStatusBar(frame, 1, config.color, 0, "ADD")

    -- Fancy atlas layer (only for specs that define one). Built once and shown
    -- or hidden by applySettings based on the global fancyTextures setting. The
    -- atlas is a plain rectangle, so it is masked to the rounded silhouette;
    -- the mask anchors to the frame so the shape stays fixed as the bar drains.
    local fancyBar
    if config.fillAtlas then
        fancyBar = CreateFrame("StatusBar", nil, frame)
        fancyBar:SetAllPoints()
        fancyBar:SetFrameLevel(frame:GetFrameLevel() + 2)
        -- Assign a texture object first, THEN apply the atlas to it
        fancyBar:SetStatusBarTexture(fancyBar:CreateTexture(nil, "ARTWORK"))
        fancyBar:GetStatusBarTexture():SetAtlas(config.fillAtlas, false)
        local mask = frame:CreateMaskTexture()
        mask:SetTexture(MASK_TEXTURE)
        mask:SetAllPoints(frame)
        fancyBar:GetStatusBarTexture():AddMaskTexture(mask)
        fancyBar:SetMinMaxValues(0, 100)
        fancyBar:SetValue(0)
    end

    -- Text on its own frame above every fill layer so it stays on top whether
    -- or not the fancy layer is shown
    local textFrame = CreateFrame("Frame", nil, frame)
    textFrame:SetAllPoints()
    textFrame:SetFrameLevel(frame:GetFrameLevel() + 3)
    local valueText = textFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    local fontFile = valueText:GetFont()
    -- OUTLINE keeps the value readable over the bright fancy fill
    valueText:SetFont(fontFile, 18, "OUTLINE")
    valueText:SetPoint("CENTER", frame, "CENTER", 0, 0)

    return frame, statusBar, valueText, fancyBar
end

local function updateBarValue(activeBar)
    local config = activeBar.config

    if config.appearanceProvider then
        local color, fillAtlas = config.appearanceProvider()
        activeBar.statusBar:SetStatusBarColor(color[1], color[2], color[3])
        -- SetAtlas re-resolves the atlas entry, so only pay for it on a real change
        if activeBar.fancyBar and fillAtlas ~= activeBar.fillAtlas then
            activeBar.fancyBar:GetStatusBarTexture():SetAtlas(fillAtlas, false)
            activeBar.fillAtlas = fillAtlas
        end
    end

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
        if activeBar.fancyBar then
            activeBar.fancyBar:SetMinMaxValues(0, maximum)
            activeBar.fancyBar:SetValue(current)
        end
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

    local settings = YaworsCleanUIDB.classResourceBars
    local fancy = settings.fancyTextures
    -- Stack away from the screen edge the bars sit closest to, so the extra bar
    -- grows toward the middle of the screen instead of off it
    -- Floored so a fractional offset never lands the bar off-pixel
    local stackDistance = math.floor(1.25 * BAR_HEIGHT)
    local stackOffset = settings.offsetY > 0 and stackDistance or -stackDistance
    local anyVisible = false
    for _, activeBar in ipairs(activeBars) do
        local config = activeBar.config
        local enabled = settings.enabled and settings[config.settingKey]
        local shouldBeVisible = enabled and (not config.shouldShow or config.shouldShow())
        if shouldBeVisible then
            if config.stacked then
                activeBar.frame:ClearAllPoints()
                activeBar.frame:SetPoint("CENTER", wrapperFrame, "CENTER", 0, stackOffset)
            end
            activeBar.frame:Show()
            anyVisible = true
        else
            activeBar.frame:Hide()
        end
        if activeBar.fancyBar then
            activeBar.fancyBar:SetShown(fancy)
        end
    end

    if anyVisible then
        wrapperFrame:Show()
        -- SetPoint offsets are in the frame's own (scaled) coordinate space, so a
        -- raw offset would move scale-times as many screen pixels. Divide by the
        -- scale to keep the on-screen displacement constant at any scale.
        local scale = settings.scale / 100
        wrapperFrame:ClearAllPoints()
        wrapperFrame:SetPoint("CENTER", UIParent, "CENTER",
            settings.offsetX / scale,
            settings.offsetY / scale)
        wrapperFrame:SetScale(scale)
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
        local frame, statusBar, valueText, fancyBar = createBar(barConfig, wrapperFrame)
        local activeBar = { frame = frame, statusBar = statusBar, valueText = valueText, fancyBar = fancyBar, fillAtlas = barConfig.fillAtlas, config = barConfig }
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
