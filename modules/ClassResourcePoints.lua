local module = {}
YaworsCleanUI.ClassResourcePoints = module
YaworsCleanUI.registerModule(module)

-- One entry per supported class. Add new classes here when their frame names are known.
-- frame: function returning the frame global (may be nil on non-matching class characters)
-- settingKey: key in YaworsCleanUIDB that controls this class's repositioning
-- restoreAnchor: fallback anchor to reattach when the setting is disabled, used only
--   if Blizzard's original anchor could not be captured before the first override
-- centerOnContent: when true, center the visible child points rather than the frame's
--   own rect. Some bars (e.g. the rogue combo bar) pad their rect so the dots sit off
--   to one side; centering the rect would leave the dots visibly off-center.
-- extraEvents: optional events that signal a lazily-created frame may now exist
local classConfigs = {
    DEATHKNIGHT = {
        frame = function() return RuneFrame end,
        settingKey = "deathKnightRunes",
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
    DRUID = {
        frame = function() return DruidComboPointBarFrame end,
        settingKey = "druidComboPoints",
        -- The combo bar is created/shown lazily (only in cat form), so it may not
        -- exist when other frames do. Re-evaluate on form and spec changes so its
        -- hooks attach the moment it appears.
        extraEvents = { "UPDATE_SHAPESHIFT_FORM", "PLAYER_SPECIALIZATION_CHANGED" },
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
    EVOKER = {
        frame = function() return EssencePlayerFrame end,
        settingKey = "evokerEssence",
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
    ROGUE = {
        frame = function() return RogueComboPointBarFrame end,
        settingKey = "rogueComboPoints",
        centerOnContent = true,
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
    PALADIN = {
        frame = function() return PaladinPowerBarFrame end,
        settingKey = "paladinHolyPower",
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 2.5,
            y = 3,
        },
    },
    MAGE = {
        frame = function() return MageArcaneChargesFrame end,
        settingKey = "mageArcaneCharges",
        -- Arcane charges exist only for Arcane spec, so the frame may be
        -- created/destroyed on spec change; re-evaluate then so its hooks attach
        -- when it appears.
        extraEvents = { "PLAYER_SPECIALIZATION_CHANGED" },
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
    WARLOCK = {
        frame = function() return WarlockPowerFrame end,
        settingKey = "warlockSoulShards",
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
    MONK = {
        frame = function() return MonkHarmonyBarFrame end,
        settingKey = "monkChi",
        -- The Chi bar exists only for Windwalker, so it may be created/destroyed on
        -- spec change; re-evaluate then so its hooks attach when it appears.
        extraEvents = { "PLAYER_SPECIALIZATION_CHANGED" },
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
}

-- Saved when hooks are first attached, so scripts, scale and the original anchor
-- can be restored when the setting is disabled
local savedState = nil

-- True once the active class frame has had its hooks attached. The frame may be
-- created lazily (e.g. the druid combo bar only exists in cat form), so setup is
-- deferred until the frame first appears rather than done unconditionally in init().
local isHooked = false

-- Guard flag: true while our own code is calling SetPoint, so the hooksecurefunc
-- callback knows to ignore the call and avoid infinite recursion.
local isRepositioning = false

-- Returns how far the visible child points' center is from the frame's own center,
-- in the frame's coordinate units, so the caller can compensate. Frames like the
-- rogue combo bar pad their rect; centering the rect alone leaves the dots off-center.
-- Returns 0, 0 when the geometry can't be measured (frame not yet laid out).
local function getContentCorrection(frame)
    local frameLeft, frameRight = frame:GetLeft(), frame:GetRight()
    if not frameLeft or not frameRight then return 0, 0 end
    local frameBottom, frameTop = frame:GetBottom(), frame:GetTop()
    if not frameBottom or not frameTop then return 0, 0 end

    -- Bounding box of the visible child points, in absolute screen pixels
    local minLeft, maxRight, minBottom, maxTop
    for _, child in ipairs({ frame:GetChildren() }) do
        if child:IsShown() then
            local childLeft, childRight = child:GetLeft(), child:GetRight()
            local childBottom, childTop = child:GetBottom(), child:GetTop()
            if childLeft and childRight and childBottom and childTop then
                local scale = child:GetEffectiveScale()
                childLeft, childRight = childLeft * scale, childRight * scale
                childBottom, childTop = childBottom * scale, childTop * scale
                if not minLeft or childLeft < minLeft then minLeft = childLeft end
                if not maxRight or childRight > maxRight then maxRight = childRight end
                if not minBottom or childBottom < minBottom then minBottom = childBottom end
                if not maxTop or childTop > maxTop then maxTop = childTop end
            end
        end
    end
    if not minLeft then return 0, 0 end

    local frameScale = frame:GetEffectiveScale()
    local frameCenterX = ((frameLeft + frameRight) / 2) * frameScale
    local frameCenterY = ((frameBottom + frameTop) / 2) * frameScale
    local contentCenterX = (minLeft + maxRight) / 2
    local contentCenterY = (minBottom + maxTop) / 2

    -- Convert the screen-pixel delta back into the frame's own coordinate units
    return (frameCenterX - contentCenterX) / frameScale,
           (frameCenterY - contentCenterY) / frameScale
end

local function centerFrame(frame, config)
    local points = YaworsCleanUIDB.classResourcePoints
    local offsetX, offsetY = points.offsetX, points.offsetY

    isRepositioning = true
    -- UIParent spans the full screen; its center is the screen center
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", offsetX, offsetY)
    if config.centerOnContent then
        local correctionX, correctionY = getContentCorrection(frame)
        if correctionX ~= 0 or correctionY ~= 0 then
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", UIParent, "CENTER",
                offsetX + correctionX, offsetY + correctionY)
        end
    end
    isRepositioning = false
end

local function restoreFrame(frame, config)
    isRepositioning = true
    frame:ClearAllPoints()
    if savedState and savedState.originalPoints and #savedState.originalPoints > 0 then
        for _, anchor in ipairs(savedState.originalPoints) do
            frame:SetPoint(anchor.point, anchor.relativeTo, anchor.relativePoint, anchor.x, anchor.y)
        end
    else
        local anchor = config.restoreAnchor
        frame:SetPoint(anchor.point, _G[anchor.relativeTo], anchor.relativePoint, anchor.x, anchor.y)
    end
    if savedState then
        frame:SetScale(savedState.scale)
        frame:SetScript("OnEnter", savedState.onEnter)
        frame:SetScript("OnLeave", savedState.onLeave)
        frame:EnableMouse(savedState.mouseEnabled)
    end
    isRepositioning = false
end

-- Attaches the OnShow and SetPoint hooks and captures the frame's pristine state.
-- Runs at most once per session, the first time the frame exists, because some
-- frames (the druid combo bar) are created lazily and aren't available in init().
local function ensureHooked(frame, config)
    if isHooked then return end
    isHooked = true

    -- Save scripts, scale and Blizzard's original anchor before any override so
    -- they can be restored later. Capturing the live anchor avoids guessing the
    -- per-class default, which may include padding the frame applies to its rect.
    local originalPoints = {}
    for i = 1, frame:GetNumPoints() do
        local point, relativeTo, relativePoint, x, y = frame:GetPoint(i)
        originalPoints[i] = {
            point = point,
            relativeTo = relativeTo,
            relativePoint = relativePoint,
            x = x,
            y = y,
        }
    end
    savedState = {
        onEnter        = frame:GetScript("OnEnter"),
        onLeave        = frame:GetScript("OnLeave"),
        scale          = frame:GetScale(),
        mouseEnabled   = frame:IsMouseEnabled(),
        originalPoints = originalPoints,
    }

    -- WoW repositions managed frames on various events (zone change, combat, etc.);
    -- re-apply our position whenever the frame is shown
    frame:HookScript("OnShow", module.applySettings)

    -- Intercept external SetPoint calls (e.g. WoW's layout manager restoring the
    -- default anchor after UIParent is re-shown by addons like Dialogue UI).
    -- hooksecurefunc fires after the original SetPoint completes; we revert to
    -- our position unless the call came from our own code (guarded by isRepositioning).
    hooksecurefunc(frame, "SetPoint", function()
        if isRepositioning then return end
        if not YaworsCleanUIDB.classResourcePoints[config.settingKey] then return end
        centerFrame(frame, config)
    end)
end

local function applyClassResources(config)
    local frame = config.frame()
    if not frame then return end

    ensureHooked(frame, config)

    if YaworsCleanUIDB.classResourcePoints[config.settingKey] then
        frame:SetScale(YaworsCleanUIDB.classResourcePoints.scale / 100)
        frame:SetScript("OnEnter", nil)
        frame:SetScript("OnLeave", nil)
        -- Centered over the screen — clicks should fall through to frames beneath
        frame:EnableMouse(false)
        -- Scale is set before centering so the content correction is measured at the
        -- final effective scale
        centerFrame(frame, config)
    else
        restoreFrame(frame, config)
    end
end

function module.applySettings()
    local class = UnitClassBase("player")
    local config = classConfigs[class]
    if config then
        applyClassResources(config)
    end
end

-- Some frames (the druid combo bar) are created by Blizzard after our login
-- handlers run, and on a fresh login already in cat form no UPDATE_SHAPESHIFT_FORM
-- fires to prompt a retry. Re-attempt for a few seconds until the frame exists and
-- ensureHooked latches; once hooked the OnShow/SetPoint hooks keep it in place.
local RETRY_INTERVAL = 0.5
local RETRY_ATTEMPTS = 10

local function applyWithRetry(attemptsLeft)
    module.applySettings()
    if not isHooked and attemptsLeft > 0 then
        C_Timer.After(RETRY_INTERVAL, function()
            applyWithRetry(attemptsLeft - 1)
        end)
    end
end

function module.init()
    local class = UnitClassBase("player")
    local config = classConfigs[class]
    if not config then return end

    -- Hooks are attached lazily in applyClassResources once the frame exists.
    local eventFrame = CreateFrame("Frame")
    -- PLAYER_ENTERING_WORLD fires on login and every zone transition
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    -- Lazily-created frames (the druid combo bar) appear on form/spec changes;
    -- re-running applySettings then lets ensureHooked pick them up.
    for _, event in ipairs(config.extraEvents or {}) do
        eventFrame:RegisterEvent(event)
    end
    eventFrame:SetScript("OnEvent", function()
        applyWithRetry(RETRY_ATTEMPTS)
    end)

    applyWithRetry(RETRY_ATTEMPTS)
end
