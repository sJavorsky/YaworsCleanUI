local category = YaworsCleanUI.settingsCategories.hide
local addCheckbox = YaworsCleanUI.addCheckbox

addCheckbox(category, "hideElements", "looting", "Hide looting window", "Hides the loot frame when looting.", function()
    YaworsCleanUI.HideElements.applySettings()
end)
addCheckbox(category, "hideElements", "bags", "Hide bag icons", "Hides the bag bar icons.", function()
    YaworsCleanUI.HideElements.applySettings()
end)
