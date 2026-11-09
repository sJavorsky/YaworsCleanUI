local Utils = {}
YaworsCleanUI.Utils = Utils

-- Blizzard's role token is only "DAMAGER", so range is told apart by spec ID
local RANGE_DAMAGE_SPEC_IDS = {
    62, 63, 64,    -- Mage: Arcane, Fire, Frost
    102,           -- Druid: Balance
    253, 254,      -- Hunter: Beast Mastery, Marksmanship
    258,           -- Priest: Shadow
    262,           -- Shaman: Elemental
    265, 266, 267, -- Warlock: Affliction, Demonology, Destruction
    1467, 1473,    -- Evoker: Devastation, Augmentation
    1480,          -- Demon Hunter: Devourer
}

-- Used before a character has chosen a spec. Mixed classes follow their starting playstyle.
local NEW_CHARACTER_SPEC_INDEX = 5
local RANGE_CLASSES = {"DRUID", "EVOKER", "HUNTER", "MAGE", "PRIEST", "SHAMAN", "WARLOCK"}

-- Returns "melee", "range", "tank" or "healer"
function Utils.getPlayerRole()
    -- GetSpecialization returns the active spec's index, nil when none is learned
    -- and 5 for newly created characters
    local specIndex = C_SpecializationInfo.GetSpecialization()
    if not specIndex or specIndex == NEW_CHARACTER_SPEC_INDEX then
        -- UnitClassBase returns the locale-independent class token, e.g. "DRUID"
        return tContains(RANGE_CLASSES, UnitClassBase("player")) and "range" or "melee"
    end
    -- Returns specID first and the role token ("DAMAGER", "TANK" or "HEALER") fifth
    local specID, _, _, _, role = C_SpecializationInfo.GetSpecializationInfo(specIndex)
    if role == "TANK" or role == "HEALER" then
        return role:lower()
    end
    return tContains(RANGE_DAMAGE_SPEC_IDS, specID) and "range" or "melee"
end
