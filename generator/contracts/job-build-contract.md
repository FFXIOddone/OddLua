# OddLua Job Build Contract

OddLua packs are Smart Gear Swap Profiles wrapped as a Playstyle Swapper. A pack should feel like one maintained job profile, not five unrelated gear files.

Every generated job pack exposes the same five playstyles:

- `Melt`: default raw kill-speed mode. This is the normal combat baseline.
- `Dagger`: weapon-family or skill mode. For THF, this keeps dagger-family weapons selected for dagger skill and dagger weapon skills.
- `Safe`: survival mode. This prefers defensive, evasion, or safer combat pieces without using non-combat filler.
- `Treasure`: Treasure Hunter, proc, or farming marker mode. If no useful eligible Treasure gear exists, it preserves the `Melt` set instead of making the character weaker.
- `Craft`: non-combat crafting utility mode. It is blocked while engaged and must not leak into combat sets.

The standard LuAshitacast command surface is:

```text
/lac fwd style
/lac fwd style melt
/lac fwd style dagger
/lac fwd style safe
/lac fwd style treasure
/lac fwd style craft
/lac fwd status
```

Combat playstyles must reject fishing, crafting, travel, experience-bonus, cosmetic, wrong-job, wrong-level, and wrong-weapon-family fallbacks. That rule matters more than filling every slot. An empty slot is safer than silently equipping a lure, rod, warp ring, or level-ineligible item.

Task 4 only builds into `OddLua/dist`. It does not copy profiles into the live Catseye install.
