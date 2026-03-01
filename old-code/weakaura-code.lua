---=== CONFIG ===---


local config = aura_env.config or {}

local reapplyDelay = config.reapply_delay or 0.5

local isHideLootWindow = (config.hide_loot_window == true)
local isHideBags = (config.hide_bags == true)
local isHideRGroupId = (config.hide_rgroup_id == true)
local isWidgetBelowMinimap = (config.hide_below_mini == true)

local isHideDruidCombo = (config.hide_druid_combo == true)
local isHideDruidTreants = (config.hide_druid_treants == true)
local isHideDkRunes = (config.hide_dk_runes == true)
local isHideEvokerEssence = (config.hide_evoker_essence == true)
local isHideMageArcane = (config.hide_mage_arcane == true)
local isHideShamanTotems = (config.hide_shaman_totems == true)
local isHidePaladinPower = (config.hide_paladin_power == true)
local isHideRogueCombo = (config.hide_rogue_combo == true)
local isHideWarlockShards = (config.hide_warlock_shards == true)

local eventFrame
local _, playerClassToken = UnitClass("player")


---=== UTILS ===---

local function isAnyOptionOn()
	    return false
	    or isHideLootWindow
	    or isHideBags
	    or isHideRGroupId
	    --------------------------
	    or isHideDruidCombo
	    or isHideDruidTreants
	    or isHideDkRunes
	    or isHideEvokerEssence
	    or isHideMageArcane
	    or isHidePaladinPower
	    or isHideRogueCombo
	    or isHideShamanTotems
	    or isHideWarlockShards
end

	local function hideAndBlockShow(frame)
		    if frame and type(frame.Hide) == "function" then
		        if not frame.__yawor_cleanui_hooked then
		            frame.__yawor_cleanui_hooked = true
		            frame:HookScript("OnShow", function(self)
		                    self:Hide()
	            end)
        end
	        frame:Hide()
    end
end

local function safeIndex(root, ...)
	    local reference = root
	    for i = 1, select("#", ...) do
	        if type(reference) ~= "table" then
	            return nil
        end
        reference = reference[select(i, ...)]
    end
    return reference
end

local function runAfterDelay(seconds, callback)
	    if type(callback) == "function" and type(seconds) == "number" and seconds > 0 then
	        C_Timer.After(seconds, callback)
    end
end

local function runAfterCombat(fn)
	    if not InCombatLockdown() then
	        fn();
	        return
    end
    local combatFrame = CreateFrame("Frame")
    combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    combatFrame:SetScript("OnEvent", function(self)
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
            fn()
    end)
end

local function runOnEvents(fn)
	    if eventFrame or not isAnyOptionOn() then
	        return
    end
    eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
    eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    eventFrame:SetScript("OnEvent", function(_, event, unit)
            if event == "PLAYER_SPECIALIZATION_CHANGED" and unit and unit ~= "player" then
	                return
            end
            _, playerClassToken = UnitClass("player")
            fn()
    end)
end


---=== CLASS RESOURCES ===---

local function hideDruidComboPoints()
	    hideAndBlockShow(_G.DruidComboPointBarFrame)
end

	local function hideDruidTreants()
		    -- Treant guardians occupy the generic TotemFrame slots
		    hideAndBlockShow(_G.TotemFrame)
	end

	local function hideDeathKnightRunes()
		    hideAndBlockShow(_G.RuneFrame)
	end

	local function hideEvokerEssence()
		    hideAndBlockShow(_G.EssencePlayerFrame)
	end

	local function hideMageArcaneCharges()
		    hideAndBlockShow(_G.MageArcaneChargesFrame)
	end

	local function hideShamanTotems()
		    hideAndBlockShow(_G.TotemFrame)
	end

	local function hidePaladinHolyPower()
		    hideAndBlockShow(_G.PaladinPowerBarFrame)
	end

	local function hideRogueComboPoints()
		    hideAndBlockShow(_G.RogueComboPointBarFrame)
	end

	local function hideShamanTotems()
		    hideAndBlockShow(_G.TotemFrame)
	end

	local function hideWarlockSoulShards()
		    hideAndBlockShow(_G.WarlockPowerFrame)
	end

	
		---=== UI HIDERS ===---

local function hideLootWindow()
	    if isHideLootWindow then
	        hideAndBlockShow(LootFrame)
    end
end

local function hideBagButtons()
	    if isHideBags then
	        local bagsFrames = {
	            _G.MainMenuBarBackpackButton,
	            _G.BagBarExpandToggle,
	            _G.CharacterReagentBag0Slot,
	            _G.CharacterBag0Slot,
	            _G.CharacterBag1Slot,
	            _G.CharacterBag2Slot,
	            _G.CharacterBag3Slot
        }
	        for _, frame in ipairs(bagsFrames) do
	            hideAndBlockShow(frame)
        end
    end
end

local function hideRaidGroupIndicator()
	    if isHideRGroupId then
	        local groupIdFrame = safeIndex(
	            _G,
	            "PlayerFrame",
	            "PlayerFrameContent",
	            "PlayerFrameContentContextual",
	            "GroupIndicator"
	        )
	        hideAndBlockShow(groupIdFrame)
    end
end

local function hideWidgetBelowMinimap()
	    if isWidgetBelowMinimap then
	        hideAndBlockShow(_G.UIWidgetBelowMinimapContainerFrame)
    end
end


local function hideClassResources()
	    local playerClass = playerClassToken
	    
	    if playerClass == "DRUID" then
	        if isHideDruidCombo then
	            hideDruidComboPoints()
        end
        if isHideDruidTreants then
	            hideDruidTreants()
        end
    elseif playerClass == "DEATHKNIGHT" then
	        if isHideDkRunes then
	            hideDeathKnightRunes()
        end
    elseif playerClass == "EVOKER" then
	        if isHideEvokerEssence then
	            hideEvokerEssence()
        end
    elseif playerClass == "MAGE" then
	        if isHideMageArcane then
	            hideMageArcaneCharges()
        end
    elseif playerClass == "PALADIN" then
	        if isHidePaladinPower then
	            hidePaladinHolyPower()
        end
    elseif playerClass == "ROGUE" then
	        if isHideRogueCombo then
	            hideRogueComboPoints()
        end
    elseif playerClass == "SHAMAN" then
	        if isHideShamanTotems then
	            hideShamanTotems()
        end
    elseif playerClass == "WARLOCK" then
	        if isHideWarlockShards then
	            hideWarlockSoulShards()
        end
        
        
        
    end
end

local function hideUiFrames()
	    hideLootWindow()
	    hideBagButtons()
	    hideRaidGroupIndicator()
	    hideClassResources()
	    hideWidgetBelowMinimap()
end

	
	---=== APPLY AND REAPPLY AFTER DELAY ===---

if InCombatLockdown() then
	    runAfterCombat(hideUiFrames)
else
	    hideUiFrames()
end

	runAfterDelay(reapplyDelay, function()
		        runAfterCombat(hideUiFrames)
	end)

	runOnEvents(hideUiFrames)
