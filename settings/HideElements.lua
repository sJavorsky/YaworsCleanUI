local category = YaworsCleanUI.addCategory("Hide UI elements")
local addCheckbox = YaworsCleanUI.addCheckbox

local function apply()
    YaworsCleanUI.HideElements.applySettings()
end

addCheckbox(category, "hideElements", "looting", "Hide looting window", "Hides the loot frame when looting.", apply)
addCheckbox(category, "hideElements", "bags", "Hide bag icons", "Hides the bag bar icons.", apply)
if YaworsCleanUI.isRetail then
    addCheckbox(category, "hideElements", "groupIndicator", "Hide group indicator", "Hides the group role/leader indicator on the player frame.", apply)
end
