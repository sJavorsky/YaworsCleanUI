# Yawor's Clean UI

Get your ultimate UI-altering addon!



#### Highly praised by ruthless critics:

>*"From what I've seen today, Yawor's UI was the least worst."*
>
> — Grim

#### Loved by addon enthusiasts:

>*"It's in my top 3 addons!"*
>
> — our lovely healer Nikaia



fr... This is primarily a private addon aiming to fill the void (pun intended) left after Blizzard's addon purge in Midnight. With them also went WeakAuras, around which I created my whole combat UI. Besides that, it may provide some useful tweaks for anyone.



## Features

Each feature can be applied separately. Open **Interface Options → AddOns → YaworsCleanUI**. Changes apply instantly, no reload needed.

\<AI generated overview>

#### Hide UI elements

- **Hide loot window** — suppresses the loot frame each time it would open
- **Hide bag icons** — hides the backpack button and all bag slots from the bag bar
- **Hide group indicator** — hides the role/leader indicator on the player frame

#### Move UI elements

- **Queue eye** — moves the queue status eye onto the minimap, positioned by distance from center and angle, with a preview circle for exact placement
- **Battle.net toast** — moves the Battle.net toast popup anywhere on screen, with a preview box for exact placement

#### Filter chat

- **Mute talent swap spam** — suppresses the "You have learned/unlearned" flood when switching talent loadouts

#### Points class resources

- **Move point resources to screen center** — Death Knight Runes, Druid and Rogue Combo Points, Evoker Essence, Monk Chi, Warlock Soul Shards, Mage Arcane Charges, Paladin Holy Power
- One switch for all, shared offset and scale, each resource toggled separately

#### Bars class resources

- **Custom center-screen bars** — Death Knight Runic Power, Druid Energy / Rage / Astral Power, Evoker Ebon Might, Demon Hunter Fury and Soul Fragments, Hunter Focus, Monk Energy, Priest Insanity, Rogue Energy, Shaman Maelstrom, Warrior Rage
- **Fancy textures** — spec-flavored fill textures for the bars that have them
- One switch for all, shared offset and scale, each bar toggled separately, spec- and form-aware

#### Player position

- **Position cross** — marks your character's position at screen center
- Configurable size, thickness, inner and border color; optionally combat-only
- Dynamic position follows the camera zoom and hides when zoomed in too close; manual position sits at a fixed offset

#### Cursor position

- **Position circle** — a single-color or two-tone ring that follows the cursor
- **Radial trackers** — optional outer and inner rings that fill for your spell cast or the global cooldown
- Configurable size, ring widths and colors; tracker preview for setup; optionally combat-only

\</AI generated overview>



## Q&A:

**Q:** Why "clean" when it's a total mess?

**A:** It started as a small addon replacing WA functionalities, specifically hiding the loot window and bag menu. That was all.

**Q:** Is this another AI slop addon?

**A:** Yes and no. Although the addon is openly written with Claude Code, part of the codebase originated from my WeakAuras, which were handwritten. I do understand the addon's code (except some math stuff where I have no idea what is being calculated) and even applied some optimisations.

**Q:** Some configuration ranges are quite silly.

**A:** Not a question, but yes. I prefer customisation over limited options.

**Q:** Will it ever be renamed to "aaa Yawor's Clean UI" so it's not at the bottom of the settings, under the huge pile of addons I have installed?

**A:** No. You should just install the addon and use the defaults, because that's what I'm using and it's the best way to use this addon.

**Q:** How many addons does Nikaia have?

**A:** Three. Why are you asking?



## Recommended Addons

Having this addon is not enough to reach an enlightened UI. I also recommend installing:
- [Mouseover Action Settings - Automatic UI Fader - Mouseover Everything](https://www.curseforge.com/wow/addons/mouseover-action-settings-automtic-ui-fader)
- [LS: Toasts](https://www.curseforge.com/wow/addons/ls-toasts)
- [Dialogue UI](https://www.curseforge.com/wow/addons/dialogueui) or...
- ...or [Immersion](https://www.curseforge.com/wow/addons/immersion)
- [HidingBar](https://www.curseforge.com/wow/addons/hidingbar)
- [Cleaner Loot Messages](https://www.curseforge.com/wow/addons/cleanerlootmessages)

And for better gameplay:
- anything or everything from [plusmouse](https://www.curseforge.com/members/plusmouse)
- [OPie](https://www.curseforge.com/wow/addons/opie)
- [Plumber](https://www.curseforge.com/wow/addons/plumber)
- [Titan Panel](https://www.curseforge.com/wow/addons/titan-panel)



## References

I worked with the codebases of these addons:
- [SenseiClassResourceBar](https://www.curseforge.com/wow/addons/senseiclassresourcebar) (MIT) - power type names and API usage
- [MoveAnything](https://www.curseforge.com/wow/addons/move-anything) - reference for frame position persistence
- [Auctionator](https://www.curseforge.com/wow/addons/auctionator) - categories structure in settings
- [NeedToKnow](https://www.curseforge.com/wow/addons/need-to-know) (GPLv3) - color picking implementation

Inspiration taken from WAs:
- [Character Position](https://wago.io/aiBdawlHy)
- [Ultimate Mouse Cursor](https://wago.io/ZbjlsgMkp)
- [Frogski's mouse fire trail](https://wago.io/RzZVq4F1a)
- [Simple Combo Points and Energy Bar](https://wago.io/yn2XaJbM8)
- [Evoker Essences](https://wago.io/YG8xiHgZP)
- [Mori Runes](https://wago.io/3aOJocMuY)
- [FeverHUD :: Warlock :: Straight Shards](https://wago.io/3xMSoa8Zs)
- [FeverHUD :: Paladin :: Holy Power](https://wago.io/4vBgCAFEo)
- [FeverHUD :: Mage :: Arcane Charges New Style](https://wago.io/rlN7pUObv)
- [!SpizyPie - Combo Points](https://wago.io/YOZFYEIiK)



## Authorship

The codebase was written by Anthropic's [Claude](https://claude.ai) under Yawor's supervision and direction.
