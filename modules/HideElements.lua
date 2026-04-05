local module = {}
YaworsCleanUI.HideElements = module

YaworsCleanUI.registerModule(module)

-- Individual bag bar button names. Targeting the container frame alone is not
-- sufficient because Blizzard re-shows children independently.
local BAG_FRAME_NAMES = {
    "MainMenuBarBackpackButton",
    "CharacterBag0Slot",
    "CharacterBag1Slot",
    "CharacterBag2Slot",
    "CharacterBag3Slot",
    "CharacterReagentBag0Slot",
    "BagBarExpandToggle",
}

local eventFrame = CreateFrame("Frame")
-- LOOT_OPENED fires each time the game opens the loot window
eventFrame:RegisterEvent("LOOT_OPENED")
eventFrame:SetScript("OnEvent", function(self, event)
    if YaworsCleanUIDB.hideElements.looting and LootFrame then
        LootFrame:Hide()
    end
end)

-- HookScript cannot be undone, so the hook reads the live setting each time
-- rather than capturing a boolean at hook time. This allows toggling to work.
local function hookBagFrame(frame)
    if frame.__yawors_hooked then return end
    frame.__yawors_hooked = true
    frame:HookScript("OnShow", function(self)
        if YaworsCleanUIDB.hideElements.bags then
            self:Hide()
        end
    end)
end

local function applyLootSettings()
    if YaworsCleanUIDB.hideElements.looting and LootFrame and LootFrame:IsShown() then
        LootFrame:Hide()
    end
end

local function applyBagSettings()
    for _, name in ipairs(BAG_FRAME_NAMES) do
        local frame = _G[name]
        if frame then
            hookBagFrame(frame)
            if YaworsCleanUIDB.hideElements.bags then
                frame:Hide()
            else
                frame:Show()
            end
        end
    end
end

function module.init()
    module.applySettings()
end

function module.applySettings()
    applyLootSettings()
    applyBagSettings()
end
