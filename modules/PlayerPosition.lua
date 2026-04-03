local module = {}
YaworsCleanUI.PlayerPosition = module
YaworsCleanUI.registerModule(module)

local crossFrame

local function createCrossFrame()
    local frame = CreateFrame("Frame", "YaworsCleanUI_PlayerPosition", UIParent)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    -- Clicks pass through to the world beneath the frame
    frame:EnableMouse(false)
    frame:SetFrameStrata("MEDIUM")
    frame:Hide()

    frame.horizontalBorder = frame:CreateTexture(nil, "BACKGROUND")
    frame.horizontalBorder:SetPoint("CENTER", frame, "CENTER", 0, 0)

    frame.horizontal = frame:CreateTexture(nil, "OVERLAY")
    frame.horizontal:SetPoint("CENTER", frame, "CENTER", 0, 0)

    frame.verticalBorder = frame:CreateTexture(nil, "BACKGROUND")
    frame.verticalBorder:SetPoint("CENTER", frame, "CENTER", 0, 0)

    frame.vertical = frame:CreateTexture(nil, "OVERLAY")
    frame.vertical:SetPoint("CENTER", frame, "CENTER", 0, 0)

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

    local width     = YaworsCleanUIDB.playerPositionWidth
    local height    = YaworsCleanUIDB.playerPositionHeight
    local thickness = YaworsCleanUIDB.playerPositionThickness
    -- Border is bonded to thickness: same px as the inner line on each side
    local border    = thickness

    crossFrame:SetSize(width, height)

    crossFrame.horizontalBorder:SetColorTexture(
        YaworsCleanUIDB.playerPositionBorderR,
        YaworsCleanUIDB.playerPositionBorderG,
        YaworsCleanUIDB.playerPositionBorderB, 1)
    crossFrame.horizontalBorder:SetSize(width, thickness + border * 2)

    crossFrame.horizontal:SetColorTexture(
        YaworsCleanUIDB.playerPositionInnerR,
        YaworsCleanUIDB.playerPositionInnerG,
        YaworsCleanUIDB.playerPositionInnerB, 1)
    crossFrame.horizontal:SetSize(width, thickness)

    crossFrame.verticalBorder:SetColorTexture(
        YaworsCleanUIDB.playerPositionBorderR,
        YaworsCleanUIDB.playerPositionBorderG,
        YaworsCleanUIDB.playerPositionBorderB, 1)
    crossFrame.verticalBorder:SetSize(thickness + border * 2, height)

    crossFrame.vertical:SetColorTexture(
        YaworsCleanUIDB.playerPositionInnerR,
        YaworsCleanUIDB.playerPositionInnerG,
        YaworsCleanUIDB.playerPositionInnerB, 1)
    crossFrame.vertical:SetSize(thickness, height)

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
