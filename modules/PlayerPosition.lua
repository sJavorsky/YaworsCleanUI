local module = {}
YaworsCleanUI.PlayerPosition = module
YaworsCleanUI.registerModule(module)

local crossFrame
-- Separate always-shown frame so OnUpdate keeps firing even when crossFrame is hidden
local pollFrame

-- Anchor points for the zoom->offset curve (not hard clamps; we extrapolate past the near anchor)
local DYNAMIC_ZOOM_MIN        = 6
local DYNAMIC_ZOOM_MAX        = 40
local DYNAMIC_OFFSET_AT_MIN   = -300
local DYNAMIC_OFFSET_AT_MAX   = -50
-- Guards 1/zoom from exploding toward first-person; below this the cross is usually hidden anyway
local DYNAMIC_ZOOM_FLOOR      = 1
local LERP_SPEED              = 10

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

local function computeZoomOffsetY(zoom)
    -- Floor (not the near anchor) so zoom below DYNAMIC_ZOOM_MIN extrapolates instead of freezing
    local clamped = math.max(DYNAMIC_ZOOM_FLOOR, math.min(DYNAMIC_ZOOM_MAX, zoom))
    -- Interpolate in 1/zoom space: character screen position is hyperbolic with camera distance
    local fraction = (1/DYNAMIC_ZOOM_MIN - 1/clamped) / (1/DYNAMIC_ZOOM_MIN - 1/DYNAMIC_ZOOM_MAX)
    return DYNAMIC_OFFSET_AT_MIN + (DYNAMIC_OFFSET_AT_MAX - DYNAMIC_OFFSET_AT_MIN) * fraction
end

local function updateVisibility()
    if not crossFrame then return end

    if not YaworsCleanUIDB.playerPosition.enabled then
        crossFrame:Hide()
        return
    end

    if YaworsCleanUIDB.playerPosition.combatOnly and not UnitAffectingCombat("player") then
        crossFrame:Hide()
        return
    end

    if not YaworsCleanUIDB.playerPosition.manualOffset and GetCameraZoom() < YaworsCleanUIDB.playerPosition.minZoom then
        crossFrame:Hide()
        return
    end

    crossFrame:Show()
end

local currentOffsetY = nil  -- nil forces an immediate snap on the first update

local function onUpdateDynamic(_, elapsed)
    local targetOffsetY = computeZoomOffsetY(GetCameraZoom())

    if currentOffsetY == nil then
        currentOffsetY = targetOffsetY
    else
        currentOffsetY = currentOffsetY + (targetOffsetY - currentOffsetY) * math.min(1, LERP_SPEED * elapsed)
    end

    crossFrame:ClearAllPoints()
    crossFrame:SetPoint("CENTER", UIParent, "CENTER", 0, currentOffsetY)
    updateVisibility()
end

function module.init()
    crossFrame = createCrossFrame()

    pollFrame = CreateFrame("Frame")
    -- pollFrame must stay shown so its OnUpdate fires even when crossFrame is hidden
    pollFrame:Show()

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

    local settings  = YaworsCleanUIDB.playerPosition
    local width     = settings.width
    local height    = settings.height
    local thickness = settings.thickness
    -- Border is bonded to thickness: same px as the inner line on each side
    local border    = thickness

    crossFrame:SetSize(width, height)

    local borderColor = settings.borderColor
    local innerColor  = settings.innerColor

    crossFrame.horizontalBorder:SetColorTexture(borderColor.r, borderColor.g, borderColor.b, 1)
    crossFrame.horizontalBorder:SetSize(width, thickness + border * 2)

    crossFrame.horizontal:SetColorTexture(innerColor.r, innerColor.g, innerColor.b, 1)
    crossFrame.horizontal:SetSize(width, thickness)

    crossFrame.verticalBorder:SetColorTexture(borderColor.r, borderColor.g, borderColor.b, 1)
    crossFrame.verticalBorder:SetSize(thickness + border * 2, height)

    crossFrame.vertical:SetColorTexture(innerColor.r, innerColor.g, innerColor.b, 1)
    crossFrame.vertical:SetSize(thickness, height)

    if settings.manualOffset then
        pollFrame:SetScript("OnUpdate", nil)
        crossFrame:ClearAllPoints()
        crossFrame:SetPoint("CENTER", UIParent, "CENTER", settings.offsetX, settings.offsetY)
    else
        currentOffsetY = nil  -- snap to correct position immediately on next frame
        pollFrame:SetScript("OnUpdate", onUpdateDynamic)
    end

    updateVisibility()
end
