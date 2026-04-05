---=== CONFIG ===---

local isDebug = false

local config = aura_env.config or {}

local isFilterLearnedSpells = (config.filter_learned_spells == true)
local isFilterUnlearnedSpells = (config.filter_unlearned_spells == true)
local isFilterPetSpells = (config.filter_pet_spells == true)
local isFilterNoPlayer = (config.filter_no_player == true)
local isFilterPlayerInactive = (config.filter_player_inactive == true)

-- "Auction created." is somehow posted directly to chat and cant be intercepted
-- local isFilterAuctionCreated = (config.filter_auction_created == true)


---=== UTILS ===---

local function debugOut(text)
        if isDebug then
            local f = _G.DEFAULT_CHAT_FRAME or _G.ChatFrame1
            if f and type(text) == "string" then
                f:AddMessage("|cff88ff88CleanUI|r " .. text)
        end
    end
end

local function formatToPattern(formatString)
        if type(formatString) ~= "string" then
            return nil
    end
    -- escape Lua pattern specials EXCEPT '%'
    local pattern = formatString:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
    -- convert Blizzard placeholders for text and digit
    pattern = pattern:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
    return "^" .. pattern .. "$"
end

local function addPatternByKey(destination, globalKey)
        local formatString = globalKey and _G[globalKey]
        if type(formatString) == "string" then
            local pattern = formatToPattern(formatString)
            if pattern then
                destination[#destination + 1] = { pattern = pattern, source = globalKey }
        end
    end
end

local function addLiteral(destination, pattern, label)
        destination[#destination + 1] = { pattern = pattern, source = (label .. "_LITERAL") }
end
    
    
    ---=== PATTERN BUILD ===---
    
    -- based on: https://wowpedia.fandom.com/wiki/UI_INFO_MESSAGE
    
    local function buildRules()
        local rules = {}
        
        if isFilterLearnedSpells then
            addPatternByKey(rules, "ERR_LEARN_SPELL_S")
            addPatternByKey(rules, "ERR_LEARN_ABILITY_S")
            addPatternByKey(rules, "ERR_LEARN_PASSIVE_S")
    end
    
    if isFilterUnlearnedSpells then
            addPatternByKey(rules, "ERR_SPELL_UNLEARNED_S")
    end
    
    if isFilterPetSpells then
            addPatternByKey(rules, "ERR_PET_LEARN_SPELL_S")
            addPatternByKey(rules, "ERR_PET_LEARN_ABILITY_S")
            addPatternByKey(rules, "ERR_PET_SPELL_UNLEARNED_S")
    end
    
    if isFilterNoPlayer then
            addPatternByKey(rules, "ERR_CHAT_PLAYER_NOT_FOUND_S")
    end
    
    if isFilterPlayerInactive then
            addPatternByKey(rules, "^You have been inactive for some time and will be logged out of the game%. If you wish to remain logged in, hit the cancel button%.$", "PLAYER_INACTIVE"
            )
    end
    
    -- if isFilterAuctionCreated then
        --     addPatternByKey(rules, "ERR_AUCTION_STARTED")
        --     addLiteral(rules, "^Auction created%.?%s*$", "AUCTION_CREATED")
        -- end
    
    return rules
end


---=== FILTER ===---

-- Extracted matcher: returns true to block, false to allow
local function shouldFilterSystemMessage(message)
        if type(message) ~= "string" then
            return false
    end
    local rules = _G.__YAWOR_SYSMSG_FILTER.rules or {}
    for i = 1, #rules do
            local rule = rules[i]
            if message:match(rule.pattern) then
                debugOut(("Filtered [%s]: %s"):format(rule.source or "?", message))
                return true
        end
    end
    return false
end


---=== GLOBAL STATE & (RE)REGISTRATION ===---

_G.__YAWOR_SYSMSG_FILTER = _G.__YAWOR_SYSMSG_FILTER or {}

-- Unhook old function if installed
    if _G.__YAWOR_SYSMSG_FILTER.installed and _G.__YAWOR_SYSMSG_FILTER.func then
        ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", _G.__YAWOR_SYSMSG_FILTER.func)
        _G.__YAWOR_SYSMSG_FILTER.installed = false
end
    
    -- Build fresh rules
    _G.__YAWOR_SYSMSG_FILTER.rules = buildRules()
    
    -- Assign chat filter
    _G.__YAWOR_SYSMSG_FILTER.func = function(_, _, message)
        return shouldFilterSystemMessage(message)
end
    
    -- Re-hook if there are any rules
    if #_G.__YAWOR_SYSMSG_FILTER.rules > 0 then
        ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", _G.__YAWOR_SYSMSG_FILTER.func)
        _G.__YAWOR_SYSMSG_FILTER.installed = true
end
    
    
    