# Aahtacos 30102 THF Reference Pack

Build the current Aahtacos THF pack from the live Catseye gearexport data:

```powershell
powershell -ExecutionPolicy Bypass -File .\OddLua\Build-OddLuaPack.ps1
```

The wrapper defaults to:

- Player: `Aahtacos`
- Player ID: `30102`
- Job: `THF`
- Gear export: `C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport\Aahtacos_30102_gear.lua`
- Character snapshot: `C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport\Aahtacos_30102\Aahtacos_30102_character.json`
- Output root: `OddLua\dist`

Generated files land under:

```text
OddLua\dist\packs\Aahtacos_30102\THF\
```

This command does not copy anything into the live Catseye install. The generated profile exposes the standard OddLua playstyles: `Melt`, `Dagger`, `Safe`, `Treasure`, and `Craft`.
