return {
    ["Remove UI elements"] = {
        ["iconSource"] = -1,
        ["color"] = {1, 1, 1, 1},
        ["adjustedMax"] = "",
        ["adjustedMin"] = "",
        ["yOffset"] = -1000,
        ["anchorPoint"] = "CENTER",
        ["cooldownSwipe"] = true,
        ["cooldownEdge"] = false,
        ["icon"] = true,
        ["triggers"] = {
            {
                ["trigger"] = {
                    ["debuffType"] = "HELPFUL",
                    ["type"] = "aura2",
                    ["spellIds"] = {},
                    ["subeventSuffix"] = "_CAST_START",
                    ["unit"] = "player",
                    ["names"] = {},
                    ["event"] = "Health",
                    ["subeventPrefix"] = "SPELL"
                },
                ["untrigger"] = {}
            },
            ["activeTriggerMode"] = -10
        },
        ["internalVersion"] = 88,
        ["progressSource"] = {-1, ""},
        ["selfPoint"] = "CENTER",
        ["desaturate"] = false,
        ["subRegions"] = {{
            ["type"] = "subbackground"
        }, {
            ["text_shadowXOffset"] = 0,
            ["text_text_format_s_format"] = "none",
            ["text_text"] = "%s",
            ["text_shadowColor"] = {0, 0, 0, 1},
            ["text_selfPoint"] = "AUTO",
            ["text_automaticWidth"] = "Auto",
            ["text_fixedWidth"] = 64,
            ["anchorYOffset"] = 0,
            ["text_justify"] = "CENTER",
            ["rotateText"] = "NONE",
            ["type"] = "subtext",
            ["text_color"] = {1, 1, 1, 1},
            ["text_font"] = "Friz Quadrata TT",
            ["text_shadowYOffset"] = 0,
            ["text_wordWrap"] = "WordWrap",
            ["text_visible"] = true,
            ["anchor_point"] = "INNER_BOTTOMRIGHT",
            ["text_fontSize"] = 12,
            ["anchorXOffset"] = 0,
            ["text_fontType"] = "OUTLINE"
        }, {
            ["glowFrequency"] = 0.25,
            ["type"] = "subglow",
            ["useGlowColor"] = false,
            ["glowType"] = "buttonOverlay",
            ["glowLength"] = 10,
            ["glowYOffset"] = 0,
            ["glowColor"] = {1, 1, 1, 1},
            ["glowScale"] = 1,
            ["glow"] = false,
            ["glowDuration"] = 1,
            ["glowXOffset"] = 0,
            ["glowThickness"] = 1,
            ["glowLines"] = 8,
            ["glowBorder"] = false
        }},
        ["height"] = 64,
        ["load"] = {
            ["use_never"] = false,
            ["talent"] = {
                ["multi"] = {}
            },
            ["class"] = {
                ["multi"] = {}
            },
            ["spec"] = {
                ["multi"] = {}
            },
            ["size"] = {
                ["multi"] = {}
            }
        },
        ["useAdjustededMax"] = false,
        ["parent"] = "Clean UI",
        ["useAdjustededMin"] = false,
        ["regionType"] = "icon",
        ["conditions"] = {},
        ["keepAspectRatio"] = false,
        ["animation"] = {
            ["start"] = {
                ["easeStrength"] = 3,
                ["type"] = "none",
                ["duration_type"] = "seconds",
                ["easeType"] = "none"
            },
            ["main"] = {
                ["easeStrength"] = 3,
                ["type"] = "none",
                ["duration_type"] = "seconds",
                ["easeType"] = "none"
            },
            ["finish"] = {
                ["easeStrength"] = 3,
                ["type"] = "none",
                ["duration_type"] = "seconds",
                ["easeType"] = "none"
            }
        },
        ["information"] = {},
        ["xOffset"] = 0,
        ["uid"] = "PR1dovKoLYv",
        ["cooldownTextDisabled"] = false,
        ["zoom"] = 0,
        ["width"] = 64,
        ["id"] = "Remove UI elements",
        ["useCooldownModRate"] = true,
        ["alpha"] = 1,
        ["anchorFrameType"] = "SCREEN",
        ["frameStrata"] = 1,
        ["config"] = {
            ["hide_paladin_power"] = true,
            ["hide_shaman_totems"] = false,
            ["hide_evoker_essence"] = true,
            ["hide_loot_window"] = true,
            ["hide_below_mini"] = true,
            ["hide_druid_treants"] = true,
            ["hide_mage_arcane"] = true,
            ["hide_warlock_shards"] = true,
            ["hide_druid_combo"] = true,
            ["hide_rogue_combo"] = true,
            ["hide_bags"] = true,
            ["hide_rgroup_id"] = true,
            ["reapply_delay"] = 0.5,
            ["hide_dk_runes"] = true
        },
        ["inverse"] = false,
        ["actions"] = {
            ["start"] = {},
            ["finish"] = {
                ["do_custom"] = true,
                ["custom"] = "\n\n"
            },
            ["init"] = {
                ["do_custom"] = true,
                ["custom"] = "---=== CONFIG ===---\n\nlocal config = aura_env.config or {}\n\nlocal reapplyDelay = config.reapply_delay or 0.5\n\nlocal isHideLootWindow = (config.hide_loot_window == true)\nlocal isHideBags = (config.hide_bags == true)\nlocal isHideRGroupId = (config.hide_rgroup_id == true)\nlocal isWidgetBelowMinimap = (config.hide_below_mini == true)\n\nlocal isHideDruidCombo = (config.hide_druid_combo == true)\nlocal isHideDruidTreants = (config.hide_druid_treants == true)\nlocal isHideDkRunes = (config.hide_dk_runes == true)\nlocal isHideEvokerEssence = (config.hide_evoker_essence == true)\nlocal isHideMageArcane = (config.hide_mage_arcane == true)\nlocal isHideShamanTotems = (config.hide_shaman_totems == true)\nlocal isHidePaladinPower = (config.hide_paladin_power == true)\nlocal isHideRogueCombo = (config.hide_rogue_combo == true)\nlocal isHideWarlockShards = (config.hide_warlock_shards == true)\n\nlocal eventFrame\nlocal _, playerClassToken = UnitClass(\"player\")\n\n\n---=== UTILS ===---\n\nlocal function isAnyOptionOn()\n    return false\n    or isHideLootWindow\n    or isHideBags\n    or isHideRGroupId\n    --------------------------\n    or isHideDruidCombo\n    or isHideDruidTreants\n    or isHideDkRunes\n    or isHideEvokerEssence\n    or isHideMageArcane\n    or isHidePaladinPower\n    or isHideRogueCombo\n    or isHideShamanTotems\n    or isHideWarlockShards\nend\n\nlocal function hideAndBlockShow(frame)\n    if frame and type(frame.Hide) == \"function\" then\n        if not frame.__yawor_cleanui_hooked then\n            frame.__yawor_cleanui_hooked = true\n            frame:HookScript(\"OnShow\", function(self)\n                    self:Hide()\n            end)\n        end\n        frame:Hide()\n    end\nend\n\nlocal function safeIndex(root, ...)\n    local reference = root\n    for i = 1, select(\"#\", ...) do\n        if type(reference) ~= \"table\" then\n            return nil\n        end\n        reference = reference[select(i, ...)]\n    end\n    return reference\nend\n\nlocal function runAfterDelay(seconds, callback)\n    if type(callback) == \"function\" and type(seconds) == \"number\" and seconds > 0 then\n        C_Timer.After(seconds, callback)\n    end\nend\n\nlocal function runAfterCombat(fn)\n    if not InCombatLockdown() then\n        fn();\n        return\n    end\n    local combatFrame = CreateFrame(\"Frame\")\n    combatFrame:RegisterEvent(\"PLAYER_REGEN_ENABLED\")\n    combatFrame:SetScript(\"OnEvent\", function(self)\n            self:UnregisterEvent(\"PLAYER_REGEN_ENABLED\")\n            fn()\n    end)\nend\n\nlocal function runOnEvents(fn)\n    if eventFrame or not isAnyOptionOn() then\n        return\n    end\n    eventFrame = CreateFrame(\"Frame\")\n    eventFrame:RegisterEvent(\"PLAYER_ENTERING_WORLD\")\n    eventFrame:RegisterEvent(\"PLAYER_TALENT_UPDATE\")\n    eventFrame:RegisterEvent(\"PLAYER_SPECIALIZATION_CHANGED\")\n    eventFrame:RegisterEvent(\"PLAYER_REGEN_ENABLED\")\n    eventFrame:SetScript(\"OnEvent\", function(_, event, unit)\n            if event == \"PLAYER_SPECIALIZATION_CHANGED\" and unit and unit ~= \"player\" then\n                return\n            end\n            _, playerClassToken = UnitClass(\"player\")\n            fn()\n    end)\nend\n\n\n---=== CLASS RESOURCES ===---\n\nlocal function hideDruidComboPoints()\n    hideAndBlockShow(_G.DruidComboPointBarFrame)\nend\n\nlocal function hideDruidTreants()\n    -- Treant guardians occupy the generic TotemFrame slots\n    hideAndBlockShow(_G.TotemFrame)\nend\n\nlocal function hideDeathKnightRunes()\n    hideAndBlockShow(_G.RuneFrame)\nend\n\nlocal function hideEvokerEssence()\n    hideAndBlockShow(_G.EssencePlayerFrame)\nend\n\nlocal function hideMageArcaneCharges()\n    hideAndBlockShow(_G.MageArcaneChargesFrame)\nend\n\nlocal function hideShamanTotems()\n    hideAndBlockShow(_G.TotemFrame)\nend\n\nlocal function hidePaladinHolyPower()\n    hideAndBlockShow(_G.PaladinPowerBarFrame)\nend\n\nlocal function hideRogueComboPoints()\n    hideAndBlockShow(_G.RogueComboPointBarFrame)\nend\n\nlocal function hideShamanTotems()\n    hideAndBlockShow(_G.TotemFrame)\nend\n\nlocal function hideWarlockSoulShards()\n    hideAndBlockShow(_G.WarlockPowerFrame)\nend\n\n\n---=== UI HIDERS ===---\n\nlocal function hideLootWindow()\n    if isHideLootWindow then\n        hideAndBlockShow(LootFrame)\n    end\nend\n\nlocal function hideBagButtons()\n    if isHideBags then\n        local bagsFrames = {\n            _G.MainMenuBarBackpackButton,\n            _G.BagBarExpandToggle,\n            _G.CharacterReagentBag0Slot,\n            _G.CharacterBag0Slot,\n            _G.CharacterBag1Slot,\n            _G.CharacterBag2Slot,\n            _G.CharacterBag3Slot\n        }\n        for _, frame in ipairs(bagsFrames) do\n            hideAndBlockShow(frame)\n        end\n    end\nend\n\nlocal function hideRaidGroupIndicator()\n    if isHideRGroupId then\n        local groupIdFrame = safeIndex(\n            _G,\n            \"PlayerFrame\",\n            \"PlayerFrameContent\",\n            \"PlayerFrameContentContextual\",\n            \"GroupIndicator\"\n        )\n        hideAndBlockShow(groupIdFrame)\n    end\nend\n\nlocal function hideWidgetBelowMinimap()\n    if isWidgetBelowMinimap then\n        hideAndBlockShow(_G.UIWidgetBelowMinimapContainerFrame)\n    end\nend\n\n\nlocal function hideClassResources()\n    local playerClass = playerClassToken\n    \n    if playerClass == \"DRUID\" then\n        if isHideDruidCombo then\n            hideDruidComboPoints()\n        end\n        if isHideDruidTreants then\n            hideDruidTreants()\n        end\n    elseif playerClass == \"DEATHKNIGHT\" then\n        if isHideDkRunes then\n            hideDeathKnightRunes()\n        end\n    elseif playerClass == \"EVOKER\" then\n        if isHideEvokerEssence then\n            hideEvokerEssence()\n        end\n    elseif playerClass == \"MAGE\" then\n        if isHideMageArcane then\n            hideMageArcaneCharges()\n        end\n    elseif playerClass == \"PALADIN\" then\n        if isHidePaladinPower then\n            hidePaladinHolyPower()\n        end\n    elseif playerClass == \"ROGUE\" then\n        if isHideRogueCombo then\n            hideRogueComboPoints()\n        end\n    elseif playerClass == \"SHAMAN\" then\n        if isHideShamanTotems then\n            hideShamanTotems()\n        end\n    elseif playerClass == \"WARLOCK\" then\n        if isHideWarlockShards then\n            hideWarlockSoulShards()\n        end\n        \n        \n        \n    end\nend\n\nlocal function hideUiFrames()\n    hideLootWindow()\n    hideBagButtons()\n    hideRaidGroupIndicator()\n    hideClassResources()\n    hideWidgetBelowMinimap()\nend\n\n\n---=== APPLY AND REAPPLY AFTER DELAY ===---\n\nif InCombatLockdown() then\n    runAfterCombat(hideUiFrames)\nelse\n    hideUiFrames()\nend\n\nrunAfterDelay(reapplyDelay, function()\n        runAfterCombat(hideUiFrames)\nend)\n\nrunOnEvents(hideUiFrames)\n\n\n"
            }
        },
        ["displayIcon"] = "4622273",
        ["cooldown"] = true,
        ["authorOptions"] = {{
            ["type"] = "space",
            ["variableWidth"] = true,
            ["height"] = 1,
            ["useHeight"] = false,
            ["width"] = 2
        }, {
            ["fontSize"] = "large",
            ["type"] = "description",
            ["text"] = "Reapply Delay (seconds):",
            ["width"] = 2
        }, {
            ["softMin"] = 0.1,
            ["type"] = "range",
            ["step"] = 0.05,
            ["width"] = 1,
            ["min"] = 0,
            ["name"] = "",
            ["softMax"] = 5,
            ["default"] = 0.5,
            ["key"] = "reapply_delay"
        }, {
            ["type"] = "space",
            ["variableWidth"] = true,
            ["height"] = 1,
            ["width"] = 2,
            ["useHeight"] = false
        }, {
            ["type"] = "description",
            ["fontSize"] = "small",
            ["text"] = "Some UI elements are re-created by Blizzard shortly after login, spec change, or reload. This delay makes the WeakAura run its hiding code again after a short wait to catch those late-loading elements.",
            ["width"] = 2
        }, {
            ["fontSize"] = "small",
            ["type"] = "description",
            ["text"] = "- Keep it at 0.5 unless you notice UI elements reappearing.\n- Increase it if some frames are still showing after reload.\n- Setting it to 0 disables the second pass.",
            ["width"] = 2
        }, {
            ["type"] = "header",
            ["useName"] = false,
            ["text"] = "",
            ["width"] = 1
        }, {
            ["type"] = "description",
            ["fontSize"] = "large",
            ["text"] = "Select which UI elements to hide:\n",
            ["width"] = 2
        }, {
            ["type"] = "space",
            ["variableWidth"] = true,
            ["height"] = 1,
            ["width"] = 2,
            ["useHeight"] = false
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_loot_window",
            ["useDesc"] = false,
            ["default"] = false,
            ["name"] = "Loot Window",
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_bags",
            ["useDesc"] = false,
            ["default"] = false,
            ["name"] = "Bags",
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_rgroup_id",
            ["useDesc"] = false,
            ["default"] = false,
            ["name"] = "Raid Group Indicator",
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["useDesc"] = false,
            ["key"] = "hide_below_mini",
            ["name"] = "Widget Below Minimap",
            ["default"] = false,
            ["width"] = 1
        }, {
            ["type"] = "header",
            ["useName"] = false,
            ["text"] = "",
            ["width"] = 1
        }, {
            ["type"] = "space",
            ["variableWidth"] = true,
            ["height"] = 1,
            ["width"] = 2,
            ["useHeight"] = false
        }, {
            ["type"] = "description",
            ["fontSize"] = "large",
            ["text"] = "Select which class resources to hide:",
            ["width"] = 2
        }, {
            ["type"] = "space",
            ["variableWidth"] = true,
            ["height"] = 1,
            ["width"] = 2,
            ["useHeight"] = false
        }, {
            ["type"] = "toggle",
            ["useDesc"] = false,
            ["key"] = "hide_dk_runes",
            ["name"] = "Death Knight Runes",
            ["default"] = false,
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_druid_combo",
            ["useDesc"] = false,
            ["name"] = "Druid Combo Points",
            ["default"] = false,
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["useDesc"] = false,
            ["key"] = "hide_druid_treants",
            ["default"] = false,
            ["name"] = "Druid Treants",
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_evoker_essence",
            ["useDesc"] = false,
            ["default"] = false,
            ["name"] = "Evoker Essence",
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["useDesc"] = false,
            ["key"] = "hide_mage_arcane",
            ["name"] = "Mage Arcane Charges",
            ["default"] = false,
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_paladin_power",
            ["width"] = 1,
            ["default"] = false,
            ["name"] = "Paladin Holy Power",
            ["useDesc"] = false,
            ["desc"] = ""
        }, {
            ["type"] = "toggle",
            ["useDesc"] = false,
            ["key"] = "hide_rogue_combo",
            ["default"] = false,
            ["name"] = "Rogue Combo Points",
            ["width"] = 1
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_shaman_totems",
            ["width"] = 1,
            ["default"] = false,
            ["name"] = "Shaman Totems",
            ["useDesc"] = false,
            ["desc"] = ""
        }, {
            ["type"] = "toggle",
            ["key"] = "hide_warlock_shards",
            ["desc"] = "",
            ["useDesc"] = false,
            ["name"] = "Warlock Soul Shards",
            ["default"] = false,
            ["width"] = 1
        }, {
            ["type"] = "space",
            ["variableWidth"] = true,
            ["height"] = 1,
            ["useHeight"] = false,
            ["width"] = 1
        }}
    }
}
