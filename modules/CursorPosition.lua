local module = {}
YaworsCleanUI.CursorPosition = module
YaworsCleanUI.registerModule(module)

-- A solid white disc (tints cleanly via SetVertexColor) and a mask that punches a
-- transparent hole through its center, leaving a hollow ring.
local DISC_TEXTURE = [[Interface\AddOns\YaworsCleanUI\textures\disc.png]]
local HOLE_MASK_TEXTURE = [[Interface\AddOns\YaworsCleanUI\textures\ring-hole-mask.png]]
-- The mask's transparent hole spans this fraction of the mask texture; must match
-- the value baked into ring-hole-mask.png so we can scale the hole to any diameter.
local HOLE_FRACTION = 0.5

local circleFrame

-- Builds one hollow ring: a solid disc with its own mask punching the center hole
local function createRing(frame)
    local disc = frame:CreateTexture(nil, "ARTWORK")
    disc:SetTexture(DISC_TEXTURE)
    disc:SetPoint("CENTER", frame, "CENTER", 0, 0)

    -- CLAMPTOWHITE makes the area outside the mask quad count as opaque, so the
    -- disc's outer rim stays visible no matter how small the hole mask is scaled
    local holeMask = frame:CreateMaskTexture()
    holeMask:SetTexture(HOLE_MASK_TEXTURE, "CLAMPTOWHITE", "CLAMPTOWHITE", "LINEAR")
    holeMask:SetPoint("CENTER", frame, "CENTER", 0, 0)
    disc:AddMaskTexture(holeMask)

    disc.holeMask = holeMask
    return disc
end

-- Sizes a ring to the given outer diameter and band thickness, then tints it
local function sizeRing(disc, outerDiameter, width, color)
    disc:SetSize(outerDiameter, outerDiameter)
    disc:SetVertexColor(color.r, color.g, color.b, 1)

    -- Scaling the mask by 1/HOLE_FRACTION lands its baked hole at the diameter that
    -- leaves a band `width` px wide on every side
    local holeDiameter = math.max(0, outerDiameter - width * 2)
    local maskSize = math.max(1, holeDiameter / HOLE_FRACTION)
    disc.holeMask:SetSize(maskSize, maskSize)
end

local function createCircleFrame()
    local frame = CreateFrame("Frame", "YaworsCleanUI_CursorPosition", UIParent)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    -- Clicks pass through to the world beneath the frame
    frame:EnableMouse(false)
    frame:SetFrameStrata("MEDIUM")
    frame:Hide()

    frame.outerRing = createRing(frame)
    frame.innerRing = createRing(frame)

    return frame
end

local function updateVisibility()
    if not circleFrame then return end

    if not YaworsCleanUIDB.cursorPosition.enabled then
        circleFrame:Hide()
        return
    end

    if YaworsCleanUIDB.cursorPosition.combatOnly and not UnitAffectingCombat("player") then
        circleFrame:Hide()
        return
    end

    circleFrame:Show()
end

function module.init()
    circleFrame = createCircleFrame()

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
    if not circleFrame then return end

    local settings = YaworsCleanUIDB.cursorPosition
    local size     = settings.size
    local width    = settings.width

    circleFrame:SetSize(size, size)

    sizeRing(circleFrame.outerRing, size, width, settings.outerColor)

    -- The inner ring's outer edge sits exactly at the outer ring's inner edge so the
    -- two bands touch. They must not overlap: the inner ring draws on top, so any
    -- overlap would paint over the outer ring and make it look thinner than the inner.
    local innerOuter = math.max(0, size - width * 2)
    sizeRing(circleFrame.innerRing, innerOuter, width, settings.innerColor)

    updateVisibility()
end
