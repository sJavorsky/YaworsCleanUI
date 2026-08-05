local category = YaworsCleanUI.settingsCategories.points
local addCheckbox = YaworsCleanUI.addCheckbox
local addSlider = YaworsCleanUI.addSlider

local screenHeightHalf = math.floor(GetScreenHeight()*0.75)
local screenWidthHalf = math.floor(GetScreenWidth()*0.75)

local function apply()
    YaworsCleanUI.ClassResourcePoints.applySettings()
end

addSlider(category, "classResourcePoints", "offsetY",
    "Vertical offset", "Vertical offset for class resource frames.",
    -screenHeightHalf, screenHeightHalf, apply)
addSlider(category, "classResourcePoints", "offsetX",
    "Horizontal offset", "Horizontal offset for class resource frames.",
    -screenWidthHalf, screenWidthHalf, apply)
addSlider(category, "classResourcePoints", "scale",
    "Scale", "Scale of class resource frames (percentage).",
    1, 1000, apply)

addCheckbox(category, "classResourcePoints", "deathKnightRunes",
    "Death Knight Runes", "Move the Death Knight Runes to the center of the screen.", apply)
addCheckbox(category, "classResourcePoints", "druidComboPoints",
    "Druid Combo Points", "Move the Druid combo points bar to the center of the screen.", apply)
addCheckbox(category, "classResourcePoints", "evokerEssence",
    "Evoker Essence", "Move the Evoker Essence to the center of the screen.", apply)
addCheckbox(category, "classResourcePoints", "rogueComboPoints",
    "Rogue Combo Points", "Move the Rogue combo points bar to the center of the screen.", apply)
addCheckbox(category, "classResourcePoints", "monkChi",
    "Monk Chi", "Move the Monk Chi bar to the center of the screen (Windwalker only).", apply)
addCheckbox(category, "classResourcePoints", "warlockSoulShards",
    "Warlock Soul Shards", "Move the Warlock Soul Shards to the center of the screen.", apply)
addCheckbox(category, "classResourcePoints", "mageArcaneCharges",
    "Mage Arcane Charges", "Move the Mage Arcane Charges to the center of the screen (Arcane only).", apply)
addCheckbox(category, "classResourcePoints", "paladinHolyPower",
    "Paladin Holy Power", "Move the Paladin Holy Power to the center of the screen.", apply)
