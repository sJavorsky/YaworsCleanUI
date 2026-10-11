local module = {}
YaworsCleanUI.FilterChat = module
YaworsCleanUI.registerModule(module)

-- Casts that produce learn/unlearn system spam: 200749 = single talent change,
-- 384255 = loadout swap
local TALENT_SWITCH_SPELL_IDS = {
    [200749] = true,
    [384255] = true,
}

-- GUID of the cast we are currently tracking; nil when not in a talent switch cast
local trackedCastGUID = nil
-- Removes the filter a short beat after the cast ends (trailing spam)
local removeTimer = nil
-- Force-removes the filter if the cast's end event is somehow never seen
local safetyTimer = nil
local talentSpamFrame = nil

-- Converts a Blizzard format string (e.g. "You have learned %s.") into a Lua pattern
local function formatToPattern(formatString)
    if type(formatString) ~= "string" then return nil end
    local pattern = formatString:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
    pattern = pattern:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
    return "^" .. pattern .. "$"
end

local talentSpamPatterns = {}

local function buildTalentSpamPatterns()
    local keys = {
        "ERR_LEARN_SPELL_S",
        "ERR_LEARN_ABILITY_S",
        "ERR_LEARN_PASSIVE_S",
        "ERR_SPELL_UNLEARNED_S",
        "ERR_PET_LEARN_SPELL_S",
        "ERR_PET_LEARN_ABILITY_S",
        "ERR_PET_SPELL_UNLEARNED_S",
    }
    for _, key in ipairs(keys) do
        local pattern = formatToPattern(_G[key])
        if pattern then
            talentSpamPatterns[#talentSpamPatterns + 1] = pattern
        end
    end
end

local talentSpamFilterFunc = nil

local function installTalentSpamFilter()
    if talentSpamFilterFunc then return end
    talentSpamFilterFunc = function(_, _, message)
        if type(message) ~= "string" then return false end
        for i = 1, #talentSpamPatterns do
            if message:match(talentSpamPatterns[i]) then
                return true
            end
        end
        return false
    end
    -- ChatFrame_AddMessageEventFilter intercepts CHAT_MSG_SYSTEM before display;
    -- returning true from the callback suppresses the message
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", talentSpamFilterFunc)
end

local function removeTalentSpamFilter()
    if talentSpamFilterFunc then
        ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", talentSpamFilterFunc)
        talentSpamFilterFunc = nil
    end
end

local function clearTimers()
    if removeTimer then
        removeTimer:Cancel()
        removeTimer = nil
    end
    if safetyTimer then
        safetyTimer:Cancel()
        safetyTimer = nil
    end
end

local function createTalentSpamFrame()
    talentSpamFrame = CreateFrame("Frame")
    talentSpamFrame:SetScript("OnEvent", function(self, event, unitTarget, castGUID, spellID)
        if event == "UNIT_SPELLCAST_START" then
            if not TALENT_SWITCH_SPELL_IDS[spellID] then return end

            trackedCastGUID = castGUID
            clearTimers()
            -- Keep the filter open for the entire cast; the learn/unlearn spam
            -- fires as the cast resolves, and its exact timing varies per cast
            installTalentSpamFilter()
            -- Failsafe in case the cast-end event never arrives (e.g. zoning)
            safetyTimer = C_Timer.NewTimer(15, function()
                safetyTimer = nil
                trackedCastGUID = nil
                removeTalentSpamFilter()
            end)

        elseif event == "UNIT_SPELLCAST_STOP"
            or event == "UNIT_SPELLCAST_CHANNEL_STOP"
            or event == "UNIT_SPELLCAST_INTERRUPTED" then
            if castGUID ~= trackedCastGUID then return end

            trackedCastGUID = nil
            clearTimers()
            -- Spam can trail the cast's end by a few frames, so hold briefly
            removeTimer = C_Timer.NewTimer(0.5, function()
                removeTimer = nil
                removeTalentSpamFilter()
            end)
        end
    end)
end

local function enableTalentSpamFiltering()
    if not talentSpamFrame then
        createTalentSpamFrame()
    end
    talentSpamFrame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
    talentSpamFrame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
    talentSpamFrame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
    talentSpamFrame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
end

local function disableTalentSpamFiltering()
    if not talentSpamFrame then return end
    talentSpamFrame:UnregisterEvent("UNIT_SPELLCAST_START")
    talentSpamFrame:UnregisterEvent("UNIT_SPELLCAST_STOP")
    talentSpamFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    talentSpamFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    trackedCastGUID = nil
    clearTimers()
    removeTalentSpamFilter()
end

function module.applySettings()
    if YaworsCleanUIDB.filterChat.talentSpam then
        enableTalentSpamFiltering()
    else
        disableTalentSpamFiltering()
    end
end

function module.init()
    buildTalentSpamPatterns()
    module.applySettings()
end
