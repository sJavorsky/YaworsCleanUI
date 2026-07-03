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

-- Half-plane wiper mask: right half reveals, left half hides, hard edge through the
-- center. Rotating it sweeps the reveal edge around the ring for a radial fill.
local HALF_MASK_TEXTURE = [[Interface\AddOns\YaworsCleanUI\textures\half-mask.png]]

-- A dummy spell whose cooldown mirrors the global cooldown
local GCD_SPELL_ID = 61304

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

-- A tracker is a ring that fills radially (like a circular cast bar). The fill is a
-- wedge revealed by rotating half-plane masks. Two masks can only ever intersect to a
-- convex wedge (<=180 deg), so we use two ring copies: A covers 0-180 deg, B covers
-- 180-360 deg, and their union is the filled arc for any progress 0..1.
local function createWiper(frame)
    local mask = frame:CreateMaskTexture()
    -- CLAMP keeps each side's edge behavior past the quad: right edge stays revealing,
    -- left edge stays hiding, so the half-plane extends correctly under rotation.
    mask:SetTexture(HALF_MASK_TEXTURE, "CLAMP", "CLAMP", "LINEAR")
    mask:SetPoint("CENTER", frame, "CENTER", 0, 0)
    return mask
end

local function createTracker(frame)
    local tracker = {}
    tracker.contentA = createRing(frame)
    tracker.contentB = createRing(frame)

    tracker.startA = createWiper(frame)  -- A's start edge, fixed at 12 o'clock
    tracker.endA   = createWiper(frame)  -- A's moving end edge
    tracker.startB = createWiper(frame)  -- B's start edge, fixed at 6 o'clock
    tracker.endB   = createWiper(frame)  -- B's moving end edge
    tracker.contentA:AddMaskTexture(tracker.startA)
    tracker.contentA:AddMaskTexture(tracker.endA)
    tracker.contentB:AddMaskTexture(tracker.startB)
    tracker.contentB:AddMaskTexture(tracker.endB)

    -- Fixed start edges: A reveals clockwise from 0 deg, B reveals clockwise from 180 deg
    tracker.startA:SetRotation(0)
    tracker.startB:SetRotation(math.rad(-180))
    tracker.contentB:Hide()

    return tracker
end

-- Places a tracker as a ring of the given outer diameter and thickness, and oversizes
-- its wiper masks so rotation never uncovers the band (SetRotation shrinks by 2^-0.5).
local function sizeTracker(tracker, outerDiameter, width, color)
    tracker.active = outerDiameter > 0 and width > 0
    if not tracker.active then
        tracker.contentA:Hide()
        tracker.contentB:Hide()
        return
    end

    sizeRing(tracker.contentA, outerDiameter, width, color)
    sizeRing(tracker.contentB, outerDiameter, width, color)

    local wiperSize = outerDiameter * 2
    tracker.startA:SetSize(wiperSize, wiperSize)
    tracker.endA:SetSize(wiperSize, wiperSize)
    tracker.startB:SetSize(wiperSize, wiperSize)
    tracker.endB:SetSize(wiperSize, wiperSize)
end

-- Reveals the arc [0, progress] clockwise from 12 o'clock. The end edge maps to a mask
-- rotation of (180 - 360*progress) degrees.
local function setTrackerProgress(tracker, progress)
    if not tracker.active then return end
    progress = math.max(0, math.min(1, progress))
    local endRotation = math.rad(180 - 360 * progress)

    tracker.contentA:Show()
    if progress <= 0.5 then
        -- A alone covers the sub-180 wedge; B stays hidden
        tracker.endA:SetRotation(endRotation)
        tracker.contentB:Hide()
    else
        -- A fills its whole 0-180 half; B fills the remainder past 180
        tracker.endA:SetRotation(0)
        tracker.endB:SetRotation(endRotation)
        tracker.contentB:Show()
    end
end

-- Fill fraction of the player's current spell. Casts fill up (0 -> 1); channels
-- drain (1 -> 0). Returns 0 when nothing is being cast.
local function getCastProgress()
    -- Both return: name, text, texture, startTimeMS, endTimeMS, ...
    local name, _, _, startMS, endMS = UnitCastingInfo("player")
    local draining = false
    if not name then
        name, _, _, startMS, endMS = UnitChannelInfo("player")
        draining = true
    end
    if not name or not startMS then return 0 end

    local total = endMS - startMS
    if total <= 0 then return 0 end

    local elapsed = math.max(0, math.min(1, (GetTime() * 1000 - startMS) / total))
    if draining then return 1 - elapsed end
    return elapsed
end

-- Fill fraction of the global cooldown, filling up as it elapses. 0 when off the GCD.
local function getGCDProgress()
    local info = C_Spell.GetSpellCooldown(GCD_SPELL_ID)
    if not info or info.duration <= 0 then return 0 end
    return math.max(0, math.min(1, (GetTime() - info.startTime) / info.duration))
end

local function trackerProgress(source)
    if source == "gcd" then return getGCDProgress() end
    return getCastProgress()
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
    frame.outerTracker = createTracker(frame)
    frame.innerTracker = createTracker(frame)

    -- Follow the cursor while shown. OnUpdate only fires on visible frames, so this
    -- costs nothing while the ring is hidden. GetCursorPosition returns screen pixels
    -- from the bottom-left, scaled by the UI scale, hence dividing by the frame's scale.
    frame:SetScript("OnUpdate", function(self)
        local scale = self:GetEffectiveScale()
        local cursorX, cursorY = GetCursorPosition()
        self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", cursorX / scale, cursorY / scale)

        if self.previewTrackers then
            -- Demo sweep so the trackers are visible while configuring them
            local progress = (GetTime() % 3) / 3
            setTrackerProgress(self.outerTracker, progress)
            setTrackerProgress(self.innerTracker, progress)
        else
            setTrackerProgress(self.outerTracker, trackerProgress(self.outerTracker.source))
            setTrackerProgress(self.innerTracker, trackerProgress(self.innerTracker.source))
        end
    end)

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

    local settings          = YaworsCleanUIDB.cursorPosition
    local size              = settings.size
    local width             = settings.width
    local outerTrackerWidth = settings.outerTrackerWidth
    local innerTrackerWidth = settings.innerTrackerWidth

    circleFrame:SetSize(size + outerTrackerWidth * 2, size + outerTrackerWidth * 2)

    sizeRing(circleFrame.outerRing, size, width, settings.outerColor)

    -- The inner ring's outer edge sits exactly at the outer ring's inner edge so the
    -- two bands touch. They must not overlap: the inner ring draws on top, so any
    -- overlap would paint over the outer ring and make it look thinner than the inner.
    local innerOuter = math.max(0, size - width * 2)
    sizeRing(circleFrame.innerRing, innerOuter, width, settings.innerColor)

    -- Outer tracker sits just outside the outer ring; inner tracker just inside the
    -- inner ring. Both touch the static block's edges.
    sizeTracker(circleFrame.outerTracker, size + outerTrackerWidth * 2, outerTrackerWidth, settings.outerTrackerColor)
    local innerTrackerOuter = math.max(0, size - width * 4)
    sizeTracker(circleFrame.innerTracker, innerTrackerOuter, innerTrackerWidth, settings.innerTrackerColor)

    circleFrame.outerTracker.source = settings.outerTrackerSource
    circleFrame.innerTracker.source = settings.innerTrackerSource
    circleFrame.previewTrackers = settings.previewTrackers

    updateVisibility()
end
