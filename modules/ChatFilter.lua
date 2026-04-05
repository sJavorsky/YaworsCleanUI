local module = {}
YaworsCleanUI.ChatFilter = module
YaworsCleanUI.registerModule(module)

local TALENT_SWITCH_SPELL_ID = 200749

-- GUID of the cast we are currently tracking; nil when not in a talent switch cast
local trackedCastGUID = nil
local timer = nil

-- Converts a Blizzard format string (e.g. "You have learned %s.") into a Lua pattern
local function formatToPattern(formatString)
    if type(formatString) ~= "string" then return nil end
    local pattern = formatString:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
    pattern = pattern:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
    return "^" .. pattern .. "$"
end

local filterPatterns = {}

local function buildPatterns()
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
            filterPatterns[#filterPatterns + 1] = pattern
        end
    end
end

local filterFunc = nil

local function installFilter()
    filterFunc = function(_, _, message)
        if type(message) ~= "string" then return false end
        for i = 1, #filterPatterns do
            if message:match(filterPatterns[i]) then
                return true
            end
        end
        return false
    end
    -- ChatFrame_AddMessageEventFilter intercepts CHAT_MSG_SYSTEM before display;
    -- returning true from the callback suppresses the message
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterFunc)
end

local function removeFilter()
    if filterFunc then
        ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", filterFunc)
        filterFunc = nil
    end
end

function module.applySettings()
    -- Nothing to apply immediately; the event listener reads the setting live
end

function module.init()
    buildPatterns()

    local eventFrame = CreateFrame("Frame")
    -- RegisterUnitEvent limits delivery to events for the specified unit,
    -- avoiding spurious fires from other players' casts
    eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
    eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")

    eventFrame:SetScript("OnEvent", function(self, event, unitTarget, castGUID, spellID)
        if not YaworsCleanUIDB.filterChat.talentSpam then return end

        if event == "UNIT_SPELLCAST_START" then
            if spellID ~= TALENT_SWITCH_SPELL_ID then return end

            trackedCastGUID = castGUID

            timer = C_Timer.NewTimer(4.9, function()
                timer = nil
                installFilter()
                C_Timer.After(0.2, function()
                    removeFilter()
                end)
            end)

        elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
            if castGUID ~= trackedCastGUID then return end
            trackedCastGUID = nil

            if timer then
                timer:Cancel()
                timer = nil
            end
        end
    end)
end
