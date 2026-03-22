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
        settingKey = "centerDKRunes",
        restoreAnchor = {
            point = "TOP",
            relativeTo = "PlayerFrameBottomManagedFramesContainer",
            relativePoint = "TOP",
            x = 0,
            y = 0,
        },
    },
}

local function applyClassResources(config)
    local frame = config.frame()
    if not frame then return end

    if YaworsCleanUIDB[config.settingKey] then
        frame:ClearAllPoints()
        -- UIParent spans the full screen; its center is the screen center
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    else
        local anchor = config.restoreAnchor
        frame:ClearAllPoints()
        frame:SetPoint(anchor.point, _G[anchor.relativeTo], anchor.relativePoint, anchor.x, anchor.y)
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
