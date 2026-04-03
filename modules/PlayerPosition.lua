local module = {}
YaworsCleanUI.PlayerPosition = module
YaworsCleanUI.registerModule(module)

local CROSS_THICKNESS = 2
local CROSS_LENGTH = 40

local crossFrame

local function createCrossFrame()
    local frame = CreateFrame("Frame", "YaworsCleanUI_PlayerPosition", UIParent)
    frame:SetSize(CROSS_LENGTH, CROSS_LENGTH)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    -- Clicks pass through to the world beneath the frame
    frame:EnableMouse(false)
    frame:SetFrameStrata("MEDIUM")
    frame:Hide()

    local horizontal = frame:CreateTexture(nil, "OVERLAY")
    horizontal:SetColorTexture(1, 1, 1, 1)
    horizontal:SetSize(CROSS_LENGTH, CROSS_THICKNESS)
    horizontal:SetPoint("CENTER", frame, "CENTER", 0, 0)

    local vertical = frame:CreateTexture(nil, "OVERLAY")
    vertical:SetColorTexture(1, 1, 1, 1)
    vertical:SetSize(CROSS_THICKNESS, CROSS_LENGTH)
    vertical:SetPoint("CENTER", frame, "CENTER", 0, 0)

    return frame
end

function module.init()
    crossFrame = createCrossFrame()
    module.applySettings()
end

function module.applySettings()
    if not crossFrame then return end

    if YaworsCleanUIDB.playerPositionEnabled then
        crossFrame:ClearAllPoints()
        crossFrame:SetPoint(
            "CENTER",
            UIParent,
            "CENTER",
            YaworsCleanUIDB.playerPositionOffsetX,
            YaworsCleanUIDB.playerPositionOffsetY
        )
        crossFrame:Show()
    else
        crossFrame:Hide()
    end
end
