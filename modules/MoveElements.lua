local module = {}
YaworsCleanUI.MoveElements = module
YaworsCleanUI.registerModule(module)

-- Guards against our own SetPoint re-triggering the SetPoint hooks below
local pinning = false

local managedFrames = {}

-- BNToastFrame's default size (from /fstack); the preview box mirrors it
local TOAST_WIDTH = 250
local TOAST_HEIGHT = 63
local toastPreview
local eyePreview
local isToastPreviewShown = false
local isEyePreviewShown = false

local function anchorQueueEye(frame)
    local settings = YaworsCleanUIDB.moveElements
    -- Polar placement around the minimap center: distance in px, angle
    -- in degrees (0 = left, counter-clockwise). Distance 0 sits dead center.
    local angleRadians = math.rad(settings.eyeAngle)
    local offsetX = -settings.eyeDistance * math.cos(angleRadians)
    local offsetY = settings.eyeDistance * math.sin(angleRadians)
    frame:SetPoint("CENTER", Minimap, "CENTER", offsetX, offsetY)
end

local function anchorToast(frame)
    local settings = YaworsCleanUIDB.moveElements
    -- Offset 0,0 sits the toast at screen center
    frame:SetPoint("CENTER", UIParent, "CENTER", settings.toastOffsetX, settings.toastOffsetY)
end

local function captureOriginalPoints(state)
    if state.originalPoints then return end
    local frame = state.frame
    state.originalPoints = {}
    for i = 1, frame:GetNumPoints() do
        state.originalPoints[i] = { frame:GetPoint(i) }
    end
end

local function applyAnchor(state)
    pinning = true
    state.frame:ClearAllPoints()
    state.anchor(state.frame)
    pinning = false
end

local function restoreAnchor(state)
    if not state.originalPoints then return end
    pinning = true
    state.frame:ClearAllPoints()
    for _, point in ipairs(state.originalPoints) do
        state.frame:SetPoint(unpack(point))
    end
    pinning = false
end

local function updateAnchor(state)
    if state.isEnabled() then
        applyAnchor(state)
    else
        restoreAnchor(state)
    end
end

-- Blizzard re-anchors these frames on its own schedule (minimap layout, toast
-- queue), so re-apply our anchor whenever it moves them while we are enabled.
local function setupPinnedFrame(frame, isEnabled, anchor)
    local state = { frame = frame, isEnabled = isEnabled, anchor = anchor }
    captureOriginalPoints(state)
    hooksecurefunc(frame, "SetPoint", function()
        if pinning then return end
        if not isEnabled() then return end
        applyAnchor(state)
    end)
    table.insert(managedFrames, state)
end

function module.init()
    if QueueStatusButton then
        setupPinnedFrame(QueueStatusButton,
            function() return YaworsCleanUIDB.moveElements.queueEye end,
            anchorQueueEye)
    end

    if BNToastFrame then
        setupPinnedFrame(BNToastFrame,
            function() return YaworsCleanUIDB.moveElements.bnetToast end,
            anchorToast)
    end

    toastPreview = CreateFrame("Frame", "YaworsCleanUI_ToastPreview", UIParent)
    toastPreview:SetSize(TOAST_WIDTH, TOAST_HEIGHT)
    toastPreview:EnableMouse(false)
    toastPreview:SetFrameStrata("DIALOG")
    toastPreview:Hide()
    local previewTexture = toastPreview:CreateTexture(nil, "OVERLAY")
    previewTexture:SetAllPoints(toastPreview)
    previewTexture:SetColorTexture(0, 0.4, 1, 0.5)

    eyePreview = CreateFrame("Frame", "YaworsCleanUI_EyePreview", UIParent)
    eyePreview:EnableMouse(false)
    eyePreview:SetFrameStrata("DIALOG")
    eyePreview:Hide()
    local eyeTexture = eyePreview:CreateTexture(nil, "OVERLAY")
    eyeTexture:SetAllPoints(eyePreview)
    eyeTexture:SetColorTexture(0, 1, 0.2, 0.5)
    -- Blizzard's round portrait mask clips the square color texture into a circle
    local eyeMask = eyePreview:CreateMaskTexture()
    eyeMask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    eyeMask:SetAllPoints(eyePreview)
    eyeTexture:AddMaskTexture(eyeMask)

    -- Previews are only for positioning, so they never outlive the options panel
    SettingsPanel:HookScript("OnHide", module.hidePreviews)

    module.applySettings()
end

function module.toggleEyePreview()
    isEyePreviewShown = not isEyePreviewShown
    module.applySettings()
end

function module.toggleToastPreview()
    isToastPreviewShown = not isToastPreviewShown
    module.applySettings()
end

function module.hidePreviews()
    isEyePreviewShown = false
    isToastPreviewShown = false
    module.applySettings()
end

local function updatePreview(preview, isShown, anchor)
    if not preview then return end
    if isShown then
        preview:ClearAllPoints()
        anchor(preview)
        preview:Show()
    else
        preview:Hide()
    end
end

function module.applySettings()
    for _, state in ipairs(managedFrames) do
        updateAnchor(state)
    end
    if QueueStatusButton then
        -- Size is read live so the circle tracks the eye even if Blizzard resizes it
        eyePreview:SetSize(QueueStatusButton:GetSize())
    end
    updatePreview(eyePreview, isEyePreviewShown, anchorQueueEye)
    updatePreview(toastPreview, isToastPreviewShown, anchorToast)
end
