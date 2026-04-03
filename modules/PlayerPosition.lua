local module = {}
YaworsCleanUI.PlayerPosition = module
YaworsCleanUI.registerModule(module)

local CROSS_THICKNESS = 2
local CROSS_LENGTH = 40
local CROSS_BORDER = 2

local crossFrame

local function createCrossFrame()
    local frame = CreateFrame("Frame", "YaworsCleanUI_PlayerPosition", UIParent)
    frame:SetSize(CROSS_LENGTH, CROSS_LENGTH)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    -- Clicks pass through to the world beneath the frame
    frame:EnableMouse(false)
    frame:SetFrameStrata("MEDIUM")
    frame:Hide()

    local horizontalBorder = frame:CreateTexture(nil, "BACKGROUND")
    horizontalBorder:SetColorTexture(0, 0, 0, 1)
    horizontalBorder:SetSize(CROSS_LENGTH, CROSS_THICKNESS + CROSS_BORDER * 2)
    horizontalBorder:SetPoint("CENTER", frame, "CENTER", 0, 0)

    local horizontal = frame:CreateTexture(nil, "OVERLAY")
    horizontal:SetColorTexture(1, 1, 1, 1)
    horizontal:SetSize(CROSS_LENGTH, CROSS_THICKNESS)
    horizontal:SetPoint("CENTER", frame, "CENTER", 0, 0)

    local verticalBorder = frame:CreateTexture(nil, "BACKGROUND")
    verticalBorder:SetColorTexture(0, 0, 0, 1)
    verticalBorder:SetSize(CROSS_THICKNESS + CROSS_BORDER * 2, CROSS_LENGTH)
    verticalBorder:SetPoint("CENTER", frame, "CENTER", 0, 0)

    local vertical = frame:CreateTexture(nil, "OVERLAY")
    vertical:SetColorTexture(1, 1, 1, 1)
    vertical:SetSize(CROSS_THICKNESS, CROSS_LENGTH)
    vertical:SetPoint("CENTER", frame, "CENTER", 0, 0)

    return frame
end

local function updateVisibility()
    if not crossFrame then return end

    if not YaworsCleanUIDB.playerPositionEnabled then
        crossFrame:Hide()
        return
    end

    if YaworsCleanUIDB.playerPositionCombatOnly and not UnitAffectingCombat("player") then
        crossFrame:Hide()
        return
    end

    crossFrame:Show()
end

function module.init()
    crossFrame = createCrossFrame()

    -- PLAYER_REGEN_DISABLED fires on entering combat, PLAYER_REGEN_ENABLED on leaving
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    eventFrame:SetScript("OnEvent", function()
        updateVisibility()
    end)

    module.applySettings()
end

function module.applySettings()
    if not crossFrame then return end

    crossFrame:ClearAllPoints()
    crossFrame:SetPoint(
        "CENTER",
        UIParent,
        "CENTER",
        YaworsCleanUIDB.playerPositionOffsetX,
        YaworsCleanUIDB.playerPositionOffsetY
    )
    updateVisibility()
end
