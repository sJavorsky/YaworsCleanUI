local module = {}
YaworsCleanUI.ClassResourcePoints = module
YaworsCleanUI.registerModule(module)

-- One entry per supported class. Add new classes here when their frame names are known.
-- frame: function returning the frame global (may be nil on non-matching class characters)
-- settingKey: key in YaworsCleanUIDB that controls this class's repositioning
-- restoreAnchor: original anchor to reattach when the setting is disabled
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
}

-- Saved once in init() so scripts and scale can be restored when the setting is disabled
local savedState = nil

-- Guard flag: true while our own code is calling SetPoint, so the hooksecurefunc
-- callback knows to ignore the call and avoid infinite recursion.
local isRepositioning = false

local function applyClassResources(config)
    local frame = config.frame()
    if not frame then return end

    isRepositioning = true
    if YaworsCleanUIDB.classResourcePoints[config.settingKey] then
        frame:ClearAllPoints()
        -- UIParent spans the full screen; its center is the screen center
        frame:SetPoint("CENTER", UIParent, "CENTER",
            YaworsCleanUIDB.classResourcePoints.offsetX,
            YaworsCleanUIDB.classResourcePoints.offsetY)
        frame:SetScale(YaworsCleanUIDB.classResourcePoints.scale / 100)
        frame:SetScript("OnEnter", nil)
        frame:SetScript("OnLeave", nil)
        -- Centered over the screen — clicks should fall through to frames beneath
        frame:EnableMouse(false)
    else
        local anchor = config.restoreAnchor
        frame:ClearAllPoints()
        frame:SetPoint(anchor.point, _G[anchor.relativeTo], anchor.relativePoint, anchor.x, anchor.y)
        if savedState then
            frame:SetScale(savedState.scale)
            frame:SetScript("OnEnter", savedState.onEnter)
            frame:SetScript("OnLeave", savedState.onLeave)
            frame:EnableMouse(savedState.mouseEnabled)
        end
    end
    isRepositioning = false
end

function module.applySettings()
    local class = UnitClassBase("player")
    local config = classConfigs[class]
    if config then
        applyClassResources(config)
    end
end

function module.init()
    local class = UnitClassBase("player")
    local config = classConfigs[class]
    if not config then return end

    local frame = config.frame()
    if frame then
        -- Save scripts and scale before any override so they can be restored later
        savedState = {
            onEnter      = frame:GetScript("OnEnter"),
            onLeave      = frame:GetScript("OnLeave"),
            scale        = frame:GetScale(),
            mouseEnabled = frame:IsMouseEnabled(),
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
            isRepositioning = true
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", UIParent, "CENTER",
                YaworsCleanUIDB.classResourcePoints.offsetX,
                YaworsCleanUIDB.classResourcePoints.offsetY)
            isRepositioning = false
        end)
    end

    local eventFrame = CreateFrame("Frame")
    -- PLAYER_ENTERING_WORLD fires on login and every zone transition
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:SetScript("OnEvent", module.applySettings)

    module.applySettings()
end
