# All Job Contract Matrix

OddLua supports all 22 current job abbreviations:

`WAR MNK WHM BLM RDM THF PLD DRK BST BRD RNG SAM NIN DRG SMN BLU COR PUP DNC SCH GEO RUN`

Generated packs remain snapshot-gated. A job contract can exist even when the current character snapshot reports that job as level 0, but OddLua will not generate a personalized pack for level 0 because job and level eligibility would be false.

## Style Matrix

- WAR: `Damage`, `Accuracy`, `WeaponSkill`, `Survival`
- MNK: `Damage`, `Accuracy`, `WeaponSkill`, `Evasion`
- WHM: `Cure`, `FastCast`, `IdleRefresh`, `Damage`
- BLM: `Nuke`, `MagicAccuracy`, `FastCast`, `IdleRefresh`
- RDM: `Enspell`, `MagicAccuracy`, `FastCast`, `Cure`
- THF: `Melt`, `Dagger`, `Safe`, `Treasure`, `Craft`
- PLD: `Tank`, `Enmity`, `Damage`, `MagicDefense`
- DRK: `Damage`, `Accuracy`, `WeaponSkill`, `DrainAbsorb`
- BST: `Damage`, `Accuracy`, `PetDamage`, `PetTank`
- BRD: `Song`, `FastCast`, `MagicAccuracy`, `IdleRefresh`
- RNG: `RangedDamage`, `RangedAccuracy`, `WeaponSkill`, `Evasion`
- SAM: `StoreTP`, `Accuracy`, `WeaponSkill`, `Evasion`
- NIN: `Damage`, `Accuracy`, `Evasion`, `Ninjutsu`
- DRG: `Damage`, `Accuracy`, `WeaponSkill`, `Jump`
- SMN: `AvatarPerp`, `BloodPact`, `SummoningMagic`, `IdleRefresh`
- BLU: `PhysicalBlue`, `MagicalBlue`, `FastCast`, `Accuracy`
- COR: `RangedDamage`, `RangedAccuracy`, `QuickDraw`, `Roll`
- PUP: `Damage`, `Accuracy`, `PetDamage`, `PetTank`
- DNC: `Damage`, `Accuracy`, `Waltz`, `Evasion`
- SCH: `Nuke`, `MagicAccuracy`, `FastCast`, `IdleRefresh`
- GEO: `GeoMagic`, `Nuke`, `FastCast`, `IdleRefresh`
- RUN: `Tank`, `MagicDefense`, `Damage`, `Enmity`

## Current Snapshot Coverage

The current Aahtacos and Oddone snapshots generate packs for every positive-level job they contain. The only contract-only jobs across those two snapshots are `RNG`, `DRG`, and `RUN`, because both snapshots report those jobs as level 0.
