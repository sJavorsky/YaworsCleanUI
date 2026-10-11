local category = YaworsCleanUI.settingsCategories.chat
local addCheckbox = YaworsCleanUI.addCheckbox

addCheckbox(category, "filterChat", "talentSpam",
    "Mute talent swap spam",
    "Suppresses the 'You have learned/unlearned' chat spam when switching talent loadouts.",
    function()
        YaworsCleanUI.FilterChat.applySettings()
    end
)
