local Migrations = {}
YaworsCleanUI.Migrations = Migrations

-- Add an entry when a release renames or reshapes saved settings, keyed by that
-- release's version and kept in ascending order. New keys alone need no entry;
-- applyDefaults fills them in. Each migrate upgrades a save to its own version.
local MIGRATIONS = {
    {
        version = "1.1.0",
        migrate = function(database)
            -- Player Position: the Manual offset checkbox became the Position dropdown
            local playerPosition = database.playerPosition
            if playerPosition and playerPosition.manualOffset ~= nil then
                playerPosition.positionMode = playerPosition.manualOffset and "manual" or "dynamic"
                playerPosition.manualOffset = nil
            end

            -- Preview checkboxes became buttons, so their state is no longer saved
            if database.moveElements then
                database.moveElements.toastPreview = nil
                database.moveElements.eyePreview = nil
            end
            if database.cursorPosition then
                database.cursorPosition.previewTrackers = nil
            end
        end,
    },
}

Migrations.SETTINGS_VERSION = MIGRATIONS[#MIGRATIONS].version

local function isNewerVersion(version, baselineVersion)
    local parts = { strsplit(".", version) }
    local baselineParts = { strsplit(".", baselineVersion) }
    for i = 1, math.max(#parts, #baselineParts) do
        local part = tonumber(parts[i]) or 0
        local baselinePart = tonumber(baselineParts[i]) or 0
        if part ~= baselinePart then
            return part > baselinePart
        end
    end
    return false
end

function Migrations.migrate(database)
    -- Saves from before versioning have no version and predate every migration
    local savedVersion = database.settingsVersion or "0.0.0"
    for _, migration in ipairs(MIGRATIONS) do
        if isNewerVersion(migration.version, savedVersion) then
            migration.migrate(database)
            savedVersion = migration.version
            database.settingsVersion = savedVersion
        end
    end
end
