local module = {}
YaworsCleanUI.CombatResources = module
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

-- Saved once in init() so OnEnter/OnLeave can be restored when the setting is disabled
local savedTooltipScripts = nil

local function applyClassResources(config)
    local frame = config.frame()
    if not frame then return end

    if YaworsCleanUIDB[config.settingKey] then
        frame:ClearAllPoints()
        -- UIParent spans the full screen; its center is the screen center
        frame:SetPoint("CENTER", UIParent, "CENTER",
            YaworsCleanUIDB.classResourcePointsOffsetX,
            YaworsCleanUIDB.classResourcePointsOffsetY)
        frame:SetScript("OnEnter", nil)
        frame:SetScript("OnLeave", nil)
    else
        local anchor = config.restoreAnchor
        frame:ClearAllPoints()
        frame:SetPoint(anchor.point, _G[anchor.relativeTo], anchor.relativePoint, anchor.x, anchor.y)
        if savedTooltipScripts then
            frame:SetScript("OnEnter", savedTooltipScripts.onEnter)
            frame:SetScript("OnLeave", savedTooltipScripts.onLeave)
        end
    end
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
        -- Save tooltip scripts before any override so they can be restored later
        savedTooltipScripts = {
            onEnter = frame:GetScript("OnEnter"),
            onLeave = frame:GetScript("OnLeave"),
        }
        -- WoW repositions managed frames on various events (zone change, combat, etc.);
        -- re-apply our position whenever the frame is shown
        frame:HookScript("OnShow", module.applySettings)
    end

    local eventFrame = CreateFrame("Frame")
    -- PLAYER_ENTERING_WORLD fires on login and every zone transition
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:SetScript("OnEvent", module.applySettings)

    module.applySettings()
end
