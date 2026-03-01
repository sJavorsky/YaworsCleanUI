local mod = {}
YaworsCleanUI.HideElements = mod

YaworsCleanUI.registerModule(mod)

-- Bag slot frame names in the action bar area, accessed via _G to allow nil
-- checks rather than hard global references that would error if a frame is
-- absent in a future patch.
local BAG_FRAME_NAMES = {
    "MainMenuBarBackpackButton", -- the default backpack icon
    "CharacterBag0Slot",         -- additional bag slot 1
    "CharacterBag1Slot",         -- additional bag slot 2
    "CharacterBag2Slot",         -- additional bag slot 3
    "CharacterBag3Slot",         -- additional bag slot 4
    "BagBarExpandToggle",        -- collapse/expand toggle for the bag bar
}

local eventFrame = CreateFrame("Frame")
-- LOOT_OPENED fires each time the game opens the loot window
eventFrame:RegisterEvent("LOOT_OPENED")
eventFrame:SetScript("OnEvent", function(self, event)
    if YaworsCleanUIDB.hideLooting and LootFrame then
        LootFrame:Hide()
    end
end)

function mod.init()
    mod.applySettings()
end

function mod.applySettings()
    local db = YaworsCleanUIDB

    -- Suppress the loot frame if it is currently visible and the setting is on
    if db.hideLooting and LootFrame and LootFrame:IsShown() then
        LootFrame:Hide()
    end

    for _, name in ipairs(BAG_FRAME_NAMES) do
        local f = _G[name]
        if f then
            if db.hideBags then
                f:Hide()
            else
                f:Show()
            end
        end
    end
end
