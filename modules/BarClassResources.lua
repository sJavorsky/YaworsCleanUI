local module = {}
YaworsCleanUI.BarClassResources = module
YaworsCleanUI.registerModule(module)

local BAR_TEXTURE = "Legionfall_BarFrame-Glow"
local BAR_WIDTH   = 300
local BAR_HEIGHT  = 30

-- One entry per supported class. Add new classes here.
-- settingKey: key in YaworsCleanUIDB that controls visibility
-- color:      {r, g, b} foreground tint applied over the desaturated texture
local classConfigs = {
    DEATHKNIGHT = {
        settingKey = "deathKnightRunicPower",
        color      = {0, 0.855, 1},
    },
}

-- Populated in init() with the config for the logged-in character's class
local activeConfig = nil

-- The bar frame, created once in init()
local barFrame = nil

local function createBar(config)
    local frame = CreateFrame("Frame", "YaworsCleanUI_BarClassResource", UIParent)
    frame:SetSize(BAR_WIDTH, BAR_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    -- CreateFrame shows frames by default; start hidden so applySettings() controls visibility
    frame:Hide()

    -- Background uses the same texture at full value, darkened, so the shape matches the foreground
    local background = CreateFrame("StatusBar", nil, frame)
    background:SetAllPoints()
    -- Must be below the foreground bar; child frames share the parent level by default
    background:SetFrameLevel(frame:GetFrameLevel())
    background:SetStatusBarTexture(BAR_TEXTURE)
    background:GetStatusBarTexture():SetDesaturated(true)
    background:SetStatusBarColor(0.1, 0.1, 0.1)
    background:SetMinMaxValues(0, 100)
    background:SetValue(100)

    local bar = CreateFrame("StatusBar", nil, frame)
    bar:SetAllPoints()
    bar:SetFrameLevel(frame:GetFrameLevel() + 1)
    -- SetStatusBarTexture names a texture from the game files by its atlas/path key
    bar:SetStatusBarTexture(BAR_TEXTURE)
    -- Desaturate to grayscale first so the vertex color is the sole source of hue
    bar:GetStatusBarTexture():SetDesaturated(true)
    bar:SetStatusBarColor(config.color[1], config.color[2], config.color[3])
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(69)

    return frame
end

function module.applySettings()
    if not barFrame then return end

    if not YaworsCleanUIDB[activeConfig.settingKey] then
        barFrame:Hide()
        return
    end

    barFrame:Show()
    barFrame:ClearAllPoints()
    -- UIParent spans the full screen; its center is the screen center
    barFrame:SetPoint("CENTER", UIParent, "CENTER",
        YaworsCleanUIDB.classResourceBarsOffsetX,
        YaworsCleanUIDB.classResourceBarsOffsetY)
    barFrame:SetScale(YaworsCleanUIDB.classResourceBarsScale / 100)
end

function module.init()
    local class = UnitClassBase("player")
    activeConfig = classConfigs[class]
    if not activeConfig then return end

    barFrame = createBar(activeConfig)

    module.applySettings()
end
