local profile = {};
profile.OddLuaBuildToken = 'A3E6689C3ECE24D617142A7993EE5EA03FDDC6F335676D017BCEF64662AE45EE';


local state = {
    Playstyle = 'GeoMagic',
    IdleOverrideSet = nil,
    IdleMaxMPThreshold = 0,
    IdleMaxMPAdd = 0,
    IdleMaxHPThreshold = 0,
    IdleMaxHPAdd = 0,
    EmergencyHpActive = false,
    IdleMaxMPActive = false,
    IdleMaxHPActive = false,
    NumberRowPaletteEnabled = true,
    WarpRingLocked = false,
    PetActionPin = nil,
    LastEquippedSetName = nil,
    ActiveConditionalOverlaySlots = {},
    SecondarySlotLocks = {},
    SecondarySlotLockContextSetNames = nil,
    MechanicsProbes = false,
    MechanicsExecution = false,
    HpToMpBridgeInFlight = false,
    ReconcileEnabled = true,
    BuffItemOverlaysEnabled = true,
    ReconcileSnapshotSeq = 0,
    ReconcileCycleSeq = 0,
    ReconcilePendingSnapshot = nil,
    ReconcileScanScheduled = false,
    ReconcileScanToken = 0,
    ReconcileLastRecordedSignature = nil,
    ReconcileLast = nil,
    ReconcileCompositionActive = false,
    ReconcileCompositionPending = nil,
    ReconcileLogDirectoryReady = false,
    ReconcileLastWriteError = nil,
    StableEquipForcePending = false,
    OddLuaRefreshPending = false,
    OddLuaRefreshLastStatus = 'none',
    MagicBurstMode = false,




    ExplicitGearMode = 'off',
    ExplicitGearModeDefaultRouting = false,

};

local sets = {
    Playstyle_GeoMagic = {
        Main = 'Kirin\'s Pole',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Snow Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Playstyle_Nuke = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Playstyle_FastCast = {
        Ear1 = 'Loquac. Earring',
        Back = 'Swith Cape',
    },

    Playstyle_IdleRefresh = {
        Main = 'Numen Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Body = 'Oracle\'s Robe',
        Hands = 'Bagua Mitaines',
        Back = 'Intensifying Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Oracle\'s Pigaches',
    },

    GeoMagic = {
        Main = 'Kirin\'s Pole',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Snow Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Nuke = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    FastCast = {
        Ear1 = 'Loquac. Earring',
        Back = 'Swith Cape',
    },

    IdleRefresh = {
        Main = 'Numen Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Body = 'Oracle\'s Robe',
        Hands = 'Bagua Mitaines',
        Back = 'Intensifying Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Oracle\'s Pigaches',
    },

    Idle = {
        Main = 'Numen Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Relaxing Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Bagua Mitaines',
        Ring1 = 'Shadow Ring',
        Ring2 = 'Alert Ring',
        Back = 'Intensifying Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Oracle\'s Pigaches',
    },

    IdleCity = {
        Main = 'Numen Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Body = 'Kupo Suit',
        Hands = 'Bagua Mitaines',
        Back = 'Intensifying Cape',
        Waist = 'Hierarch Belt',
        Legs = 'remove',
        Feet = 'Oracle\'s Pigaches',
    },

    IdleCombat = {
        Main = 'Terra\'s Staff',
        Sub = 'Raptor Strap +1',
        Head = 'Walahra Turban',
        Neck = 'Bird Whistle',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Succor Ring',
        Ring2 = 'Corneus Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Creek M Clomps',
    },

    IdleMaxMP = {
        Head = 'Faerie Hairpin',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Oracle\'s Gloves',
        Ring1 = 'Succor Ring',
        Ring2 = 'Mana Ring',
        Back = 'Intensifying Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Oracle\'s Pigaches',
    },

    IdleMaxHP = {
        Head = 'Walahra Turban',
        Neck = 'Bird Whistle',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Leather Ring',
        Ring2 = 'Corneus Ring',
        Back = 'Intensifying Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Creek M Clomps',
    },

    IdleNonCombat = {
        Main = 'Numen Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Body = 'Oracle\'s Robe',
        Hands = 'Bagua Mitaines',
        Back = 'Intensifying Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Oracle\'s Pigaches',
    },

    Resting = {
        Main = 'Numen Staff',
        Ammo = 'Mana Ampulla',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Ear1 = 'Relaxing Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Oracle\'s Gloves',
        Back = 'Invigorating Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Avocat Pigaches',
    },

    InCity = {
        Body = 'Kupo Suit',
        Legs = 'remove',
    },

    Movement = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Movement_City = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Movement_Night = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Movement_DuskToDawn = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Aftercast = {
        Main = 'Numen Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Oracle\'s Cap',
        Neck = 'Beak Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Relaxing Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Bagua Mitaines',
        Ring1 = 'Shadow Ring',
        Ring2 = 'Alert Ring',
        Back = 'Intensifying Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Oracle\'s Pigaches',
    },

    Dt = {
        Main = 'Terra\'s Staff',
        Sub = 'Raptor Strap +1',
        Head = 'Walahra Turban',
        Neck = 'Bird Whistle',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Succor Ring',
        Ring2 = 'Corneus Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Creek M Clomps',
    },

    PDT = {
        Main = 'Terra\'s Staff',
        Sub = 'Raptor Strap +1',
        Head = 'Walahra Turban',
        Neck = 'Bird Whistle',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Succor Ring',
        Ring2 = 'Corneus Ring',
        Back = 'Intensifying Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Creek M Clomps',
    },

    MDT = {
        Main = 'Chatoyant Staff',
        Sub = 'Raptor Strap +1',
        Head = 'Walahra Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Green Earring',
        Body = 'Dalmatica',
        Hands = 'Creek M Mitts',
        Ring1 = 'Emerald Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Ataractic Solea',
    },

    FireRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Sardonyx Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Garnet Ring',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    IceRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Ear1 = 'Sardonyx Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Zircon Ring',
        Ring2 = 'Clear Ring',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    WindRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Ear1 = 'Green Earring',
        Body = 'Carpenter\'s Apron',
        Hands = 'Ornate Gloves',
        Ring1 = 'Emerald Ring',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    EarthRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Ear1 = 'Green Earring',
        Body = 'Carpenter\'s Apron',
        Hands = 'Carpenter\'s Gloves',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    ThunderRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Neck = 'Chain Choker',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    LightningRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Neck = 'Chain Choker',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    WaterRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Neck = 'Chain Choker',
        Ear1 = 'Star Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    LightRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Neck = 'Colossus\'s Torque',
        Body = 'Benedight Coat',
        Hands = 'remove',
        Ring1 = 'Pearl Ring',
        Ring2 = 'Pearl Ring',
        Back = 'Colossus\'s Mantle',
        Legs = 'Benedight Hose',
        Feet = 'remove',
    },

    DarkRes = {
        Main = 'Chatoyant Staff',
        Head = 'Walahra Turban',
        Neck = 'Aesir Torque',
        Ear1 = 'Black Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Back = 'Colossus\'s Mantle',
        Feet = 'Ataractic Solea',
    },

    CharmResist = {
        Head = 'Walahra Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Green Earring',
        Body = 'Dalmatica',
        Hands = 'Creek M Mitts',
        Ring1 = 'Emerald Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Ataractic Solea',
    },

    Crafting = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    TP = {
        Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Cotton Doublet',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Grapevine Cape',
        Waist = 'Headlong Belt',
        Legs = 'Bagua Pants',
        Feet = 'Battle Boots',
    },

    Hybrid = {
        Main = 'Terra\'s Staff',
        Sub = 'Raptor Strap +1',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Brutal Earring',
        Body = 'Yigit Gomlek',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Creek M Clomps',
    },

    TPAccuracy = {
        Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Cotton Doublet',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Grapevine Cape',
        Waist = 'Headlong Belt',
        Legs = 'Bagua Pants',
        Feet = 'Battle Boots',
    },

    CombatSkillup = {
        Head = 'Sprout Beret',
    },

    MagicSkillup = {
        Head = 'Sprout Beret',
    },

    Proc = {
        Main = 'Misery Staff',
    },

    Precast = {
        Ear1 = 'Loquac. Earring',
        Back = 'Swith Cape',
    },

    ElementalPrecast = {
        Ear1 = 'Loquac. Earring',
        Hands = 'Bagua Mitaines',
        Back = 'Swith Cape',
    },

    Guard = {
        Head = 'Walahra Turban',
        Neck = 'Bird Whistle',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Succor Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Colossus\'s Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Creek M Clomps',
    },

    SIRD = {
        Main = 'Hermit\'s Wand',
        Sub = 'remove',
        Feet = 'Mountain Gaiters',
    },

    SIRD_NIN = {
        Main = 'Hermit\'s Wand',
        Sub = 'remove',
        Ear1 = 'Loquac. Earring',
        Back = 'Swith Cape',
        Feet = 'Mountain Gaiters',
    },

    ConserveMP = {
        Hands = 'Zenith Mitts',
        Waist = 'Pythia Sash',
    },

    Midcast = {
        Main = 'Kirin\'s Pole',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    CurePrecast = {
        Head = 'Erudite Cap',
        Ear1 = 'Loquac. Earring',
        Back = 'Hierarch\'s Mantle',
    },

    Cure = {
        Main = 'Chatoyant Staff',
        Sub = 'Reign Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Yigit Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Pythia Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Zenith Pumps',
    },

    Healing = {
        Main = 'Chatoyant Staff',
        Sub = 'Reign Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Yigit Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Pythia Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Zenith Pumps',
    },

    Enhancing = {
        Neck = 'Colossus\'s Torque',
        Back = 'Grapevine Cape',
    },

    EnhancingDuration = {
        Back = 'Grapevine Cape',
    },

    Spikes = {
        Main = 'Tamaxchi',
        Sub = 'Harpy Shield',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Refresh = {
        Back = 'Grapevine Cape',
    },

    Regen = {
        Back = 'Grapevine Cape',
    },

    SneakInvisible = {
        Back = 'Grapevine Cape',
    },

    Barspell = {
        Neck = 'Colossus\'s Torque',
        Back = 'Grapevine Cape',
    },

    Phalanx = {
        Neck = 'Colossus\'s Torque',
        Back = 'Grapevine Cape',
    },

    Aquaveil = {
        Neck = 'Colossus\'s Torque',
        Back = 'Grapevine Cape',
    },

    Haste = {
        Back = 'Grapevine Cape',
    },

    Enfeebling = {
        Main = 'Kirin\'s Pole',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Sleep = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Bind = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Burn = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Choke = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Drown = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Frost = {
        Main = 'Aquilo\'s Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Gravity = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Silence = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Slow = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Paralyze = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Poison = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Rasp = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Shock = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Blind = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Dispel = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Dia = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Head = 'Erudite Cap',
        Neck = 'Enfeebling Torque',
        Ear1 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Karka Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Bagua Sandals',
    },

    Bio = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Abyssal Earring',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Divine = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Elemental = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    DarkMagic = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Abyssal Earring',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    DrainAspir = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Bagua Galero',
        Neck = 'Aesir Torque',
        Ear1 = 'Hirudinea Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Absorb = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Abyssal Earring',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Stun = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Erudite Cap',
        Neck = 'Aesir Torque',
        Ear1 = 'Abyssal Earring',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Insect Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Geomancy = {
        Main = 'Kirin\'s Pole',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Snow Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    IndiDuration = {
        Main = 'Kirin\'s Pole',
        Sub = 'Omni Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Erudite Cap',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Snow Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Bagua Pants',
        Feet = 'Yigit Crackows',
    },

    Ninjutsu = {
        Main = 'Tamaxchi',
        Sub = 'Harpy Shield',
        Ammo = 'Morion Tathlum',
        Head = 'Walahra Turban',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Headlong Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Utsusemi = {
        Head = 'Walahra Turban',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Mythril Earring',
        Body = 'Yigit Gomlek',
        Hands = 'Ornate Gloves',
        Ring1 = 'Alert Ring',
        Back = 'Swith Cape',
        Waist = 'Headlong Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Yigit Crackows',
    },

    NinjutsuEnfeeble = {
        Main = 'Kirin\'s Pole',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Walahra Turban',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Incubus Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Back = 'Oneiros Cape',
        Waist = 'Headlong Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weaponskill = {
        Head = 'Empress Hairpin',
        Neck = 'Moepapa Medal',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Grapevine Cape',
        Waist = 'Penitent\'s Rope',
        Legs = 'Bagua Pants',
        Feet = 'Creek M Clomps',
    },

    WeaponSkillAccuracy = {
        Head = 'Empress Hairpin',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Grapevine Cape',
        Waist = 'Tilt Belt',
        Legs = 'Bagua Pants',
        Feet = 'Battle Boots',
    },

    WSElemental = {
        Head = 'Zenith Crown +1',
        Neck = 'Moepapa Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Blobnag Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Bagua Pants',
        Feet = 'Yigit Crackows',
    },

    JobAbility = {
        Head = 'Baron\'s Chapeau',
        Ear1 = 'Incubus Earring',
        Ring1 = 'Corneus Ring',
    },

    Enmity = {
        Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
        Head = 'Baron\'s Chapeau',
        Ear1 = 'Incubus Earring',
        Ring1 = 'Corneus Ring',
    },

    Elemental_Fire = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Fire = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Fire = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Ice = {
        Main = 'Aquilo\'s Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Ice = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Ice = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Wind = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Wind = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Wind = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Earth = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Earth = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Earth = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Thunder = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Thunder = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Thunder = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Lightning = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Lightning = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Lightning = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Water = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Water = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Water = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Light = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Light = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Light = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Elemental_Dark = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Weather_Dark = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Day_Dark = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip',
        Ammo = 'Morion Tathlum',
        Head = 'Zenith Crown +1',
        Neck = 'Aesir Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    Stoneskin = {
        Main = 'Kirin\'s Pole',
        Sub = 'Reign Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Zenith Crown +1',
        Neck = 'Stone Gorget',
        Ear1 = 'Star Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Grapevine Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Bagua Sandals',
    },

    Cursna = {
        Main = 'Hermit\'s Wand',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Loquac. Earring',
        Hands = 'Ornate Gloves',
        Ring1 = 'Tamas Ring',
        Back = 'Swith Cape',
        Waist = 'Headlong Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Mountain Gaiters',
    },

    StatusRemoval = {
        Main = 'Hermit\'s Wand',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Ear1 = 'Loquac. Earring',
        Hands = 'Ornate Gloves',
        Ring1 = 'Tamas Ring',
        Back = 'Swith Cape',
        Waist = 'Headlong Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Mountain Gaiters',
    },

    DivineDamage = {
        Main = 'Chatoyant Staff',
        Sub = 'Reign Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    CureWeather_Light = {
        Main = 'Chatoyant Staff',
        Sub = 'Reign Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Yigit Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Pythia Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Zenith Pumps',
    },

    CureDay_Light = {
        Main = 'Chatoyant Staff',
        Sub = 'Reign Grip',
        Ammo = 'Mana Ampulla',
        Head = 'Yigit Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Pythia Sash',
        Legs = 'Mahatma Slops',
        Feet = 'Zenith Pumps',
    },

    WS_Seraph_Strike = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Yigit Crackows',
    },

    WSAcc_Seraph_Strike = {
        Head = 'Zenith Crown +1',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Yigit Crackows',
    },

    WS_Brainshaker = {
        Head = 'Sinister Mask',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Hands = 'Creek M Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Garnet Ring',
        Waist = 'Headlong Belt',
        Feet = 'Creek M Clomps',
    },

    WSAcc_Brainshaker = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Creek M Clomps',
    },

    WS_Starlight = {
        Neck = 'Storm Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Waist = 'Headlong Belt',
        Feet = 'Battle Boots',
    },

    WSAcc_Starlight = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Battle Boots',
    },

    WS_Moonlight = {
        Neck = 'Storm Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Waist = 'Headlong Belt',
        Feet = 'Battle Boots',
    },

    WSAcc_Moonlight = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Battle Boots',
    },

    WS_Skullbreaker = {
        Head = 'Sinister Mask',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Hands = 'Creek M Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Garnet Ring',
        Waist = 'Headlong Belt',
        Feet = 'Creek M Clomps',
    },

    WSAcc_Skullbreaker = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Creek M Clomps',
    },

    WS_True_Strike = {
        Head = 'Sinister Mask',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Hands = 'Creek M Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Garnet Ring',
        Waist = 'Headlong Belt',
        Feet = 'Creek M Clomps',
    },

    WSAcc_True_Strike = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Creek M Clomps',
    },

    WS_Judgment = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Creek M Clomps',
    },

    WSAcc_Judgment = {
        Head = 'Zenith Crown +1',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Creek M Clomps',
    },

    WS_Hexa_Strike = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Dalmatica',
        Hands = 'Ornate Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Creek M Clomps',
    },

    WSAcc_Hexa_Strike = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Battle Boots',
    },

    WS_Heavy_Swing = {
        Head = 'Sinister Mask',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Hands = 'Creek M Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Garnet Ring',
        Waist = 'Headlong Belt',
        Feet = 'Creek M Clomps',
    },

    WSAcc_Heavy_Swing = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Creek M Clomps',
    },

    WS_Rock_Crusher = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Bagua Pants',
        Feet = 'Yigit Crackows',
    },

    WSAcc_Rock_Crusher = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Bagua Pants',
        Feet = 'Yigit Crackows',
    },

    WS_Earth_Crusher = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Grapevine Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Bagua Pants',
        Feet = 'Yigit Crackows',
    },

    WSAcc_Earth_Crusher = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Zenith Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Salire Belt',
        Legs = 'Bagua Pants',
        Feet = 'Yigit Crackows',
    },

    WS_Starburst = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Yigit Crackows',
    },

    WSAcc_Starburst = {
        Head = 'Zenith Crown +1',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Yigit Crackows',
    },

    WS_Sunburst = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Yigit Crackows',
    },

    WSAcc_Sunburst = {
        Head = 'Zenith Crown +1',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Ornate Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Swith Cape',
        Waist = 'Salire Belt',
        Legs = 'Zenith Slacks',
        Feet = 'Yigit Crackows',
    },

    WS_Shell_Crusher = {
        Head = 'Sinister Mask',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Hands = 'Creek M Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Garnet Ring',
        Waist = 'Headlong Belt',
        Feet = 'Creek M Clomps',
    },

    WSAcc_Shell_Crusher = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Creek M Clomps',
    },

    WS_Full_Swing = {
        Head = 'Sinister Mask',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Cotton Doublet',
        Hands = 'Creek M Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Garnet Ring',
        Waist = 'Headlong Belt',
        Feet = 'Creek M Clomps',
    },

    WSAcc_Full_Swing = {
        Head = 'Erudite Cap',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Incubus Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Creek M Mitts',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Oneiros Cape',
        Waist = 'Tilt Belt',
        Legs = 'Seer\'s Slacks',
        Feet = 'Creek M Clomps',
    },

    WS_Spirit_Taker = {
        Head = 'Zenith Crown +1',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Abyssal Earring',
        Body = 'Dalmatica',
        Hands = 'Yigit Gages',
        Ring1 = 'Karka Ring',
        Ring2 = 'Snow Ring',
        Back = 'Grapevine Cape',
        Waist = 'Penitent\'s Rope',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    WSAcc_Spirit_Taker = {
        Head = 'Erudite Cap',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Abyssal Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Yigit Gages',
        Ring1 = 'Karka Ring',
        Ring2 = 'Snow Ring',
        Back = 'Grapevine Cape',
        Waist = 'Penitent\'s Rope',
        Legs = 'Mahatma Slops',
        Feet = 'Yigit Crackows',
    },

    BlueMagic = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    PhysicalBlueMagic = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    MagicalBlueMagic = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Song = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    SongPrecast = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    SongDebuff = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    SongBuff = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Summoning = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    BloodPactRage = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    BloodPactWard = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    AvatarPerp = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Snapshot = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    RangedPreshot = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Ranged = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    RangedMidshot = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    RangedAccuracy = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    RangedAttack = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    QuickDraw = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Waltz = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Flourish = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Steps = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Samba = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Jump = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    PetReady = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    PetMagic = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    PetTank = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },

    Roll = {
        Main = 'remove',
        Sub = 'remove',
        Range = 'remove',
        Ammo = 'remove',
        Head = 'remove',
        Neck = 'remove',
        Ear1 = 'remove',
        Ear2 = 'remove',
        Body = 'remove',
        Hands = 'remove',
        Ring1 = 'remove',
        Ring2 = 'remove',
        Back = 'remove',
        Waist = 'remove',
        Legs = 'remove',
        Feet = 'remove',
    },
};

profile.Sets = sets;
local movementPenaltyItems = {

};
profile.Packer = {};
profile.GetThreatEntities = nil;

local subjobs = {
    RDM = {
        level = 37,
        capabilities = {
            'fast_cast',
            'cure',
            'enfeeble',
            'enhancing',
            'sneak_invisible',
            'elemental_magic',
            'stoneskin',
        },
        abilities = {
        },
        traits = {
            { name = 'resist petrify', level = 10, rank = 1, mod = 'PETRIFYRES', value = 10 },
            { name = 'fast cast', level = 15, rank = 1, mod = 'FASTCAST', value = 10 },
            { name = 'magic atk. bonus', level = 20, rank = 1, mod = 'MATT', value = 20 },
            { name = 'magic def. bonus', level = 25, rank = 1, mod = 'MDEF', value = 10 },
            { name = 'tranquil heart', level = 26, rank = 1, mod = 'NONE', value = 0 },
            { name = 'resist petrify', level = 30, rank = 2, mod = 'PETRIFYRES', value = 15 },
            { name = 'clear mind', level = 31, rank = 1, mod = 'MPHEAL', value = 3 },
            { name = 'fast cast', level = 35, rank = 2, mod = 'FASTCAST', value = 15 },
        },
        spells = {
            { name = 'dia', level = 1, mp = 7, cast = 1000, recast = 5000 },
            { name = 'cure', level = 3, mp = 8, cast = 2000, recast = 5000 },
            { name = 'stone', level = 4, mp = 4, cast = 500, recast = 2000 },
            { name = 'barstone', level = 5, mp = 6, cast = 500, recast = 10000 },
            { name = 'poison', level = 5, mp = 5, cast = 1000, recast = 5000 },
            { name = 'paralyze', level = 6, mp = 6, cast = 3000, recast = 10000 },
            { name = 'barsleep', level = 7, mp = 7, cast = 2500, recast = 10000 },
            { name = 'protect', level = 7, mp = 9, cast = 1000, recast = 5000 },
            { name = 'blind', level = 8, mp = 5, cast = 2000, recast = 10000 },
            { name = 'barwater', level = 9, mp = 6, cast = 500, recast = 10000 },
            { name = 'water', level = 9, mp = 5, cast = 500, recast = 2000 },
            { name = 'barpoison', level = 10, mp = 9, cast = 2500, recast = 10000 },
            { name = 'bio', level = 10, mp = 15, cast = 1500, recast = 5000 },
            { name = 'bind', level = 11, mp = 8, cast = 2000, recast = 40000 },
            { name = 'aquaveil', level = 12, mp = 12, cast = 5000, recast = 10000 },
            { name = 'barparalyze', level = 12, mp = 11, cast = 2500, recast = 10000 },
            { name = 'baraero', level = 13, mp = 6, cast = 500, recast = 10000 },
            { name = 'slow', level = 13, mp = 15, cast = 2000, recast = 20000 },
            { name = 'aero', level = 14, mp = 6, cast = 500, recast = 2000 },
            { name = 'cure_ii', level = 14, mp = 24, cast = 2250, recast = 5500 },
            { name = 'deodorize', level = 15, mp = 10, cast = 2000, recast = 8000 },
            { name = 'diaga', level = 15, mp = 12, cast = 1500, recast = 6000 },
            { name = 'diaga_ii', level = 15, mp = 60, cast = 1750, recast = 6250 },
            { name = 'enthunder', level = 16, mp = 12, cast = 3000, recast = 10000 },
            { name = 'barfire', level = 17, mp = 6, cast = 500, recast = 10000 },
            { name = 'shell', level = 17, mp = 18, cast = 1000, recast = 5000 },
            { name = 'barblind', level = 18, mp = 13, cast = 2500, recast = 10000 },
            { name = 'enstone', level = 18, mp = 12, cast = 3000, recast = 10000 },
            { name = 'silence', level = 18, mp = 16, cast = 3000, recast = 10000 },
            { name = 'fire', level = 19, mp = 7, cast = 500, recast = 2000 },
            { name = 'blaze_spikes', level = 20, mp = 8, cast = 3000, recast = 10000 },
            { name = 'enaero', level = 20, mp = 12, cast = 3000, recast = 10000 },
            { name = 'sneak', level = 20, mp = 12, cast = 3000, recast = 10000 },
            { name = 'barblizzard', level = 21, mp = 6, cast = 500, recast = 10000 },
            { name = 'gravity', level = 21, mp = 24, cast = 1500, recast = 60000 },
            { name = 'regen', level = 21, mp = 15, cast = 1500, recast = 12000 },
            { name = 'enblizzard', level = 22, mp = 12, cast = 3000, recast = 10000 },
            { name = 'barsilence', level = 23, mp = 15, cast = 2500, recast = 10000 },
            { name = 'blink', level = 23, mp = 20, cast = 6000, recast = 10000 },
            { name = 'blizzard', level = 24, mp = 8, cast = 500, recast = 2000 },
            { name = 'enfire', level = 24, mp = 12, cast = 3000, recast = 10000 },
            { name = 'barthunder', level = 25, mp = 6, cast = 500, recast = 10000 },
            { name = 'invisible', level = 25, mp = 15, cast = 3000, recast = 10000 },
            { name = 'sleep', level = 25, mp = 19, cast = 2500, recast = 30000 },
            { name = 'cure_iii', level = 26, mp = 46, cast = 2500, recast = 6000 },
            { name = 'enwater', level = 27, mp = 12, cast = 3000, recast = 10000 },
            { name = 'protect_ii', level = 27, mp = 28, cast = 1250, recast = 5250 },
            { name = 'thunder', level = 29, mp = 9, cast = 500, recast = 2000 },
            { name = 'dia_ii', level = 31, mp = 30, cast = 1500, recast = 6000 },
            { name = 'dispel', level = 32, mp = 25, cast = 3000, recast = 10000 },
            { name = 'phalanx', level = 33, mp = 21, cast = 3000, recast = 10000 },
            { name = 'stoneskin', level = 34, mp = 29, cast = 7000, recast = 30000 },
            { name = 'distract', level = 35, mp = 32, cast = 3000, recast = 10000 },
            { name = 'stone_ii', level = 35, mp = 16, cast = 1500, recast = 6000 },
            { name = 'bio_ii', level = 36, mp = 36, cast = 1500, recast = 5000 },
            { name = 'shell_ii', level = 37, mp = 37, cast = 1250, recast = 5250 },
        },
    },
    WHM = {
        level = 37,
        capabilities = {
            'cure',
            'status_removal',
            'protect_shell',
            'sneak_invisible',
            'divine_damage',
            'stoneskin',
        },
        abilities = {
            { name = 'divine_seal', level = 15, recast = 600, recastId = 26, ce = 0, ve = 80 },
        },
        traits = {
            { name = 'magic def. bonus', level = 10, rank = 1, mod = 'MDEF', value = 10 },
            { name = 'clear mind', level = 20, rank = 1, mod = 'MPHEAL', value = 3 },
            { name = 'tranquil heart', level = 21, rank = 1, mod = 'NONE', value = 0 },
            { name = 'auto regen', level = 25, rank = 1, mod = 'REGEN', value = 1 },
            { name = 'magic def. bonus', level = 30, rank = 2, mod = 'MDEF', value = 12 },
            { name = 'clear mind', level = 35, rank = 2, mod = 'MPHEAL', value = 6 },
        },
        spells = {
            { name = 'cure', level = 1, mp = 8, cast = 2000, recast = 5000 },
            { name = 'dia', level = 3, mp = 7, cast = 1000, recast = 5000 },
            { name = 'paralyze', level = 4, mp = 6, cast = 3000, recast = 10000 },
            { name = 'banish', level = 5, mp = 15, cast = 2000, recast = 15000 },
            { name = 'barstonra', level = 5, mp = 12, cast = 500, recast = 10000 },
            { name = 'poisona', level = 6, mp = 8, cast = 1000, recast = 5000 },
            { name = 'barsleepra', level = 7, mp = 14, cast = 5000, recast = 10000 },
            { name = 'protect', level = 7, mp = 9, cast = 1000, recast = 5000 },
            { name = 'protectra', level = 7, mp = 9, cast = 1000, recast = 15000 },
            { name = 'barwatera', level = 9, mp = 12, cast = 500, recast = 10000 },
            { name = 'paralyna', level = 9, mp = 12, cast = 1000, recast = 5000 },
            { name = 'aquaveil', level = 10, mp = 12, cast = 5000, recast = 10000 },
            { name = 'barpoisonra', level = 10, mp = 18, cast = 5000, recast = 10000 },
            { name = 'cure_ii', level = 11, mp = 24, cast = 2250, recast = 5500 },
            { name = 'barparalyzra', level = 12, mp = 22, cast = 5000, recast = 10000 },
            { name = 'baraera', level = 13, mp = 12, cast = 500, recast = 10000 },
            { name = 'slow', level = 13, mp = 15, cast = 2000, recast = 20000 },
            { name = 'blindna', level = 14, mp = 16, cast = 1000, recast = 10000 },
            { name = 'banishga', level = 15, mp = 41, cast = 2750, recast = 15000 },
            { name = 'deodorize', level = 15, mp = 10, cast = 2000, recast = 8000 },
            { name = 'silence', level = 15, mp = 16, cast = 3000, recast = 10000 },
            { name = 'curaga', level = 16, mp = 60, cast = 4500, recast = 10000 },
            { name = 'barfira', level = 17, mp = 12, cast = 500, recast = 10000 },
            { name = 'shell', level = 17, mp = 18, cast = 1000, recast = 5000 },
            { name = 'shellra', level = 17, mp = 18, cast = 1000, recast = 15000 },
            { name = 'barblindra', level = 18, mp = 26, cast = 5000, recast = 10000 },
            { name = 'diaga', level = 18, mp = 12, cast = 1500, recast = 6000 },
            { name = 'diaga_ii', level = 18, mp = 60, cast = 1750, recast = 6250 },
            { name = 'blink', level = 19, mp = 20, cast = 6000, recast = 10000 },
            { name = 'silena', level = 19, mp = 24, cast = 1000, recast = 5000 },
            { name = 'sneak', level = 20, mp = 12, cast = 3000, recast = 10000 },
            { name = 'barblizzara', level = 21, mp = 12, cast = 500, recast = 10000 },
            { name = 'cure_iii', level = 21, mp = 46, cast = 2500, recast = 6000 },
            { name = 'regen', level = 21, mp = 15, cast = 1500, recast = 12000 },
            { name = 'barsilencera', level = 23, mp = 30, cast = 5000, recast = 10000 },
            { name = 'barthundra', level = 25, mp = 12, cast = 500, recast = 10000 },
            { name = 'invisible', level = 25, mp = 15, cast = 3000, recast = 10000 },
            { name = 'raise', level = 25, mp = 150, cast = 15000, recast = 60000 },
            { name = 'reraise', level = 25, mp = 150, cast = 8000, recast = 60000 },
            { name = 'protect_ii', level = 27, mp = 28, cast = 1250, recast = 5250 },
            { name = 'protectra_ii', level = 27, mp = 28, cast = 1250, recast = 16000 },
            { name = 'stoneskin', level = 28, mp = 29, cast = 7000, recast = 30000 },
            { name = 'cursna', level = 29, mp = 30, cast = 1000, recast = 10000 },
            { name = 'banish_ii', level = 30, mp = 57, cast = 2500, recast = 30000 },
            { name = 'curaga_ii', level = 31, mp = 120, cast = 4750, recast = 10250 },
            { name = 'erase', level = 32, mp = 18, cast = 2500, recast = 15000 },
            { name = 'viruna', level = 34, mp = 48, cast = 1000, recast = 5000 },
            { name = 'dia_ii', level = 36, mp = 30, cast = 1500, recast = 6000 },
            { name = 'teleport-dem', level = 36, mp = 75, cast = 20000, recast = 10000 },
            { name = 'teleport-holla', level = 36, mp = 75, cast = 20000, recast = 10000 },
            { name = 'teleport-mea', level = 36, mp = 75, cast = 20000, recast = 10000 },
            { name = 'shell_ii', level = 37, mp = 37, cast = 1250, recast = 5250 },
            { name = 'shellra_ii', level = 37, mp = 37, cast = 1250, recast = 16000 },
        },
    },
    BLM = {
        level = 37,
        capabilities = {
            'warp',
            'sleep',
            'magic_burst',
            'drain_aspir',
            'elemental_magic',
        },
        abilities = {
            { name = 'elemental_seal', level = 15, recast = 600, recastId = 38, ce = 0, ve = 80 },
        },
        traits = {
            { name = 'magic atk. bonus', level = 10, rank = 1, mod = 'MATT', value = 20 },
            { name = 'clear mind', level = 15, rank = 1, mod = 'MPHEAL', value = 3 },
            { name = 'conserve mp', level = 20, rank = 1, mod = 'CONSERVE_MP', value = 25 },
            { name = 'magic atk. bonus', level = 30, rank = 2, mod = 'MATT', value = 24 },
            { name = 'clear mind', level = 30, rank = 2, mod = 'MPHEAL', value = 6 },
        },
        spells = {
            { name = 'stone', level = 1, mp = 4, cast = 500, recast = 2000 },
            { name = 'poison', level = 3, mp = 5, cast = 1000, recast = 5000 },
            { name = 'blind', level = 4, mp = 5, cast = 2000, recast = 10000 },
            { name = 'water', level = 5, mp = 5, cast = 500, recast = 2000 },
            { name = 'bind', level = 7, mp = 8, cast = 2000, recast = 40000 },
            { name = 'aero', level = 9, mp = 6, cast = 500, recast = 2000 },
            { name = 'bio', level = 10, mp = 15, cast = 1500, recast = 5000 },
            { name = 'blaze_spikes', level = 10, mp = 8, cast = 3000, recast = 10000 },
            { name = 'drain', level = 12, mp = 21, cast = 3000, recast = 60000 },
            { name = 'fire', level = 13, mp = 7, cast = 500, recast = 2000 },
            { name = 'stonega', level = 15, mp = 24, cast = 2000, recast = 5000 },
            { name = 'shock', level = 16, mp = 25, cast = 2500, recast = 10000 },
            { name = 'blizzard', level = 17, mp = 8, cast = 500, recast = 2000 },
            { name = 'warp', level = 17, mp = 100, cast = 4000, recast = 10000 },
            { name = 'rasp', level = 18, mp = 25, cast = 2500, recast = 10000 },
            { name = 'waterga', level = 19, mp = 34, cast = 2000, recast = 5000 },
            { name = 'choke', level = 20, mp = 25, cast = 2500, recast = 10000 },
            { name = 'ice_spikes', level = 20, mp = 16, cast = 3000, recast = 10000 },
            { name = 'sleep', level = 20, mp = 19, cast = 2500, recast = 30000 },
            { name = 'thunder', level = 21, mp = 9, cast = 500, recast = 2000 },
            { name = 'frost', level = 22, mp = 25, cast = 2500, recast = 10000 },
            { name = 'aeroga', level = 23, mp = 45, cast = 2000, recast = 5000 },
            { name = 'burn', level = 24, mp = 25, cast = 2500, recast = 10000 },
            { name = 'poisonga', level = 24, mp = 44, cast = 2000, recast = 10000 },
            { name = 'aspir', level = 25, mp = 10, cast = 3000, recast = 60000 },
            { name = 'tractor', level = 25, mp = 26, cast = 3000, recast = 10000 },
            { name = 'stone_ii', level = 26, mp = 16, cast = 1500, recast = 6000 },
            { name = 'drown', level = 27, mp = 25, cast = 2500, recast = 10000 },
            { name = 'firaga', level = 28, mp = 57, cast = 2000, recast = 5000 },
            { name = 'escape', level = 29, mp = 125, cast = 15000, recast = 60000 },
            { name = 'shock_spikes', level = 30, mp = 24, cast = 3000, recast = 10000 },
            { name = 'water_ii', level = 30, mp = 19, cast = 1500, recast = 6000 },
            { name = 'sleepga', level = 31, mp = 38, cast = 3000, recast = 30000 },
            { name = 'blizzaga', level = 32, mp = 80, cast = 2000, recast = 5000 },
            { name = 'aero_ii', level = 34, mp = 22, cast = 1500, recast = 6000 },
            { name = 'bio_ii', level = 35, mp = 36, cast = 1500, recast = 5000 },
            { name = 'thundaga', level = 36, mp = 105, cast = 2000, recast = 5000 },
        },
    },
    NIN = {
        level = 37,
        capabilities = {
            'dual_wield',
            'shadows',
            'ninjutsu',
            'subtle_blow',
            'daken',
        },
        abilities = {
        },
        traits = {
            { name = 'stealth', level = 5, rank = 1, mod = 'STEALTH', value = 3 },
            { name = 'dual wield', level = 10, rank = 1, mod = 'DUAL_WIELD', value = 10 },
            { name = 'resist bind', level = 10, rank = 1, mod = 'BINDRES', value = 10 },
            { name = 'subtle blow', level = 15, rank = 1, mod = 'SUBTLE_BLOW', value = 5 },
            { name = 'max hp boost', level = 20, rank = 1, mod = 'BASE_HP', value = 30 },
            { name = 'dual wield', level = 25, rank = 2, mod = 'DUAL_WIELD', value = 15 },
            { name = 'daken', level = 25, rank = 1, mod = 'DAKEN', value = 20 },
            { name = 'resist bind', level = 30, rank = 2, mod = 'BINDRES', value = 15 },
            { name = 'subtle blow', level = 30, rank = 2, mod = 'SUBTLE_BLOW', value = 10 },
        },
        spells = {
            { name = 'tonko_ichi', level = 9, mp = 1194, cast = 1500, recast = 30000 },
            { name = 'utsusemi_ichi', level = 12, mp = 1179, cast = 4000, recast = 30000 },
            { name = 'doton_ichi', level = 15, mp = 1170, cast = 4000, recast = 30000 },
            { name = 'huton_ichi', level = 15, mp = 1167, cast = 4000, recast = 30000 },
            { name = 'hyoton_ichi', level = 15, mp = 1164, cast = 4000, recast = 30000 },
            { name = 'katon_ichi', level = 15, mp = 1161, cast = 4000, recast = 30000 },
            { name = 'raiton_ichi', level = 15, mp = 1173, cast = 4000, recast = 30000 },
            { name = 'suiton_ichi', level = 15, mp = 1176, cast = 4000, recast = 30000 },
            { name = 'kurayami_ichi', level = 19, mp = 1188, cast = 4000, recast = 30000 },
            { name = 'hojo_ichi', level = 23, mp = 1185, cast = 4000, recast = 30000 },
            { name = 'monomi_ichi', level = 25, mp = 2553, cast = 1500, recast = 30000 },
            { name = 'dokumori_ichi', level = 27, mp = 1191, cast = 4000, recast = 30000 },
            { name = 'jubaku_ichi', level = 30, mp = 1182, cast = 4000, recast = 30000 },
            { name = 'tonko_ni', level = 34, mp = 1194, cast = 1500, recast = 45000 },
            { name = 'utsusemi_ni', level = 37, mp = 1179, cast = 1500, recast = 45000 },
        },
    },
    SCH = {
        level = 37,
        capabilities = {
            'light_arts',
            'dark_arts',
            'sublimation',
            'stratagems',
            'cure',
            'drain_aspir',
            'elemental_magic',
            'status_removal',
            'sneak_invisible',
            'alacrity_celerity',
        },
        abilities = {
            { name = 'light_arts', level = 10, recast = 60, recastId = 228, ce = 1, ve = 80 },
            { name = 'dark_arts', level = 10, recast = 60, recastId = 232, ce = 1, ve = 80 },
            { name = 'penury', level = 10, recast = 1, recastId = 231, ce = 1, ve = 80 },
            { name = 'parsimony', level = 10, recast = 1, recastId = 231, ce = 1, ve = 80 },
            { name = 'stratagems', level = 10, recast = 0, recastId = 233, ce = 0, ve = 0 },
            { name = 'addendum_white', level = 10, recast = 1, recastId = 231, ce = 1, ve = 80 },
            { name = 'celerity', level = 25, recast = 1, recastId = 231, ce = 1, ve = 80 },
            { name = 'alacrity', level = 25, recast = 1, recastId = 231, ce = 1, ve = 80 },
            { name = 'addendum_black', level = 30, recast = 1, recastId = 231, ce = 1, ve = 80 },
            { name = 'sublimation', level = 35, recast = 30, recastId = 234, ce = 1, ve = 80 },
        },
        traits = {
            { name = 'resist silence', level = 10, rank = 1, mod = 'SILENCERES', value = 10 },
            { name = 'clear mind', level = 20, rank = 1, mod = 'MPHEAL', value = 3 },
            { name = 'conserve mp', level = 25, rank = 1, mod = 'CONSERVE_MP', value = 25 },
            { name = 'max mp boost', level = 30, rank = 1, mod = 'BASE_MP', value = 10 },
            { name = 'tranquil heart', level = 30, rank = 1, mod = 'NONE', value = 0 },
            { name = 'clear mind', level = 35, rank = 2, mod = 'MPHEAL', value = 6 },
        },
        spells = {
            { name = 'stone', level = 4, mp = 4, cast = 500, recast = 2000 },
            { name = 'cure', level = 5, mp = 8, cast = 2000, recast = 5000 },
            { name = 'embrava', level = 5, mp = 1, cast = 3000, recast = 3000 },
            { name = 'kaustra', level = 5, mp = 1, cast = 5000, recast = 30000 },
            { name = 'water', level = 8, mp = 5, cast = 500, recast = 2000 },
            { name = 'poisona', level = 10, mp = 8, cast = 1000, recast = 5000 },
            { name = 'protect', level = 10, mp = 9, cast = 1000, recast = 5000 },
            { name = 'aero', level = 12, mp = 6, cast = 500, recast = 2000 },
            { name = 'paralyna', level = 12, mp = 12, cast = 1000, recast = 5000 },
            { name = 'aquaveil', level = 13, mp = 12, cast = 5000, recast = 10000 },
            { name = 'deodorize', level = 15, mp = 10, cast = 2000, recast = 8000 },
            { name = 'fire', level = 16, mp = 7, cast = 500, recast = 2000 },
            { name = 'blindna', level = 17, mp = 16, cast = 1000, recast = 10000 },
            { name = 'cure_ii', level = 17, mp = 24, cast = 2250, recast = 5500 },
            { name = 'geohelix', level = 18, mp = 26, cast = 5000, recast = 45000 },
            { name = 'regen', level = 18, mp = 15, cast = 1500, recast = 12000 },
            { name = 'blizzard', level = 20, mp = 8, cast = 500, recast = 2000 },
            { name = 'hydrohelix', level = 20, mp = 26, cast = 5000, recast = 45000 },
            { name = 'shell', level = 20, mp = 18, cast = 1000, recast = 5000 },
            { name = 'sneak', level = 20, mp = 12, cast = 3000, recast = 10000 },
            { name = 'drain', level = 21, mp = 21, cast = 3000, recast = 60000 },
            { name = 'anemohelix', level = 22, mp = 26, cast = 5000, recast = 45000 },
            { name = 'silena', level = 22, mp = 24, cast = 1000, recast = 5000 },
            { name = 'pyrohelix', level = 24, mp = 26, cast = 5000, recast = 45000 },
            { name = 'thunder', level = 24, mp = 9, cast = 500, recast = 2000 },
            { name = 'invisible', level = 25, mp = 15, cast = 3000, recast = 10000 },
            { name = 'cryohelix', level = 26, mp = 26, cast = 5000, recast = 45000 },
            { name = 'ionohelix', level = 28, mp = 26, cast = 5000, recast = 45000 },
            { name = 'blink', level = 29, mp = 20, cast = 6000, recast = 10000 },
            { name = 'blaze_spikes', level = 30, mp = 8, cast = 3000, recast = 10000 },
            { name = 'cure_iii', level = 30, mp = 46, cast = 2500, recast = 6000 },
            { name = 'noctohelix', level = 30, mp = 26, cast = 5000, recast = 45000 },
            { name = 'protect_ii', level = 30, mp = 28, cast = 1250, recast = 5250 },
            { name = 'sleep', level = 30, mp = 19, cast = 2500, recast = 30000 },
            { name = 'stone_ii', level = 30, mp = 16, cast = 1500, recast = 6000 },
            { name = 'cursna', level = 32, mp = 30, cast = 1000, recast = 10000 },
            { name = 'dispel', level = 32, mp = 25, cast = 3000, recast = 10000 },
            { name = 'luminohelix', level = 32, mp = 26, cast = 5000, recast = 45000 },
            { name = 'water_ii', level = 34, mp = 19, cast = 1500, recast = 6000 },
            { name = 'raise', level = 35, mp = 150, cast = 15000, recast = 60000 },
            { name = 'reraise', level = 35, mp = 150, cast = 8000, recast = 60000 },
            { name = 'aspir', level = 36, mp = 10, cast = 3000, recast = 60000 },
            { name = 'regen_ii', level = 37, mp = 36, cast = 1750, recast = 16000 },
        },
    },
    DRK = {
        level = 37,
        capabilities = {
            'last_resort',
            'souleater',
            'dark_magic',
            'attack_boost',
            'occult_acumen',
            'drain_aspir',
            'elemental_magic',
        },
        abilities = {
            { name = 'arcane_circle', level = 5, recast = 300, recastId = 86, ce = 1, ve = 20 },
            { name = 'last_resort', level = 15, recast = 300, recastId = 87, ce = 1, ve = 1300 },
            { name = 'weapon_bash', level = 20, recast = 180, recastId = 88, ce = 1, ve = 900 },
            { name = 'souleater', level = 30, recast = 360, recastId = 85, ce = 1, ve = 1300 },
        },
        traits = {
            { name = 'attack bonus', level = 10, rank = 1, mod = 'ATT', value = 10 },
            { name = 'attack bonus', level = 10, rank = 1, mod = 'RATT', value = 10 },
            { name = 'desperate blows', level = 15, rank = 1, mod = 'DESPERATE_BLOWS', value = 500 },
            { name = 'smite', level = 15, rank = 1, mod = 'SMITE', value = 25 },
            { name = 'resist paralyze', level = 20, rank = 1, mod = 'PARALYZERES', value = 10 },
            { name = 'damage limit+', level = 20, rank = 1, mod = 'DAMAGE_LIMIT', value = 10 },
            { name = 'arcana killer', level = 25, rank = 1, mod = 'ARCANA_KILLER', value = 8 },
            { name = 'attack bonus', level = 30, rank = 2, mod = 'ATT', value = 22 },
            { name = 'attack bonus', level = 30, rank = 2, mod = 'RATT', value = 22 },
            { name = 'desperate blows', level = 30, rank = 2, mod = 'DESPERATE_BLOWS', value = 1000 },
            { name = 'smite', level = 35, rank = 2, mod = 'SMITE', value = 38 },
        },
        spells = {
            { name = 'stone', level = 5, mp = 4, cast = 500, recast = 2000 },
            { name = 'poison', level = 6, mp = 5, cast = 1000, recast = 5000 },
            { name = 'drain', level = 10, mp = 21, cast = 3000, recast = 60000 },
            { name = 'water', level = 11, mp = 5, cast = 500, recast = 2000 },
            { name = 'bio', level = 15, mp = 15, cast = 1500, recast = 5000 },
            { name = 'aero', level = 17, mp = 6, cast = 500, recast = 2000 },
            { name = 'aspir', level = 20, mp = 10, cast = 3000, recast = 60000 },
            { name = 'bind', level = 20, mp = 8, cast = 2000, recast = 40000 },
            { name = 'fire', level = 23, mp = 7, cast = 500, recast = 2000 },
            { name = 'poisonga', level = 26, mp = 44, cast = 2000, recast = 10000 },
            { name = 'blizzard', level = 29, mp = 8, cast = 500, recast = 2000 },
            { name = 'sleep', level = 30, mp = 19, cast = 2500, recast = 30000 },
            { name = 'absorb-mnd', level = 31, mp = 33, cast = 500, recast = 60000 },
            { name = 'tractor', level = 32, mp = 26, cast = 3000, recast = 10000 },
            { name = 'absorb-chr', level = 33, mp = 33, cast = 500, recast = 60000 },
            { name = 'absorb-vit', level = 35, mp = 33, cast = 500, recast = 60000 },
            { name = 'thunder', level = 35, mp = 9, cast = 500, recast = 2000 },
            { name = 'absorb-agi', level = 37, mp = 33, cast = 500, recast = 60000 },
            { name = 'stun', level = 37, mp = 25, cast = 500, recast = 45000 },
        },
    },
};

profile.Subjobs = subjobs;

local jobIdToAbbr = {
    [1] = 'WAR',
    [2] = 'MNK',
    [3] = 'WHM',
    [4] = 'BLM',
    [5] = 'RDM',
    [6] = 'THF',
    [7] = 'PLD',
    [8] = 'DRK',
    [9] = 'BST',
    [10] = 'BRD',
    [11] = 'RNG',
    [12] = 'SAM',
    [13] = 'NIN',
    [14] = 'DRG',
    [15] = 'SMN',
    [16] = 'BLU',
    [17] = 'COR',
    [18] = 'PUP',
    [19] = 'DNC',
    [20] = 'SCH',
    [21] = 'GEO',
    [22] = 'RUN',
};

local setIntents = {
    Playstyle_GeoMagic = 'MagicAccuracy',
    Playstyle_Nuke = 'Nuke',
    Playstyle_FastCast = 'FastCast',
    Playstyle_IdleRefresh = 'Refresh',
    GeoMagic = 'MagicAccuracy',
    Nuke = 'Nuke',
    FastCast = 'FastCast',
    IdleRefresh = 'Refresh',
    Idle = 'Idle',
    IdleCity = 'Idle',
    IdleCombat = 'PDT',
    IdleMaxMP = 'Idle',
    IdleMaxHP = 'Idle',
    IdleNonCombat = 'Idle',
    Resting = 'Idle',
    InCity = 'Movement',
    Movement = 'Movement',
    Movement_City = 'Movement',
    Movement_Night = 'Movement',
    Movement_DuskToDawn = 'Movement',
    Aftercast = 'Idle',
    Dt = 'PDT',
    PDT = 'PDT',
    MDT = 'MDT',
    FireRes = 'MDT',
    IceRes = 'MDT',
    WindRes = 'MDT',
    EarthRes = 'MDT',
    ThunderRes = 'MDT',
    LightningRes = 'MDT',
    WaterRes = 'MDT',
    LightRes = 'MDT',
    DarkRes = 'MDT',
    CharmResist = 'MDT',
    Crafting = 'Crafting',
    TP = 'TP',
    Hybrid = 'TP',
    TPAccuracy = 'Accuracy',
    CombatSkillup = 'TP',
    MagicSkillup = 'MagicAccuracy',
    Proc = 'TP',
    Precast = 'FastCast',
    ElementalPrecast = 'FastCast',
    Guard = 'PDT',
    SIRD = 'SIRD',
    SIRD_NIN = 'SIRD',
    ConserveMP = 'FastCast',
    Midcast = 'MagicAccuracy',
    CurePrecast = 'CurePrecast',
    Cure = 'Cure',
    Healing = 'Healing',
    Enhancing = 'Enhancing',
    EnhancingDuration = 'Enhancing',
    Spikes = 'Enhancing',
    Refresh = 'Refresh',
    Regen = 'Regen',
    SneakInvisible = 'Enhancing',
    Barspell = 'Enhancing',
    Phalanx = 'Enhancing',
    Aquaveil = 'Enhancing',
    Haste = 'Enhancing',
    Enfeebling = 'Enfeebling',
    Sleep = 'Enfeebling',
    Bind = 'Enfeebling',
    Burn = 'Enfeebling',
    Choke = 'Enfeebling',
    Drown = 'Enfeebling',
    Frost = 'Enfeebling',
    Gravity = 'Enfeebling',
    Silence = 'Enfeebling',
    Slow = 'Enfeebling',
    Paralyze = 'Enfeebling',
    Poison = 'Enfeebling',
    Rasp = 'Enfeebling',
    Shock = 'Enfeebling',
    Blind = 'Enfeebling',
    Dispel = 'Enfeebling',
    Dia = 'Dia',
    Bio = 'DarkMagic',
    Divine = 'Enfeebling',
    Elemental = 'Nuke',
    DarkMagic = 'DarkMagic',
    DrainAspir = 'DarkMagic',
    Absorb = 'DarkMagic',
    Stun = 'DarkMagic',
    Geomancy = 'MagicAccuracy',
    IndiDuration = 'MagicAccuracy',
    Ninjutsu = 'Ninjutsu',
    Utsusemi = 'FastCast',
    NinjutsuEnfeeble = 'NinjutsuEnfeeble',
    Weaponskill = 'Weaponskill',
    WeaponSkillAccuracy = 'WeaponSkillAccuracy',
    WSElemental = 'WSElemental',
    JobAbility = 'JobAbility',
    Enmity = 'Enmity',
    Elemental_Fire = 'Nuke',
    Weather_Fire = 'Nuke',
    Day_Fire = 'Nuke',
    Elemental_Ice = 'Nuke',
    Weather_Ice = 'Nuke',
    Day_Ice = 'Nuke',
    Elemental_Wind = 'Nuke',
    Weather_Wind = 'Nuke',
    Day_Wind = 'Nuke',
    Elemental_Earth = 'Nuke',
    Weather_Earth = 'Nuke',
    Day_Earth = 'Nuke',
    Elemental_Thunder = 'Nuke',
    Weather_Thunder = 'Nuke',
    Day_Thunder = 'Nuke',
    Elemental_Lightning = 'Nuke',
    Weather_Lightning = 'Nuke',
    Day_Lightning = 'Nuke',
    Elemental_Water = 'Nuke',
    Weather_Water = 'Nuke',
    Day_Water = 'Nuke',
    Elemental_Light = 'Nuke',
    Weather_Light = 'Nuke',
    Day_Light = 'Nuke',
    Elemental_Dark = 'Nuke',
    Weather_Dark = 'Nuke',
    Day_Dark = 'Nuke',
    Stoneskin = 'Enhancing',
    Cursna = 'Healing',
    StatusRemoval = 'Healing',
    DivineDamage = 'Nuke',
    CureWeather_Light = 'Cure',
    CureDay_Light = 'Cure',
    WS_Seraph_Strike = 'Weaponskill',
    WSAcc_Seraph_Strike = 'WeaponSkillAccuracy',
    WS_Brainshaker = 'Weaponskill',
    WSAcc_Brainshaker = 'WeaponSkillAccuracy',
    WS_Starlight = 'Weaponskill',
    WSAcc_Starlight = 'WeaponSkillAccuracy',
    WS_Moonlight = 'Weaponskill',
    WSAcc_Moonlight = 'WeaponSkillAccuracy',
    WS_Skullbreaker = 'Weaponskill',
    WSAcc_Skullbreaker = 'WeaponSkillAccuracy',
    WS_True_Strike = 'Weaponskill',
    WSAcc_True_Strike = 'WeaponSkillAccuracy',
    WS_Judgment = 'Weaponskill',
    WSAcc_Judgment = 'WeaponSkillAccuracy',
    WS_Hexa_Strike = 'Weaponskill',
    WSAcc_Hexa_Strike = 'WeaponSkillAccuracy',
    WS_Heavy_Swing = 'Weaponskill',
    WSAcc_Heavy_Swing = 'WeaponSkillAccuracy',
    WS_Rock_Crusher = 'Weaponskill',
    WSAcc_Rock_Crusher = 'WeaponSkillAccuracy',
    WS_Earth_Crusher = 'Weaponskill',
    WSAcc_Earth_Crusher = 'WeaponSkillAccuracy',
    WS_Starburst = 'Weaponskill',
    WSAcc_Starburst = 'WeaponSkillAccuracy',
    WS_Sunburst = 'Weaponskill',
    WSAcc_Sunburst = 'WeaponSkillAccuracy',
    WS_Shell_Crusher = 'Weaponskill',
    WSAcc_Shell_Crusher = 'WeaponSkillAccuracy',
    WS_Full_Swing = 'Weaponskill',
    WSAcc_Full_Swing = 'WeaponSkillAccuracy',
    WS_Spirit_Taker = 'Weaponskill',
    WSAcc_Spirit_Taker = 'WeaponSkillAccuracy',
    BlueMagic = 'BlueMagic',
    PhysicalBlueMagic = 'PhysicalBlueMagic',
    MagicalBlueMagic = 'Nuke',
    Song = 'Song',
    SongPrecast = 'SongPrecast',
    SongDebuff = 'SongDebuff',
    SongBuff = 'SongBuff',
    Summoning = 'Summoning',
    BloodPactRage = 'PetDamage',
    BloodPactWard = 'PetTank',
    AvatarPerp = 'Refresh',
    Snapshot = 'RangedPreshot',
    RangedPreshot = 'RangedPreshot',
    Ranged = 'RangedAccuracy',
    RangedMidshot = 'RangedAccuracy',
    RangedAccuracy = 'RangedAccuracy',
    RangedAttack = 'RangedAttack',
    QuickDraw = 'QuickDraw',
    Waltz = 'Cure',
    Flourish = 'Flourish',
    Steps = 'Accuracy',
    Samba = 'TP',
    Jump = 'Weaponskill',
    PetReady = 'PetDamage',
    PetMagic = 'PetMagic',
    PetTank = 'PetTank',
    Roll = 'Roll',
};

local styleAliases = {
    geomagic = 'GeoMagic',
    nuke = 'Nuke',
    fastcast = 'FastCast',
    idlerefresh = 'IdleRefresh',
};

local playstyleNames = {
    'GeoMagic',
    'Nuke',
    'FastCast',
    'IdleRefresh',
};

local numberRowBindings = {
    { key = 'NUMPAD.', displayKey = '.', label = 'Style-', literal = '/lac fwd styleprev', kind = 'action', toggle = '' },
    { key = 'NUMPAD0', displayKey = '0', label = 'Style+', literal = '/lac fwd stylenext', kind = 'action', toggle = '' },
    { key = 'NUMPAD1', displayKey = '1', label = 'Styles', literal = '/lac fwd styles', kind = 'action', toggle = '' },
    { key = 'NUMPAD2', displayKey = '2', label = 'Status', literal = '/lac fwd status', kind = 'command-only', toggle = '' },
    { key = 'NUMPAD3', displayKey = '3', label = 'Lockstyle', literal = '/lac fwd lockstyle', kind = 'action', toggle = '' },
    { key = 'NUMPAD4', displayKey = '4', label = 'Move', literal = '/lac fwd utility movement', kind = 'command-only', toggle = '' },
    { key = 'NUMPAD5', displayKey = '5', label = 'Craft', literal = '/lac fwd utility craft', kind = 'utility', toggle = '' },
    { key = 'NUMPAD6', displayKey = '6', label = 'Auto 1', literal = '/lac fwd palette missing', kind = 'command-only', toggle = '' },
    { key = 'NUMPAD7', displayKey = '7', label = 'Warp', literal = '/lac fwd warp', kind = 'action', toggle = '' },
    { key = 'NUMPAD8', displayKey = '8', label = 'Auto 2', literal = '/lac fwd palette missing', kind = 'command-only', toggle = '' },
    { key = 'NUMPAD9', displayKey = '9', label = 'Job 1', literal = '/lac fwd palette missing', kind = 'job', toggle = '' },
    { key = '', displayKey = '', label = 'Unbound', literal = '', kind = 'unbound', toggle = '' },
};

local DEFAULT_PLAYSTYLE = 'GeoMagic';
local STYLE_COMMANDS_TEXT = 'geomagic|nuke|fastcast|idlerefresh';
profile.ResistAliases = {
    allstatusres = 'StatusResist',
    ares = 'WindRes',
    bres = 'IceRes',
    charmres = 'CharmResist',
    charmresist = 'CharmResist',
    clearres = '',
    darkres = 'DarkRes',
    darkresist = 'DarkRes',
    darkresistance = 'DarkRes',
    dres = 'DarkRes',
    earthres = 'EarthRes',
    earthresist = 'EarthRes',
    earthresistance = 'EarthRes',
    eres = 'EarthRes',
    fireres = 'FireRes',
    fireresist = 'FireRes',
    fireresistance = 'FireRes',
    fres = 'FireRes',
    iceres = 'IceRes',
    iceresist = 'IceRes',
    iceresistance = 'IceRes',
    ires = 'IceRes',
    lightningres = 'LightningRes',
    lightningresist = 'LightningRes',
    lightningresistance = 'LightningRes',
    lightres = 'LightRes',
    lightresist = 'LightRes',
    lightresistance = 'LightRes',
    lres = 'LightningRes',
    nores = '',
    resistoff = '',
    resoff = '',
    sres = 'EarthRes',
    statusres = 'StatusResist',
    statusresist = 'StatusResist',
    thunderres = 'ThunderRes',
    thunderresist = 'ThunderRes',
    thunderresistance = 'ThunderRes',
    tres = 'LightningRes',
    wares = 'WaterRes',
    waterres = 'WaterRes',
    waterresist = 'WaterRes',
    waterresistance = 'WaterRes',
    windres = 'WindRes',
    windresist = 'WindRes',
    windresistance = 'WindRes',
    wires = 'WindRes',
    wres = 'WaterRes',
};
profile.DefenseAliases = {
    clearoverride = '',
    defenseoff = '',
    defoff = '',
    dt = 'Dt',
    eva = 'Evasion',
    evasion = 'Evasion',
    idlecity = 'IdleCity',
    idlecombat = 'IdleCombat',
    idlenoncombat = 'IdleNonCombat',
    magicdefense = 'MagicDefense',
    mdef = 'MagicDefense',
    mdt = 'MDT',
    nooverride = '',
    overrideoff = '',
    pdt = 'PDT',
    safe = 'Safe',
    survival = 'Survival',
    tank = 'Tank',
};
local oddLuaRefresh = {
    launcher = 'C:\\Users\\jakeb\\Projects\\FFXI Personal Server\\OddLua\\Run-OddLuaGameRefresh.cmd',
    statusPath = 'C:\\Users\\jakeb\\Projects\\FFXI Personal Server\\OddLua\\reports\\game-refresh\\latest-status.json',
    delaySeconds = 12,
    resourceDelaySeconds = 18,
    pollSeconds = 5,
    maxPolls = 48,
};

local setSecondarySlotLocks = {
    IdleCity = {
        Body = { 'Legs' },
    },
    InCity = {
        Body = { 'Legs' },
    },
    LightRes = {
        Body = { 'Hands' },
        Legs = { 'Feet' },
    },
};

local nativeDualWieldMainJobs = {
    DNC = 20,
    NIN = 10,
    THF = 20,
};

local setRequiresDualWieldSub = {};

local conditionalEquips = {};

profile.BuffItemOverlays = {
    Playstyle_IdleRefresh = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Oracle\'s Pigaches' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Oracle\'s Cap' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    IdleRefresh = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Oracle\'s Pigaches' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Oracle\'s Cap' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Idle = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Oracle\'s Pigaches' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Oracle\'s Cap' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    IdleCity = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Oracle\'s Pigaches' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Oracle\'s Cap' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    IdleCombat = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Creek M Clomps' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Wh. Rarab Cap +1' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 25679,
                ['name'] = 'Wh. Rarab Cap +1',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\white_rarab_cap_+1.lua',
            },
        },
    },
    IdleMaxMP = {
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Faerie Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    IdleNonCombat = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Oracle\'s Pigaches' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Oracle\'s Cap' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    InCity = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Movement = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Movement_City = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Movement_Night = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Movement_DuskToDawn = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Aftercast = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Oracle\'s Pigaches' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Oracle\'s Cap' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Dt = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Creek M Clomps' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Wh. Rarab Cap +1' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 25679,
                ['name'] = 'Wh. Rarab Cap +1',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\white_rarab_cap_+1.lua',
            },
        },
    },
    PDT = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Creek M Clomps' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Wh. Rarab Cap +1' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 25679,
                ['name'] = 'Wh. Rarab Cap +1',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\white_rarab_cap_+1.lua',
            },
        },
    },
    MDT = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    FireRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    IceRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    WindRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    EarthRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    ThunderRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    LightningRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    WaterRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    LightRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    DarkRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    CharmResist = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Ataractic Solea' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    Crafting = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
    Guard = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Creek M Clomps' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Wh. Rarab Cap +1' },
            afterUse = { Head = 'Walahra Turban' },
            item = {
                ['id'] = 25679,
                ['name'] = 'Wh. Rarab Cap +1',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\white_rarab_cap_+1.lua',
            },
        },
    },
    Refresh = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
        {
            condition = { type = 'missing_status', name = 'reraise', buffs = { 'reraise', 113 } },
            slots = { Head = 'Reraise Hairpin' },
            item = {
                ['id'] = 15211,
                ['name'] = 'Reraise Hairpin',
                ['effect'] = 'reraise',
                ['sourcePath'] = 'scripts\\items\\reraise_hairpin.lua',
            },
        },
    },
};

local mechanicsSwapPlanner = {
    ['loaded'] = true,
    ['plannerVersion'] = 4,
    ['baselineSet'] = 'Aftercast',
    ['negativeTickOwnershipKnown'] = true,
    ['ownedNegativeTickItems'] = {},
    ['supportedOpportunities'] = { 'hp_bridge_swap', 'mp_bridge_swap', 'negative_tick_avoidance' },
    ['explicitTransitions'] = {
        ['setmp'] = {
            ['available'] = true,
            ['sourceSet'] = 'IdleNonCombat',
            ['targetSet'] = 'IdleMaxMP',
            ['sourceEquipment'] = {
                ['Head'] = 'Oracle\'s Cap',
                ['Body'] = 'Oracle\'s Robe',
                ['Hands'] = 'Bagua Mitaines',
                ['Legs'] = 'Yigit Seraweels',
                ['Feet'] = 'Oracle\'s Pigaches',
                ['Neck'] = 'Beak Necklace',
                ['Waist'] = 'Hierarch Belt',
                ['Back'] = 'Intensifying Cape',
            },
            ['sourceVariants'] = {
                ['Ear1'] = {
                    {
                        ['item'] = '',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Abyssal Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Aesir Ear Pendant',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Astral Earring',
                        ['hp'] = -25,
                        ['mp'] = 25,
                    },
                    {
                        ['item'] = 'Black Earring',
                        ['hp'] = 0,
                        ['mp'] = 4,
                    },
                    {
                        ['item'] = 'Brutal Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Colossus\'s Earring',
                        ['hp'] = 10,
                        ['mp'] = 10,
                    },
                    {
                        ['item'] = 'Green Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Hirudinea Earring',
                        ['hp'] = -5,
                        ['mp'] = -5,
                    },
                    {
                        ['item'] = 'Incubus Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Loquac. Earring',
                        ['hp'] = 0,
                        ['mp'] = 30,
                    },
                    {
                        ['item'] = 'Moldavite Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Mythril Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Novio Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Pagondas Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Relaxing Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Sardonyx Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Silver Earring +1',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Star Earring',
                        ['hp'] = 0,
                        ['mp'] = 20,
                    },
                    {
                        ['item'] = 'Suppanomimi',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Titanis Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Wilderness Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                },
                ['Ear2'] = {
                    {
                        ['item'] = '',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Abyssal Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Aesir Ear Pendant',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Astral Earring',
                        ['hp'] = -25,
                        ['mp'] = 25,
                    },
                    {
                        ['item'] = 'Black Earring',
                        ['hp'] = 0,
                        ['mp'] = 4,
                    },
                    {
                        ['item'] = 'Brutal Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Colossus\'s Earring',
                        ['hp'] = 10,
                        ['mp'] = 10,
                    },
                    {
                        ['item'] = 'Green Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Hirudinea Earring',
                        ['hp'] = -5,
                        ['mp'] = -5,
                    },
                    {
                        ['item'] = 'Incubus Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Loquac. Earring',
                        ['hp'] = 0,
                        ['mp'] = 30,
                    },
                    {
                        ['item'] = 'Moldavite Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Mythril Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Novio Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Pagondas Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Relaxing Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Sardonyx Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Silver Earring +1',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Star Earring',
                        ['hp'] = 0,
                        ['mp'] = 20,
                    },
                    {
                        ['item'] = 'Suppanomimi',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Titanis Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Wilderness Earring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                },
                ['Ring1'] = {
                    {
                        ['item'] = '',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Alert Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Anniversary Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Aqua Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Archer\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Artificer\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Blobnag Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Clear Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Corneus Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Craftkeeper\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Craftmaster\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Dcl.Grd. Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Echad Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Emerald Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Empress Band',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Garnet Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Hard Leather Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Insect Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Karka Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Kupofried\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Leather Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Mana Ring',
                        ['hp'] = 0,
                        ['mp'] = 15,
                    },
                    {
                        ['item'] = 'Marksman\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Opal Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Pearl Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Portus Annulet',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Portus Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Serket Ring',
                        ['hp'] = -50,
                        ['mp'] = 50,
                    },
                    {
                        ['item'] = 'Shadow Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Sniper\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Snow Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Succor Ring',
                        ['hp'] = 0,
                        ['mp'] = 30,
                    },
                    {
                        ['item'] = 'Tavnazian Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Vivian Ring',
                        ['hp'] = -50,
                        ['mp'] = 50,
                    },
                    {
                        ['item'] = 'Warp Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Zircon Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                },
                ['Ring2'] = {
                    {
                        ['item'] = '',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Alert Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Anniversary Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Aqua Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Archer\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Artificer\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Blobnag Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Clear Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Corneus Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Craftkeeper\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Craftmaster\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Dcl.Grd. Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Echad Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Emerald Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Empress Band',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Garnet Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Hard Leather Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Insect Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Karka Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Kupofried\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Leather Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Mana Ring',
                        ['hp'] = 0,
                        ['mp'] = 15,
                    },
                    {
                        ['item'] = 'Marksman\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Opal Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Pearl Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Portus Annulet',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Portus Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Serket Ring',
                        ['hp'] = -50,
                        ['mp'] = 50,
                    },
                    {
                        ['item'] = 'Shadow Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Sniper\'s Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Snow Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Succor Ring',
                        ['hp'] = 0,
                        ['mp'] = 30,
                    },
                    {
                        ['item'] = 'Tavnazian Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Vivian Ring',
                        ['hp'] = -50,
                        ['mp'] = 50,
                    },
                    {
                        ['item'] = 'Warp Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                    {
                        ['item'] = 'Zircon Ring',
                        ['hp'] = 0,
                        ['mp'] = 0,
                    },
                },
            },
            ['targetEquipment'] = {
                ['Head'] = 'Faerie Hairpin',
                ['Body'] = 'Oracle\'s Robe',
                ['Hands'] = 'Oracle\'s Gloves',
                ['Legs'] = 'Yigit Seraweels',
                ['Feet'] = 'Oracle\'s Pigaches',
                ['Neck'] = 'Beak Necklace',
                ['Waist'] = 'Hierarch Belt',
                ['Ear1'] = 'Loquac. Earring',
                ['Ear2'] = 'Star Earring',
                ['Ring1'] = 'Succor Ring',
                ['Ring2'] = 'Mana Ring',
                ['Back'] = 'Intensifying Cape',
            },
            ['slot'] = 'Body',
            ['sourceItem'] = 'Oracle\'s Robe',
            ['bridgeItem'] = 'Dalmatica',
            ['finalItem'] = 'Oracle\'s Robe',
            ['conversionAmount'] = 50,
            ['bridgeHpCost'] = 70,
            ['hpCost'] = 70,
            ['mpGain'] = 30,
            ['sourceKnownHp'] = 105,
            ['sourceKnownMp'] = 214,
            ['targetHp'] = 85,
            ['targetMp'] = 343,
            ['targetMpGain'] = -31,
            ['sourcePath'] = 'C:\\Users\\jakeb\\Projects\\FFXI Personal Server\\server\\sql\\item_mods.sql',
            ['sourceText'] = 'item_mods item_id=13787 mod_id=7 mod_name=CONVHPTOMP value=50',
        },
        ['avoidtick'] = {
            ['available'] = false,
            ['reason'] = 'no_owned_negative_tick_items',
            ['actions'] = {},
        },
    },
    ['transitions'] = {},
    ['skippedTransitions'] = {},
};
mechanicsSwapPlanner.transitions['GeoMagic'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'GeoMagic',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Main',
            ['itemId'] = 17567,
            ['item'] = 'Kirin\'s Pole',
            ['reason'] = 'pool delta HP+20, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 155,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Nuke'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Nuke',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['FastCast'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'FastCast',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 55,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 279,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['IdleRefresh'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'IdleRefresh',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 18624,
            ['item'] = 'Numen Staff',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 16156,
            ['item'] = 'Oracle\'s Cap',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 27016,
            ['item'] = 'Bagua Mitaines',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 11377,
            ['item'] = 'Oracle\'s Pigaches',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16263,
            ['item'] = 'Beak Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 15295,
            ['item'] = 'Hierarch Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 15492,
            ['item'] = 'Intensifying Cape',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 279,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Idle'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Idle',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 18624,
            ['item'] = 'Numen Staff',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 16156,
            ['item'] = 'Oracle\'s Cap',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 27016,
            ['item'] = 'Bagua Mitaines',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 11377,
            ['item'] = 'Oracle\'s Pigaches',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16263,
            ['item'] = 'Beak Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 15295,
            ['item'] = 'Hierarch Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14792,
            ['item'] = 'Relaxing Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14646,
            ['item'] = 'Shadow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11635,
            ['item'] = 'Alert Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 15492,
            ['item'] = 'Intensifying Cape',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 279,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Resting'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Resting',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Hands',
            ['itemId'] = 15022,
            ['item'] = 'Oracle\'s Gloves',
            ['reason'] = 'pool delta HP+15, MP+4',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Back',
            ['itemId'] = 15494,
            ['item'] = 'Invigorating Cape',
            ['reason'] = 'pool delta HP-30, MP-30, MPP+1',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 18624,
            ['item'] = 'Numen Staff',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 16156,
            ['item'] = 'Oracle\'s Cap',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16263,
            ['item'] = 'Beak Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 15295,
            ['item'] = 'Hierarch Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14792,
            ['item'] = 'Relaxing Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 11366,
            ['item'] = 'Avocat Pigaches',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 228,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 1,
        },
    },
};
mechanicsSwapPlanner.transitions['InCity'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'InCity',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 25726,
            ['item'] = 'Kupo Suit',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 85,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 259,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['PDT'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'PDT',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15859,
            ['item'] = 'Succor Ring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Sub',
            ['itemId'] = 19016,
            ['item'] = 'Raptor Strap +1',
            ['reason'] = 'pool delta HP+15, MP-15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Neck',
            ['itemId'] = 13072,
            ['item'] = 'Bird Whistle',
            ['reason'] = 'pool delta HP+5, MP-20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16056,
            ['item'] = 'Pagondas Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11630,
            ['item'] = 'Corneus Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 15492,
            ['item'] = 'Intensifying Cape',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17552,
            ['item'] = 'Terra\'s Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 255,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 180,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['MDT'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'MDT',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Sub',
            ['itemId'] = 19016,
            ['item'] = 'Raptor Strap +1',
            ['reason'] = 'pool delta HP+15, MP-15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13343,
            ['item'] = 'Green Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13448,
            ['item'] = 'Emerald Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 197,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 187,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['FireRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'FireRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13331,
            ['item'] = 'Sardonyx Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13477,
            ['item'] = 'Garnet Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 245,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['IceRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'IceRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13331,
            ['item'] = 'Sardonyx Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13470,
            ['item'] = 'Clear Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 245,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WindRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WindRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13343,
            ['item'] = 'Green Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13448,
            ['item'] = 'Emerald Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14392,
            ['item'] = 'Carpenter\'s Apron',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 245,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['EarthRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'EarthRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13343,
            ['item'] = 'Green Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14392,
            ['item'] = 'Carpenter\'s Apron',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14830,
            ['item'] = 'Carpenter\'s Gloves',
            ['reason'] = 'pool delta MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 225,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['ThunderRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'ThunderRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13083,
            ['item'] = 'Chain Choker',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 225,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['LightningRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'LightningRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13083,
            ['item'] = 'Chain Choker',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 225,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WaterRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WaterRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13083,
            ['item'] = 'Chain Choker',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 245,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['LightRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'LightRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13483,
            ['item'] = 'Pearl Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13483,
            ['item'] = 'Pearl Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 11309,
            ['item'] = 'Benedight Coat',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 16364,
            ['item'] = 'Benedight Hose',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 85,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 204,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['DarkRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'DarkRes',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 13320,
            ['item'] = 'Black Earring',
            ['reason'] = 'pool delta MP+4',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 229,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['CharmResist'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'CharmResist',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 15705,
            ['item'] = 'Ataractic Solea',
            ['reason'] = 'pool delta HP+7, MP-3',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13343,
            ['item'] = 'Green Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13448,
            ['item'] = 'Emerald Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 182,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 227,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['TP'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'TP',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 21125,
            ['item'] = 'Tamaxchi',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12296,
            ['item'] = 'Genbu\'s Shield',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 57,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Hybrid'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Hybrid',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Sub',
            ['itemId'] = 19016,
            ['item'] = 'Raptor Strap +1',
            ['reason'] = 'pool delta HP+15, MP-15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17552,
            ['item'] = 'Terra\'s Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14527,
            ['item'] = 'Yigit Gomlek',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 155,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['TPAccuracy'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'TPAccuracy',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 21125,
            ['item'] = 'Tamaxchi',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12296,
            ['item'] = 'Genbu\'s Shield',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 57,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 117,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['CombatSkillup'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'CombatSkillup',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15198,
            ['item'] = 'Sprout Beret',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 90,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 254,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['MagicSkillup'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'MagicSkillup',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15198,
            ['item'] = 'Sprout Beret',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 90,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 254,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Proc'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Proc',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17116,
            ['item'] = 'Misery Staff',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 254,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Precast'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Precast',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 55,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 279,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['ElementalPrecast'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'ElementalPrecast',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 27016,
            ['item'] = 'Bagua Mitaines',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 55,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 279,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Guard'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Guard',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15859,
            ['item'] = 'Succor Ring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Neck',
            ['itemId'] = 13072,
            ['item'] = 'Bird Whistle',
            ['reason'] = 'pool delta HP+5, MP-20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16056,
            ['item'] = 'Pagondas Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 230,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 210,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['SIRD'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'SIRD',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17413,
            ['item'] = 'Hermit\'s Wand',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 90,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 229,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Midcast'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Midcast',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Main',
            ['itemId'] = 17567,
            ['item'] = 'Kirin\'s Pole',
            ['reason'] = 'pool delta HP+20, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 40,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['CurePrecast'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'CurePrecast',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 28640,
            ['item'] = 'Hierarch\'s Mantle',
            ['reason'] = 'pool delta HP-30, MP-15',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 60,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 299,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Cure'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Cure',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 19048,
            ['item'] = 'Reign Grip',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 16064,
            ['item'] = 'Yigit Turban',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 14123,
            ['item'] = 'Zenith Pumps',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15949,
            ['item'] = 'Pythia Sash',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = -20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 85,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Healing'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Healing',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 19048,
            ['item'] = 'Reign Grip',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 16064,
            ['item'] = 'Yigit Turban',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 14123,
            ['item'] = 'Zenith Pumps',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15949,
            ['item'] = 'Pythia Sash',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = -20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 85,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Enhancing'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Enhancing',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 229,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['EnhancingDuration'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'EnhancingDuration',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 249,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Spikes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Spikes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 21125,
            ['item'] = 'Tamaxchi',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 16180,
            ['item'] = 'Harpy Shield',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 48,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Refresh'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Refresh',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 249,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Regen'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Regen',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 249,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['SneakInvisible'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'SneakInvisible',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 249,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Barspell'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Barspell',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 229,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Phalanx'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Phalanx',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 229,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Aquaveil'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Aquaveil',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 229,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Haste'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Haste',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 249,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Enfeebling'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Enfeebling',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Main',
            ['itemId'] = 17567,
            ['item'] = 'Kirin\'s Pole',
            ['reason'] = 'pool delta HP+20, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 40,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Sleep'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Sleep',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 141,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Bind'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Bind',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 141,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Burn'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Burn',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Choke'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Choke',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Drown'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Drown',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Frost'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Frost',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17548,
            ['item'] = 'Aquilo\'s Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Gravity'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Gravity',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 141,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Silence'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Silence',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Slow'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Slow',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Paralyze'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Paralyze',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Poison'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Poison',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 141,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Rasp'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Rasp',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Shock'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Shock',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Blind'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Blind',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 141,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Dispel'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Dispel',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 141,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Dia'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Dia',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13155,
            ['item'] = 'Enfeebling Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Bio'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Bio',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Divine'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Divine',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['DarkMagic'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'DarkMagic',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['DrainAspir'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'DrainAspir',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 26664,
            ['item'] = 'Bagua Galero',
            ['reason'] = 'pool delta HP-15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16054,
            ['item'] = 'Hirudinea Earring',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 15,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 113,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Absorb'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Absorb',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Stun'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Stun',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 123,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Geomancy'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Geomancy',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Main',
            ['itemId'] = 17567,
            ['item'] = 'Kirin\'s Pole',
            ['reason'] = 'pool delta HP+20, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 155,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['IndiDuration'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'IndiDuration',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Main',
            ['itemId'] = 17567,
            ['item'] = 'Kirin\'s Pole',
            ['reason'] = 'pool delta HP+20, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 180,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Ninjutsu'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Ninjutsu',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 21125,
            ['item'] = 'Tamaxchi',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 16180,
            ['item'] = 'Harpy Shield',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 70,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 93,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Utsusemi'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Utsusemi',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15606,
            ['item'] = 'Yigit Seraweels',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13328,
            ['item'] = 'Mythril Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11635,
            ['item'] = 'Alert Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14527,
            ['item'] = 'Yigit Gomlek',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 55,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 210,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['NinjutsuEnfeeble'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'NinjutsuEnfeeble',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Main',
            ['itemId'] = 17567,
            ['item'] = 'Kirin\'s Pole',
            ['reason'] = 'pool delta HP+20, MP-5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 90,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 138,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weaponskill'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weaponskill',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15224,
            ['item'] = 'Empress Hairpin',
            ['reason'] = 'pool delta HP-30, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10943,
            ['item'] = 'Moepapa Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15292,
            ['item'] = 'Penitent\'s Rope',
            ['reason'] = 'pool delta HP-20, MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 75,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WeaponSkillAccuracy'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WeaponSkillAccuracy',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15224,
            ['item'] = 'Empress Hairpin',
            ['reason'] = 'pool delta HP-30, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = -15,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 110,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSElemental'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSElemental',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11631,
            ['item'] = 'Blobnag Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10943,
            ['item'] = 'Moepapa Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 155,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['JobAbility'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'JobAbility',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11630,
            ['item'] = 'Corneus Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15208,
            ['item'] = 'Baron\'s Chapeau',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 90,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 254,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Enmity'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Enmity',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11630,
            ['item'] = 'Corneus Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 21125,
            ['item'] = 'Tamaxchi',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12296,
            ['item'] = 'Genbu\'s Shield',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15208,
            ['item'] = 'Baron\'s Chapeau',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 90,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 204,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Fire'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Fire',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Fire'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Fire',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Fire'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Fire',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Ice'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Ice',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17548,
            ['item'] = 'Aquilo\'s Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Ice'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Ice',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Ice'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Ice',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Wind'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Wind',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Wind'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Wind',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Wind'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Wind',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Earth'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Earth',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Earth'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Earth',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Earth'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Earth',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Thunder'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Thunder',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Thunder'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Thunder',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Thunder'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Thunder',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Lightning'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Lightning',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Lightning'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Lightning',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Lightning'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Lightning',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Water'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Water',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Water'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Water',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Water'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Water',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Light'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Light',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Light'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Light',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Light'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Light',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Elemental_Dark'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Elemental_Dark',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Weather_Dark'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weather_Dark',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Day_Dark'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Day_Dark',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 22199,
            ['item'] = 'Omni Grip',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-12',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11589,
            ['item'] = 'Aesir Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 73,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Stoneskin'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Stoneskin',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Main',
            ['itemId'] = 17567,
            ['item'] = 'Kirin\'s Pole',
            ['reason'] = 'pool delta HP+20, MP-5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 19048,
            ['item'] = 'Reign Grip',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 27368,
            ['item'] = 'Bagua Sandals',
            ['reason'] = 'pool delta HP-15, MP-7',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13177,
            ['item'] = 'Stone Gorget',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 118,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Cursna'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Cursna',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'pool delta MP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15545,
            ['item'] = 'Tamas Ring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17413,
            ['item'] = 'Hermit\'s Wand',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 50,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 205,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['StatusRemoval'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'StatusRemoval',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'pool delta MP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'pool delta HP+35, MP+25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15545,
            ['item'] = 'Tamas Ring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 17413,
            ['item'] = 'Hermit\'s Wand',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 50,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 225,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['DivineDamage'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'DivineDamage',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 19780,
            ['item'] = 'Mana Ampulla',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Main',
            ['itemId'] = 18633,
            ['item'] = 'Chatoyant Staff',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 19048,
            ['item'] = 'Reign Grip',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 80,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Seraph_Strike'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Seraph_Strike',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Seraph_Strike'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Seraph_Strike',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Brainshaker'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Brainshaker',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13477,
            ['item'] = 'Garnet Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15219,
            ['item'] = 'Sinister Mask',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 92,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Brainshaker'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Brainshaker',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 120,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 89,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Starlight'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Starlight',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13167,
            ['item'] = 'Storm Gorget',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 77,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Starlight'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Starlight',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 144,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Moonlight'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Moonlight',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13167,
            ['item'] = 'Storm Gorget',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 77,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 173,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Moonlight'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Moonlight',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 144,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Skullbreaker'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Skullbreaker',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13477,
            ['item'] = 'Garnet Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15219,
            ['item'] = 'Sinister Mask',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 92,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Skullbreaker'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Skullbreaker',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 120,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 89,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_True_Strike'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_True_Strike',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13477,
            ['item'] = 'Garnet Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15219,
            ['item'] = 'Sinister Mask',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 92,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_True_Strike'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_True_Strike',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 120,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 89,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Judgment'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Judgment',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 15,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 95,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Judgment'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Judgment',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 35,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Hexa_Strike'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Hexa_Strike',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 15,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 95,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Hexa_Strike'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Hexa_Strike',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta MP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 180,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Heavy_Swing'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Heavy_Swing',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13477,
            ['item'] = 'Garnet Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15219,
            ['item'] = 'Sinister Mask',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 92,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Heavy_Swing'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Heavy_Swing',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 120,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 89,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Rock_Crusher'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Rock_Crusher',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 135,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Rock_Crusher'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Rock_Crusher',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 165,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Earth_Crusher'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Earth_Crusher',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13486,
            ['item'] = 'Zircon Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28445,
            ['item'] = 'Charmer\'s Sash',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 135,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Earth_Crusher'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Earth_Crusher',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14006,
            ['item'] = 'Zenith Mitts',
            ['reason'] = 'pool delta MP-21, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 27192,
            ['item'] = 'Bagua Pants',
            ['reason'] = 'pool delta HP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 165,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Starburst'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Starburst',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Starburst'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Starburst',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Sunburst'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Sunburst',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Sunburst'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Sunburst',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14724,
            ['item'] = 'Moldavite Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28062,
            ['item'] = 'Ornate Gloves',
            ['reason'] = 'pool delta MP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14247,
            ['item'] = 'Zenith Slacks',
            ['reason'] = 'pool delta HP-25, MP-25, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'pool delta MP-23',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11000,
            ['item'] = 'Swith Cape',
            ['reason'] = 'pool delta HP-50, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Shell_Crusher'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Shell_Crusher',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13477,
            ['item'] = 'Garnet Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15219,
            ['item'] = 'Sinister Mask',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 92,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Shell_Crusher'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Shell_Crusher',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 120,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 89,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Full_Swing'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Full_Swing',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 14632,
            ['item'] = 'Aqua Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13477,
            ['item'] = 'Garnet Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15219,
            ['item'] = 'Sinister Mask',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 12593,
            ['item'] = 'Cotton Doublet',
            ['reason'] = 'pool delta HP-13, MP-13',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-48',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 92,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Full_Swing'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Full_Swing',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 14837,
            ['item'] = 'Creek M Mitts',
            ['reason'] = 'pool delta HP+65, MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Feet',
            ['itemId'] = 14202,
            ['item'] = 'Creek M Clomps',
            ['reason'] = 'pool delta HP+20, MP-60',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 16052,
            ['item'] = 'Incubus Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14325,
            ['item'] = 'Seer\'s Slacks',
            ['reason'] = 'pool delta HP-25, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 15523,
            ['item'] = 'Chivalrous Chain',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15286,
            ['item'] = 'Tilt Belt',
            ['reason'] = 'pool delta MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10973,
            ['item'] = 'Oneiros Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 120,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 89,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Spirit_Taker'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Spirit_Taker',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 13877,
            ['item'] = 'Zenith Crown +1',
            ['reason'] = 'pool delta HP-15, MP-25, CONVHPTOMP+55',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 13787,
            ['item'] = 'Dalmatica',
            ['reason'] = 'pool delta HP-20, MP-20, CONVHPTOMP+50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14935,
            ['item'] = 'Yigit Gages',
            ['reason'] = 'pool delta MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15292,
            ['item'] = 'Penitent\'s Rope',
            ['reason'] = 'pool delta HP-20, MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = -20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 65,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Spirit_Taker'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Spirit_Taker',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 27767,
            ['item'] = 'Erudite Cap',
            ['reason'] = 'pool delta HP-15, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 11283,
            ['item'] = 'Oracle\'s Robe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14741,
            ['item'] = 'Abyssal Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 14935,
            ['item'] = 'Yigit Gages',
            ['reason'] = 'pool delta MP-21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14302,
            ['item'] = 'Mahatma Slops',
            ['reason'] = 'pool delta HP-25, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Feet',
            ['itemId'] = 15690,
            ['item'] = 'Yigit Crackows',
            ['reason'] = 'pool delta HP-15, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15292,
            ['item'] = 'Penitent\'s Rope',
            ['reason'] = 'pool delta HP-20, MP-48',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11575,
            ['item'] = 'Grapevine Cape',
            ['reason'] = 'pool delta HP-30, MP-30',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 105,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 279,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.skippedTransitions['IdleCity'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['IdleCombat'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['IdleMaxMP'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['IdleMaxHP'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['IdleNonCombat'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['Movement'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Movement_City'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Movement_Night'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Movement_DuskToDawn'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Dt'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Crafting'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['SIRD_NIN'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['ConserveMP'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['CureWeather_Light'] = 'runtime_overlay';
mechanicsSwapPlanner.skippedTransitions['CureDay_Light'] = 'runtime_overlay';

local blueMagicRoutes = {
    ['1000 needles'] = 'MagicalBlueMagic',
    ['actinic burst'] = 'Enfeebling',
    ['amorphic spikes'] = 'PhysicalBlueMagic',
    ['amplification'] = 'Enhancing',
    ['animating wail'] = 'Enhancing',
    ['asuran claws'] = 'PhysicalBlueMagic',
    ['auroral drape'] = 'Enfeebling',
    ['awful eye'] = 'Enfeebling',
    ['bad breath'] = 'MagicalBlueMagic',
    ['battery charge'] = 'Enhancing',
    ['battle dance'] = 'PhysicalBlueMagic',
    ['blank gaze'] = 'Enfeebling',
    ['blastbomb'] = 'MagicalBlueMagic',
    ['blitzstrahl'] = 'MagicalBlueMagic',
    ['blood drain'] = 'MagicalBlueMagic',
    ['blood saber'] = 'MagicalBlueMagic',
    ['bludgeon'] = 'PhysicalBlueMagic',
    ['body slam'] = 'PhysicalBlueMagic',
    ['bomb toss'] = 'MagicalBlueMagic',
    ['cannonball'] = 'PhysicalBlueMagic',
    ['chaotic eye'] = 'Enfeebling',
    ['charged whisker'] = 'MagicalBlueMagic',
    ['cimicine discharge'] = 'Enfeebling',
    ['claw cyclone'] = 'PhysicalBlueMagic',
    ['cocoon'] = 'Enhancing',
    ['cold wave'] = 'Enfeebling',
    ['corrosive ooze'] = 'MagicalBlueMagic',
    ['cursed sphere'] = 'MagicalBlueMagic',
    ['death ray'] = 'MagicalBlueMagic',
    ['death scissors'] = 'PhysicalBlueMagic',
    ['delta thrust'] = 'PhysicalBlueMagic',
    ['diamondhide'] = 'Enhancing',
    ['digest'] = 'MagicalBlueMagic',
    ['dimensional death'] = 'PhysicalBlueMagic',
    ['disseverment'] = 'PhysicalBlueMagic',
    ['dream flower'] = 'Enfeebling',
    ['empty thrash'] = 'PhysicalBlueMagic',
    ['enervation'] = 'Enfeebling',
    ['exuviation'] = 'Cure',
    ['eyes on me'] = 'MagicalBlueMagic',
    ['feather barrier'] = 'Enhancing',
    ['feather storm'] = 'PhysicalBlueMagic',
    ['feather tickle'] = 'Enfeebling',
    ['filamented hold'] = 'Enfeebling',
    ['firespit'] = 'MagicalBlueMagic',
    ['flying hip press'] = 'MagicalBlueMagic',
    ['foot kick'] = 'PhysicalBlueMagic',
    ['frenetic rip'] = 'PhysicalBlueMagic',
    ['frightful roar'] = 'Enfeebling',
    ['frost breath'] = 'MagicalBlueMagic',
    ['frypan'] = 'PhysicalBlueMagic',
    ['geist wall'] = 'Enfeebling',
    ['goblin rush'] = 'PhysicalBlueMagic',
    ['grand slam'] = 'PhysicalBlueMagic',
    ['head butt'] = 'PhysicalBlueMagic',
    ['healing breeze'] = 'Cure',
    ['heat breath'] = 'MagicalBlueMagic',
    ['heavy strike'] = 'PhysicalBlueMagic',
    ['hecatomb wave'] = 'MagicalBlueMagic',
    ['helldive'] = 'PhysicalBlueMagic',
    ['hydro shot'] = 'PhysicalBlueMagic',
    ['hysteric barrage'] = 'PhysicalBlueMagic',
    ['ice break'] = 'MagicalBlueMagic',
    ['infrasonics'] = 'Enfeebling',
    ['jet stream'] = 'PhysicalBlueMagic',
    ['jettatura'] = 'Enfeebling',
    ['light of penance'] = 'Enfeebling',
    ['lowing'] = 'Enfeebling',
    ['maelstrom'] = 'MagicalBlueMagic',
    ['magic fruit'] = 'Cure',
    ['magic hammer'] = 'MagicalBlueMagic',
    ['magnetite cloud'] = 'MagicalBlueMagic',
    ['mandibular bite'] = 'PhysicalBlueMagic',
    ['memento mori'] = 'Enhancing',
    ['metallic body'] = 'Enhancing',
    ['mind blast'] = 'MagicalBlueMagic',
    ['mp drainkiss'] = 'MagicalBlueMagic',
    ['mysterious light'] = 'MagicalBlueMagic',
    ['occultation'] = 'Enhancing',
    ['pinecone bomb'] = 'PhysicalBlueMagic',
    ['plasma charge'] = 'Enhancing',
    ['plenilune embrace'] = 'Cure',
    ['poison breath'] = 'MagicalBlueMagic',
    ['pollen'] = 'Cure',
    ['power attack'] = 'PhysicalBlueMagic',
    ['quad continuum'] = 'PhysicalBlueMagic',
    ['quadrastrike'] = 'PhysicalBlueMagic',
    ['queasyshroom'] = 'PhysicalBlueMagic',
    ['radiant breath'] = 'MagicalBlueMagic',
    ['ram charge'] = 'PhysicalBlueMagic',
    ['reactor cool'] = 'Enhancing',
    ['refueling'] = 'Enhancing',
    ['regeneration'] = 'Enhancing',
    ['regurgitation'] = 'MagicalBlueMagic',
    ['rending deluge'] = 'MagicalBlueMagic',
    ['saline coat'] = 'Enhancing',
    ['sandspin'] = 'MagicalBlueMagic',
    ['sandspray'] = 'Enfeebling',
    ['screwdriver'] = 'PhysicalBlueMagic',
    ['seedspray'] = 'PhysicalBlueMagic',
    ['self destruct'] = 'MagicalBlueMagic',
    ['sheep song'] = 'Enfeebling',
    ['sickle slash'] = 'PhysicalBlueMagic',
    ['smite of rage'] = 'PhysicalBlueMagic',
    ['soporific'] = 'Enfeebling',
    ['sound blast'] = 'Enfeebling',
    ['spinal cleave'] = 'PhysicalBlueMagic',
    ['spiral spin'] = 'PhysicalBlueMagic',
    ['sprout smack'] = 'PhysicalBlueMagic',
    ['stinking gas'] = 'Enfeebling',
    ['sub zero smash'] = 'PhysicalBlueMagic',
    ['sudden lunge'] = 'PhysicalBlueMagic',
    ['tail slap'] = 'PhysicalBlueMagic',
    ['temporal shift'] = 'Enfeebling',
    ['terror touch'] = 'PhysicalBlueMagic',
    ['thermal pulse'] = 'MagicalBlueMagic',
    ['triumphant roar'] = 'Enhancing',
    ['uppercut'] = 'PhysicalBlueMagic',
    ['venom shell'] = 'Enfeebling',
    ['vertical cleave'] = 'PhysicalBlueMagic',
    ['voracious trunk'] = 'Enfeebling',
    ['warm up'] = 'Enhancing',
    ['whirl of rage'] = 'PhysicalBlueMagic',
    ['white wind'] = 'Cure',
    ['wild carrot'] = 'Cure',
    ['wild oats'] = 'PhysicalBlueMagic',
    ['wind breath'] = 'MagicalBlueMagic',
    ['yawn'] = 'Enfeebling',
    ['zephyr mantle'] = 'Enhancing',
};

local weaponSkillRoutes = {
    ['brainshaker'] = 'WS_Brainshaker',
    ['earth_crusher'] = 'WS_Earth_Crusher',
    ['full_swing'] = 'WS_Full_Swing',
    ['heavy_swing'] = 'WS_Heavy_Swing',
    ['hexa_strike'] = 'WS_Hexa_Strike',
    ['judgment'] = 'WS_Judgment',
    ['moonlight'] = 'WS_Moonlight',
    ['rock_crusher'] = 'WS_Rock_Crusher',
    ['seraph_strike'] = 'WS_Seraph_Strike',
    ['shell_crusher'] = 'WS_Shell_Crusher',
    ['skullbreaker'] = 'WS_Skullbreaker',
    ['spirit_taker'] = 'WS_Spirit_Taker',
    ['starburst'] = 'WS_Starburst',
    ['starlight'] = 'WS_Starlight',
    ['sunburst'] = 'WS_Sunburst',
    ['true_strike'] = 'WS_True_Strike',
};

local weaponSkillAccuracyRoutes = {
    ['brainshaker'] = 'WSAcc_Brainshaker',
    ['earth_crusher'] = 'WSAcc_Earth_Crusher',
    ['full_swing'] = 'WSAcc_Full_Swing',
    ['heavy_swing'] = 'WSAcc_Heavy_Swing',
    ['hexa_strike'] = 'WSAcc_Hexa_Strike',
    ['judgment'] = 'WSAcc_Judgment',
    ['moonlight'] = 'WSAcc_Moonlight',
    ['rock_crusher'] = 'WSAcc_Rock_Crusher',
    ['seraph_strike'] = 'WSAcc_Seraph_Strike',
    ['shell_crusher'] = 'WSAcc_Shell_Crusher',
    ['skullbreaker'] = 'WSAcc_Skullbreaker',
    ['spirit_taker'] = 'WSAcc_Spirit_Taker',
    ['starburst'] = 'WSAcc_Starburst',
    ['starlight'] = 'WSAcc_Starlight',
    ['sunburst'] = 'WSAcc_Sunburst',
    ['true_strike'] = 'WSAcc_True_Strike',
};





local OVERT_DEFENSE_TARGET_COUNT = 3;
local OVERT_DEFENSE_TP_UNLOCK = 700;
local OVERT_DEFENSE_HP_FORCE_HPP = 60;

local dangerousStatusBuffs = {
    bind = true,
    doom = true,
    ['gradual petrification'] = true,
    petrification = true,
    sleep = true,
    stun = true,
    terror = true,
};

local dangerousStatusIds = { 2, 7, 10, 11, 15, 18, 19, 28 };

local cityZoneIds = {
    [26] = true,  -- Tavnazian Safehold
    [48] = true,  -- Al Zahbi
    [50] = true,  -- Aht Urhgan Whitegate
    [53] = true,  -- Nashmau
    [80] = true,  -- Southern San d'Oria [S]
    [87] = true,  -- Bastok Markets [S]
    [94] = true,  -- Windurst Waters [S]
    [230] = true, -- Southern San d'Oria
    [231] = true, -- Northern San d'Oria
    [232] = true, -- Port San d'Oria
    [233] = true, -- Chateau d'Oraguille
    [234] = true, -- Bastok Mines
    [235] = true, -- Bastok Markets
    [236] = true, -- Port Bastok
    [237] = true, -- Metalworks
    [238] = true, -- Windurst Waters
    [239] = true, -- Windurst Walls
    [240] = true, -- Port Windurst
    [241] = true, -- Windurst Woods
    [242] = true, -- Heavens Tower
    [243] = true, -- Ru'Lude Gardens
    [244] = true, -- Upper Jeuno
    [245] = true, -- Lower Jeuno
    [246] = true, -- Port Jeuno
    [247] = true, -- Rabao
    [248] = true, -- Selbina
    [249] = true, -- Mhaura
    [250] = true, -- Kazham
    [252] = true, -- Norg
    [256] = true, -- Western Adoulin
    [257] = true, -- Eastern Adoulin
};

local cityAreas = {
    ["southern san d'oria"] = true,
    ["northern san d'oria"] = true,
    ["port san d'oria"] = true,
    ["chateau d'oraguille"] = true,
    ["bastok mines"] = true,
    ["bastok markets"] = true,
    ["port bastok"] = true,
    ["metalworks"] = true,
    ["windurst waters"] = true,
    ["windurst walls"] = true,
    ["port windurst"] = true,
    ["windurst woods"] = true,
    ["heavens tower"] = true,
    ["ru'lude gardens"] = true,
    ["upper jeuno"] = true,
    ["lower jeuno"] = true,
    ["port jeuno"] = true,
    ["aht urhgan whitegate"] = true,
    ["al zahbi"] = true,
    ["nashmau"] = true,
    ["tavnazian safehold"] = true,
    ["rabao"] = true,
    ["selbina"] = true,
    ["mhaura"] = true,
    ["norg"] = true,
    ["kazham"] = true,
    ["western adoulin"] = true,
    ["eastern adoulin"] = true,
    ["residential area"] = true,
    ["southern san d'oria [s]"] = true,
    ["bastok markets [s]"] = true,
    ["windurst waters [s]"] = true,
};

local equipmentSlots = {
    'Main',
    'Sub',
    'Range',
    'Ammo',
    'Head',
    'Neck',
    'Ear1',
    'Ear2',
    'Body',
    'Hands',
    'Ring1',
    'Ring2',
    'Back',
    'Waist',
    'Legs',
    'Feet',
};

local scale = nil;
if gFunc and gFunc.LoadFile then
    local ok, loaded = pcall(function()
        return gFunc.LoadFile('common/scale.lua');
    end);
    if ok then
        scale = loaded;
    end
end

local conditionals = nil;
if gFunc and gFunc.LoadFile then
    local ok, loaded = pcall(function()
        return gFunc.LoadFile('common/conditionals.lua');
    end);
    if ok then
        conditionals = loaded;
    end
end

local function message(text)
    text = '[Oddone GEO] ' .. tostring(text or '');
    if gFunc and gFunc.Message then
        gFunc.Message(text);
    else
        print(text);
    end
end

local function queueTypedCommand(command, mode)
    if not AshitaCore or not AshitaCore.GetChatManager then
        return false;
    end

    local chatManager = AshitaCore:GetChatManager();
    if not chatManager or not chatManager.QueueCommand then
        return false;
    end

    local ok = pcall(function()
        chatManager:QueueCommand(mode or 1, command);
    end);
    return ok == true;
end

local function nowSeconds()
    if os and os.time then
        return os.time();
    elseif os and os.clock then
        return os.clock();
    end
    return 0;
end

local function scheduleTask(delay, callback)
    if ashita and ashita.tasks and ashita.tasks.once then
        local ok = pcall(function()
            ashita.tasks.once(delay, callback);
        end);
        return ok == true;
    end
    return false;
end

local function normalize(value)
    return string.lower(tostring(value or ''));
end

profile.BuffItemContainers = { 0, 8, 10, 11, 12, 13, 14, 15, 16 };

function profile.BuffItemOverlaysEnabled()
    return state.BuffItemOverlaysEnabled == true;
end

function profile.BuffItemOverlayStateText()
    if profile.BuffItemOverlaysEnabled() then
        return 'on';
    end
    return 'off';
end

function profile.HandleBuffItemOverlayCommand(args)
    local value = normalize(args and args[2]);
    if value == 'on' or value == 'enable' or value == 'enabled' or value == 'true' or value == '1' then
        state.BuffItemOverlaysEnabled = true;
        message('Buff item overlays=on.');
    elseif value == 'off' or value == 'disable' or value == 'disabled' or value == 'false' or value == '0' then
        state.BuffItemOverlaysEnabled = false;
        message('Buff item overlays=off.');
    elseif value == '' or value == 'status' or value == 'help' then
        message('Buff item overlays=' .. profile.BuffItemOverlayStateText() .. '; use /lac fwd buffitems on|off|status.');
    else
        message('Unknown buffitems command. Use /lac fwd buffitems on|off|status.');
    end
end

function profile.BuffItemInventory()
    if not AshitaCore then
        return nil;
    end

    if AshitaCore.GetMemoryManager then
        local okManager, manager = pcall(function()
            return AshitaCore:GetMemoryManager();
        end);
        if okManager and manager and manager.GetInventory then
            local okInventory, inventory = pcall(function()
                return manager:GetInventory();
            end);
            if okInventory and inventory then
                return inventory;
            end
        end
    end

    if AshitaCore.GetDataManager then
        local okManager, manager = pcall(function()
            return AshitaCore:GetDataManager();
        end);
        if okManager and manager and manager.GetInventory then
            local okInventory, inventory = pcall(function()
                return manager:GetInventory();
            end);
            if okInventory and inventory then
                return inventory;
            end
        end
    end

    return nil;
end

function profile.BuffItemContainerMax(inventory, container)
    if not inventory then
        return 80;
    end

    local maxValue = nil;
    if inventory.GetContainerMax then
        pcall(function()
            maxValue = inventory:GetContainerMax(container);
        end);
    end
    if maxValue == nil and inventory.GetContainerCountMax then
        pcall(function()
            maxValue = inventory:GetContainerCountMax(container);
        end);
    end
    if maxValue == nil and inventory.GetContainerItemCount then
        pcall(function()
            maxValue = inventory:GetContainerItemCount(container);
        end);
    end

    maxValue = tonumber(maxValue);
    if maxValue ~= nil and maxValue >= 0 and maxValue <= 200 then
        return maxValue;
    end
    return 80;
end

function profile.BuffItemContainerItem(inventory, container, index)
    if not inventory then
        return nil;
    end

    if inventory.GetContainerItem then
        local ok, item = pcall(function()
            return inventory:GetContainerItem(container, index);
        end);
        if ok and item then
            return item;
        end
    end
    if inventory.GetItem then
        local ok, item = pcall(function()
            return inventory:GetItem(container, index);
        end);
        if ok and item then
            return item;
        end
    end
    return nil;
end

function profile.BuffItemEntryId(entry)
    if type(entry) ~= 'table' or type(entry.item) ~= 'table' then
        return nil;
    end
    return tonumber(entry.item.id or entry.item.Id or entry.item.itemId or entry.item.ItemId);
end

function profile.BuffItemRuntimeItemId(item)
    local itemType = type(item);
    if itemType ~= 'table' and itemType ~= 'userdata' then
        return nil;
    end
    return tonumber(item.Id or item.id or item.ItemId or item.itemId or item.Item or item.item);
end

function profile.BuffItemRuntimeItemCount(item)
    local itemType = type(item);
    if itemType ~= 'table' and itemType ~= 'userdata' then
        return nil;
    end
    return tonumber(item.Count or item.count or item.Quantity or item.quantity or item.Charges or item.charges or item.Uses or item.uses);
end

function profile.BuffItemHasUsesLeft(entry)
    local wantedId = profile.BuffItemEntryId(entry);
    if wantedId == nil then
        return false;
    end

    local inventory = profile.BuffItemInventory();
    if not inventory then
        return false;
    end

    for _, container in ipairs(profile.BuffItemContainers or {}) do
        local maxIndex = profile.BuffItemContainerMax(inventory, container);
        for index = 0, maxIndex do
            local item = profile.BuffItemContainerItem(inventory, container, index);
            if profile.BuffItemRuntimeItemId(item) == wantedId then
                local count = profile.BuffItemRuntimeItemCount(item);
                if count ~= nil and count > 0 then
                    return true;
                end
            end
        end
    end
    return false;
end

local function styleListText()
    local parts = {};
    for _, styleName in ipairs(playstyleNames) do
        local token = normalize(styleName);
        local label = token;
        if styleName == state.Playstyle and styleName == DEFAULT_PLAYSTYLE then
            label = label .. ' (current, default)';
        elseif styleName == state.Playstyle then
            label = label .. ' (current)';
        elseif styleName == DEFAULT_PLAYSTYLE then
            label = label .. ' (default)';
        end
        parts[#parts + 1] = label;
    end
    if #parts == 0 then
        return STYLE_COMMANDS_TEXT;
    end
    return table.concat(parts, ' | ');
end

local function printStyleList()
    message('Styles: ' .. styleListText() .. '. Use /lac fwd style <name>.');
end

local function printOddLuaHelp()
    message('Quick start: /lac fwd help | styles | status | keypad | lockstyle | weaponsync | warp | subjob | buffitems | pdt | fireres | guard | mode.');
    message('Current style=' .. tostring(state.Playstyle) .. '; default=' .. tostring(DEFAULT_PLAYSTYLE) .. '.');
    printStyleList();
    message('Lockstyle: /lac fwd lockstyle equips the TP set first, then /lockstyle on.');
    message('Weapon sync: /lac fwd weaponsync deliberately equips only the active style Main/Sub/Range through Scale and may reset TP; the weapon lock is restored immediately.');
    message('Keypad macros: /lac fwd keypad shows keypad map; /lac fwd keypad off disables; /lac fwd keypad clear unbinds keypad and old number-row keys.');
    message('Buff item overlays: /lac fwd buffitems on|off|status.');
    message('Conditional overlays: /lac fwd overlays.');
    message('Magic Burst mode: /lac fwd burst on|off|status (default off).');


    message('Guard mode: /lac fwd guard on|off|status (default off; active only while engaged with Guard skill and Hand-to-Hand/unarmed).');

    message('Gear modes: /lac fwd mode combat|magic|proc|off|status (default off; Proc deliberately swaps Main and may reset TP).');
    message('Defensive overrides: /lac fwd pdt|mdt|dt|evasion|safe|survival|tank|defenseoff.');
    message('Resist overrides: /lac fwd fireres|iceres|earthres|windres|waterres|thunderres|lightningres|lightres|darkres|statusres|charmres|resoff.');
    message('Idle pool floors: /lac fwd setmp <n>|addmp <n>|resetmp and sethp <n>|addhp <n>|resethp.');
    message('Update gear: /lac fwd updategear; status: /lac fwd updategear status.');
end

local function oddLuaStatusField(text, field)
    if type(text) ~= 'string' then
        return nil;
    end
    local pattern = '"' .. field .. '"%s*:%s*"([^"]*)"';
    return string.match(text, pattern);
end

local function readOddLuaRefreshStatus()
    if not io or not io.open then
        return nil, 'io.open unavailable';
    end

    local file = io.open(oddLuaRefresh.statusPath, 'rb');
    if not file then
        return nil, 'status not ready';
    end

    local text = file:read('*a') or '';
    file:close();
    local status = normalize(oddLuaStatusField(text, 'state') or oddLuaStatusField(text, 'status') or '');
    local detail = oddLuaStatusField(text, 'message') or '';
    if status == '' then
        return nil, 'status missing';
    end
    return status, detail;
end

local function pollOddLuaRefreshStatus(attempt)
    attempt = tonumber(attempt or 1) or 1;
    local status, detail = readOddLuaRefreshStatus();
    if status == 'success' then
        state.OddLuaRefreshPending = false;
        state.OddLuaRefreshLastStatus = 'success';
        message('OddLua gear refresh complete. Reloading LuAshitacast profile.');
        queueTypedCommand('/lac reload', 1);
        return;
    elseif status == 'failed' or status == 'error' then
        state.OddLuaRefreshPending = false;
        state.OddLuaRefreshLastStatus = 'failed';
        message('OddLua gear refresh failed: ' .. tostring(detail or '') .. '. Use /lac fwd refreshgear status.');
        return;
    end

    state.OddLuaRefreshLastStatus = status or 'running';
    if attempt >= oddLuaRefresh.maxPolls then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh still running or status unavailable after polling. Use /lac fwd refreshgear status.');
        return;
    end

    if not scheduleTask(oddLuaRefresh.pollSeconds, function()
        pollOddLuaRefreshStatus(attempt + 1);
    end) then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh poll scheduling failed. Use /lac fwd refreshgear status.');
    end
end

local function launchOddLuaGearRefresh()
    if not ashita or not ashita.misc or not ashita.misc.execute then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed: command launcher unavailable in this runtime.');
        return false;
    end

    local ok, err = pcall(function()
        ashita.misc.execute(oddLuaRefresh.launcher, '');
    end);
    if not ok then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed to launch.');
        return false;
    end

    message('OddLua refresh launched. Polling status.');
    pollOddLuaRefreshStatus(1);
    return true;
end

local function startOddLuaGearRefresh(args)
    local option = normalize(args and args[2]);
    if option == 'status' then
        local status, detail = readOddLuaRefreshStatus();
        message('OddLua refresh status=' .. tostring(status or state.OddLuaRefreshLastStatus or 'unknown') .. '; detail=' .. tostring(detail or '') .. '; pending=' .. tostring(state.OddLuaRefreshPending == true));
        return;
    end

    if state.OddLuaRefreshPending == true then
        message('OddLua gear refresh is already pending; use /lac fwd refreshgear status.');
        return;
    end

    local includeResources = option == 'resources' or option == 'full';
    if not queueTypedCommand('/gearexport full', 1) then
        message('OddLua gear refresh failed: could not queue /gearexport full.');
        return;
    end

    state.OddLuaRefreshPending = true;
    state.OddLuaRefreshLastStatus = 'queued';
    if includeResources then
        if not scheduleTask(2, function()
            queueTypedCommand('/gearexport resources', 1);
        end) then
            queueTypedCommand('/gearexport resources', 1);
        end
    end

    local delay = oddLuaRefresh.delaySeconds;
    if includeResources then
        delay = oddLuaRefresh.resourceDelaySeconds;
    end
    message('Queued /gearexport full. OddLua rebuild/apply will launch in ' .. tostring(delay) .. ' seconds.');
    if not scheduleTask(delay, launchOddLuaGearRefresh) then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed: scheduler unavailable after gearexport.');
    end
end

profile.OddLuaRuntime = profile.OddLuaRuntime or {};
profile.OddLuaRuntime.Hysteresis = {
    EmergencyHpEnterHpp = 35,
    EmergencyHpExitHpp = 40,
    IdlePoolBand = 10,
};
profile.OddLuaRuntime.MountedStatusBuffs = { 'chocobo', 'mount', 'mounted', 252 };
profile.OddLuaRuntime.EncumbranceStatusBuffs = { 'encumbrance', 177, 259 };

profile.OddLuaRuntime.StatusRemovalSpells = {
    blindna = true,
    cursna = true,
    erase = true,
    esuna = true,
    paralyna = true,
    poisona = true,
    sacrifice = true,
    silena = true,
    stona = true,
    viruna = true,
};

function profile.OddLuaRuntime.GetPlayer()
    if not gData or not gData.GetPlayer then
        return nil;
    end
    local ok, player = pcall(gData.GetPlayer);
    if ok == true and type(player) == 'table' then
        return player;
    end
    return nil;
end

function profile.OddLuaRuntime.GetEnvironment()
    if not gData or not gData.GetEnvironment then
        return nil;
    end
    local ok, environment = pcall(gData.GetEnvironment);
    if ok ~= true or type(environment) ~= 'table' then
        return nil;
    end
    if AshitaCore and AshitaCore.GetMemoryManager then
        local okZone, zoneId = pcall(function()
            return AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
        end);
        if okZone then
            environment.ZoneId = zoneId;
        end
    end
    return environment;
end

local function movementEquipItemName(item)
    if type(item) == 'string' then
        return item;
    elseif type(item) == 'table' then
        if item.Name ~= nil then
            return item.Name;
        elseif item.name ~= nil then
            return item.name;
        elseif type(item.Resource) == 'table' and type(item.Resource.Name) == 'table' then
            return item.Resource.Name[1];
        elseif type(item.Item) == 'table' and item.Item.Name ~= nil then
            return item.Item.Name;
        end
    end
    return nil;
end

function profile.OddLuaRuntime.PlayerIsMoving(player)
    if type(player) ~= 'table' then
        return false;
    end
    local value = player.IsMoving;
    if value == nil then value = player.isMoving; end
    if value == nil then value = player.Moving; end
    if value == nil then value = player.moving; end
    local text = normalize(value);
    return value == true or text == 'true' or text == '1' or text == 'yes';
end

local function movementSafetyActive()
    if next(movementPenaltyItems) == nil then
        return false;
    end
    local player = profile.OddLuaRuntime.GetPlayer();
    if profile.OddLuaRuntime.PlayerIsMoving(player) ~= true then
        return false;
    end
    if type(profile.OddLuaRuntime.IsOnFoot) == 'function' then
        local ok, onFoot = pcall(profile.OddLuaRuntime.IsOnFoot, player);
        if ok == true and onFoot ~= true then
            return false;
        end
    end
    return true;
end

local function movementSafeEquipSet(set)
    local safe = {};
    if type(set) ~= 'table' then
        return safe;
    end
    for slot, item in pairs(set) do
        safe[slot] = item;
    end
    if movementSafetyActive() ~= true then
        return safe;
    end

    local observed = nil;
    if gData and gData.GetEquipment then
        local ok, equipment = pcall(gData.GetEquipment);
        if ok == true and type(equipment) == 'table' then
            observed = equipment;
        end
    end

    for slot, names in pairs(movementPenaltyItems) do
        local requestedName = normalize(movementEquipItemName(safe[slot]));
        if requestedName ~= '' and names[requestedName] == true then
            safe[slot] = 'remove';
        elseif safe[slot] == nil then
            local observedName = '';
            if observed ~= nil then
                observedName = normalize(movementEquipItemName(observed[slot]));
            end
            if observed == nil or (observedName ~= '' and names[observedName] == true) then
                safe[slot] = 'remove';
            end
        end
    end
    return safe;
end

profile.OddLuaRuntime.MovementSafeEquipSet = movementSafeEquipSet;

function profile.OddLuaRuntime.PlayerContextReady(player)
    if type(player) ~= 'table' then
        return false;
    end
    local name = tostring(player.Name or player.name or '');
    local hp = tonumber(player.HP or player.hp or player.CurrentHP or player.currentHP);
    local hpp = tonumber(
        player.HPP or player.hpp or player.HPPercent or player.hpPercent
        or player.HPPercentage or player.hpPercentage
    );
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    if name == '' or hp == nil or hp <= 0 then
        return false;
    end
    if hpp == nil or hpp <= 0 then
        return false;
    end
    if status == '' or status == 'unknown' or status == 'dead' or status == 'zoning'
        or status == '2' or status == '3' or status == '4' then
        return false;
    end
    return true;
end


local reconciliationConfig = {
    schema = 'oddlua.reconcile.v1',
    player = 'Oddone',
    playerId = '29938',
    job = 'GEO',
    logPath = 'logs/oddlua-reconcile-Oddone_29938-GEO.jsonl',
    slotOrder = {
    'Main',
    'Sub',
    'Range',
    'Ammo',
    'Head',
    'Neck',
    'Ear1',
    'Ear2',
    'Body',
    'Hands',
    'Ring1',
    'Ring2',
    'Back',
    'Waist',
    'Legs',
    'Feet',
    },
};

profile.ReconciliationNameAliases = {
    groups = {
        { 'Abyssal Earring', 'abyssal_earring' },
        { 'Aesir Ear Pendant', 'aesir_ear_pendant' },
        { 'Aesir Torque', 'aesir_torque' },
        { 'Aife\'s Medal', 'aifes_medal' },
        { 'Alert Ring', 'alert_ring' },
        { 'Aqua Ring', 'aqua_ring' },
        { 'Aquilo\'s Staff', 'aquilos_staff' },
        { 'Ataractic Solea', 'ataractic_solea' },
        { 'Avocat Pigaches', 'avocat_pigaches' },
        { 'Bagua Galero', 'bagua_galero' },
        { 'Bagua Mitaines', 'bagua_mitaines' },
        { 'Bagua Pants', 'bagua_pants' },
        { 'Bagua Sandals', 'bagua_sandals' },
        { 'Baron\'s Chapeau', 'barons_chapeau' },
        { 'Battle Boots', 'battle_boots' },
        { 'Beak Necklace', 'beak_necklace' },
        { 'Benedight Coat', 'benedight_coat' },
        { 'Benedight Hose', 'benedight_hose' },
        { 'Bird Whistle', 'bird_whistle' },
        { 'Black Earring', 'black_earring' },
        { 'Blobnag Ring', 'blobnag_ring' },
        { 'Brutal Earring', 'brutal_earring' },
        { 'Carpenter\'s Apron', 'carpenters_apron' },
        { 'Carpenter\'s Gloves', 'carpenters_gloves' },
        { 'Chain Choker', 'chain_choker' },
        { 'Charmer\'s Sash', 'shetal_stone' },
        { 'Chatoyant Staff', 'chatoyant_staff' },
        { 'Chivalrous Chain', 'chivalrous_chain' },
        { 'Clear Ring', 'clear_ring' },
        { 'Colossus\'s Earring', 'colossuss_earring' },
        { 'Colossus\'s Mantle', 'colossuss_mantle' },
        { 'Colossus\'s Torque', 'colossuss_torque' },
        { 'Corneus Ring', 'corneus_ring' },
        { 'Cotton Doublet', 'cotton_doublet' },
        { 'Creek M Clomps', 'creek_m_clomps' },
        { 'Creek M Mitts', 'creek_m_mitts' },
        { 'Dalmatica', 'dalmatica' },
        { 'Emerald Ring', 'emerald_ring' },
        { 'Empress Hairpin', 'empress_hairpin' },
        { 'Enfeebling Torque', 'enfeebling_torque' },
        { 'Erudite Cap', 'buremte_hat' },
        { 'Faerie Hairpin', 'faerie_hairpin' },
        { 'Garnet Ring', 'garnet_ring' },
        { 'Genbu\'s Shield', 'genbus_shield' },
        { 'Grapevine Cape', 'grapevine_cape' },
        { 'Green Earring', 'green_earring' },
        { 'Harpy Shield', 'harpy_shield' },
        { 'Headlong Belt', 'headlong_belt' },
        { 'Hedgehog Bomb', 'hedgehog_bomb' },
        { 'Hermit\'s Wand', 'hermits_wand' },
        { 'Hierarch Belt', 'hierarch_belt' },
        { 'Hierarch\'s Mantle', 'pahtli_cape' },
        { 'Hirudinea Earring', 'hirudinea_earring' },
        { 'Incubus Earring', 'incubus_earring' },
        { 'Insect Ring', 'insect_ring' },
        { 'Intensifying Cape', 'intensifying_cape' },
        { 'Invigorating Cape', 'invigorating_cape' },
        { 'Karka Ring', 'karka_ring' },
        { 'Kirin\'s Pole', 'kirins_pole' },
        { 'Kupo Suit', 'kupo_suit' },
        { 'Leather Ring', 'leather_ring' },
        { 'Loquac. Earring', 'loquac._earring', 'loquacious_earring' },
        { 'Mahatma Slops', 'mahatma_slops' },
        { 'Mana Ampulla', 'mana_ampulla' },
        { 'Mana Ring', 'mana_ring' },
        { 'Misery Staff', 'misery_staff' },
        { 'Moepapa Medal', 'moepapa_medal' },
        { 'Moldavite Earring', 'moldavite_earring' },
        { 'Morion Tathlum', 'morion_tathlum' },
        { 'Mountain Gaiters', 'mountain_gaiters' },
        { 'Mythril Earring', 'mythril_earring' },
        { 'Novio Earring', 'novio_earring' },
        { 'Numen Staff', 'numen_staff' },
        { 'Omni Grip', 'thrace_strap' },
        { 'Oneiros Cape', 'oneiros_cape' },
        { 'Oracle\'s Cap', 'oracles_cap' },
        { 'Oracle\'s Gloves', 'oracles_gloves' },
        { 'Oracle\'s Pigaches', 'oracles_pigaches' },
        { 'Oracle\'s Robe', 'oracles_robe' },
        { 'Ornate Gloves', 'quauhpilli_gloves' },
        { 'Pagondas Earring', 'pagondas_earring' },
        { 'Pearl Ring', 'pearl_ring' },
        { 'Penitent\'s Rope', 'penitents_rope' },
        { 'Portus Annulet', 'portus_annulet' },
        { 'Pythia Sash', 'pythia_sash' },
        { 'Raptor Strap +1', 'raptor_leather_strap_+1', 'raptor_strap_+1' },
        { 'Reign Grip', 'reign_grip' },
        { 'Relaxing Earring', 'relaxing_earring' },
        { 'Salire Belt', 'salire_belt' },
        { 'Sardonyx Earring', 'sardonyx_earring' },
        { 'Seer\'s Slacks', 'seers_slacks' },
        { 'Shadow Ring', 'shadow_ring' },
        { 'Sinister Mask', 'sinister_mask' },
        { 'Sniper\'s Ring', 'snipers_ring' },
        { 'Snow Ring', 'snow_ring' },
        { 'Sprout Beret', 'sprout_beret' },
        { 'Star Earring', 'star_earring' },
        { 'Stone Gorget', 'stone_gorget' },
        { 'Storm Gorget', 'storm_gorget' },
        { 'Succor Ring', 'succor_ring' },
        { 'Swith Cape', 'swith_cape' },
        { 'Tamas Ring', 'tamas_ring' },
        { 'Tamaxchi', 'tamaxchi' },
        { 'Terra\'s Staff', 'terras_staff' },
        { 'Tilt Belt', 'tilt_belt' },
        { 'Walahra Turban', 'walahra_turban' },
        { 'Wilderness Earring', 'handlers_earring' },
        { 'Yigit Crackows', 'yigit_crackows' },
        { 'Yigit Gages', 'yigit_gages' },
        { 'Yigit Gomlek', 'yigit_gomlek' },
        { 'Yigit Seraweels', 'yigit_seraweels' },
        { 'Yigit Turban', 'yigit_turban' },
        { 'Zenith Crown +1', 'zenith_crown_+1' },
        { 'Zenith Mitts', 'zenith_mitts' },
        { 'Zenith Pumps', 'zenith_pumps' },
        { 'Zenith Slacks', 'zenith_slacks' },
        { 'Zircon Ring', 'zircon_ring' },
    },
    aliases = {},
};

function profile.ReconciliationNameAliases.Base(value)
    if type(value) == 'table' then
        value = value.Name or value.name or '';
    end
    local text = normalize(value);
    text = string.gsub(text, '_', ' ');
    text = string.gsub(text, '[%p%c]+', ' ');
    text = string.gsub(text, '%s+', ' ');
    text = string.gsub(text, '^%s+', '');
    text = string.gsub(text, '%s+$', '');
    return text;
end

function profile.ReconciliationNameAliases.Register(names)
    local canonical = nil;
    for _, name in ipairs(names or {}) do
        local text = profile.ReconciliationNameAliases.Base(name);
        if text ~= '' and canonical == nil then
            canonical = text;
        end
    end
    if canonical == nil then
        return;
    end
    for _, name in ipairs(names or {}) do
        local text = profile.ReconciliationNameAliases.Base(name);
        if text ~= '' then
            profile.ReconciliationNameAliases.aliases[text] = canonical;
        end
    end
end

for _, names in ipairs(profile.ReconciliationNameAliases.groups) do
    profile.ReconciliationNameAliases.Register(names);
end

function profile.ReconciliationNameAliases.Canonical(value)
    local text = profile.ReconciliationNameAliases.Base(value);
    return profile.ReconciliationNameAliases.aliases[text] or text;
end

local function reconciliationJsonEscape(value)
    value = tostring(value or '');
    value = string.gsub(value, '\\', '\\\\');
    value = string.gsub(value, '"', '\\"');
    value = string.gsub(value, '\r', '\\r');
    value = string.gsub(value, '\n', '\\n');
    value = string.gsub(value, '\t', '\\t');
    return '"' .. value .. '"';
end

local function reconciliationJsonBool(value)
    if value == true then
        return 'true';
    end
    return 'false';
end

local function ensureReconciliationLogDirectory()
    if state.ReconcileLogDirectoryReady == true then
        return true;
    end

    if ashita and ashita.fs and ashita.fs.exists and ashita.fs.exists('logs') then
        state.ReconcileLogDirectoryReady = true;
        return true;
    end

    if ashita and ashita.fs then
        if ashita.fs.create_directory then
            pcall(ashita.fs.create_directory, 'logs');
        elseif ashita.fs.create_dir then
            pcall(ashita.fs.create_dir, 'logs');
        end
    end

    state.ReconcileLogDirectoryReady = true;
    return true;
end

local function reconciliationExpectedName(value)
    if type(value) == 'string' then
        return value;
    elseif type(value) == 'table' then
        return value.Name or value.name or value[1];
    end
    return nil;
end

local function reconciliationExpectedMap(set)
    local expected = {};
    if type(set) ~= 'table' then
        return expected;
    end

    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local name = reconciliationExpectedName(set[slot]);
        if name ~= nil then
            expected[slot] = tostring(name);
        end
    end
    return expected;
end

local function reconciliationObservedField(value, key)
    if value == nil then
        return nil;
    end
    local ok, result = pcall(function()
        return value[key];
    end);
    if ok == true then
        return result;
    end
    return nil;
end

local function reconciliationObservedResource(entry)
    return reconciliationObservedField(entry, 'Resource')
        or reconciliationObservedField(entry, 'resource')
        or reconciliationObservedField(entry, 'Item')
        or reconciliationObservedField(entry, 'item')
        or entry;
end

local function reconciliationObservedLocalizedName(value)
    if type(value) == 'string' then
        return value;
    end
    return reconciliationObservedField(value, 1) or reconciliationObservedField(value, 0);
end

local function reconciliationObservedName(entry)
    if type(entry) == 'string' then
        return entry;
    end
    local directName = reconciliationObservedLocalizedName(
        reconciliationObservedField(entry, 'Name')
        or reconciliationObservedField(entry, 'name')
    );
    if directName ~= nil then
        return directName;
    end
    local resource = reconciliationObservedResource(entry);
    local name = reconciliationObservedField(resource, 'Name')
        or reconciliationObservedField(resource, 'name');
    return reconciliationObservedLocalizedName(name);
end

local function reconciliationObservedId(entry)
    local item = reconciliationObservedField(entry, 'Item')
        or reconciliationObservedField(entry, 'item');
    local resource = reconciliationObservedResource(entry);
    return tonumber(
        reconciliationObservedField(item, 'Id')
        or reconciliationObservedField(item, 'ID')
        or reconciliationObservedField(item, 'id')
        or reconciliationObservedField(entry, 'Id')
        or reconciliationObservedField(entry, 'ID')
        or reconciliationObservedField(entry, 'id')
        or reconciliationObservedField(resource, 'Id')
        or reconciliationObservedField(resource, 'ID')
        or reconciliationObservedField(resource, 'id')
    );
end

local function observeReconciliationEquipment()
    if not gData or not gData.GetEquipment then
        return nil, 'gData.GetEquipment unavailable';
    end

    local ok, equipment = pcall(gData.GetEquipment);
    if not ok then
        return nil, 'gData.GetEquipment failed';
    end
    if type(equipment) ~= 'table' then
        return nil, 'gData.GetEquipment returned non-table';
    end
    if next(equipment) == nil then
        return nil, 'gData.GetEquipment returned empty table';
    end

    local observed = {};
    local observedIds = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local name = reconciliationObservedName(equipment[slot]);
        if name ~= nil and tostring(name) ~= '' then
            observed[slot] = tostring(name);
        end
        local itemId = reconciliationObservedId(equipment[slot]);
        if itemId ~= nil and itemId > 0 then
            observedIds[slot] = itemId;
        end
    end
    return observed, nil, observedIds;
end

local function reconciliationNamesMatch(expected, observed)
    local expectedText = profile.ReconciliationNameAliases.Canonical(expected);
    local observedText = profile.ReconciliationNameAliases.Canonical(observed);
    if expectedText == 'remove' then
        return observedText == '';
    end
    return expectedText == observedText;
end

local function compareReconciliationSnapshot(setName, expected, observed)
    local mismatches = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local expectedName = expected[slot];
        if expectedName ~= nil then
            local observedName = observed[slot] or '';
            if not reconciliationNamesMatch(expectedName, observedName) then
                mismatches[#mismatches + 1] = {
                    slot = slot,
                    expected = tostring(expectedName),
                    observed = tostring(observedName),
                };
            end
        end
    end

    local status = 'match';
    if #mismatches > 0 then
        status = 'mismatch';
    end
    return {
        set = setName,
        status = status,
        mismatches = mismatches,
    };
end

local function encodeReconciliationMap(map)
    local parts = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        if map and map[slot] ~= nil then
            parts[#parts + 1] = reconciliationJsonEscape(slot) .. ':' .. reconciliationJsonEscape(map[slot]);
        end
    end
    return '{' .. table.concat(parts, ',') .. '}';
end

local function encodeReconciliationMismatches(mismatches)
    local parts = {};
    for _, mismatch in ipairs(mismatches or {}) do
        parts[#parts + 1] = '{'
            .. '"slot":' .. reconciliationJsonEscape(mismatch.slot)
            .. ',"expected":' .. reconciliationJsonEscape(mismatch.expected)
            .. ',"observed":' .. reconciliationJsonEscape(mismatch.observed)
            .. '}';
    end
    return '[' .. table.concat(parts, ',') .. ']';
end

local function encodeReconciliationSnapshot(snapshot)
    local parts = {};
    parts[#parts + 1] = '"schema":' .. reconciliationJsonEscape(reconciliationConfig.schema);
    parts[#parts + 1] = '"player":' .. reconciliationJsonEscape(reconciliationConfig.player);
    parts[#parts + 1] = '"playerId":' .. reconciliationJsonEscape(reconciliationConfig.playerId);
    parts[#parts + 1] = '"job":' .. reconciliationJsonEscape(reconciliationConfig.job);
    parts[#parts + 1] = '"profileBuildToken":' .. reconciliationJsonEscape(snapshot.profileBuildToken);
    parts[#parts + 1] = '"sequence":' .. tostring(snapshot.sequence or 0);
    parts[#parts + 1] = '"cycleSequence":' .. tostring(snapshot.cycleSequence or 0);
    parts[#parts + 1] = '"timestamp":' .. tostring(snapshot.timestamp or 0);
    parts[#parts + 1] = '"set":' .. reconciliationJsonEscape(snapshot.set);
    parts[#parts + 1] = '"status":' .. reconciliationJsonEscape(snapshot.status);
    parts[#parts + 1] = '"force":' .. reconciliationJsonBool(snapshot.force == true);
    parts[#parts + 1] = '"repair":' .. reconciliationJsonBool(snapshot.repair == true);
    parts[#parts + 1] = '"repairAttempt":' .. tostring(tonumber(snapshot.repairAttempt) or 0);
    parts[#parts + 1] = '"repairQueued":' .. reconciliationJsonBool(snapshot.repairQueued == true);
    parts[#parts + 1] = '"repairPaused":' .. reconciliationJsonBool(snapshot.repairPaused == true);
    parts[#parts + 1] = '"repairFailed":' .. reconciliationJsonBool(snapshot.repairFailed == true);
    parts[#parts + 1] = '"observationOnly":' .. reconciliationJsonBool(snapshot.observationOnly == true);
    parts[#parts + 1] = '"contextSignature":' .. reconciliationJsonEscape(snapshot.contextSignature);
    if snapshot.repairStrategy ~= nil and snapshot.repairStrategy ~= '' then
        parts[#parts + 1] = '"repairStrategy":' .. reconciliationJsonEscape(snapshot.repairStrategy);
    end
    parts[#parts + 1] = '"playstyle":' .. reconciliationJsonEscape(snapshot.playstyle);
    parts[#parts + 1] = '"intent":' .. reconciliationJsonEscape(snapshot.intent);
    if snapshot.actionProbeSequence ~= nil and snapshot.actionProbeSequence ~= '' then
        parts[#parts + 1] = '"actionProbeSequence":' .. reconciliationJsonEscape(snapshot.actionProbeSequence);
    end
    parts[#parts + 1] = '"expected":' .. encodeReconciliationMap(snapshot.expected);
    parts[#parts + 1] = '"observed":' .. encodeReconciliationMap(snapshot.observed);
    parts[#parts + 1] = '"mismatches":' .. encodeReconciliationMismatches(snapshot.mismatches);
    if snapshot.reason ~= nil then
        parts[#parts + 1] = '"reason":' .. reconciliationJsonEscape(snapshot.reason);
    end
    return '{' .. table.concat(parts, ',') .. '}';
end

local function writeReconciliationSnapshot(snapshot)
    if not io or not io.open then
        return false, 'io.open unavailable';
    end

    ensureReconciliationLogDirectory();
    local file, err = io.open(reconciliationConfig.logPath, 'ab');
    if not file then
        state.ReconcileLastWriteError = tostring(err or 'unknown write error');
        return false, state.ReconcileLastWriteError;
    end

    file:write(encodeReconciliationSnapshot(snapshot), '\n');
    file:close();
    state.ReconcileLastWriteError = nil;
    return true, nil;
end

local function reconciliationMismatchSlots(mismatches)
    local parts = {};
    for _, mismatch in ipairs(mismatches or {}) do
        parts[#parts + 1] = tostring(mismatch.slot);
    end
    if #parts == 0 then
        return 'none';
    end
    return table.concat(parts, ',');
end

local function reconciliationExpectedSignature(setName, expected)
    local parts = { tostring(setName or '') };
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        if expected and expected[slot] ~= nil then
            parts[#parts + 1] = tostring(slot) .. '=' .. tostring(expected[slot]);
        end
    end
    return table.concat(parts, '|');
end

profile.OddLuaRuntime.ReconciliationObservationSettleSeconds = 0.25;

function profile.OddLuaRuntime.ReconciliationContextSignature()
    local player = profile.OddLuaRuntime.GetPlayer();
    local environment = profile.OddLuaRuntime.GetEnvironment();
    local function jobText(value)
        local numeric = tonumber(value);
        if numeric ~= nil and jobIdToAbbr[numeric] ~= nil then
            return normalize(jobIdToAbbr[numeric]);
        end
        return normalize(value);
    end
    local function effectiveLevel(...)
        for index = 1, select('#', ...) do
            local candidate = select(index, ...);
            local value = tonumber(candidate);
            if value ~= nil then
                return value;
            end
        end
        return '';
    end
    local mainJob = '';
    local subJob = '';
    local mainLevel = '';
    local subLevel = '';
    local status = '';
    local moving = false;
    local tpPositive = false;
    if type(player) == 'table' then
        mainJob = jobText(player.MainJob or player.mainJob or player.MainJobName or player.mainJobName);
        subJob = jobText(player.SubJob or player.subJob or player.Subjob or player.subjob or player.SubJobName or player.subJobName);
        mainLevel = effectiveLevel(
            player.MainJobSync,
            player.mainJobSync,
            player.MainJobLevel,
            player.mainJobLevel,
            player.MainLevel,
            player.mainLevel
        );
        subLevel = effectiveLevel(
            player.SubJobSync,
            player.subJobSync,
            player.SubJobLevel,
            player.subJobLevel,
            player.SubLevel,
            player.subLevel
        );
        status = normalize(player.Status or player.status or player.StatusName or player.statusName);
        moving = profile.OddLuaRuntime.PlayerIsMoving(player) == true;
        local tp = tonumber(player.TP or player.tp or player.TacticalPoints or player.tacticalPoints);
        tpPositive = tp ~= nil and tp > 0;
    end
    local zone = '';
    local area = '';
    if type(environment) == 'table' then
        zone = tostring(environment.ZoneId or environment.zoneId or environment.Zone or environment.zone or '');
        area = normalize(environment.Area or environment.area or environment.ZoneName or environment.zoneName);
    end
    return table.concat({
        'moving=' .. tostring(moving),
        'mainJob=' .. tostring(mainJob),
        'mainLevel=' .. tostring(mainLevel),
        'subJob=' .. tostring(subJob),
        'subLevel=' .. tostring(subLevel),
        'tpPositive=' .. tostring(tpPositive),
        'status=' .. tostring(status),
        'zone=' .. tostring(zone),
        'area=' .. tostring(area),
        'movementSafety=' .. tostring(movementSafetyActive() == true),
    }, '|');
end

function profile.OddLuaRuntime.ReconciliationContextMatches(pending)
    return type(pending) == 'table'
        and type(pending.contextSignature) == 'string'
        and pending.contextSignature == profile.OddLuaRuntime.ReconciliationContextSignature();
end

local function reconciliationDelayForSet(setName)
    if state.IdleOverrideSet == setName then
        return 0.35;
    end
    local intent = normalize(setIntents[setName] or '');
    if intent == 'idle' or intent == 'movement' or intent == 'tp' then
        return 0.35;
    end
    return 0.08;
end

local function reconciliationCanRepairSet(setName, intent)
    if state.IdleOverrideSet == setName then
        return true;
    end
    local intentText = normalize(intent or '');
    return intentText == 'tp' or intentText == 'idle' or intentText == 'movement';
end

local reconciliationMaxRepairAttempts = 2;
local reconciliationResetBarrierDelaySeconds = 0.35;
local reconciliationResetBarrierSafeSlots = {
    Head = true,
    Neck = true,
    Ear1 = true,
    Ear2 = true,
    Body = true,
    Hands = true,
    Ring1 = true,
    Ring2 = true,
    Back = true,
    Waist = true,
    Legs = true,
    Feet = true,
};
local repairReconciliationMismatch;
local forceReconciliationExpected;
local scheduleReconciliationSnapshot;

local function cancelPendingReconciliationSnapshot()
    state.ReconcilePendingSnapshot = nil;
    state.ReconcileScanScheduled = false;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
end

function profile.OddLuaRuntime.QueueReconciliationObservationSettle(pending)
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    scheduleReconciliationSnapshot(
        pending.set,
        pending.expected,
        pending.force,
        pending.repair,
        pending.repairAttempt,
        {
            actionProbeSequence = pending.actionProbeSequence,
            profileBuildToken = pending.profileBuildToken,
            contextSignature = pending.contextSignature,
            cycleSequence = pending.cycleSequence,
            delaySeconds = profile.OddLuaRuntime.ReconciliationObservationSettleSeconds,
            observationOnly = true,
        }
    );
    return true;
end

local function recordPendingReconciliationSnapshot(token)
    if token ~= nil and token ~= state.ReconcileScanToken then
        return;
    end
    if state.ReconcileEnabled ~= true then
        state.ReconcileScanScheduled = false;
        state.ReconcilePendingSnapshot = nil;
        return;
    end

    local pending = state.ReconcilePendingSnapshot;
    state.ReconcileScanScheduled = false;
    state.ReconcilePendingSnapshot = nil;
    if type(pending) ~= 'table' then
        return;
    end
    local superseding = pending.repairSupersedingSnapshot;
    if type(superseding) == 'table' then
        -- The old intent's delay says nothing about how long the new set has
        -- been equipped. Yield without observing and grant the current intent
        -- its complete normal settle window.
        state.ReconcileLastRecordedSignature = nil;
        if profile.OddLuaRuntime.ReconciliationContextMatches(superseding) ~= true then
            return;
        end
        scheduleReconciliationSnapshot(
            superseding.set,
            superseding.expected,
            superseding.force,
            false,
            nil,
            {
                actionProbeSequence = superseding.actionProbeSequence,
                profileBuildToken = superseding.profileBuildToken,
                contextSignature = superseding.contextSignature,
            }
        );
        return;
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return;
    end

    local observed, reason = observeReconciliationEquipment();
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return;
    end
    local snapshot;
    if observed == nil then
        snapshot = {
            set = pending.set,
            status = 'unknown_observation',
            reason = reason or 'unknown observation failure',
            mismatches = {},
            expected = pending.expected,
            observed = {},
        };
    else
        snapshot = compareReconciliationSnapshot(pending.set, pending.expected, observed);
        snapshot.expected = pending.expected;
        snapshot.observed = observed;
    end

    snapshot.profileBuildToken = pending.profileBuildToken;
    snapshot.sequence = pending.sequence;
    snapshot.cycleSequence = pending.cycleSequence;
    snapshot.contextSignature = pending.contextSignature;
    snapshot.timestamp = nowSeconds();
    snapshot.force = pending.force == true;
    snapshot.repair = pending.repair == true;
    snapshot.repairAttempt = tonumber(pending.repairAttempt) or 0;
    snapshot.repairQueued = false;
    snapshot.repairFailed = false;
    snapshot.repairPaused = false;
    snapshot.observationOnly = pending.observationOnly == true;
    snapshot.playstyle = pending.playstyle;
    snapshot.intent = pending.intent;
    snapshot.actionProbeSequence = pending.actionProbeSequence;

    if snapshot.status == 'mismatch' and snapshot.observationOnly ~= true then
        local terminalRepairAttempt = snapshot.repair == true
            and snapshot.repairAttempt >= reconciliationMaxRepairAttempts;
        local actionNeedsSettle = snapshot.repair ~= true
            and tostring(snapshot.actionProbeSequence or '') ~= ''
            and reconciliationCanRepairSet(pending.set, pending.intent) ~= true;
        if terminalRepairAttempt or actionNeedsSettle then
            state.ReconcileLastRecordedSignature = nil;
            profile.OddLuaRuntime.QueueReconciliationObservationSettle(pending);
            return;
        end
    end

    local repairPauseReason = nil;
    local repairStrategy = nil;
    if snapshot.status == 'mismatch'
        and snapshot.observationOnly ~= true
        and repairReconciliationMismatch
    then
        snapshot.repairQueued, repairPauseReason, repairStrategy = repairReconciliationMismatch(pending, snapshot.mismatches);
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return;
    end
    snapshot.repairStrategy = repairStrategy;
    snapshot.repairPaused = repairPauseReason ~= nil;
    snapshot.repairFailed = snapshot.status == 'mismatch'
        and snapshot.observationOnly == true
        and snapshot.repair == true
        and snapshot.repairAttempt >= reconciliationMaxRepairAttempts;
    if repairPauseReason ~= nil then
        snapshot.reason = repairPauseReason;
    end
    state.ReconcileLast = snapshot;
    if snapshot.status == 'unknown_observation' or snapshot.repairPaused == true then
        state.ReconcileLastRecordedSignature = nil;
    else
        state.ReconcileLastRecordedSignature = pending.signature;
    end
    writeReconciliationSnapshot(snapshot);

    if snapshot.status == 'mismatch' and snapshot.repairQueued ~= true and snapshot.repairPaused ~= true then
        local repairText = '';
        if snapshot.repairFailed == true then
            repairText = '; repair=failed';
        end
        message('Reconcile mismatch set=' .. tostring(pending.set) .. '; slots=' .. reconciliationMismatchSlots(snapshot.mismatches) .. repairText .. '.');
    end
end

scheduleReconciliationSnapshot = function(setName, expectedSet, force, repair, repairAttempt, options)
    if state.ReconcileEnabled ~= true then
        return;
    end

    local expected = reconciliationExpectedMap(expectedSet);
    if repair ~= true and state.ReconcileCompositionActive == true then
        -- Default handling composes a complete baseline and one or more sparse
        -- overlays synchronously. Only its final request is an observable
        -- intent; intermediate layers must not become scheduler superseders.
        state.ReconcileCompositionPending = {
            set = setName,
            expected = expected,
            force = force == true,
        };
        return;
    end
    local metadata = type(options) == 'table' and options or {};
    local observationOnly = metadata.observationOnly == true;
    local profileBuildToken = tostring(metadata.profileBuildToken or profile.OddLuaBuildToken or '');
    local contextSignature = tostring(
        metadata.contextSignature or profile.OddLuaRuntime.ReconciliationContextSignature()
    );
    local actionProbeSequence = metadata.actionProbeSequence;
    if actionProbeSequence == nil then
        actionProbeSequence = profile.OddLuaRuntime.ActionProbeSequence;
    end
    actionProbeSequence = tostring(actionProbeSequence or '');
    local signature = reconciliationExpectedSignature(setName, expected)
        .. '|contextSignature=' .. contextSignature;
    local equipmentSignature = reconciliationExpectedSignature('', expected)
        .. '|contextSignature=' .. contextSignature;
    if actionProbeSequence ~= '' then
        signature = signature .. '|actionProbeSequence=' .. actionProbeSequence;
        equipmentSignature = equipmentSignature .. '|actionProbeSequence=' .. actionProbeSequence;
    end
    local scheduled = state.ReconcilePendingSnapshot;
    if repair ~= true
        and observationOnly ~= true
        and state.ReconcileScanScheduled == true
        and type(scheduled) == 'table'
    then
        -- Preserve one scheduler owner. Identical equipment can coalesce on
        -- its existing timer only in the same runtime context; a different
        -- final intent/context gets a complete fresh settle window.
        local hasSupersedingIntent = type(scheduled.repairSupersedingSnapshot) == 'table';
        if hasSupersedingIntent ~= true
            and contextSignature == scheduled.contextSignature
            and equipmentSignature == scheduled.equipmentSignature
        then
            if scheduled.repair ~= true then
                scheduled.set = setName;
                scheduled.expected = expected;
                scheduled.force = force == true;
                scheduled.playstyle = state.Playstyle;
                scheduled.intent = setIntents[setName] or '';
                scheduled.actionProbeSequence = actionProbeSequence;
                scheduled.signature = signature;
                scheduled.equipmentSignature = equipmentSignature;
            end
            return;
        end
        scheduled.repairSupersedingSnapshot = {
            profileBuildToken = profileBuildToken,
            set = setName,
            expected = expected,
            force = force == true,
            playstyle = state.Playstyle,
            intent = setIntents[setName] or '',
            actionProbeSequence = actionProbeSequence,
            contextSignature = contextSignature,
            signature = signature,
            equipmentSignature = equipmentSignature,
        };
        return;
    end
    if repair ~= true
        and observationOnly ~= true
        and signature == state.ReconcileLastRecordedSignature
    then
        cancelPendingReconciliationSnapshot();
        return;
    end

    local cycleSequence = tonumber(metadata.cycleSequence);
    if cycleSequence == nil then
        state.ReconcileCycleSeq = (state.ReconcileCycleSeq or 0) + 1;
        cycleSequence = state.ReconcileCycleSeq;
    end
    state.ReconcileSnapshotSeq = (state.ReconcileSnapshotSeq or 0) + 1;
    state.ReconcilePendingSnapshot = {
        profileBuildToken = profileBuildToken,
        sequence = state.ReconcileSnapshotSeq,
        cycleSequence = cycleSequence,
        contextSignature = contextSignature,
        set = setName,
        expected = expected,
        force = force == true,
        repair = repair == true,
        repairAttempt = repair == true and (tonumber(repairAttempt) or 1) or 0,
        observationOnly = observationOnly,
        playstyle = state.Playstyle,
        intent = setIntents[setName] or '',
        actionProbeSequence = actionProbeSequence,
        signature = signature,
        equipmentSignature = equipmentSignature,
    };

    if state.ReconcileScanScheduled == true then
        return;
    end

    state.ReconcileScanScheduled = true;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
    local token = state.ReconcileScanToken;
    local delaySeconds = tonumber(metadata.delaySeconds) or reconciliationDelayForSet(setName);
    if not scheduleTask(delaySeconds, function()
        recordPendingReconciliationSnapshot(token);
    end) then
        recordPendingReconciliationSnapshot(token);
    end
end

function profile.OddLuaRuntime.RunReconciliationComposition(callback)
    if state.ReconcileCompositionActive == true then
        return callback();
    end
    state.ReconcileCompositionActive = true;
    state.ReconcileCompositionPending = nil;
    local ok, result = pcall(callback);
    local pending = state.ReconcileCompositionPending;
    state.ReconcileCompositionPending = nil;
    state.ReconcileCompositionActive = false;
    if ok ~= true then
        -- The failed composition may already have changed gear. Invalidate any
        -- older observation, repair, or reset owner before propagating the
        -- error so its queued callback cannot act on stale intent.
        cancelPendingReconciliationSnapshot();
        state.ReconcileLastRecordedSignature = nil;
        error(result, 0);
    end
    if type(pending) == 'table' then
        scheduleReconciliationSnapshot(pending.set, pending.expected, pending.force, false, nil);
    end
    return result;
end

forceReconciliationExpected = function(pending)
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    if movementSafetyActive() == true and gFunc and gFunc.ForceEquipSet then
        local ok = pcall(function()
            gFunc.ForceEquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    elseif movementSafetyActive() == true and gFunc and gFunc.EquipSet then
        local ok = pcall(function()
            gFunc.EquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    elseif scale and scale.ForceEquipSet then
        local ok = pcall(function()
            scale.ForceEquipSet(pending.set, pending.expected, pending.intent);
        end);
        return ok == true;
    elseif gFunc and gFunc.ForceEquipSet then
        local ok = pcall(function()
            gFunc.ForceEquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    elseif gFunc and gFunc.EquipSet then
        local ok = pcall(function()
            gFunc.EquipSet(movementSafeEquipSet(pending.expected));
        end);
        return ok == true;
    end
    return false;
end

local function reconciliationResetSetForMismatches(pending, mismatches)
    local resetSet = {};
    for _, mismatch in ipairs(mismatches or {}) do
        local slot = tostring(mismatch.slot or '');
        local expected = type(pending.expected) == 'table' and pending.expected[slot] or nil;
        local expectedText = profile.ReconciliationNameAliases.Canonical(expected);
        if reconciliationResetBarrierSafeSlots[slot] == true
            and expectedText ~= ''
            and expectedText ~= 'remove'
        then
            resetSet[slot] = 'remove';
        end
    end
    return resetSet;
end

local function queueReconciliationResetBarrier(pending, mismatches, repairAttempt)
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    if movementSafetyActive() == true or not gFunc or not gFunc.ForceEquipSet then
        return false;
    end
    local resetSet = reconciliationResetSetForMismatches(pending, mismatches);
    if next(resetSet) == nil then
        return false;
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    local resetOk = pcall(function()
        gFunc.ForceEquipSet(resetSet);
    end);
    if resetOk ~= true then
        return false;
    end

    local nextAttempt = repairAttempt + 1;
    local resetExpected = {};
    for slot, _ in pairs(resetSet) do
        resetExpected[slot] = pending.expected[slot];
    end
    local reservation = {
        profileBuildToken = pending.profileBuildToken,
        cycleSequence = pending.cycleSequence,
        contextSignature = pending.contextSignature,
        set = pending.set,
        expected = pending.expected,
        force = true,
        repair = true,
        repairAttempt = nextAttempt,
        repairResetBarrier = true,
        repairResetExpected = resetExpected,
        playstyle = pending.playstyle,
        intent = pending.intent,
        actionProbeSequence = pending.actionProbeSequence,
        signature = pending.signature,
        equipmentSignature = pending.equipmentSignature,
    };
    state.ReconcilePendingSnapshot = reservation;
    state.ReconcileScanScheduled = true;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
    local token = state.ReconcileScanToken;
    local function releaseResetBarrier()
        state.ReconcileScanScheduled = false;
        state.ReconcilePendingSnapshot = nil;
    end
    local function supersedeResetBarrierIfNeeded()
        local superseding = reservation.repairSupersedingSnapshot;
        if type(superseding) ~= 'table' then
            return false;
        end
        releaseResetBarrier();
        state.ReconcileLastRecordedSignature = nil;
        if profile.OddLuaRuntime.ReconciliationContextMatches(superseding) ~= true then
            return true;
        end
        scheduleReconciliationSnapshot(
            superseding.set,
            superseding.expected,
            superseding.force,
            false,
            nil,
            {
                actionProbeSequence = superseding.actionProbeSequence,
                profileBuildToken = superseding.profileBuildToken,
                contextSignature = superseding.contextSignature,
            }
        );
        return true;
    end
    local function resetBarrierContextDrifted()
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) == true then
            return false;
        end
        releaseResetBarrier();
        state.ReconcileLastRecordedSignature = nil;
        return true;
    end
    local function resetBarrierCanContinue()
        if state.ReconcileEnabled ~= true then
            return false;
        end
        local contextReady = profile.OddLuaRuntime.PlayerContextReady(profile.OddLuaRuntime.GetPlayer()) == true;
        local encumbranceState = profile.OddLuaRuntime.HasEncumbrance();
        return contextReady == true
            and encumbranceState == false
            and movementSafetyActive() ~= true
            and profile.OddLuaRuntime.ReconciliationContextMatches(reservation) == true;
    end
    local function deferResetBarrier()
        releaseResetBarrier();
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) ~= true then
            state.ReconcileLastRecordedSignature = nil;
            return;
        end
        if state.ReconcileEnabled == true then
            scheduleReconciliationSnapshot(
                pending.set,
                pending.expected,
                true,
                true,
                repairAttempt,
                {
                    actionProbeSequence = pending.actionProbeSequence,
                    profileBuildToken = pending.profileBuildToken,
                    contextSignature = pending.contextSignature,
                    cycleSequence = pending.cycleSequence,
                }
            );
        end
    end
    local function forceResetBarrierExpected()
        local request = {
            profileBuildToken = reservation.profileBuildToken,
            cycleSequence = reservation.cycleSequence,
            contextSignature = reservation.contextSignature,
            set = reservation.set,
            expected = reservation.repairResetExpected,
            intent = reservation.intent,
        };
        if forceReconciliationExpected(request) then
            return true;
        end
        -- Scale can fail while raw ForceEquipSet remains available (the reset
        -- removal above already proved that path). Keep the fallback scoped to
        -- the same safe-slot subset so weapon slots can never be widened in.
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) ~= true then
            state.ReconcileLastRecordedSignature = nil;
            return false;
        end
        local ok = pcall(function()
            gFunc.ForceEquipSet(reservation.repairResetExpected);
        end);
        return ok == true;
    end
    local function completeResetBarrierReassert()
        if token ~= state.ReconcileScanToken or state.ReconcilePendingSnapshot ~= reservation then
            return;
        end
        if supersedeResetBarrierIfNeeded() then
            return;
        end
        if resetBarrierContextDrifted() then
            return;
        end
        if resetBarrierCanContinue() ~= true then
            deferResetBarrier();
            return;
        end
        releaseResetBarrier();
        -- One fixed, delayed reassert handles a partially accepted first send
        -- without widening the reset to weapon slots or creating a retry loop.
        forceResetBarrierExpected();
        if profile.OddLuaRuntime.ReconciliationContextMatches(reservation) ~= true then
            state.ReconcileLastRecordedSignature = nil;
            return;
        end
        scheduleReconciliationSnapshot(
            pending.set,
            pending.expected,
            true,
            true,
            nextAttempt,
            {
                actionProbeSequence = pending.actionProbeSequence,
                profileBuildToken = pending.profileBuildToken,
                contextSignature = pending.contextSignature,
                cycleSequence = pending.cycleSequence,
            }
        );
    end
    local function completeResetBarrier()
        if token ~= state.ReconcileScanToken or state.ReconcilePendingSnapshot ~= reservation then
            return;
        end
        if supersedeResetBarrierIfNeeded() then
            return;
        end
        if resetBarrierContextDrifted() then
            return;
        end
        if resetBarrierCanContinue() ~= true then
            deferResetBarrier();
            return;
        end
        -- Keep Scale's cache aligned with the partial post-barrier request. If
        -- LuAshitacast accepts only part of this send, the guarded reassert
        -- below gets one bounded chance to finish the same safe-slot request.
        forceResetBarrierExpected();
        if resetBarrierContextDrifted() then
            return;
        end
        if not scheduleTask(reconciliationResetBarrierDelaySeconds, completeResetBarrierReassert) then
            completeResetBarrierReassert();
        end
    end
    if not scheduleTask(reconciliationResetBarrierDelaySeconds, completeResetBarrier) then
        completeResetBarrier();
    end
    return true;
end

repairReconciliationMismatch = function(pending, mismatches)
    if type(pending) ~= 'table' then
        return false;
    end
    if profile.OddLuaRuntime.ReconciliationContextMatches(pending) ~= true then
        state.ReconcileLastRecordedSignature = nil;
        return false;
    end
    if profile.OddLuaRuntime.PlayerContextReady(profile.OddLuaRuntime.GetPlayer()) ~= true then
        return false;
    end
    if not reconciliationCanRepairSet(pending.set, pending.intent) then
        return false;
    end
    local repairAttempt = tonumber(pending.repairAttempt) or 0;
    if repairAttempt >= reconciliationMaxRepairAttempts then
        return false;
    end
    local encumbranceState = profile.OddLuaRuntime.HasEncumbrance();
    if encumbranceState == true then
        return false, 'repair_paused_encumbrance';
    elseif encumbranceState ~= false then
        return false, 'repair_paused_encumbrance_unknown';
    end
    if type(pending.expected) ~= 'table' or next(pending.expected) == nil then
        return false;
    end

    if repairAttempt == 1 and queueReconciliationResetBarrier(pending, mismatches, repairAttempt) then
        return true, nil, 'reset_barrier';
    end

    local repaired = forceReconciliationExpected(pending);
    if repaired == true then
        scheduleReconciliationSnapshot(
            pending.set,
            pending.expected,
            true,
            true,
            repairAttempt + 1,
            {
                actionProbeSequence = pending.actionProbeSequence,
                profileBuildToken = pending.profileBuildToken,
                contextSignature = pending.contextSignature,
                cycleSequence = pending.cycleSequence,
            }
        );
    end
    if repaired == true then
        return true, nil, 'direct';
    end
    return false;
end

local function handleReconcileCommand(args)
    local command = normalize(args and args[2]);
    if command == 'on' then
        state.ReconcileEnabled = true;
        message('Reconciliation snapshots enabled.');
    elseif command == 'off' then
        state.ReconcileEnabled = false;
        message('Reconciliation snapshots disabled.');
    elseif command == 'status' or command == '' then
        local lastStatus = 'none';
        if state.ReconcileLast and state.ReconcileLast.status then
            lastStatus = tostring(state.ReconcileLast.status);
        end
        message('Reconcile enabled=' .. tostring(state.ReconcileEnabled == true) .. '; last=' .. lastStatus .. '; use /lac fwd reconcile on|off|status|last.');
    elseif command == 'last' then
        if not state.ReconcileLast then
            message('Reconcile last: none yet.');
            return;
        end
        message('Reconcile last set=' .. tostring(state.ReconcileLast.set) .. '; status=' .. tostring(state.ReconcileLast.status) .. '; mismatches=' .. reconciliationMismatchSlots(state.ReconcileLast.mismatches) .. '.');
    else
        message('Unknown reconcile command. Use reconcile on|off|status|last.');
    end
end


local function weaponSkillRouteKey(name)
    local text = normalize(name);
    text = string.gsub(text, ':', '_');
    text = string.gsub(text, '-', '_');
    text = string.gsub(text, '%s+', '_');
    text = string.gsub(text, '[^%w_]', '');
    text = string.gsub(text, '_+', '_');
    return text;
end

local function getPlayer()
    return profile.OddLuaRuntime.GetPlayer();
end

profile.OddLuaPet = {};

function profile.OddLuaPet.getPet()
    if gData and gData.GetPet then
        local ok, pet = pcall(gData.GetPet);
        if ok then
            return pet;
        end
    end

    local player = getPlayer();
    if type(player) == 'table' then
        return player.Pet or player.pet or player.PetName or player.petName;
    end
    return nil;
end

do
local function mechanicsPlanForSet(setName)
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        return nil;
    end
    local transitions = mechanicsSwapPlanner.transitions;
    if type(transitions) ~= 'table' then
        return nil;
    end
    return transitions[setName];
end

local function mechanicsSkipReasonForSet(setName)
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        return nil;
    end
    local skippedTransitions = mechanicsSwapPlanner.skippedTransitions;
    if type(skippedTransitions) ~= 'table' then
        return nil;
    end
    return skippedTransitions[setName];
end

local function mechanicsWarningText(plan)
    local warnings = plan and plan.warnings;
    if type(warnings) ~= 'table' or #warnings == 0 then
        return 'none';
    end
    return table.concat(warnings, ',');
end

local function mechanicsActionText(action)
    if type(action) ~= 'table' then
        return 'unknown action';
    end
    return tostring(action.phase or 'phase') .. ' ' .. tostring(action.slot or '?') .. '=' .. tostring(action.item or '?') .. ' (' .. tostring(action.reason or '') .. ')';
end

local function tableCount(value)
    if type(value) ~= 'table' then
        return 0;
    end
    local count = 0;
    for _, _ in pairs(value) do
        count = count + 1;
    end
    return count;
end

local function sortedMechanicsKeys(value)
    local names = {};
    if type(value) ~= 'table' then
        return names;
    end
    for name, _ in pairs(value) do
        table.insert(names, tostring(name));
    end
    table.sort(names);
    return names;
end

local function mechanicsPlanActionWarningCounts()
    local transitions = mechanicsSwapPlanner and mechanicsSwapPlanner.transitions;
    if type(transitions) ~= 'table' then
        return 0, 0;
    end
    local actionCount = 0;
    local warningCount = 0;
    for _, plan in pairs(transitions) do
        if type(plan) == 'table' then
            if type(plan.actions) == 'table' then
                actionCount = actionCount + #plan.actions;
            end
            if type(plan.warnings) == 'table' then
                warningCount = warningCount + #plan.warnings;
            end
        end
    end
    local explicitTransitions = mechanicsSwapPlanner and mechanicsSwapPlanner.explicitTransitions;
    if type(explicitTransitions) == 'table' then
        for _, plan in pairs(explicitTransitions) do
            if type(plan) == 'table' and type(plan.actions) == 'table' then
                actionCount = actionCount + #plan.actions;
            end
        end
    end
    return actionCount, warningCount;
end

local function mechanicsListText(names)
    if type(names) ~= 'table' or #names == 0 then
        return 'none';
    end
    if #names <= 12 then
        return table.concat(names, ',');
    end
    local visible = {};
    for index = 1, 12 do
        table.insert(visible, names[index]);
    end
    return table.concat(visible, ',') .. ' +' .. tostring(#names - 12) .. ' more';
end

local function printMechanicsList()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        message('Mechanics planner is not loaded.');
        return false;
    end
    local plannedNames = sortedMechanicsKeys(mechanicsSwapPlanner.transitions);
    local skippedNames = sortedMechanicsKeys(mechanicsSwapPlanner.skippedTransitions);
    message('Mechanics planned sets (' .. tostring(#plannedNames) .. '): ' .. mechanicsListText(plannedNames));
    message('Mechanics skipped sets (' .. tostring(#skippedNames) .. '): ' .. mechanicsListText(skippedNames));
    return true;
end

local function mechanicsWarningTypeCounts()
    local counts = {};
    local transitions = mechanicsSwapPlanner and mechanicsSwapPlanner.transitions;
    if type(transitions) ~= 'table' then
        return counts;
    end
    for _, plan in pairs(transitions) do
        local warnings = type(plan) == 'table' and plan.warnings or nil;
        if type(warnings) == 'table' then
            for _, warning in ipairs(warnings) do
                local key = tostring(warning);
                counts[key] = (counts[key] or 0) + 1;
            end
        end
    end
    return counts;
end

local function printMechanicsWarnings()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        message('Mechanics planner is not loaded.');
        return false;
    end
    local counts = mechanicsWarningTypeCounts();
    local names = sortedMechanicsKeys(counts);
    if #names == 0 then
        message('Mechanics warning types: none.');
        return true;
    end
    for _, warning in ipairs(names) do
        message('Mechanics warning type ' .. tostring(warning) .. ': ' .. tostring(counts[warning]));
    end
    return true;
end

local function mechanicsSkippedReasonCounts()
    local counts = {};
    local skippedTransitions = mechanicsSwapPlanner and mechanicsSwapPlanner.skippedTransitions;
    if type(skippedTransitions) ~= 'table' then
        return counts;
    end
    for _, reason in pairs(skippedTransitions) do
        local key = tostring(reason);
        counts[key] = (counts[key] or 0) + 1;
    end
    return counts;
end

local function printMechanicsSkipped()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        message('Mechanics planner is not loaded.');
        return false;
    end
    local counts = mechanicsSkippedReasonCounts();
    local names = sortedMechanicsKeys(counts);
    if #names == 0 then
        message('Mechanics skipped reasons: none.');
        return true;
    end
    for _, reason in ipairs(names) do
        message('Mechanics skipped reason ' .. tostring(reason) .. ': ' .. tostring(counts[reason]));
    end
    return true;
end

local function mechanicsTargetSet(args)
    local setName = args and args[3];
    if setName and sets[setName] then
        return setName;
    end
    local alias = styleAliases[normalize(setName)];
    if alias and sets['Playstyle_' .. alias] then
        return 'Playstyle_' .. alias;
    end
    if alias and sets[alias] then
        return alias;
    end
    if setName and sets['Playstyle_' .. tostring(setName)] then
        return 'Playstyle_' .. tostring(setName);
    end
    return setName or '';
end

local function printMechanicsPlan(setName)
    local plan = mechanicsPlanForSet(setName);
    if not plan then
        local skipReason = mechanicsSkipReasonForSet(setName);
        if skipReason then
            message('Mechanics transition skipped for ' .. tostring(setName) .. ': ' .. tostring(skipReason) .. '.');
            return false;
        end
        message('No mechanics transition plan for ' .. tostring(setName) .. '.');
        return false;
    end
    local actions = plan.actions or {};
    message('Mechanics plan ' .. tostring(setName) .. ': actions=' .. tostring(#actions) .. '; warnings=' .. mechanicsWarningText(plan));
    for index, action in ipairs(actions) do
        message('Mechanics action ' .. tostring(index) .. ': ' .. mechanicsActionText(action));
    end
    return true;
end

local function playerMechanicsText(player)
    if type(player) ~= 'table' then
        return 'player unavailable';
    end
    local hp = player.HP or player.hp or player.CurrentHP or player.currentHP or '?';
    local maxHp = player.MaxHP or player.maxHP or player.HPMax or player.hpmax or '?';
    local mp = player.MP or player.mp or player.CurrentMP or player.currentMP or '?';
    local maxMp = player.MaxMP or player.maxMP or player.MPMax or player.mpmax or '?';
    return 'HP=' .. tostring(hp) .. '/' .. tostring(maxHp) .. '; MP=' .. tostring(mp) .. '/' .. tostring(maxMp);
end

local function probeMechanicsPlan(setName)
    if state.MechanicsProbes ~= true then
        message('Mechanics probes disabled. Use mechanics probes on.');
        return false;
    end
    message('Mechanics probe ' .. tostring(setName) .. ': ' .. playerMechanicsText(getPlayer()));
    return printMechanicsPlan(setName);
end

local function mechanicsStatus()
    local loaded = mechanicsSwapPlanner and mechanicsSwapPlanner.loaded == true;
    local baseline = mechanicsSwapPlanner and mechanicsSwapPlanner.baselineSet or '';
    local plannerVersion = mechanicsSwapPlanner and mechanicsSwapPlanner.plannerVersion or 0;
    local transitionCount = tableCount(mechanicsSwapPlanner and mechanicsSwapPlanner.transitions);
    local skippedCount = tableCount(mechanicsSwapPlanner and mechanicsSwapPlanner.skippedTransitions);
    local actionCount, warningCount = mechanicsPlanActionWarningCounts();
    message('Mechanics planner loaded=' .. tostring(loaded) .. '; baseline=' .. tostring(baseline) .. '; version=' .. tostring(plannerVersion) .. '; transitions=' .. tostring(transitionCount) .. '; skipped=' .. tostring(skippedCount) .. '; actions=' .. tostring(actionCount) .. '; warnings=' .. tostring(warningCount) .. '; probes=' .. tostring(state.MechanicsProbes == true) .. '; execution=' .. tostring(state.MechanicsExecution == true));
    message('Automatic mechanics execution is disabled; explicit avoidtick acts only on receive-only observed harmful gear.');
end

local function handleMechanicsCommand(args)
    local subcommand = normalize(args and args[2]);
    if subcommand == '' or subcommand == 'status' then
        mechanicsStatus();
        return;
    elseif subcommand == 'help' then
        message('mechanics status | mechanics list | mechanics warnings | mechanics skipped | mechanics probes on|off | mechanics plan <set> | mechanics probe <set> | mechanics avoidtick');
        return;
    elseif subcommand == 'list' then
        printMechanicsList();
        return;
    elseif subcommand == 'warnings' then
        printMechanicsWarnings();
        return;
    elseif subcommand == 'skipped' then
        printMechanicsSkipped();
        return;
    elseif subcommand == 'probes' then
        local value = normalize(args and args[3]);
        if value == 'on' then
            state.MechanicsProbes = true;
        elseif value == 'off' then
            state.MechanicsProbes = false;
        end
        message('Mechanics probes: ' .. (state.MechanicsProbes and 'on' or 'off') .. '.');
        return;
    elseif subcommand == 'plan' then
        printMechanicsPlan(mechanicsTargetSet(args));
        return;
    elseif subcommand == 'probe' then
        probeMechanicsPlan(mechanicsTargetSet(args));
        return;
    elseif subcommand == 'avoidtick' then
        local avoided, detail = profile.OddLuaRuntime.AvoidNegativeTickGear();
        if avoided == true then
            message('Negative-tick avoidance requested: ' .. tostring(detail) .. '; verify observed equipment before treating it as proof.');
        else
            message('Negative-tick avoidance skipped: ' .. tostring(detail or 'unavailable') .. '.');
        end
        return;
    end
    message('Unknown mechanics command. Use mechanics help.');
end

profile.OddLuaRuntime.HandleMechanicsCommand = handleMechanicsCommand;
end

local function getAction()
    if gData and gData.GetAction then
        return gData.GetAction();
    end
    return nil;
end

local function getEnvironment()
    return profile.OddLuaRuntime.GetEnvironment();
end

local function truthy(value)
    if value == true then
        return true;
    end
    local text = normalize(value);
    return text == 'true' or text == '1' or text == 'yes';
end

local function environmentHour(environment)
    if not environment then
        return nil;
    end

    local timestamp = environment.Timestamp or environment.timestamp;
    if type(timestamp) == 'table' then
        local hour = tonumber(timestamp.hour or timestamp.Hour);
        if hour then
            return hour;
        end
    end

    local hour = tonumber(environment.Hour or environment.hour or environment.VanaHour or environment.vanaHour);
    if hour then
        return hour;
    end

    local time = tonumber(environment.Time or environment.time or environment.VanaTime or environment.vanaTime);
    if time then
        return math.floor(time);
    end
    return nil;
end

local function isCity(environment)
    if not environment then
        return false;
    end

    if truthy(environment.inCity or environment.InCity or environment.city or environment.City) then
        return true;
    end

    local zoneId = tonumber(environment.ZoneId or environment.zoneId or environment.Zone or environment.zone);
    if zoneId and cityZoneIds[zoneId] then
        return true;
    end

    local area = normalize(environment.Area or environment.area or environment.ZoneName or environment.zoneName);
    return cityAreas[area] == true;
end

local function isNight(environment)
    local hour = environmentHour(environment);
    if hour == nil then
        return false;
    end
    return hour >= 20 or hour < 4;
end

local function isDuskToDawn(environment)
    local hour = environmentHour(environment);
    if hour == nil then
        return false;
    end
    return hour >= 18 or hour < 6;
end

local function getBuffCount(name)
    if name == nil or tostring(name) == '' or not gData or not gData.GetBuffCount then
        return 0, false;
    end

    local ok, count = pcall(gData.GetBuffCount, name);
    if ok and type(count) == 'number' then
        return count, true;
    end
    return 0, false;
end

local function hasBuff(name)
    local count, known = getBuffCount(name);
    return known == true and count > 0;
end



profile.OddLuaRuntime.IncapacitatingStatusBuffs = {
    'sleep', 'sleep ii', 'stun', 'lullaby', 'petrification', 'terror', 'impairment',
    2, 7, 10, 19, 28, 193, 261,
};

profile.OddLuaRuntime.AmnesiaStatusBuffs = { 'amnesia', 16 };
profile.OddLuaRuntime.WeaknessStatusBuffs = { 'weakness', 1 };
profile.OddLuaRuntime.CurseStatusBuffs = { 'curse', 9, 20 };

function profile.OddLuaRuntime.StatusListState(statuses)
    local unknown = false;
    for _, status in ipairs(statuses or {}) do
        local count, known = getBuffCount(status);
        if known ~= true then
            unknown = true;
        elseif count > 0 then
            return true;
        end
    end
    if unknown then
        return nil;
    end
    return false;
end

function profile.OddLuaRuntime.HasIncapacitatingStatus()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.IncapacitatingStatusBuffs);
end

function profile.OddLuaRuntime.HasAmnesia()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.AmnesiaStatusBuffs);
end

function profile.OddLuaRuntime.HasWeakness()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.WeaknessStatusBuffs);
end

function profile.OddLuaRuntime.HasEncumbrance()
    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.EncumbranceStatusBuffs);
end

function profile.OddLuaRuntime.DangerousStatusState()
    local unknown = false;
    for name in pairs(dangerousStatusBuffs) do
        local count, known = getBuffCount(name);
        if known ~= true then
            unknown = true;
        elseif count > 0 then
            return true;
        end
    end
    for _, id in ipairs(dangerousStatusIds) do
        local count, known = getBuffCount(id);
        if known ~= true then
            unknown = true;
        elseif count > 0 then
            return true;
        end
    end
    if unknown then
        return nil;
    end
    return false;
end

local function hasDangerousStatus()
    return profile.OddLuaRuntime.DangerousStatusState() == true;
end

local function activeSubjob()
    local player = getPlayer();
    if player then
        local subjob = player.SubJob or player.subJob or player.Subjob or player.subjob or player.SubJobName or player.subJobName;
        if subjob and tostring(subjob) ~= '' then
            local numeric = tonumber(subjob);
            if numeric and jobIdToAbbr[numeric] then
                return jobIdToAbbr[numeric];
            end
            return string.upper(tostring(subjob));
        end
    end
    return 'RDM';
end

local function currentSubjobProfile()
    local subjob = activeSubjob();
    return subjobs[subjob], subjob;
end
function profile.OddLuaRuntime.ShouldEquipSirdNin(action)
    if type(sets['SIRD_NIN']) ~= 'table' then
        return false;
    end
    if activeSubjob() ~= 'NIN' then
        return false;
    end

    local name = normalize(action and (action.Name or action.name));
    return string.find(name, 'aquaveil', 1, true) ~= nil
        or string.find(name, 'utsusemi', 1, true) ~= nil;
end

local function hasSubjobCapability(capability)
    local subjob = currentSubjobProfile();
    if not subjob or not capability then
        return false;
    end
    local wanted = normalize(capability);
    for _, value in ipairs(subjob.capabilities or {}) do
        if normalize(value) == wanted then
            return true;
        end
    end
    return false;
end

profile.HasSubjobCapability = hasSubjobCapability;

local function mainJobHasNativeDualWield()
    local minimumLevel = nativeDualWieldMainJobs['GEO'];
    if type(minimumLevel) ~= 'number' then
        return false;
    end
    local player = gData.GetPlayer();
    if type(player) ~= 'table' then
        return false;
    end
    local mainLevel = tonumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
    );
    return mainLevel ~= nil and mainLevel >= minimumLevel;
end

local function setWithSubjobLegalOffhand(setName, set)
    if type(set) ~= 'table' then
        return set;
    end
    if setRequiresDualWieldSub[setName] ~= true then
        return set;
    end
    if mainJobHasNativeDualWield() or hasSubjobCapability('dual_wield') then
        return set;
    end

    local adjusted = {};
    for slot, item in pairs(set) do
        adjusted[slot] = item;
    end
    adjusted.Sub = 'remove';
    return adjusted;
end

local function summarizeSubjobEntries(entries, label)
    local parts = {};
    for _, entry in ipairs(entries or {}) do
        local text = tostring(entry.name or '');
        if entry.level then
            text = text .. '@' .. tostring(entry.level);
        end
        if entry.mod and entry.value then
            text = text .. '(' .. tostring(entry.mod) .. tostring(entry.value) .. ')';
        end
        table.insert(parts, text);
    end
    if #parts == 0 then
        return label .. '=none';
    end
    return label .. '=' .. table.concat(parts, ',');
end

local function isEngaged(player)
    if not player then
        return false;
    end
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    return status == 'engaged' or status == 'attack' or status == 'attacking' or status == '1';
end

function profile.OddLuaRuntime.CanIssueAutomaticJobAbility(player)
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true or not isEngaged(player) then
        return false;
    end
    if profile.OddLuaRuntime.HasIncapacitatingStatus() ~= false then
        return false;
    end
    if profile.OddLuaRuntime.HasAmnesia() ~= false then
        return false;
    end
    return true;
end

local function isResting(player)
    if not player then
        return false;
    end
    local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
    return status == 'resting' or status == 'healing' or status == '33' or status == '34';
end

local function isMounted(player)
    if player then
        if truthy(player.Mounted or player.mounted or player.IsMounted or player.isMounted or player.OnMount or player.onMount) then
            return true;
        end

        local status = normalize(player.Status or player.status or player.StatusName or player.statusName);
        if status == 'mounted' or status == 'mount' or status == 'chocobo' or status == '252' then
            return true;
        end
    end

    return profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.MountedStatusBuffs);
end

function profile.OddLuaRuntime.IsOnFoot(player)
    return isMounted(player) == false;
end

local function canEquipMovement(player, environment)
    if not profile.OddLuaRuntime.IsOnFoot(player) then
        return false;
    end
    return profile.OddLuaRuntime.PlayerIsMoving(player) == true;
end

local function shouldEquipInCityMovement(player, environment)
    return isCity(environment) and profile.OddLuaRuntime.IsOnFoot(player);
end

local function playerHpp(player)
    if not player then
        return nil;
    end

    local hpp = player.HPP or player.hpp or player.HPPercent or player.hpPercent or player.HPPercentage or player.hpPercentage;
    if hpp then
        return tonumber(hpp);
    end

    local hp = tonumber(player.HP or player.hp);
    local maxHp = tonumber(player.MaxHP or player.maxHP);
    if hp and maxHp and maxHp > 0 then
        return (hp / maxHp) * 100;
    end
    return nil;
end

function profile.OddLuaRuntime.PlayerHp(player)
    if not player then
        return nil;
    end
    return tonumber(player.HP or player.hp or player.CurrentHP or player.currentHP);
end

function profile.OddLuaRuntime.PlayerMp(player)
    if not player then
        return nil;
    end
    return tonumber(player.MP or player.mp or player.CurrentMP or player.currentMP);
end
function profile.OddLuaRuntime.PlayerMpp(player)
    if not player then
        return nil;
    end

    local mpp = player.MPP or player.mpp or player.MPPercent or player.mpPercent or player.MPPercentage or player.mpPercentage;
    if mpp then
        return tonumber(mpp);
    end

    local mp = profile.OddLuaRuntime.PlayerMp(player);
    local maxMp = tonumber(player.MaxMP or player.maxMP);
    if mp and maxMp and maxMp > 0 then
        return (mp / maxMp) * 100;
    end
    return nil;
end

function profile.OddLuaRuntime.ShouldEquipConserveMP(player, action)
    if type(sets['ConserveMP']) ~= 'table' then
        return false;
    end
    if not action then
        return false;
    end
    local mpp = profile.OddLuaRuntime.PlayerMpp(player);
    if mpp == nil or mpp > 50 then
        return false;
    end

    local skill = normalize(action.Skill or action.skill or action.SkillName or action.skillName);
    if skill == 'ninjutsu' then
        return false;
    end
    if skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        return false;
    end
    return true;
end

local function playerTp(player)
    if not player then
        return 0;
    end
    return tonumber(player.TP or player.tp or player.TacticalPoints or player.tacticalPoints or 0) or 0;
end

local function isEmergencyHp(player)
    if player == nil then
        state.EmergencyHpActive = false;
        return false;
    end
    local hpp = playerHpp(player);
    local thresholds = profile.OddLuaRuntime.Hysteresis;
    return profile.OddLuaRuntime.UpdateHysteresisState(
        'EmergencyHpActive',
        hpp ~= nil,
        hpp ~= nil and hpp <= thresholds.EmergencyHpEnterHpp,
        hpp ~= nil and hpp >= thresholds.EmergencyHpExitHpp
    );
end

function profile.OddLuaRuntime.IsEmergencyHp(player)
    return isEmergencyHp(player);
end



local function setNameFor(styleName)
    return 'Playstyle_' .. tostring(styleName or state.Playstyle);
end

local function isClearSet(set)
    if type(set) ~= 'table' then
        return false;
    end

    for _, slot in ipairs(equipmentSlots) do
        local item = set[slot];
        if item == nil then
            return false;
        end

        if type(item) == 'string' then
            if normalize(item) ~= 'remove' then
                return false;
            end
        elseif type(item) == 'table' then
            if normalize(item.Name or item.name) ~= 'remove' then
                return false;
            end
        else
            return false;
        end
    end

    return true;
end

local function firstAvailableDefensiveSet()
    local candidates = { 'IdleCombat', 'Dt', 'PDT', 'Playstyle_Safe', 'Safe', 'Survival', 'Tank', 'Evasion', 'MDT', 'MagicDefense' };
    for _, setName in ipairs(candidates) do
        local set = sets[setName];
        if type(set) == 'table' and not isClearSet(set) then
            return setName;
        end
    end
    return nil;
end

local function providedThreatEntities(player)
    if type(profile.GetThreatEntities) == 'function' then
        local ok, entities = pcall(profile.GetThreatEntities, player);
        if ok and type(entities) == 'table' then
            return entities;
        end
    end
    if gData and type(gData.GetThreatEntities) == 'function' then
        local ok, entities = pcall(gData.GetThreatEntities, player);
        if ok and type(entities) == 'table' then
            return entities;
        end
    end
    return nil;
end

local function isIncrediblyToughEntity(entity)
    if type(entity) ~= 'table' then
        return false;
    end
    if entity.IsIncrediblyTough == true or entity.isIncrediblyTough == true then
        return true;
    end
    local difficulty = normalize(
        entity.Difficulty
        or entity.difficulty
        or entity.Check
        or entity.check
        or entity.CheckMessage
        or entity.checkMessage
        or entity.DifficultyText
        or entity.difficultyText
    );
    return difficulty == 'it'
        or difficulty == 'incredibly tough'
        or difficulty == 'incredibly_tough'
        or difficulty == 'incrediblytough';
end

local function addThreatIdentifier(identifiers, value)
    if value ~= nil and tostring(value) ~= '' then
        identifiers[tostring(value)] = true;
    end
end

local function playerThreatIdentifiers(player)
    local identifiers = {};
    if type(player) ~= 'table' then
        return identifiers;
    end
    addThreatIdentifier(identifiers, player.Id or player.ID or player.id);
    addThreatIdentifier(identifiers, player.ServerId or player.ServerID or player.serverId or player.serverID);
    addThreatIdentifier(identifiers, player.TargetIndex or player.targetIndex or player.Index or player.index);
    addThreatIdentifier(identifiers, player.Name or player.name);
    return identifiers;
end

local function threatValueIsActive(value)
    if value == true then
        return true;
    end
    if type(value) == 'number' then
        return value > 0;
    end
    if type(value) == 'string' then
        local normalized = normalize(value);
        return normalized == 'true' or normalized == 'yes' or normalized == 'active' or tonumber(value) ~= nil and tonumber(value) > 0;
    end
    return type(value) == 'table';
end

local function threatEntryMatchesPlayer(entry, identifiers)
    if type(entry) ~= 'table' then
        return false;
    end
    local id = entry.Id or entry.ID or entry.id or entry.ServerId or entry.ServerID or entry.serverId or entry.serverID;
    local index = entry.Index or entry.index or entry.TargetIndex or entry.targetIndex;
    local name = entry.Name or entry.name;
    if (id ~= nil and identifiers[tostring(id)] == true)
        or (index ~= nil and identifiers[tostring(index)] == true)
        or (name ~= nil and identifiers[tostring(name)] == true) then
        return threatValueIsActive(entry.Threat or entry.threat or entry.Enmity or entry.enmity or true);
    end
    return false;
end

local function entityHasPlayerThreat(entity, player)
    if type(entity) ~= 'table' then
        return false;
    end
    for _, field in ipairs({ 'HasPlayerThreat', 'hasPlayerThreat', 'OnPlayerThreatTable', 'onPlayerThreatTable', 'PlayerThreat', 'playerThreat', 'ClaimedByPlayer', 'claimedByPlayer' }) do
        if threatValueIsActive(entity[field]) then
            return true;
        end
    end

    local identifiers = playerThreatIdentifiers(player);
    for _, field in ipairs({ 'TargetId', 'targetId', 'TargetID', 'targetID', 'TargetServerId', 'targetServerId', 'TargetIndex', 'targetIndex' }) do
        local value = entity[field];
        if value ~= nil and identifiers[tostring(value)] == true then
            return true;
        end
    end

    local threatTable = entity.ThreatTable or entity.threatTable or entity.Threat or entity.threat or entity.Enmity or entity.enmity;
    if type(threatTable) ~= 'table' then
        return false;
    end
    for key, value in pairs(threatTable) do
        if identifiers[tostring(key)] == true and threatValueIsActive(value) then
            return true;
        end
        if threatEntryMatchesPlayer(value, identifiers) then
            return true;
        end
    end
    return false;
end

local function countOvertDefenseThreats(player)
    local entities = providedThreatEntities(player);
    if type(entities) ~= 'table' then
        return 0;
    end

    local count = 0;
    for _, entity in pairs(entities) do
        if isIncrediblyToughEntity(entity) and entityHasPlayerThreat(entity, player) then
            count = count + 1;
        end
    end
    return count;
end

function profile.OddLuaRuntime.CountPlayerThreats(player)
    local entities = providedThreatEntities(player);
    if type(entities) ~= 'table' then
        return 0;
    end

    local count = 0;
    for _, entity in pairs(entities) do
        if entityHasPlayerThreat(entity, player) then
            count = count + 1;
        end
    end
    return count;
end

function profile.OddLuaRuntime.ShouldEquipIdleCombat(player)
    if not player or isEngaged(player) or isResting(player) then
        return false;
    end
    return profile.OddLuaRuntime.CountPlayerThreats(player) > 0;
end

function profile.OddLuaRuntime.IdlePoolFloor(threshold, extra)
    local floor = (tonumber(threshold or 0) or 0) + (tonumber(extra or 0) or 0);
    if floor < 0 then
        return 0;
    end
    return floor;
end

function profile.OddLuaRuntime.UpdateHysteresisState(fieldName, observed, shouldEnter, shouldExit)
    if fieldName ~= 'EmergencyHpActive'
        and fieldName ~= 'IdleMaxMPActive'
        and fieldName ~= 'IdleMaxHPActive' then
        return false;
    end
    if observed ~= true then
        return state[fieldName] == true;
    end
    if state[fieldName] == true then
        if shouldExit == true then
            state[fieldName] = false;
        end
    elseif shouldEnter == true then
        state[fieldName] = true;
    end
    return state[fieldName] == true;
end

function profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player)
    if not player or isEngaged(player) or isResting(player) then
        state.IdleMaxMPActive = false;
        return false;
    end
    local floor = profile.OddLuaRuntime.IdlePoolFloor(state.IdleMaxMPThreshold, state.IdleMaxMPAdd);
    if floor <= 0 then
        state.IdleMaxMPActive = false;
        return false;
    end
    local mp = profile.OddLuaRuntime.PlayerMp(player);
    local exitFloor = math.max(0, floor - profile.OddLuaRuntime.Hysteresis.IdlePoolBand);
    return profile.OddLuaRuntime.UpdateHysteresisState(
        'IdleMaxMPActive',
        mp ~= nil,
        mp ~= nil and mp >= floor,
        mp ~= nil and mp <= exitFloor
    );
end

function profile.OddLuaRuntime.ShouldEquipIdleMaxHP(player)
    if not player or isEngaged(player) or isResting(player) then
        state.IdleMaxHPActive = false;
        return false;
    end
    local floor = profile.OddLuaRuntime.IdlePoolFloor(state.IdleMaxHPThreshold, state.IdleMaxHPAdd);
    if floor <= 0 then
        state.IdleMaxHPActive = false;
        return false;
    end
    local hp = profile.OddLuaRuntime.PlayerHp(player);
    return profile.OddLuaRuntime.UpdateHysteresisState(
        'IdleMaxHPActive',
        hp ~= nil,
        hp ~= nil and hp < floor,
        hp ~= nil and hp >= floor + profile.OddLuaRuntime.Hysteresis.IdlePoolBand
    );
end

local function shouldEquipOvertDefense(player)
    if not player or not isEngaged(player) then
        return nil;
    end
    if countOvertDefenseThreats(player) < OVERT_DEFENSE_TARGET_COUNT then
        return nil;
    end

    local defensiveSet = firstAvailableDefensiveSet();
    if not defensiveSet then
        return nil;
    end
    local hpp = playerHpp(player);
    if hpp ~= nil and hpp < OVERT_DEFENSE_HP_FORCE_HPP then
        return defensiveSet, true;
    end
    local tp = playerTp(player);
    if tp < OVERT_DEFENSE_TP_UNLOCK then
        return defensiveSet, tp == 0;
    end
    return nil;
end

function profile.OddLuaRuntime.ActiveSafetyReason(player)
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return 'none';
    end
    if hasDangerousStatus() then
        return 'dangerous-status';
    end
    if profile.OddLuaRuntime.HasWeakness() == true then
        return 'weakness';
    end
    if (player and isResting(player)) or state.Playstyle == 'Craft' then
        return 'none';
    end
    if state.IdleOverrideSet ~= nil and state.IdleOverrideSet ~= 'Guard'
        and type(sets[state.IdleOverrideSet]) == 'table'
        and not isClearSet(sets[state.IdleOverrideSet])
    then
        return 'manual-override';
    end
    if player and isEngaged(player) then
        if shouldEquipOvertDefense(player) ~= nil then
            return 'overt-threat';
        end
        if isEmergencyHp(player) and firstAvailableDefensiveSet() ~= nil then
            return 'emergency-hp';
        end
        if state.IdleOverrideSet == 'Guard'
            and profile.OddLuaRuntime.ShouldEquipGuard(player)
            and type(sets['Guard']) == 'table'
            and not isClearSet(sets['Guard'])
        then
            return 'manual-override';
        end
    end
    return 'none';
end

local function applyWarpRingLock(set)
    if state.WarpRingLocked ~= true or type(set) ~= 'table' then
        return set;
    end

    local lockedSet = {};
    for slot, item in pairs(set) do
        lockedSet[slot] = item;
    end
    lockedSet.Ring2 = 'Warp Ring';
    return lockedSet;
end

local function desiredSecondarySlotLocks(setName)
    local desired = {};
    local setLocks = setSecondarySlotLocks[setName];
    if type(setLocks) ~= 'table' then
        return desired;
    end

    for _, lockedSlots in pairs(setLocks) do
        if type(lockedSlots) == 'table' then
            for _, slot in ipairs(lockedSlots) do
                desired[slot] = true;
            end
        end
    end
    return desired;
end

local function desiredSecondarySlotLocksForSetNames(setNames)
    local desired = {};
    if type(setNames) ~= 'table' then
        return desired;
    end

    for _, setName in ipairs(setNames) do
        local setDesired = desiredSecondarySlotLocks(setName);
        for slot, _ in pairs(setDesired) do
            desired[slot] = true;
        end
    end
    return desired;
end

local function contextSecondarySlotSafeSet(set)
    local contextSetNames = state.SecondarySlotLockContextSetNames;
    if type(set) ~= 'table' or type(contextSetNames) ~= 'table' then
        return set;
    end

    local lockedSlots = desiredSecondarySlotLocksForSetNames(contextSetNames);
    if next(lockedSlots) == nil then
        return set;
    end

    local safe = {};
    for slot, item in pairs(set) do
        if lockedSlots[slot] ~= true then
            safe[slot] = item;
        end
    end
    return safe;
end

local function contextSafeEquipSet(set)
    return movementSafeEquipSet(contextSecondarySlotSafeSet(set));
end

local contextSafeGFunc = {};
contextSafeGFunc.EquipSet = function(set)
    if gFunc and gFunc.EquipSet then
        return gFunc.EquipSet(contextSafeEquipSet(set));
    end
    return nil;
end;
contextSafeGFunc.ForceEquipSet = function(set)
    if gFunc and gFunc.ForceEquipSet then
        return gFunc.ForceEquipSet(contextSafeEquipSet(set));
    elseif gFunc and gFunc.EquipSet then
        return gFunc.EquipSet(contextSafeEquipSet(set));
    end
    return nil;
end;

local function releaseSecondarySlotLocksNotInSetNames(setNames)
    local active = state.SecondarySlotLocks;
    if type(active) ~= 'table' then
        state.SecondarySlotLocks = {};
        return;
    end

    local desired = desiredSecondarySlotLocksForSetNames(setNames);
    local slotsToEnable = {};
    for slot, _ in pairs(active) do
        if desired[slot] ~= true then
            slotsToEnable[#slotsToEnable + 1] = slot;
        end
    end

    for _, slot in ipairs(slotsToEnable) do
        active[slot] = nil;
    end

    for _, slot in ipairs(slotsToEnable) do
        if gFunc and gFunc.Enable then
            gFunc.Enable(slot);
        end
    end
end

local function releaseSecondarySlotLocksNotInSet(setName)
    local contextSetNames = state.SecondarySlotLockContextSetNames;
    if type(contextSetNames) == 'table' then
        releaseSecondarySlotLocksNotInSetNames(contextSetNames);
        return;
    end

    releaseSecondarySlotLocksNotInSetNames({ setName });
end

local function applySecondarySlotLocksForSet(setName)
    local active = state.SecondarySlotLocks;
    if type(active) ~= 'table' then
        active = {};
        state.SecondarySlotLocks = active;
    end

    local desired = desiredSecondarySlotLocks(setName);
    local slotsToDisable = {};
    for slot, _ in pairs(desired) do
        if active[slot] ~= true then
            slotsToDisable[#slotsToDisable + 1] = slot;
        end
    end

    for _, slot in ipairs(slotsToDisable) do
        active[slot] = true;
    end

    for _, slot in ipairs(slotsToDisable) do
        if gFunc and gFunc.Disable then
            gFunc.Disable(slot);
        end
    end
end

local function unlockSecondarySlotLocks()
    local active = state.SecondarySlotLocks;
    if type(active) ~= 'table' then
        state.SecondarySlotLocks = {};
        return;
    end

    local slotsToEnable = {};
    for slot, _ in pairs(active) do
        slotsToEnable[#slotsToEnable + 1] = slot;
    end

    for _, slot in ipairs(slotsToEnable) do
        active[slot] = nil;
    end

    for _, slot in ipairs(slotsToEnable) do
        if gFunc and gFunc.Enable then
            gFunc.Enable(slot);
        end
    end
end

local function buildConditionalOverlayForSet(setName, context)
    return conditionals.BuildOverlay(conditionalEquips[setName], context);
end

local function applyConditionalEquipsForSet(setName, baseSet, force)
    if not conditionals or not conditionals.BuildOverlay then
        return false;
    end

    local ok, overlay = pcall(function()
        return buildConditionalOverlayForSet(setName, {
            force = force,
            gFunc = contextSafeGFunc,
            getBuffCount = getBuffCount,
            getEnvironment = getEnvironment,
            getPlayer = getPlayer,
            hasBuff = hasBuff,
            itemHasUsesLeft = profile.BuffItemHasUsesLeft,
            state = state,
        });
    end);
    if ok ~= true or type(overlay) ~= 'table' then
        overlay = {};
    end

    local previousSlots = state.ActiveConditionalOverlaySlots;
    if type(previousSlots) ~= 'table' then
        previousSlots = {};
    end
    local restoration = {};
    local activeSlots = {};
    for slot, _ in pairs(previousSlots) do
        if overlay[slot] == nil then
            if state.WarpRingLocked == true and slot == 'Ring2' then
                activeSlots[slot] = true;
            else
                local baseItem = type(baseSet) == 'table' and baseSet[slot] or nil;
                restoration[slot] = baseItem or 'remove';
            end
        end
    end
    for slot, _ in pairs(overlay) do
        activeSlots[slot] = true;
    end
    state.ActiveConditionalOverlaySlots = activeSlots;

    local equipped = false;
    for _, candidate in ipairs({ restoration, overlay }) do
        if next(candidate) ~= nil then
            if force == true and gFunc and gFunc.ForceEquipSet then
                gFunc.ForceEquipSet(contextSafeEquipSet(candidate));
                equipped = true;
            elseif gFunc and gFunc.EquipSet then
                gFunc.EquipSet(contextSafeEquipSet(candidate));
                equipped = true;
            end
        end
    end
    return equipped;
end

function profile.ApplyBuffItemOverlaysForSet(setName, force)
    if not conditionals or not conditionals.ApplyForSet then
        return false;
    end

    local equipped = false;
    if profile.BuffItemAfterUseOverlayForSet then
        local afterUseOverlay = profile.BuffItemAfterUseOverlayForSet(setName, force);
        if next(afterUseOverlay) ~= nil then
            if force == true and gFunc and gFunc.ForceEquipSet then
                gFunc.ForceEquipSet(contextSafeEquipSet(afterUseOverlay));
                equipped = true;
            elseif gFunc and gFunc.EquipSet then
                gFunc.EquipSet(contextSafeEquipSet(afterUseOverlay));
                equipped = true;
            end
        end
    end

    if profile.BuffItemOverlaysEnabled() ~= true then
        return equipped;
    end

    local overlayEquipped = conditionals.ApplyForSet(profile.BuffItemOverlays, setName, {
        force = force,
        gFunc = contextSafeGFunc,
        getBuffCount = getBuffCount,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        itemHasUsesLeft = profile.BuffItemHasUsesLeft,
        state = state,
    });
    return equipped or overlayEquipped;
end

local reconciliationProtectedWeaponSlots = {
    Main = true,
    Sub = true,
    Range = true,
};

local scaleWeaponGuardBypassSlotsBySet = {};

local function profileSlotsDroppedByScale(setName, requestedSet, appliedSet)
    local dropped = {};
    if type(requestedSet) ~= 'table' then
        return dropped;
    end
    if type(appliedSet) ~= 'table' then
        appliedSet = {};
    end

    local bypassSlots = scaleWeaponGuardBypassSlotsBySet[setName] or {};
    for _, slot in ipairs(equipmentSlots) do
        local requestedRemove = normalize(requestedSet[slot]) == 'remove';
        local scaleChangedRemove = requestedRemove and normalize(appliedSet[slot]) ~= 'remove';
        if requestedSet[slot] ~= nil
            and (appliedSet[slot] == nil or scaleChangedRemove)
            and (reconciliationProtectedWeaponSlots[slot] ~= true
                or bypassSlots[slot] == true) then
            dropped[slot] = requestedSet[slot];
        end
    end
    return dropped;
end

local function copyEquipSet(set)
    local copy = {};
    if type(set) ~= 'table' then
        return copy;
    end
    for slot, item in pairs(set) do
        copy[slot] = item;
    end
    return copy;
end

local function overlayEquipSet(baseSet, overlay)
    local result = copyEquipSet(baseSet);
    if type(overlay) ~= 'table' then
        return result;
    end
    for slot, item in pairs(overlay) do
        result[slot] = item;
    end
    return result;
end

function profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, requestedSet)
    local guardedSet = copyEquipSet(requestedSet);
    local bypassSlots = scaleWeaponGuardBypassSlotsBySet[setName] or {};
    for slot, _ in pairs(reconciliationProtectedWeaponSlots) do
        if bypassSlots[slot] ~= true then
            guardedSet[slot] = nil;
        end
    end
    return guardedSet;
end

local function equipProfileSlotsDroppedByScale(setName, requestedSet, appliedSet, force)
    local dropped = profileSlotsDroppedByScale(setName, requestedSet, appliedSet);
    if next(dropped) == nil then
        return appliedSet;
    end
    dropped = movementSafeEquipSet(dropped);

    if force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(dropped);
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(dropped);
    end
    return overlayEquipSet(appliedSet, dropped);
end

local function reconciliationEquipContext(force)
    return {
        force = force,
        gFunc = contextSafeGFunc,
        getBuffCount = getBuffCount,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        itemHasUsesLeft = profile.BuffItemHasUsesLeft,
        state = state,
    };
end

local function conditionalOverlayForSet(setName, force)
    if not conditionals or not conditionals.BuildOverlay then
        return {};
    end

    local ok, overlay = pcall(function()
        return buildConditionalOverlayForSet(setName, reconciliationEquipContext(force));
    end);
    if ok and type(overlay) == 'table' then
        return overlay;
    end
    return {};
end

local function globalConditionalOverlay(force)
    if not conditionals or not conditionals.BuildOverlay then
        return {};
    end

    local ok, overlay = pcall(function()
        return conditionals.BuildOverlay(conditionalEquips.Global, reconciliationEquipContext(force));
    end);
    if ok and type(overlay) == 'table' then
        return overlay;
    end
    return {};
end

local function applyGlobalConditionalEquips(force)
    local overlay = globalConditionalOverlay(force);
    if next(overlay) == nil then
        return false;
    end
    if force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(contextSafeEquipSet(overlay));
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(contextSafeEquipSet(overlay));
        return true;
    end
    return false;
end





local guardSkillJobs = {
    ['MNK'] = true,
    ['PUP'] = true,
};

local function guardJobAbbr(value)
    local numeric = tonumber(value);
    if numeric and jobIdToAbbr[numeric] then
        return jobIdToAbbr[numeric];
    end
    return string.upper(tostring(value or ''));
end

function profile.OddLuaRuntime.GuardSkillState(player)
    player = player or getPlayer();
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return false, 'player context unavailable';
    end

    local mainJob = guardJobAbbr(player.MainJob or player.mainJob);
    local mainLevel = tonumber(
        player.MainJobSync
        or player.mainJobSync
        or player.MainJobLevel
        or player.mainJobLevel
        or player.MainLevel
        or player.mainLevel
    ) or 0;
    if mainLevel < 1 or mainLevel > 75 then
        return false, 'main level outside CatsEye 1-75';
    end
    if guardSkillJobs[mainJob] == true then
        return true, 'native ' .. mainJob;
    end

    local subJob = guardJobAbbr(player.SubJob or player.subJob or player.Subjob or player.subjob);
    local subLevel = tonumber(
        player.SubJobSync
        or player.subJobSync
        or player.SubJobLevel
        or player.subJobLevel
        or player.SubLevel
        or player.subLevel
    ) or 0;
    local effectiveSubCap = math.min(37, math.floor(mainLevel / 2));
    if guardSkillJobs[subJob] == true and subLevel >= 1 and subLevel <= effectiveSubCap then
        return true, 'subjob ' .. subJob .. tostring(subLevel);
    end
    return false, 'current main/subjob has no Guard skill';
end

function profile.OddLuaRuntime.GuardEligibility(player)
    player = player or getPlayer();
    if type(sets.Guard) ~= 'table' or isClearSet(sets.Guard) then
        return false, 'no resolved Guard equipment set';
    end
    local hasSkill, skillReason = profile.OddLuaRuntime.GuardSkillState(player);
    if hasSkill ~= true then
        return false, skillReason;
    end
    if not isEngaged(player) then
        return false, 'not engaged';
    end
    if profile.OddLuaRuntime.HasIncapacitatingStatus() ~= false then
        return false, 'incapacitating status active or unknown';
    end
    if not gData or not gData.GetEquipment then
        return false, 'equipment state unavailable';
    end
    local ok, equipment = pcall(gData.GetEquipment);
    if not ok or type(equipment) ~= 'table' then
        return false, 'equipment state unavailable';
    end
    local main = equipment.Main or equipment.main;
    if main == nil then
        return true, 'eligible while unarmed';
    end
    if type(main) ~= 'table' then
        return false, 'main weapon state unavailable';
    end
    local resource = main.Resource or main.resource;
    if type(resource) ~= 'table' then
        return false, 'main weapon resource unavailable';
    end
    local skill = tonumber(resource.Skill or resource.skill);
    if skill ~= 1 then
        return false, 'main weapon is not Hand-to-Hand';
    end
    return true, 'eligible with Hand-to-Hand';
end

function profile.OddLuaRuntime.ShouldEquipGuard(player)
    local eligible = profile.OddLuaRuntime.GuardEligibility(player);
    return eligible == true;
end



local explicitGearModeSetNames = {
    combat = 'CombatSkillup',
    magic = 'MagicSkillup',
    proc = 'Proc',
};

local function explicitGearModeSetAvailable(mode)
    local setName = explicitGearModeSetNames[normalize(mode)];
    return setName ~= nil
        and type(sets[setName]) == 'table'
        and not isClearSet(sets[setName]);
end

function profile.OddLuaRuntime.ExplicitGearModeAvailabilityText()
    local parts = {};
    for _, mode in ipairs({ 'combat', 'magic', 'proc' }) do
        parts[#parts + 1] = mode .. '=' .. (explicitGearModeSetAvailable(mode) and 'yes' or 'no');
    end
    return table.concat(parts, ',');
end

function profile.OddLuaRuntime.ExplicitGearModeOverlay(surface)
    local mode = normalize(state.ExplicitGearMode);
    if surface == 'default'
        and (mode == 'combat' or mode == 'proc')
        and not isEngaged(getPlayer())
    then
        return {};
    end
    local active = (surface == 'default' and (mode == 'combat' or mode == 'proc'))
        or (surface == 'midcast' and mode == 'magic');
    if active ~= true or explicitGearModeSetAvailable(mode) ~= true then
        return {};
    end

    local overlay = copyEquipSet(sets[explicitGearModeSetNames[mode]]);
    if mode == 'proc' then
        -- Proc is intentionally a Main-only weapon decision. Fail closed if a
        -- malformed generated set ever grows armor or secondary weapon slots.
        for _, slot in ipairs(equipmentSlots) do
            if slot ~= 'Main' then
                overlay[slot] = nil;
            end
        end
    else
        overlay.Main = nil;
        overlay.Sub = nil;
        overlay.Range = nil;
        overlay.Ammo = nil;
    end
    return overlay;
end

function profile.OddLuaRuntime.ApplyExplicitGearMode(surface, force)
    local overlay = profile.OddLuaRuntime.ExplicitGearModeOverlay(surface);
    if next(overlay) == nil then
        return false;
    end
    if force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(movementSafeEquipSet(overlay));
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(movementSafeEquipSet(overlay));
        return true;
    end
    return false;
end

function profile.BuffItemAfterUseOverlayForSet(setName, force)
    if not conditionals or not conditionals.ConditionMatches then
        return {};
    end

    local entries = profile.BuffItemOverlays[setName];
    if type(entries) ~= 'table' then
        return {};
    end

    local context = reconciliationEquipContext(force);
    local overlay = {};
    local function setOwnsSlot(slot)
        local set = sets[setName];
        return type(set) == 'table' and set[slot] ~= nil;
    end
    for _, entry in ipairs(entries) do
        if type(entry) == 'table' then
            local hasUsesLeft = true;
            if type(entry.item) == 'table' then
                hasUsesLeft = profile.BuffItemHasUsesLeft(entry) == true;
            end
            if profile.BuffItemOverlaysEnabled() ~= true
                or conditionals.ConditionMatches(entry.condition, context) ~= true
                or hasUsesLeft ~= true then
                for slot, item in pairs(entry.afterUse or {}) do
                    if normalize(item) ~= 'remove' or setOwnsSlot(slot) then
                        overlay[slot] = item;
                    end
                end
            end
        end
    end
    if state.WarpRingLocked == true then
        overlay.Ring2 = nil;
    end
    return overlay;
end

function profile.BuffItemOverlayForSet(setName, force)
    if not conditionals or not conditionals.BuildOverlay then
        return {};
    end
    if profile.BuffItemOverlaysEnabled() ~= true then
        return {};
    end

    local ok, overlay = pcall(function()
        return conditionals.BuildOverlay(profile.BuffItemOverlays[setName], reconciliationEquipContext(force));
    end);
    if ok and type(overlay) == 'table' then
        return overlay;
    end
    return {};
end

local function shouldExpectProtectedWeapons(intent)
    local status = nil;
    if scale and scale.Status then
        local ok, result = pcall(scale.Status);
        if ok and type(result) == 'table' then
            status = result;
        end
    end

    if status and status.weaponLockEnabled == false then
        return false;
    end
    if status and tonumber(status.tp or 0) and tonumber(status.tp or 0) > 0 then
        return true;
    end
    if status and isEngaged(status) then
        return intent ~= 'TP';
    end

    local player = getPlayer();
    if playerTp(player) > 0 then
        return true;
    end
    if isEngaged(player) then
        return intent ~= 'TP';
    end
    return false;
end

local function expectedSetWithProtectedWeapons(expectedSet, requestedSet, intent)
    local expected = copyEquipSet(expectedSet);
    if not shouldExpectProtectedWeapons(intent) then
        return expected;
    end

    local observed = observeReconciliationEquipment();
    if type(observed) ~= 'table' then
        return expected;
    end

    for slot, _ in pairs(reconciliationProtectedWeaponSlots) do
        if requestedSet and requestedSet[slot] ~= nil and expected[slot] == nil and observed[slot] ~= nil then
            expected[slot] = observed[slot];
        end
    end
    return expected;
end

local function resolvedReconciliationExpectedSet(setName, requestedSet, appliedSet, force)
    local expectedSet = copyEquipSet(appliedSet);
    if next(expectedSet) == nil then
        expectedSet = copyEquipSet(requestedSet);
    end
    expectedSet = expectedSetWithProtectedWeapons(expectedSet, requestedSet, setIntents[setName]);
    expectedSet = overlayEquipSet(expectedSet, conditionalOverlayForSet(setName, force));
    expectedSet = overlayEquipSet(expectedSet, profile.BuffItemAfterUseOverlayForSet(setName, force));
    expectedSet = overlayEquipSet(expectedSet, profile.BuffItemOverlayForSet(setName, force));
    expectedSet = overlayEquipSet(expectedSet, globalConditionalOverlay(force));


    expectedSet = overlayEquipSet(expectedSet, profile.OddLuaRuntime.ExplicitGearModeOverlay('default'));
    return contextSafeEquipSet(expectedSet);
end

local function isStableEquipIntent(setName)
    if state.IdleOverrideSet == setName then
        return true;
    end
    local intent = normalize(setIntents[setName] or '');
    return intent == 'tp' or intent == 'idle' or intent == 'movement';
end

local function stableEquipForceForSet(setName, setToEquip, force)
    if force == true then
        if isStableEquipIntent(setName) then
            state.StableEquipForcePending = false;
        end
        return true;
    end
    if state.StableEquipForcePending == true and isStableEquipIntent(setName) and not isClearSet(setToEquip) then
        state.StableEquipForcePending = false;
        return true;
    end
    return false;
end

local function markStableEquipForceNeeded(setName, force)
    if force == true then
        return;
    end
    if not isStableEquipIntent(setName) then
        state.StableEquipForcePending = true;
    end
end

local function equipNamedSet(setName, force, requestedSet)
    local set = requestedSet or sets[setName];
    if not set then
        return false;
    end

    local setToEquip = setWithSubjobLegalOffhand(setName, set);
    setToEquip = contextSecondarySlotSafeSet(setToEquip);
    if state.ExplicitGearModeDefaultRouting == true
        and normalize(state.ExplicitGearMode) == 'proc'
    then
        local protectedSet = copyEquipSet(setToEquip);
        protectedSet.Main = nil;
        setToEquip = protectedSet;
    end

    local effectiveForce = stableEquipForceForSet(setName, setToEquip, force);
    if isClearSet(setToEquip) then
        markStableEquipForceNeeded(setName, effectiveForce);
        return false;
    end

    releaseSecondarySlotLocksNotInSet(setName);

    if state.WarpRingLocked == true then
        local appliedLockedSet = nil;
        if scale and scale.ResolveSet then
            local ok, resolved = pcall(scale.ResolveSet, setName, setToEquip, setIntents[setName]);
            if ok == true and type(resolved) == 'table' then
                appliedLockedSet = resolved;
            end
        end
        if type(appliedLockedSet) ~= 'table' then
            appliedLockedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, setToEquip);
        end
        appliedLockedSet = movementSafeEquipSet(applyWarpRingLock(appliedLockedSet));
        local requestedLockedSet = applyWarpRingLock(setToEquip);
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(appliedLockedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(appliedLockedSet);
        end
        applyConditionalEquipsForSet(setName, appliedLockedSet, effectiveForce);
        profile.ApplyBuffItemOverlaysForSet(setName, effectiveForce);
        applyGlobalConditionalEquips(effectiveForce);

        applySecondarySlotLocksForSet(setName);
        local equippedSet = resolvedReconciliationExpectedSet(setName, requestedLockedSet, appliedLockedSet, effectiveForce);
        scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
        markStableEquipForceNeeded(setName, effectiveForce);
        state.LastEquippedSetName = setName;
        return true;
    end

    local appliedSet = setToEquip;
    local usedScaleResolver = false;
    if movementSafetyActive() == true then
        -- Resolve first, then apply movement safety and dispatch directly so a
        -- movement-penalty item cannot be restored by a stale Scale copy.
        if scale and scale.ResolveSet then
            local ok, resolved = pcall(scale.ResolveSet, setName, setToEquip, setIntents[setName]);
            if ok == true and type(resolved) == 'table' then
                appliedSet = resolved;
                usedScaleResolver = true;
            end
        end
        if usedScaleResolver ~= true then
            appliedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, appliedSet);
        end
        appliedSet = movementSafeEquipSet(appliedSet);
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(appliedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(appliedSet);
        end
    elseif effectiveForce == true and scale and scale.ForceEquipSet then
        appliedSet = scale.ForceEquipSet(setName, setToEquip, setIntents[setName]);
        usedScaleResolver = true;
    elseif scale and scale.EquipSet then
        appliedSet = scale.EquipSet(setName, setToEquip, setIntents[setName]);
        usedScaleResolver = true;
    elseif effectiveForce == true and gFunc and gFunc.ForceEquipSet then
        appliedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, setToEquip);
        gFunc.ForceEquipSet(movementSafeEquipSet(appliedSet));
    elseif gFunc and gFunc.EquipSet then
        appliedSet = profile.OddLuaRuntime.ScaleGuardedDirectEquipSet(setName, setToEquip);
        gFunc.EquipSet(movementSafeEquipSet(appliedSet));
    end
    if usedScaleResolver == true then
        local recoverySet = setToEquip;
        if movementSafetyActive() == true then
            recoverySet = movementSafeEquipSet(recoverySet);
        end
        appliedSet = equipProfileSlotsDroppedByScale(setName, recoverySet, appliedSet, effectiveForce);
    end
    applyConditionalEquipsForSet(setName, appliedSet, effectiveForce);
    profile.ApplyBuffItemOverlaysForSet(setName, effectiveForce);
    applyGlobalConditionalEquips(effectiveForce);

    applySecondarySlotLocksForSet(setName);
    local equippedSet = resolvedReconciliationExpectedSet(setName, setToEquip, appliedSet, effectiveForce);
    scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
    markStableEquipForceNeeded(setName, effectiveForce);
    state.LastEquippedSetName = setName;
    return true;
end

local function equipNamedSetIfNotClear(setName, force)
    local set = sets[setName];
    if not set or isClearSet(set) then
        return false;
    end
    return equipNamedSet(setName, force);
end

function profile.OddLuaRuntime.ManualOverrideSourceSetName(setName)
    local candidates = {};
    local transition = nil;
    if type(mechanicsSwapPlanner) == 'table' and type(mechanicsSwapPlanner.transitions) == 'table' then
        transition = mechanicsSwapPlanner.transitions[setName];
    end
    if type(transition) == 'table' then
        table.insert(candidates, transition.sourceSet);
    end
    if type(mechanicsSwapPlanner) == 'table' then
        table.insert(candidates, mechanicsSwapPlanner.baselineSet);
    end
    table.insert(candidates, 'Aftercast');
    table.insert(candidates, 'Idle');

    local seen = {};
    for _, candidate in ipairs(candidates) do
        if type(candidate) == 'string' and candidate ~= '' and candidate ~= setName
            and seen[candidate] ~= true
        then
            seen[candidate] = true;
            if type(sets[candidate]) == 'table' and not isClearSet(sets[candidate]) then
                return candidate;
            end
        end
    end
    return nil;
end

function profile.OddLuaRuntime.BuildManualOverrideSet(setName)
    local targetSet = sets[setName];
    if type(targetSet) ~= 'table' or isClearSet(targetSet) then
        return nil, nil;
    end
    local sourceSetName = profile.OddLuaRuntime.ManualOverrideSourceSetName(setName);
    if sourceSetName == nil then
        return nil, nil;
    end
    local composedSet = overlayEquipSet(sets[sourceSetName], targetSet);
    for _, slot in ipairs(equipmentSlots) do
        if composedSet[slot] == nil then
            composedSet[slot] = 'remove';
        end
    end
    return composedSet, sourceSetName;
end

function profile.OddLuaRuntime.EquipManualOverrideSet(setName, force)
    local composedSet = profile.OddLuaRuntime.BuildManualOverrideSet(setName);
    if type(composedSet) ~= 'table' then
        return false;
    end
    return equipNamedSet(setName, force, composedSet);
end

local function equipOvertDefensiveSet(setName, unlockWeapons)
    if not setName then
        return false;
    end

    -- Ordinary three-target pressure still needs defensive armor, but it must
    -- keep Scale's weapon guard.  Only zero TP or the already-qualified
    -- sub-60% HP emergency is allowed to unlock weapons.
    if unlockWeapons ~= true then
        return equipNamedSet(setName, true);
    end

    local status = {};
    if scale and scale.Status then
        local ok, result = pcall(scale.Status);
        if ok and type(result) == 'table' then
            status = result;
        end
    end
    local previousWeaponLockEnabled = status.weaponLockEnabled == true;

    if scale and scale.SetWeaponLockEnabled then
        local unlockOk = pcall(scale.SetWeaponLockEnabled, false);
        if unlockOk ~= true then
            return equipNamedSet(setName, true);
        end
    else
        return equipNamedSet(setName, true);
    end
    local ok, equipped = pcall(equipNamedSet, setName, true);
    local restoreOk = pcall(scale.SetWeaponLockEnabled, previousWeaponLockEnabled);
    if restoreOk ~= true then
        return false;
    end
    return ok == true and equipped == true;
end

local function forceEquipInlineSet(set, ignoreWarpRingLock)
    if type(set) ~= 'table' then
        return false;
    end

    local setToEquip = set;
    if ignoreWarpRingLock ~= true then
        setToEquip = applyWarpRingLock(set);
    end

    if gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(movementSafeEquipSet(setToEquip));
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(movementSafeEquipSet(setToEquip));
        return true;
    end
    return false;
end

function profile.OddLuaRuntime.ExplicitSetMpBridgePlan()
    if not mechanicsSwapPlanner or mechanicsSwapPlanner.loaded ~= true then
        return nil;
    end
    local explicitTransitions = mechanicsSwapPlanner.explicitTransitions;
    if type(explicitTransitions) ~= 'table' then
        return nil;
    end
    local plan = explicitTransitions.setmp;
    if type(plan) ~= 'table' or plan.available ~= true then
        return nil;
    end
    if plan.targetSet ~= 'IdleMaxMP' or type(sets[plan.targetSet]) ~= 'table'
        or isClearSet(sets[plan.targetSet]) then
        return nil;
    end
    if type(plan.sourceSet) ~= 'string' or plan.sourceSet == ''
        or type(plan.sourceEquipment) ~= 'table'
        or type(plan.sourceVariants) ~= 'table'
        or type(plan.targetEquipment) ~= 'table'
        or type(plan.slot) ~= 'string' or plan.slot == ''
        or type(plan.sourceItem) ~= 'string' or plan.sourceItem == ''
        or type(plan.bridgeItem) ~= 'string' or plan.bridgeItem == ''
        or type(plan.finalItem) ~= 'string' or plan.finalItem == ''
    then
        return nil;
    end

    local knownSlot = false;
    for _, slot in ipairs(equipmentSlots) do
        if slot == plan.slot then
            knownSlot = true;
            break;
        end
    end
    if knownSlot ~= true
        or not reconciliationNamesMatch(plan.sourceItem, plan.sourceEquipment[plan.slot] or '')
        or reconciliationNamesMatch(plan.sourceItem, plan.bridgeItem)
        or reconciliationNamesMatch(plan.bridgeItem, plan.finalItem)
    then
        return nil;
    end

    local targetItem = reconciliationExpectedName(plan.targetEquipment[plan.slot]);
    if targetItem == nil or not reconciliationNamesMatch(plan.finalItem, targetItem) then
        return nil;
    end
    for slot, expected in pairs(plan.targetEquipment) do
        local namedTarget = reconciliationExpectedName(sets[plan.targetSet][slot]);
        if namedTarget == nil or not reconciliationNamesMatch(expected, namedTarget) then
            return nil;
        end
    end
    if (tonumber(plan.conversionAmount) or 0) <= 0
        or (tonumber(plan.bridgeHpCost) or -1) < 0
        or (tonumber(plan.hpCost) or -1) < 0
        or (tonumber(plan.mpGain) or 0) <= 0
        or tonumber(plan.sourceKnownHp) == nil
        or tonumber(plan.sourceKnownMp) == nil
        or tonumber(plan.targetHp) == nil
        or tonumber(plan.targetMp) == nil
    then
        return nil;
    end
    return plan;
end

function profile.OddLuaRuntime.ExplicitSetMpBridgeGate(player, plan)
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return false, 'player unavailable';
    end
    if isEngaged(player) or isResting(player) then
        return false, 'not idle';
    end
    if state.Playstyle == 'Craft' then
        return false, 'craft active';
    end
    if state.WarpRingLocked == true then
        return false, 'warp ring locked';
    end
    if state.IdleOverrideSet ~= nil then
        return false, 'override active';
    end
    if profile.OddLuaRuntime.DangerousStatusState() ~= false
        or profile.OddLuaRuntime.HasWeakness() ~= false
        or profile.OddLuaRuntime.StatusListState(profile.OddLuaRuntime.CurseStatusBuffs) ~= false
    then
        return false, 'status unsafe';
    end
    if profile.OddLuaRuntime.ActiveSafetyReason(player) ~= 'none'
        or profile.OddLuaRuntime.ShouldEquipIdleCombat(player)
        or isEmergencyHp(player)
    then
        return false, 'safety active';
    end
    if profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player) ~= true then
        return false, 'MP floor inactive';
    end

    local hp = profile.OddLuaRuntime.PlayerHp(player);
    local maxHp = tonumber(player.MaxHP or player.maxHP or player.HPMax or player.hpmax);
    local mp = profile.OddLuaRuntime.PlayerMp(player);
    local maxMp = tonumber(player.MaxMP or player.maxMP or player.MPMax or player.mpmax);
    if hp == nil or maxHp == nil or mp == nil or maxMp == nil
        or hp <= 0 or maxHp < hp or mp < 0 or maxMp < mp
    then
        return false, 'pools unavailable';
    end
    local observed = observeReconciliationEquipment();
    if type(observed) ~= 'table' then
        return false, 'source mismatch';
    end
    for slot, expected in pairs(plan.sourceEquipment) do
        if not reconciliationNamesMatch(expected, observed[slot] or '') then
            return false, 'source mismatch';
        end
    end

    local sourceHp = tonumber(plan.sourceKnownHp);
    local sourceMp = tonumber(plan.sourceKnownMp);
    for slot, variants in pairs(plan.sourceVariants) do
        if type(variants) ~= 'table' then
            return false, 'source variants invalid';
        end
        local matched = false;
        local variantHp = nil;
        local variantMp = nil;
        for _, variant in ipairs(variants) do
            if type(variant) == 'table'
                and reconciliationNamesMatch(variant.item or '', observed[slot] or '')
            then
                matched = true;
                variantHp = math.max(variantHp or tonumber(variant.hp) or 0, tonumber(variant.hp) or 0);
                variantMp = math.max(variantMp or tonumber(variant.mp) or 0, tonumber(variant.mp) or 0);
            end
        end
        if matched ~= true then
            return false, 'source variant mismatch';
        end
        sourceHp = sourceHp + (variantHp or 0);
        sourceMp = sourceMp + (variantMp or 0);
    end

    local targetHp = tonumber(plan.targetHp);
    local targetMp = tonumber(plan.targetMp);
    if targetMp < sourceMp then
        return false, 'final MP pool unsafe';
    end
    local requiredHpCost = math.max(tonumber(plan.bridgeHpCost), sourceHp - targetHp, 0);
    if maxHp - hp < requiredHpCost then
        return false, 'HP headroom low';
    end
    return true, nil, observed;
end

function profile.OddLuaRuntime.TryExplicitSetMpBridge(player)
    local plan = profile.OddLuaRuntime.ExplicitSetMpBridgePlan();
    if plan == nil then
        return false;
    end
    if state.HpToMpBridgeInFlight == true then
        return true;
    end

    local allowed, reason, observed = profile.OddLuaRuntime.ExplicitSetMpBridgeGate(player, plan);
    if allowed ~= true then
        message('HP-to-MP bridge skipped: ' .. tostring(reason) .. '.');
        return true;
    end

    local bridgeSet = {};
    bridgeSet[plan.slot] = plan.bridgeItem;
    local finalSet = {};
    finalSet[plan.slot] = plan.finalItem;
    local sourceSet = {};
    for slot in pairs(plan.targetEquipment) do
        local observedName = observed[slot];
        sourceSet[slot] = observedName ~= nil and observedName ~= '' and observedName or 'remove';
    end

    state.HpToMpBridgeInFlight = true;
    local ok, result = pcall(function()
        if forceEquipInlineSet(bridgeSet, true) ~= true then
            error('bridge equip unavailable');
        end
        if forceEquipInlineSet(plan.targetEquipment, true) ~= true then
            error('target set unavailable');
        end
        if forceEquipInlineSet(finalSet, true) ~= true then
            error('final equip unavailable');
        end
        return true;
    end);
    if ok ~= true or result ~= true then
        local restoreOk, restored = pcall(forceEquipInlineSet, sourceSet, true);
        state.HpToMpBridgeInFlight = false;
        if restoreOk == true and restored == true then
            message('HP-to-MP bridge failed; source restored.');
        else
            message('HP-to-MP bridge failed; restore unavailable.');
        end
        return true;
    end

    state.HpToMpBridgeInFlight = false;
    message('HP-to-MP bridge queued.');
    return true;
end

local oddLuaWarpRing = {};

function oddLuaWarpRing.lockRing2()
    if gFunc and gFunc.Disable then
        gFunc.Disable('Ring2');
    end
end

function oddLuaWarpRing.unlockRing2()
    if gFunc and gFunc.Enable then
        gFunc.Enable('Ring2');
    end
end

local function clearWarpRing()
    state.WarpRingLocked = false;
    oddLuaWarpRing.unlockRing2();
    if forceEquipInlineSet({ Ring2 = 'remove' }, true) then
        message('Warp Ring removed from Ring2.');
    else
        message('Warp Ring cleanup failed: unable to force Ring2 remove.');
    end
end

function oddLuaWarpRing.finishUse()
    local useQueued = queueTypedCommand('/item "Warp Ring" <me>', 1);
    if not useQueued then
        message('Warp Ring use failed: unable to queue item command.');
        clearWarpRing();
        return;
    end
    message('Warp Ring use queued. Ring2 unlocks in 10 seconds.');
    if not scheduleTask(10, clearWarpRing) then
        message('Warp Ring cleanup scheduling failed; use /lac fwd warpclear.');
    end
end

local function useWarpRing()
    if state.WarpRingLocked == true then
        message('Warp Ring flow already running.');
        return;
    end

    state.WarpRingLocked = true;
    if not forceEquipInlineSet({ Ring2 = 'Warp Ring' }, true) then
        state.WarpRingLocked = false;
        message('Warp Ring equip failed: unable to force Ring2.');
        return;
    end
    oddLuaWarpRing.lockRing2();
    message('Warp Ring equipped and locked in Ring2. Use fires in 10 seconds.');
    if not scheduleTask(10, oddLuaWarpRing.finishUse) then
        message('Warp Ring use scheduling failed.');
        clearWarpRing();
    end
end

local function equipFirstAvailable(setNames, force)
    local triedSird = false;
    for _, setName in ipairs(setNames or {}) do
        if setName == 'SIRD' then
            triedSird = true;
        elseif setName == 'Midcast' and not triedSird then
            triedSird = true;
            if equipNamedSetIfNotClear('SIRD', force) then
                return true;
            end
        end
        if setName and equipNamedSetIfNotClear(setName, force) then
            return true;
        end
    end
    return false;
end

function profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay()
    if state.IdleOverrideSet ~= nil and state.IdleOverrideSet ~= '' then
        if state.IdleOverrideSet == 'Guard'
            and not profile.OddLuaRuntime.ShouldEquipGuard(getPlayer())
        then
            return false;
        end

        return equipNamedSetIfNotClear(state.IdleOverrideSet, false);
    end
    return false;
end

function profile.OverrideStateText()
    if state.IdleOverrideSet and state.IdleOverrideSet ~= '' then
        return tostring(state.IdleOverrideSet);
    end
    return 'off';
end

function profile.ResistStateText()
    return profile.OverrideStateText();
end

function profile.SetIdleOverrideSet(setName, label)
    local messageLabel = label or 'Override';
    if setName == nil or setName == '' then
        if state.IdleOverrideSet == nil or state.IdleOverrideSet == '' then
            message(messageLabel .. '=off.');
            return false;
        end
        state.IdleOverrideSet = nil;
        message(messageLabel .. '=off.');
        return true;
    end
    if state.IdleOverrideSet == setName then
        state.IdleOverrideSet = nil;
        message(messageLabel .. '=off.');
        return true;
    end
    if not sets[setName] or isClearSet(sets[setName]) then
        message('Not Applicable / Missing Equipment');
        return false;
    end
    local composedSet = profile.OddLuaRuntime.BuildManualOverrideSet(setName);
    if type(composedSet) ~= 'table' then
        message('Not Applicable / Missing Override Baseline');
        return false;
    end
    state.IdleOverrideSet = setName;
    message(messageLabel .. '=' .. tostring(setName) .. '.');
    return true;
end

function profile.HandleOverrideCommand(args)
    local command = normalize(args and args[1]);
    local value = normalize(args and args[2]);
    if command == 'override' or command == 'defense' or command == 'def' then
        if value == '' or value == 'status' then
            message('Override=' .. profile.OverrideStateText() .. '.');
            return false;
        elseif value == 'off' or value == 'clear' then
            command = 'defenseoff';
        else
            command = value;
        end
    end
    local setName = profile.DefenseAliases[command];
    if setName == nil then
        setName = profile.ResistAliases[command];
    end
    if setName == nil then
        message('Unknown override command. Use pdt|mdt|dt|evasion|safe|survival|tank|defenseoff.');
        return false;
    end
    return profile.SetIdleOverrideSet(setName, 'Override');
end

function profile.HandleResistCommand(args)
    local command = normalize(args and args[1]);
    local value = normalize(args and args[2]);
    if command == 'resist' or command == 'res' then
        if value == '' or value == 'status' then
            message('Resist override=' .. profile.ResistStateText() .. '.');
            return false;
        elseif value == 'off' or value == 'clear' then
            command = 'resoff';
        elseif value:sub(-3) == 'res' then
            command = value;
        elseif value:sub(-6) == 'resist' then
            command = value;
        end
        if command == 'resist' or command == 'res' then
            command = value .. 'res';
        end
    end
    local setName = profile.ResistAliases[command];
    if setName == nil then
        message('Unknown resist command. Use fireres|iceres|earthres|windres|waterres|thunderres|lightningres|lightres|darkres|statusres|charmres|resoff.');
        return false;
    end
    return profile.SetIdleOverrideSet(setName, 'Resist override');
end

function profile.OddLuaRuntime.IdlePoolText(label, threshold, extra)
    if (tonumber(threshold or 0) or 0) <= 0 and (tonumber(extra or 0) or 0) <= 0 then
        return label .. '=off';
    end
    return label .. '=' .. tostring(tonumber(threshold or 0) or 0) .. '+' .. tostring(tonumber(extra or 0) or 0);
end

function profile.IdlePoolStateText()
    return profile.OddLuaRuntime.IdlePoolText('mp', state.IdleMaxMPThreshold, state.IdleMaxMPAdd)
        .. '; ' .. profile.OddLuaRuntime.IdlePoolText('hp', state.IdleMaxHPThreshold, state.IdleMaxHPAdd);
end

function profile.OddLuaRuntime.ParseIdlePoolNumber(value)
    if tonumber(value) == nil then
        return nil;
    end
    return math.max(0, math.floor(tonumber(value)));
end

function profile.OddLuaRuntime.UpdateIdlePoolField(fieldName, value, label)
    if value == nil then
        message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
        return false;
    end
    if state[fieldName] == value then
        message(label .. '=' .. tostring(value) .. '.');
        return false;
    end
    state[fieldName] = value;
    if fieldName == 'IdleMaxMPThreshold' or fieldName == 'IdleMaxMPAdd' then
        state.IdleMaxMPActive = false;
    elseif fieldName == 'IdleMaxHPThreshold' or fieldName == 'IdleMaxHPAdd' then
        state.IdleMaxHPActive = false;
    end
    message(label .. '=' .. tostring(value) .. '.');
    return true;
end

function profile.HandleIdlePoolCommand(args)
    local command = normalize(args and args[1]);
    local value = profile.OddLuaRuntime.ParseIdlePoolNumber(args and args[2]);
    if command == 'setmp' then
        local changed = profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxMPThreshold', value, 'Set MP');
        if changed ~= true then
            return false, false;
        end
        return true, profile.OddLuaRuntime.TryExplicitSetMpBridge(getPlayer());
    elseif command == 'addmp' then
        return profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxMPAdd', value, 'Add MP');
    elseif command == 'resetmp' then
        if state.IdleMaxMPThreshold == 0 and state.IdleMaxMPAdd == 0 then
            message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
            return false;
        end
        state.IdleMaxMPThreshold = 0;
        state.IdleMaxMPAdd = 0;
        state.IdleMaxMPActive = false;
        message('Reset MP.');
        return true;
    elseif command == 'sethp' then
        return profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxHPThreshold', value, 'Set HP');
    elseif command == 'addhp' then
        return profile.OddLuaRuntime.UpdateIdlePoolField('IdleMaxHPAdd', value, 'Add HP');
    elseif command == 'resethp' then
        if state.IdleMaxHPThreshold == 0 and state.IdleMaxHPAdd == 0 then
            message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
            return false;
        end
        state.IdleMaxHPThreshold = 0;
        state.IdleMaxHPAdd = 0;
        state.IdleMaxHPActive = false;
        message('Reset HP.');
        return true;
    end
    message('Idle pool floors: ' .. profile.IdlePoolStateText() .. '.');
    return false;
end

function profile.OddLuaPet.currentPetName()
    local pet = profile.OddLuaPet.getPet();
    if type(pet) == 'string' then
        return pet;
    end
    if type(pet) ~= 'table' then
        return '';
    end
    if pet.Name ~= nil then
        return tostring(pet.Name);
    elseif pet.name ~= nil then
        return tostring(pet.name);
    elseif pet.PetName ~= nil then
        return tostring(pet.PetName);
    elseif pet.petName ~= nil then
        return tostring(pet.petName);
    elseif type(pet.Resource) == 'table' and pet.Resource.Name ~= nil then
        return tostring(pet.Resource.Name);
    elseif type(pet.Item) == 'table' and pet.Item.Name ~= nil then
        return tostring(pet.Item.Name);
    end
    return '';
end

function profile.OddLuaPet.petSetToken(petName)
    local token = tostring(petName or '');
    token = string.gsub(token, '^%s+', '');
    token = string.gsub(token, '%s+$', '');
    token = string.gsub(token, '[^%w]+', '_');
    token = string.gsub(token, '_+', '_');
    token = string.gsub(token, '^_+', '');
    token = string.gsub(token, '_+$', '');
    return token;
end

function profile.OddLuaPet.titlePetSetToken(token)
    local parts = {};
    for part in string.gmatch(string.lower(tostring(token or '')), '[^_]+') do
        local first = string.sub(part, 1, 1);
        local rest = string.sub(part, 2);
        if first ~= '' then
            parts[#parts + 1] = string.upper(first) .. rest;
        end
    end
    return table.concat(parts, '_');
end

function profile.OddLuaPet.addPetOverlayCandidate(candidates, seen, setName)
    if setName and setName ~= '' and not seen[setName] then
        seen[setName] = true;
        candidates[#candidates + 1] = setName;
    end
end

function profile.OddLuaPet.petOverlaySetNames(petName)
    local token = profile.OddLuaPet.petSetToken(petName);
    if token == '' then
        return {};
    end

    local titleToken = profile.OddLuaPet.titlePetSetToken(token);
    local lowerToken = string.lower(token);
    local candidates = {};
    local seen = {};
    for _, prefix in ipairs({ 'Pet_', 'Avatar_', 'Jug_', 'SMNPet_', 'BSTPet_', 'Wyvern_' }) do
        profile.OddLuaPet.addPetOverlayCandidate(candidates, seen, prefix .. titleToken);
        profile.OddLuaPet.addPetOverlayCandidate(candidates, seen, prefix .. lowerToken);
    end
    return candidates;
end

function profile.OddLuaPet.equipPetOverlayForCurrentPet(force)
    return equipFirstAvailable(profile.OddLuaPet.petOverlaySetNames(profile.OddLuaPet.currentPetName()), force);
end

function profile.OddLuaPet.equipPetActionSet(setNames, force)
    local equipped = equipFirstAvailable(setNames, force);
    local overlayEquipped = profile.OddLuaPet.equipPetOverlayForCurrentPet(force);
    return equipped or overlayEquipped;
end

profile.OddLuaPet.PinPolicies = {
    rage = {
        SetNames = { 'BloodPactRage', 'BloodPact', 'PetDamage', 'SummoningMagic', 'JobAbility' },
        StartSlackSeconds = 1.0,
        FinishSlackSeconds = 1.0,
    },
    ward = {
        SetNames = { 'BloodPactWard', 'SummoningMagic', 'PetTank', 'AvatarPerp', 'JobAbility' },
        StartSlackSeconds = 1.0,
        FinishSlackSeconds = 1.0,
    },
    ready_sic = {
        SetNames = { 'PetReady', 'PetDamage', 'PetTank', 'JobAbility' },
        StartSlackSeconds = 1.0,
        FinishSlackSeconds = 1.0,
    },
};

-- Exact cap-75 actions whose server formulas consume the PetMagic objective.
-- Hybrids, breath/fixed-damage moves, heals, post-cap actions, and unknowns
-- deliberately stay on their existing fail-closed policy chains.
profile.OddLuaPet.MagicalActionNames = {};
for _, actionName in ipairs({
    'Searing Light', 'Level ? Holy', 'Howling Moon',
    'Fire II', 'Fire IV', 'Meteor Strike', 'Inferno',
    'Stone II', 'Stone IV', 'Geocrush', 'Earthen Fury',
    'Water II', 'Water IV', 'Grand Fall', 'Tidal Wave',
    'Aero II', 'Aero IV', 'Wind Blade', 'Aerial Blast',
    'Blizzard II', 'Blizzard IV', 'Heavenly Strike', 'Diamond Dust',
    'Thunder II', 'Thunderspark', 'Thunder IV', 'Thunderstorm', 'Judgment Bolt',
    'Somnolence', 'Mewing Lullaby', 'Eerie Eye', 'Sleepga', 'Nightmare',
    'Clarsach Call', 'Sonic Buffet', 'Tornado II',
    'Dust Cloud', 'Fireball', 'Cursed Sphere', 'Venom', 'Dream Flower',
    'Scream', 'Roar', 'Infrasonics', 'Sheep Song', 'Spore', 'Hi-Freq Field',
    'Spoil', 'Sandblast', 'Sandpit', 'Venom Spray', 'Soporific',
    'Gloeosuccus', 'Palsy Pollen', 'Numbing Noise', 'Toxic Spit',
    'Filamented Hold', 'Intimidate',
    'Dia', 'Dia II', 'Slow', 'Paralyze', 'Silence',
    'Fire', 'Fire III', 'Blizzard', 'Blizzard III', 'Aero', 'Aero III',
    'Stone', 'Stone III', 'Thunder', 'Thunder III', 'Water', 'Water III',
    'Poison', 'Poison II', 'Bio', 'Bio II', 'Drain', 'Aspir', 'Blind',
    'Dispel', 'Absorb-INT',
}) do
    profile.OddLuaPet.MagicalActionNames[normalize(actionName)] = true;
end

function profile.OddLuaPet.isMagicalAction(action)
    if type(action) ~= 'table' then
        return false;
    end
    return profile.OddLuaPet.MagicalActionNames[normalize(action.Name or action.name)] == true;
end

function profile.OddLuaPet.setNamesForObservedAction(policy, action)
    local setNames = {};
    local seen = {};
    local function add(setName)
        if type(setName) == 'string' and setName ~= '' and seen[setName] ~= true then
            seen[setName] = true;
            setNames[#setNames + 1] = setName;
        end
    end
    if profile.OddLuaPet.isMagicalAction(action) then
        add('PetMagic');
    end
    for _, setName in ipairs(type(policy) == 'table' and policy.SetNames or {}) do
        add(setName);
    end
    return setNames;
end

function profile.OddLuaPet.getPetAction()
    if not gData or type(gData.GetPetAction) ~= 'function' then
        return nil, false;
    end
    local ok, action = pcall(gData.GetPetAction);
    if ok ~= true then
        return nil, false;
    end
    return action, true;
end

function profile.OddLuaPet.canPinAction(kind)
    if type(profile.OddLuaPet.PinPolicies[kind]) ~= 'table' then
        return false;
    end
    if type(gSettings) == 'table' and gSettings.HorizonMode == true then
        return false;
    end
    return gData ~= nil and type(gData.GetPetAction) == 'function';
end

function profile.OddLuaPet.clearActionPin()
    state.PetActionPin = nil;
end

function profile.OddLuaPet.clampDelay(value, minimum, maximum)
    local number = tonumber(value) or minimum;
    if number < minimum then
        return minimum;
    elseif number > maximum then
        return maximum;
    end
    return number;
end

function profile.OddLuaPet.beginActionPin(kind)
    local policy = profile.OddLuaPet.PinPolicies[kind];
    if type(policy) ~= 'table' then
        profile.OddLuaPet.clearActionPin();
        return false;
    end
    if profile.OddLuaPet.canPinAction(kind) ~= true then
        profile.OddLuaPet.clearActionPin();
        return profile.OddLuaPet.equipPetActionSet(policy.SetNames, false);
    end

    local settings = type(gSettings) == 'table' and gSettings or {};
    local AbilityDelay = profile.OddLuaPet.clampDelay(settings.AbilityDelay, 0, 5);
    local PetskillDelay = profile.OddLuaPet.clampDelay(settings.PetskillDelay, 0, 8);
    local startedAt = os.clock();
    state.PetActionPin = {
        Kind = kind,
        Policy = policy,
        Observed = false,
        StartDeadline = startedAt + AbilityDelay + policy.StartSlackSeconds,
        FailSafeDeadline = startedAt + AbilityDelay + PetskillDelay + policy.FinishSlackSeconds,
    };
    profile.OddLuaPet.equipPetActionSet(policy.SetNames, false);
    return true;
end

function profile.OddLuaPet.maintainActionPin(player, force, allowEquip)
    local pin = state.PetActionPin;
    if type(pin) ~= 'table' or type(pin.Policy) ~= 'table' then
        if allowEquip ~= true
            or profile.OddLuaRuntime.PlayerContextReady(player) ~= true
            or (type(gSettings) == 'table' and gSettings.HorizonMode == true) then
            return false;
        end
        local autonomousAction, known = profile.OddLuaPet.getPetAction();
        if known == true and profile.OddLuaPet.isMagicalAction(autonomousAction) then
            return profile.OddLuaPet.equipPetActionSet({ 'PetMagic' }, force);
        end
        return false;
    end
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true
        or profile.OddLuaPet.canPinAction(pin.Kind) ~= true then
        profile.OddLuaPet.clearActionPin();
        return false;
    end

    local now = os.clock();
    if now > pin.FailSafeDeadline then
        profile.OddLuaPet.clearActionPin();
        return false;
    end

    local action, known = profile.OddLuaPet.getPetAction();
    if known ~= true then
        profile.OddLuaPet.clearActionPin();
        return false;
    end
    if type(action) == 'table' then
        pin.Observed = true;
        if allowEquip == false then
            return false;
        end
        return profile.OddLuaPet.equipPetActionSet(
            profile.OddLuaPet.setNamesForObservedAction(pin.Policy, action),
            force
        );
    end
    if pin.Observed == true or now > pin.StartDeadline then
        profile.OddLuaPet.clearActionPin();
        return false;
    end
    if allowEquip == false then
        return false;
    end
    return profile.OddLuaPet.equipPetActionSet(pin.Policy.SetNames, force);
end

function profile.OddLuaPet.isPetOrientedSetName(setName)
    local intent = normalize(setIntents[setName] or '');
    local name = normalize(setName);
    return intent == 'petdamage' or intent == 'pettank'
        or name == 'avatarperp' or name == 'playstyle_avatarperp';
end

local function canonicalElement(element)
    local value = normalize(element);
    if value == 'fire' then
        return 'Fire';
    elseif value == 'ice' then
        return 'Ice';
    elseif value == 'wind' then
        return 'Wind';
    elseif value == 'earth' then
        return 'Earth';
    elseif value == 'thunder' or value == 'lightning' then
        return 'Thunder';
    elseif value == 'water' then
        return 'Water';
    elseif value == 'light' then
        return 'Light';
    elseif value == 'dark' then
        return 'Dark';
    end
    return nil;
end

local function elementMatches(left, right)
    local leftElement = canonicalElement(left);
    local rightElement = canonicalElement(right);
    return leftElement ~= nil and rightElement ~= nil and leftElement == rightElement;
end

local function setNameForElement(prefix, element)
    local canonical = canonicalElement(element);
    if not canonical then
        return nil;
    end

    local setName = tostring(prefix or '') .. '_' .. canonical;
    if sets[setName] then
        return setName;
    end

    if canonical == 'Thunder' then
        local lightningName = tostring(prefix or '') .. '_Lightning';
        if sets[lightningName] then
            return lightningName;
        end
    end

    return nil;
end

local function activeCombatStyle()
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        return 'GeoMagic';
    end
    return state.Playstyle;
end

function profile.OddLuaRuntime.SyncActiveStyleWeapons()
    if not scale or not scale.Status or not scale.SetWeaponLockEnabled or not scale.ForceEquipSet then
        return false, 'Scale legal weapon resolver is unavailable';
    end

    local activeSetName = setNameFor(activeCombatStyle());
    local activeSet = sets[activeSetName];
    if type(activeSet) ~= 'table' then
        return false, 'active style has no resolved equipment set';
    end
    activeSet = setWithSubjobLegalOffhand(activeSetName, activeSet);

    local requested = {};
    for _, slot in ipairs({ 'Main', 'Sub', 'Range' }) do
        if activeSet[slot] ~= nil then
            requested[slot] = activeSet[slot];
        end
    end
    if next(requested) == nil then
        return false, 'active style has no Main, Sub, or Range selection';
    end

    local statusOk, status = pcall(scale.Status);
    if statusOk ~= true or type(status) ~= 'table' then
        return false, 'Scale weapon-lock status is unavailable';
    end
    local previousWeaponLockEnabled = status.weaponLockEnabled == true;
    local unlockOk = pcall(scale.SetWeaponLockEnabled, false);
    if unlockOk ~= true then
        return false, 'Scale weapon lock could not be disabled';
    end

    -- ForceEquipSet resolves owned/legal replacements, including the generated
    -- offhand relationship, before dispatching this deliberate one-shot swap.
    local equipOk, resolved = pcall(
        scale.ForceEquipSet,
        activeSetName .. '_WeaponSync',
        requested,
        setIntents[activeSetName]
    );
    local restoreOk = pcall(scale.SetWeaponLockEnabled, previousWeaponLockEnabled);
    if restoreOk ~= true then
        return false, 'Scale weapon lock could not be restored';
    end
    if equipOk ~= true then
        return false, 'legal weapon resolution failed: ' .. tostring(resolved or 'unknown error');
    end
    if type(resolved) ~= 'table' or next(resolved) == nil then
        return false, 'Scale found no owned legal active-style weapons';
    end
    return true, activeSetName;
end

function profile.OddLuaRuntime.AvoidNegativeTickGear()
    local explicitTransitions = mechanicsSwapPlanner and mechanicsSwapPlanner.explicitTransitions;
    local plan = type(explicitTransitions) == 'table' and explicitTransitions.avoidtick or nil;
    if type(plan) ~= 'table' or plan.available ~= true or type(plan.actions) ~= 'table' then
        return false, 'no owned negative-tick avoidance plan';
    end
    local player = getPlayer();
    if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
        return false, 'player context is not ready';
    end
    if not isEngaged(player) then
        return false, 'player is not engaged';
    end
    local mp = profile.OddLuaRuntime.PlayerMp(player);
    if mp == nil or mp <= 0 then
        return false, 'player MP is not positive';
    end
    local observed, observeError, observedIds = observeReconciliationEquipment();
    if type(observed) ~= 'table' then
        return false, observeError or 'equipment observation unavailable';
    end
    if type(observedIds) ~= 'table' then
        return false, 'equipment item IDs are unavailable';
    end

    local activeSetName = setNameFor(activeCombatStyle());
    local activeSet = sets[activeSetName];
    if type(activeSet) ~= 'table' then
        activeSet = {};
    end
    local legalSet = setWithSubjobLegalOffhand(activeSetName, activeSet);
    local replacements = {};
    local details = {};
    for _, action in ipairs(plan.actions) do
        if type(action) == 'table' then
            local slot = tostring(action.slot or '');
            local harmfulItem = tostring(action.item or '');
            local harmfulItemId = tonumber(action.itemId);
            if slot ~= '' and harmfulItem ~= ''
                and harmfulItemId ~= nil and harmfulItemId > 0
                and observedIds[slot] == harmfulItemId
                and reconciliationNamesMatch(harmfulItem, observed[slot] or '')
            then
                local safeItem = legalSet[slot];
                local safeName = movementEquipItemName(safeItem);
                if safeName == nil or reconciliationNamesMatch(harmfulItem, safeName) then
                    replacements[slot] = 'remove';
                    safeName = 'remove';
                else
                    replacements[slot] = safeItem;
                end
                details[#details + 1] = slot .. ' ' .. harmfulItem .. '->' .. tostring(safeName);
            end
        end
    end
    if next(replacements) == nil then
        return false, 'no observed owned negative-tick item is equipped';
    end
    if forceEquipInlineSet(replacements, false) ~= true then
        return false, 'safe replacement equip is unavailable';
    end
    return true, table.concat(details, ', ');
end

function profile.PrintConditionalOverlayStatus()
    local setName = state.LastEquippedSetName or setNameFor(activeCombatStyle());
    if not conditionals or not conditionals.ResolveOverlay then
        message('Conditional overlays: set=' .. tostring(setName or 'unknown') .. '; unavailable.');
        return;
    end

    local context = reconciliationEquipContext(false);
    local okSet, _, setOwners = pcall(function()
        return conditionals.ResolveOverlay(conditionalEquips[setName], context);
    end);
    local okGlobal, _, globalOwners = pcall(function()
        return conditionals.ResolveOverlay(conditionalEquips.Global, context);
    end);
    if okSet ~= true or okGlobal ~= true
        or type(setOwners) ~= 'table' or type(globalOwners) ~= 'table' then
        message('Conditional overlays: set=' .. tostring(setName or 'unknown') .. '; unavailable.');
        return;
    end

    local winners = {};
    local function recordOwners(scope, owners)
        for slot, owner in pairs(owners) do
            if type(owner) == 'table' then
                winners[slot] = {
                    scope = scope,
                    conditionType = tostring(owner.conditionType or 'conditional'),
                    conditionName = tostring(owner.conditionName or ''),
                    item = tostring(owner.item or ''),
                };
            end
        end
    end
    recordOwners('set', setOwners);
    -- Global conditionals are applied after set-local conditionals at runtime.
    recordOwners('global', globalOwners);

    local groups = {};
    local orderedGroups = {};
    for _, slot in ipairs(equipmentSlots) do
        local owner = winners[slot];
        if owner then
            local conditionName = owner.conditionName;
            if conditionName == '' then
                conditionName = '?';
            end
            local key = owner.scope .. ':' .. owner.conditionType .. '=' .. conditionName;
            local group = groups[key];
            if not group then
                group = { label = key, slots = {} };
                groups[key] = group;
                orderedGroups[#orderedGroups + 1] = group;
            end
            group.slots[#group.slots + 1] = slot .. '=' .. owner.item;
        end
    end

    if #orderedGroups == 0 then
        message('Conditional overlays: set=' .. tostring(setName or 'unknown') .. '; winners=none.');
        return;
    end
    local parts = {};
    for _, group in ipairs(orderedGroups) do
        parts[#parts + 1] = group.label .. '[' .. table.concat(group.slots, ',') .. ']';
    end
    message('Conditional overlays: set=' .. tostring(setName or 'unknown')
        .. '; winners=' .. table.concat(parts, ' | ') .. '.');
end

profile.OddLuaRuntime.StableWeaponPlaystyles = {
    Tank = true,
    Enmity = true,
    MagicDefense = true,
    PetDamage = true,
    PetTank = true,
};

local persistentCombatOverlayPlaystyles = {
    Enmity = true,
    PetDamage = true,
    PetTank = true,
};

function profile.OddLuaRuntime.ShouldEstablishStablePlaystyleWeapons(player)
    return profile.OddLuaRuntime.StableWeaponPlaystyles[state.Playstyle] == true
        and isEngaged(player)
        and playerTp(player) == 0;
end

function profile.OddLuaRuntime.EquipStablePlaystyle(setName, force)
    if not scale or not scale.Status or not scale.SetWeaponLockEnabled then
        return false;
    end
    local statusOk, status = pcall(scale.Status);
    if statusOk ~= true or type(status) ~= 'table' then
        return false;
    end
    local previousWeaponLockEnabled = status.weaponLockEnabled == true;
    local unlockOk = pcall(scale.SetWeaponLockEnabled, false);
    if unlockOk ~= true then
        return false;
    end
    local equipOk, equipped = pcall(equipNamedSet, setName, force);
    local restoreOk = pcall(scale.SetWeaponLockEnabled, previousWeaponLockEnabled);
    return restoreOk == true and equipOk == true and equipped == true;
end

local function equipCombatStyle(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        if equipNamedSet(setNameFor('GeoMagic'), force) then
            return true;
        end
        return equipNamedSet('TP', force);
    end

    local activeStyle = activeCombatStyle();
    local activeSet = setNameFor(activeStyle);
    if persistentCombatOverlayPlaystyles[activeStyle] == true
        and activeStyle ~= DEFAULT_PLAYSTYLE
        and state.LastEquippedSetName ~= activeSet
    then
        -- These labeled sets contain only positive, style-specific rows. Restore
        -- the complete default combat base first so sparse slots cannot retain
        -- a prior action snapshot or named-pet overlay.
        equipNamedSet(setNameFor(DEFAULT_PLAYSTYLE), force);
    end
    if profile.OddLuaRuntime.ShouldEstablishStablePlaystyleWeapons(getPlayer())
        and profile.OddLuaRuntime.EquipStablePlaystyle(activeSet, force)
    then
        return true;
    end
    if equipNamedSet(activeSet, force) then
        if profile.OddLuaPet.isPetOrientedSetName(activeSet) then
            profile.OddLuaPet.equipPetOverlayForCurrentPet(force);
        end
        return true;
    end
    if equipNamedSet('TP', force) then
        return true;
    end
    return equipNamedSet('Playstyle_GeoMagic', force);
end

local function equipCombatStyleWithExplicitGearMode(force)
    state.ExplicitGearModeDefaultRouting = true;
    local ok, equipped = pcall(equipCombatStyle, force);
    if ok == true and equipped == true then
        profile.OddLuaRuntime.ApplyExplicitGearMode('default', force);
    end
    state.ExplicitGearModeDefaultRouting = false;
    if ok ~= true then
        error(equipped);
    end
    return equipped;
end




local function lockstyleCombatSet()
    if not equipNamedSet('TP', true) then
        if not equipNamedSet(setNameFor('GeoMagic'), true) then
            message('Unable to equip TP set for lockstyle.');
            return;
        end
    end

    local function applyTpLockstyle()
        if queueTypedCommand('/lockstyle on', 1) then
            message('Lockstyle captured TP set.');
        else
            message('Lockstyle command unavailable; equip TP set manually, then use /lockstyle on.');
        end
    end

    if not scheduleTask(0.3, applyTpLockstyle) then
        applyTpLockstyle();
    end
end

local function equipMovement(player, environment, force)
    if not canEquipMovement(player, environment) then
        return false;
    end

    local equipped = false;

    if equipNamedSetIfNotClear('Movement', force) then
        equipped = true;
    end
    if shouldEquipInCityMovement(player, environment) and equipNamedSetIfNotClear('Movement_City', force) then
        equipped = true;
    end
    if isNight(environment) and equipNamedSetIfNotClear('Movement_Night', force) then
        equipped = true;
    end
    if isDuskToDawn(environment) and equipNamedSetIfNotClear('Movement_DuskToDawn', force) then
        equipped = true;
    end
    if shouldEquipInCityMovement(player, environment) and equipNamedSetIfNotClear('InCity', force) then
        equipped = true;
    end

    return equipped;
end

local function addSecondarySlotLockSetNameIfNotClear(setNames, setName)
    local set = sets[setName];
    if set and not isClearSet(set) then
        setNames[#setNames + 1] = setName;
    end
end

local function addMovementSecondarySlotLockSetNames(setNames, player, environment)
    if not canEquipMovement(player, environment) then
        return;
    end

    addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement');
    if shouldEquipInCityMovement(player, environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement_City');
    end
    if isNight(environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement_Night');
    end
    if isDuskToDawn(environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Movement_DuskToDawn');
    end
    if shouldEquipInCityMovement(player, environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'InCity');
    end
end

local function idleSecondarySlotLockSetNames(player, environment)
    local setNames = {};
    if shouldEquipInCityMovement(player, environment) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleCity');
    elseif profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleCombat');
    else
        addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleNonCombat');
    end
    if not profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        if profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player) then
            addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleMaxMP');
        end
        if profile.OddLuaRuntime.ShouldEquipIdleMaxHP(player) then
            addSecondarySlotLockSetNameIfNotClear(setNames, 'IdleMaxHP');
        end
    end
    addSecondarySlotLockSetNameIfNotClear(setNames, 'Aftercast');
    addSecondarySlotLockSetNameIfNotClear(setNames, 'Idle');
    if not profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        addMovementSecondarySlotLockSetNames(setNames, player, environment);
    end
    return setNames;
end

function profile.OddLuaRuntime.EquipIdleContextSet(setName, force)
    return equipNamedSetIfNotClear(setName, force);
end

local function equipBaseIdleState(player, force)
    local environment = getEnvironment();
    local equipped = false;

    -- Idle context sets are overlays and may contain only one or two slots.
    -- Establish a complete baseline before applying them so a sparse overlay
    -- cannot leave stale gear or empty slots from the previous job/action.
    if isClearSet(sets['Aftercast']) then
        equipNamedSet('Aftercast', force);
        equipped = true;
    else
        equipped = equipNamedSetIfNotClear('Aftercast', force);
    end

    if not equipped then
        if isClearSet(sets['Idle']) then
            equipNamedSet('Idle', force);
            equipped = true;
        else
            equipped = equipNamedSetIfNotClear('Idle', force);
        end
    end

    if shouldEquipInCityMovement(player, environment) and profile.OddLuaRuntime.EquipIdleContextSet('IdleCity', force) then
        equipped = true;
    elseif profile.OddLuaRuntime.ShouldEquipIdleCombat(player) and profile.OddLuaRuntime.EquipIdleContextSet('IdleCombat', force) then
        equipped = true;
    elseif profile.OddLuaRuntime.EquipIdleContextSet('IdleNonCombat', force) then
        equipped = true;
    end

    if not profile.OddLuaRuntime.ShouldEquipIdleCombat(player) then
        if profile.OddLuaRuntime.ShouldEquipIdleMaxMP(player) then
            profile.OddLuaRuntime.EquipIdleContextSet('IdleMaxMP', force);
        end
        if profile.OddLuaRuntime.ShouldEquipIdleMaxHP(player) then
            profile.OddLuaRuntime.EquipIdleContextSet('IdleMaxHP', force);
        end
        equipMovement(player, environment, force);
    end

    if equipped then
        return true;
    end
    return equipNamedSet('Idle', force);
end

local function equipIdleState(player, force)
    local previousSecondarySlotLockContext = state.SecondarySlotLockContextSetNames;
    state.SecondarySlotLockContextSetNames = idleSecondarySlotLockSetNames(player, getEnvironment());
    local ok, equipped = pcall(equipBaseIdleState, player, force);
    state.SecondarySlotLockContextSetNames = previousSecondarySlotLockContext;
    if not ok then
        error(equipped);
    end
    return equipped;
end

local function equipDefaultForPlayer(player, force)
    return profile.OddLuaRuntime.RunReconciliationComposition(function()
        if profile.OddLuaRuntime.PlayerContextReady(player) ~= true then
            profile.OddLuaPet.clearActionPin();
            return false;
        end

        local petPinMayEquip = state.WarpRingLocked ~= true
            and not isResting(player)
            and state.Playstyle ~= 'Craft'
            and profile.OddLuaRuntime.ActiveSafetyReason(player) == 'none';
        if profile.OddLuaPet.maintainActionPin(player, force, petPinMayEquip) then
            return true;
        end
        if hasDangerousStatus() then
            local defensiveSet = firstAvailableDefensiveSet();
            if defensiveSet ~= nil then
                equipNamedSet(defensiveSet, force);
            end
        elseif profile.OddLuaRuntime.HasWeakness() == true then
            local defensiveSet = firstAvailableDefensiveSet();
            if defensiveSet ~= nil then
                equipNamedSet(defensiveSet, force);
            end
        elseif player and isResting(player) then
            equipNamedSet('Resting', force);
        elseif state.Playstyle == 'Craft' then
            if not equipNamedSet('Crafting', force) then
                equipNamedSet('Idle', force);
            end
        elseif state.IdleOverrideSet ~= nil and state.IdleOverrideSet ~= 'Guard' then
            if profile.OddLuaRuntime.EquipManualOverrideSet(state.IdleOverrideSet, force) then
                return true;
            end
            state.IdleOverrideSet = nil;
            return equipDefaultForPlayer(player, force);
        elseif player and isEngaged(player) then
            local defensiveSet, unlockDefensiveWeapons = shouldEquipOvertDefense(player);
            if defensiveSet then
                local equippedDefensive = equipOvertDefensiveSet(defensiveSet, unlockDefensiveWeapons);
                if equippedDefensive then
                    return;
                end
            end
            if isEmergencyHp(player) then
                local emergencyDefensiveSet = firstAvailableDefensiveSet();
                if emergencyDefensiveSet ~= nil then
                    equipNamedSet(emergencyDefensiveSet, force);
                end
            else
            if state.IdleOverrideSet == 'Guard'
                and profile.OddLuaRuntime.ShouldEquipGuard(player)
                and equipNamedSetIfNotClear('Guard', force)
            then
                return;
            end

            equipCombatStyleWithExplicitGearMode(force);
            end
        else
            equipIdleState(player, force);
        end
    end);
end

local oddLuaNumberRow = {
    utilityFallbacks = {
        craft = { 'Craft', 'Fishing', 'Gathering', 'Clamming', 'Movement', 'Resting', 'Treasure', 'Survival' },
        movement = { 'Movement', 'Movement_City', 'Movement_Night', 'Movement_DuskToDawn', 'InCity', 'Survival' },
    },
};

function oddLuaNumberRow.setBooleanValue(current, value)
    local valueText = normalize(value);
    if valueText == 'on' or valueText == 'enable' or valueText == 'enabled' then
        return true;
    elseif valueText == 'off' or valueText == 'disable' or valueText == 'disabled' then
        return false;
    end
    return not current;
end

function oddLuaNumberRow.bindPalette()
    if state.NumberRowPaletteEnabled ~= true then
        return;
    end
    local bindingGeneration = state.BindingGeneration;
    local commands = {
        '/bind NUMPAD. /lac fwd styleprev',
        '/bind NUMPAD0 /lac fwd stylenext',
        '/bind NUMPAD1 /lac fwd styles',
        '/bind NUMPAD3 /lac fwd lockstyle',
        '/bind NUMPAD5 /lac fwd utility craft',
        '/bind NUMPAD7 /lac fwd warp',
        '/bind NUMPAD9 /lac fwd palette missing',
    };
    -- Queueing every bind during OnLoad can wedge Ashita; stagger them.
    for index, command in ipairs(commands) do
        local bindCommand = command;
        local delay = (index - 1) * 0.20;
        if not scheduleTask(delay, function()
            if not oddLuaNumberRow.isBindingGenerationCurrent(bindingGeneration) then
                return;
            end
            queueTypedCommand(bindCommand, -1);
        end) then
            message('Keypad bind scheduling unavailable; use /lac fwd keypad on after load.');
            return;
        end
    end
end

function oddLuaNumberRow.unbindPalette()
    local bindingGeneration = state.BindingGeneration;
    local commands = {
        '/unbind NUMPAD.',
        '/unbind NUMPAD0',
        '/unbind NUMPAD1',
        '/unbind NUMPAD3',
        '/unbind NUMPAD5',
        '/unbind NUMPAD7',
        '/unbind NUMPAD9',
    };
    -- Queueing every unbind during OnUnload can heap-corrupt Ashita; stagger them.
    for index, command in ipairs(commands) do
        local unbindCommand = command;
        local delay = (index - 1) * 0.20;
        if not scheduleTask(delay, function()
            if not oddLuaNumberRow.isBindingGenerationCurrent(bindingGeneration) then
                return;
            end
            queueTypedCommand(unbindCommand, -1);
        end) then
            message('Keypad unbind scheduling unavailable; binds will be cleared on next profile unload.');
            return;
        end
    end
end

function oddLuaNumberRow.clearLegacyPaletteBinds()
    local bindingGeneration = state.BindingGeneration;
    local commands = {
        '/unbind NUMPAD.',
        '/unbind NUMPAD0',
        '/unbind NUMPAD1',
        '/unbind NUMPAD2',
        '/unbind NUMPAD3',
        '/unbind NUMPAD4',
        '/unbind NUMPAD5',
        '/unbind NUMPAD6',
        '/unbind NUMPAD7',
        '/unbind NUMPAD8',
        '/unbind NUMPAD9',
        '/unbind UP',
        '/unbind DOWN',
        '/unbind LEFT',
        '/unbind RIGHT',
        '/unbind 1',
        '/unbind 2',
        '/unbind 3',
        '/unbind 4',
        '/unbind 5',
        '/unbind 6',
        '/unbind 7',
        '/unbind 8',
        '/unbind 9',
        '/unbind 0',
        '/unbind -',
        '/unbind =',
    };
    -- Clear legacy keypad and number-row captures only on explicit cleanup.
    for index, command in ipairs(commands) do
        local unbindCommand = command;
        local delay = (index - 1) * 0.20;
        if not scheduleTask(delay, function()
            if not oddLuaNumberRow.isBindingGenerationCurrent(bindingGeneration) then
                return;
            end
            queueTypedCommand(unbindCommand, -1);
        end) then
            message('Keypad legacy cleanup scheduling unavailable; retry /lac fwd keypad clear after load.');
            return;
        end
    end
end

function oddLuaNumberRow.paletteEntryText(binding)
    if not binding then
        return '';
    end
    if binding.kind == 'unbound' or binding.key == nil or binding.key == '' then
        return 'Unbound';
    end
    local displayKey = binding.displayKey;
    if displayKey == nil or displayKey == '' then
        displayKey = binding.key;
    end
    if binding.kind == 'command-only' then
        return tostring(displayKey) .. ' ' .. tostring(binding.label)
            .. ' [unbound; command ' .. tostring(binding.literal) .. ']';
    end
    return tostring(displayKey) .. ' ' .. tostring(binding.label);
end

function oddLuaNumberRow.paletteEntriesText(firstIndex, lastIndex)
    local parts = {};
    for index = firstIndex, lastIndex do
        local text = oddLuaNumberRow.paletteEntryText(numberRowBindings[index]);
        if text ~= '' then
            parts[#parts + 1] = text;
        end
    end
    return table.concat(parts, ' | ');
end

function oddLuaNumberRow.printPalette()
    local enabledText = 'off';
    if state.NumberRowPaletteEnabled == true then
        enabledText = 'on';
    end
    message('Keypad palette=' .. enabledText .. '; /lac fwd keypad on|off|clear.');
    message('Keypad 1: ' .. oddLuaNumberRow.paletteEntriesText(1, 6));
    message('Keypad 2: ' .. oddLuaNumberRow.paletteEntriesText(7, 12));
end

function oddLuaNumberRow.clearPaletteBinds()
    state.NumberRowPaletteEnabled = false;
    oddLuaNumberRow.unbindPalette();
    oddLuaNumberRow.clearLegacyPaletteBinds();
    message('OddLua keypad palette: cleared');
end

function oddLuaNumberRow.setPaletteEnabled(value)
    local enabled = oddLuaNumberRow.setBooleanValue(state.NumberRowPaletteEnabled, value);
    if state.NumberRowPaletteEnabled == enabled then
        if enabled then
            message('OddLua keypad palette: already on');
        else
            message('OddLua keypad palette: already off');
        end
        return;
    end
    state.NumberRowPaletteEnabled = enabled;
    if enabled then
        oddLuaNumberRow.bindPalette();
        message('OddLua keypad palette: on');
    else
        oddLuaNumberRow.unbindPalette();
        message('OddLua keypad palette: off');
    end
end

function oddLuaNumberRow.currentPlaystyleIndex()
    for index, styleName in ipairs(playstyleNames) do
        if styleName == state.Playstyle then
            return index;
        end
    end
    return 1;
end

function oddLuaNumberRow.cyclePlaystyle(delta)
    if #playstyleNames == 0 then
        message('No playstyles available.');
        return false;
    end
    local index = oddLuaNumberRow.currentPlaystyleIndex();
    local selectedIndex = ((index - 1 + delta) % #playstyleNames) + 1;
    state.Playstyle = playstyleNames[selectedIndex];
    message('Style=' .. state.Playstyle);
    equipDefaultForPlayer(getPlayer(), true);
    return true;
end

function oddLuaNumberRow.equipUtilityIntent(intent)
    local fallback = oddLuaNumberRow.utilityFallbacks[normalize(intent)];
    if type(fallback) ~= 'table' then
        message('Not Applicable / Missing Equipment');
        return false;
    end
    for _, setName in ipairs(fallback) do
        if equipNamedSetIfNotClear(setName, true) then
            message('Utility=' .. tostring(intent) .. '; set=' .. setName);
            return true;
        end
    end
    message('Not Applicable / Missing Equipment');
    return false;
end

local function blueMagicRouteKey(action)
    local value = action;
    if type(action) == 'table' then
        value = action.Name or action.name;
        if value == nil or tostring(value) == '' then
            value = action.DisplayName or action.displayName;
        end
    end
    local key = normalize(value);
    key = string.gsub(key, '[^%w]+', ' ');
    key = string.gsub(key, '%s+', ' ');
    key = string.gsub(key, '^%s+', '');
    return string.gsub(key, '%s+$', '');
end

local function equipBlueMagic(action)
    local route = blueMagicRoutes[blueMagicRouteKey(action)];
    if route == 'MagicalBlueMagic' then
        local environment = getEnvironment();
        local element = action and action.Element;
        local candidates = {};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
            table.insert(candidates, setNameForElement('MagicalBlueWeather', element));
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
            table.insert(candidates, setNameForElement('MagicalBlueDay', element));
        end
        table.insert(candidates, 'MagicalBlueMagic');
        table.insert(candidates, 'MagicalBlue');
        table.insert(candidates, 'BlueMagic');
        table.insert(candidates, 'Midcast');
        equipFirstAvailable(candidates, false);
        return;
    end
    if route and equipNamedSet(route, false) then
        return;
    end
    equipFirstAvailable({ 'BlueMagic', 'PhysicalBlueMagic', 'MagicalBlueMagic', 'Midcast' }, false);
end

local elementalDebuffStyleByName = {
    burn = 'Burn',
    choke = 'Choke',
    drown = 'Drown',
    frost = 'Frost',
    rasp = 'Rasp',
    shock = 'Shock',
};

function oddLuaNumberRow.advanceBindingGeneration()
    local lifecycle = package.loaded['oddlua.binding_lifecycle'];
    if type(lifecycle) ~= 'table' then
        lifecycle = { generation = 0 };
        package.loaded['oddlua.binding_lifecycle'] = lifecycle;
    end
    lifecycle.generation = (tonumber(lifecycle.generation) or 0) + 1;
    return lifecycle.generation;
end

function oddLuaNumberRow.isBindingGenerationCurrent(generation)
    local lifecycle = package.loaded['oddlua.binding_lifecycle'];
    return type(lifecycle) == 'table'
        and tonumber(lifecycle.generation) == tonumber(generation);
end

local function equipElementalMagic(action)
    action = action or {};
    local actionName = normalize(action.Name);
    local debuffStyle = elementalDebuffStyleByName[actionName];
    if debuffStyle ~= nil then
        equipFirstAvailable({ debuffStyle, 'MagicAccuracy', 'Elemental', 'Midcast' }, false);
        return;
    end
    local environment = getEnvironment();
    local element = action.Element;
    local candidates = {};

    if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
        table.insert(candidates, setNameForElement('Weather', element));
    end
    if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
        table.insert(candidates, setNameForElement('Day', element));
    end
    table.insert(candidates, setNameForElement('Elemental', element));
    table.insert(candidates, 'Elemental');
    table.insert(candidates, 'Nuke');
    table.insert(candidates, 'Midcast');
    equipFirstAvailable(candidates, false);
    if state.MagicBurstMode == true then
        equipNamedSetIfNotClear('MagicBurst', false);
    end
end

local elementalBarspellNames = {
    baraero = true,
    baraera = true,
    barblizzard = true,
    barblizzara = true,
    barfire = true,
    barfira = true,
    barstone = true,
    barstonra = true,
    barthunder = true,
    barthundra = true,
    barwater = true,
    barwatera = true,
};

local function equipEnhancingMagic(name)
    local value = normalize(name);
    if string.find(value, 'stoneskin', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({ 'Stoneskin', 'EnhancingDuration', 'Enhancing' }, false);
    elseif string.find(value, 'spikes', 1, true) then
        equipFirstAvailable({ 'Spikes', 'Enhancing' }, false);
    elseif string.find(value, 'blink', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({ 'SIRD', 'EnhancingDuration', 'Enhancing' }, false);
    elseif string.find(value, 'refresh', 1, true) then
        equipFirstAvailable({ 'Refresh', 'EnhancingDuration', 'Enhancing' }, false);
    elseif string.find(value, 'regen', 1, true) then
        equipFirstAvailable({ 'Regen', 'EnhancingDuration', 'Enhancing' }, false);
    elseif string.find(value, 'en', 1, true) == 1 then
        -- Enspell is the post-cast melee playstyle. At spell resolution, use
        -- enhancing skill and duration rather than TP/haste/attack equipment.
        equipFirstAvailable({ 'Enhancing', 'EnhancingDuration' }, false);
    elseif string.find(value, 'sneak', 1, true) or string.find(value, 'invisible', 1, true) or string.find(value, 'deodorize', 1, true) then
        equipFirstAvailable({ 'SneakInvisible', 'Enhancing' }, false);
    elseif elementalBarspellNames[value] == true then
        equipFirstAvailable({ 'Barspell', 'EnhancingDuration', 'Enhancing' }, false);
    elseif string.find(value, 'bar', 1, true) == 1 then
        -- Status-resistance Barspells have duration but no elemental Barspell
        -- potency/MDEF term. Never fall through to unrelated generic Midcast
        -- (usually magic accuracy); keep the current gear if neither sparse
        -- duration nor enhancing-skill gear is available.
        equipFirstAvailable({ 'EnhancingDuration', 'Enhancing' }, false);
    elseif string.find(value, 'phalanx', 1, true) then
        equipFirstAvailable({ 'Phalanx', 'EnhancingDuration', 'Enhancing' }, false);
    elseif string.find(value, 'aquaveil', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({ 'Aquaveil', 'SIRD', 'EnhancingDuration', 'Enhancing' }, false);
        if profile.OddLuaRuntime.ShouldEquipSirdNin({ Name = name }) then
            equipNamedSetIfNotClear('SIRD_NIN', false);
        end
    elseif string.find(value, 'haste', 1, true) then
        equipFirstAvailable({ 'Haste', 'EnhancingDuration', 'Enhancing' }, false);
    else
        equipFirstAvailable({ 'Enhancing', 'EnhancingDuration' }, false);
    end
end

local function equipEnfeeblingMagic(name)
    local value = normalize(name);
    if string.find(value, 'sleep', 1, true) or string.find(value, 'lullaby', 1, true) then
        equipFirstAvailable({ 'Sleep', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'bind', 1, true) then
        equipFirstAvailable({ 'Bind', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'gravity', 1, true) then
        equipFirstAvailable({ 'Gravity', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'silence', 1, true) then
        equipFirstAvailable({ 'Silence', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'slow', 1, true) then
        equipFirstAvailable({ 'Slow', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'paraly', 1, true) then
        equipFirstAvailable({ 'Paralyze', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'poison', 1, true) then
        equipFirstAvailable({ 'Poison', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'blind', 1, true) then
        equipFirstAvailable({ 'Blind', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'dispel', 1, true) or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({ 'Dispel', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'dia', 1, true) then
        equipFirstAvailable({ 'Dia', 'Enfeebling', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'Enfeebling', 'Midcast' }, false);
    end
end

local function equipDarkMagic(name)
    local value = normalize(name);
    if value == 'dread spikes' then
        equipFirstAvailable({ 'DreadSpikes', 'DarkDuration', 'DarkMagic', 'Midcast' }, false);
    elseif string.find(value, 'drain', 1, true) or string.find(value, 'aspir', 1, true) then
        local environment = getEnvironment();
        local candidates = {};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, 'Dark') then
            table.insert(candidates, 'DrainWeather_Dark');
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, 'Dark') then
            table.insert(candidates, 'DrainDay_Dark');
        end
        table.insert(candidates, 'DrainAspir');
        table.insert(candidates, 'DarkMagic');
        table.insert(candidates, 'Midcast');
        equipFirstAvailable(candidates, false);
    elseif string.find(value, 'absorb', 1, true) then
        equipFirstAvailable({ 'Absorb', 'DarkMagic', 'Midcast' }, false);
    elseif string.find(value, 'stun', 1, true) then
        equipFirstAvailable({ 'Stun', 'DarkMagic', 'Midcast' }, false);
    elseif string.find(value, 'bio', 1, true) then
        equipFirstAvailable({ 'Bio', 'DarkMagic', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'DarkMagic', 'Midcast' }, false);
    end
end

local function equipSong(name)
    local value = normalize(name);
    if string.find(value, 'minuet', 1, true) then
        equipFirstAvailable({ 'Song_Minuet', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'paeon', 1, true) then
        equipFirstAvailable({ 'Song_Paeon', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'lullaby', 1, true) then
        equipFirstAvailable({ 'Song_Lullaby', 'SongDebuff', 'Song', 'Midcast' }, false);
    elseif string.find(value, 'madrigal', 1, true) then
        equipFirstAvailable({ 'Song_Madrigal', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'etude', 1, true) then
        equipFirstAvailable({ 'Song_Etude', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'ballad', 1, true) then
        equipFirstAvailable({ 'Song_Ballad', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'march', 1, true) then
        equipFirstAvailable({ 'Song_March', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'carol', 1, true) then
        equipFirstAvailable({ 'Song_Carol', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'elegy', 1, true) then
        equipFirstAvailable({ 'Song_Elegy', 'SongDebuff', 'Song', 'Midcast' }, false);
    elseif string.find(value, 'prelude', 1, true) then
        equipFirstAvailable({ 'Song_Prelude', 'SongBuff', 'Song' }, false);
    elseif string.find(value, 'requiem', 1, true) then
        equipFirstAvailable({ 'Song_Requiem', 'SongDebuff', 'Song', 'Midcast' }, false);
    elseif string.find(value, 'threnody', 1, true) or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({ 'SongDebuff', 'Song', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'SongBuff', 'Song' }, false);
    end
end

local function equipNinjutsu(action)
    local function isElementalNinjutsu(name)
        return string.find(name, 'katon', 1, true) == 1
            or string.find(name, 'hyoton', 1, true) == 1
            or string.find(name, 'huton', 1, true) == 1
            or string.find(name, 'doton', 1, true) == 1
            or string.find(name, 'raiton', 1, true) == 1
            or string.find(name, 'suiton', 1, true) == 1;
    end

    local name = normalize(action and action.Name);
    if string.find(name, 'utsusemi', 1, true) then
        profile.OddLuaRuntime.EquipSurvivalDefensiveOverlay();
        equipFirstAvailable({ 'Utsusemi', 'SIRD', 'Precast', 'FastCast' }, false);
        if profile.OddLuaRuntime.ShouldEquipSirdNin(action) then
            equipNamedSetIfNotClear('SIRD_NIN', false);
        end
    elseif string.find(name, 'kurayami', 1, true) or string.find(name, 'hojo', 1, true)
        or string.find(name, 'jubaku', 1, true) or string.find(name, 'dokumori', 1, true) then
        equipFirstAvailable({ 'NinjutsuEnfeeble', 'Ninjutsu', 'Midcast' }, false);
    elseif isElementalNinjutsu(name) then
        local environment = getEnvironment();
        local element = action and action.Element;
        local candidates = {};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
            table.insert(candidates, setNameForElement('NinjutsuWeather', element));
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
            table.insert(candidates, setNameForElement('NinjutsuDay', element));
        end
        table.insert(candidates, 'Ninjutsu');
        table.insert(candidates, 'Midcast');
        equipFirstAvailable(candidates, false);
    else
        equipFirstAvailable({ 'Ninjutsu', 'Midcast' }, false);
    end
end

local function equipSummoning(name)
    local value = normalize(name);
    if string.find(value, 'siphon', 1, true) then
        equipFirstAvailable({ 'Summoning', 'AvatarPerp', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'Summoning', 'Midcast' }, false);
    end
end

function profile.OddLuaRuntime.RollSetName(actionName)
    local value = normalize(actionName);
    value = string.gsub(value, '%s+roll$', '');
    value = string.gsub(value, '[^%w%s]', '');
    local suffix = '';
    for token in string.gmatch(value, '%w+') do
        suffix = suffix .. string.upper(string.sub(token, 1, 1)) .. string.sub(token, 2);
    end
    if suffix == '' then
        return 'Roll';
    end
    return 'Roll_' .. suffix;
end

local function equipAbility()
    local action = getAction();
    local name = normalize(action and action.Name);
    local actionType = normalize(action and action.Type);
    if actionType == 'quick draw' then
        local quickDrawElements = {
            ['dark shot'] = 'Dark',
            ['earth shot'] = 'Earth',
            ['fire shot'] = 'Fire',
            ['ice shot'] = 'Ice',
            ['light shot'] = 'Light',
            ['thunder shot'] = 'Thunder',
            ['water shot'] = 'Water',
            ['wind shot'] = 'Wind',
        };
        local function equipQuickDraw(action)
            local name = normalize(action and action.Name);
            local element = quickDrawElements[name] or (action and action.Element);
            local accuracyShot = name == 'dark shot' or name == 'light shot';
            local environment = getEnvironment();
            equipFirstAvailable({ 'QuickDraw', 'MagicAccuracy', 'Midcast' }, false);
            if accuracyShot then
                -- Preserve a valid marksmanship gun/bullet, then layer the
                -- sparse Dark/Light Shot accuracy objective over it.
                equipNamedSetIfNotClear('QuickDrawAccuracy', false);
                equipNamedSetIfNotClear(setNameForElement('QuickDrawAccuracy', element), false);
            end
            -- Weather and day bonuses stack on the server, so apply both
            -- matching overlays instead of stopping at the first one found.
            if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
                equipNamedSetIfNotClear(setNameForElement('QuickDrawWeather', element), false);
            end
            if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
                equipNamedSetIfNotClear(setNameForElement('QuickDrawDay', element), false);
            end
        end
        equipQuickDraw(action);
    elseif actionType == 'corsair roll' then
        equipFirstAvailable({ profile.OddLuaRuntime.RollSetName(name), 'Roll', 'JobAbility' }, false);
    elseif string.find(name, 'barrage', 1, true) then
        -- BARRAGE_COUNT is read on the consuming ranged attack. Preload the
        -- exact sparse set here; HandleMidshot reapplies it while active.
        equipNamedSetIfNotClear('Barrage', false);
    elseif string.find(name, 'berserk', 1, true) then
        equipFirstAvailable({ 'Berserk', 'JobAbility' }, false);
    elseif string.find(name, 'aggressor', 1, true) then
        equipFirstAvailable({ 'Aggressor', 'JobAbility' }, false);
    elseif string.find(name, 'retaliation', 1, true) then
        -- The global status overlay keeps RETALIATION equipped for live hits.
        equipNamedSetIfNotClear('Retaliation', false);
    elseif name == 'warcry' then
        -- LuAshitacast holds this snapshot through ability resolution, then HandleDefault restores normal gear.
        equipFirstAvailable({ 'Warcry', 'JobAbility' }, false);
    elseif name == 'sentinel' then
        -- Snapshot the exact Sentinel effect plus Enmity only for Sentinel.
        -- HandleDefault restores the current combat or idle state.
        equipFirstAvailable({ 'Sentinel', 'Enmity', 'JobAbility' }, false);
    elseif actionType == 'blood pact: rage' then
        profile.OddLuaPet.beginActionPin('rage');
    elseif actionType == 'blood pact: ward' then
        profile.OddLuaPet.beginActionPin('ward');
    elseif name == 'super jump' then
        -- Super Jump deals no damage and has no cap-75 snapshot modifier.
        -- Preserve current gear when its exact set is intentionally clear.
        equipNamedSetIfNotClear('SuperJump', false);
    elseif name == 'spirit link' then
        equipFirstAvailable({ 'SpiritLink', 'WyvernHealing', 'JobAbility' }, false);
    elseif name == 'sneak attack' then
        equipFirstAvailable({ 'SneakAttack', 'SATA', 'JobAbility' }, false);
    elseif name == 'trick attack' then
        equipFirstAvailable({ 'TrickAttack', 'SATA', 'JobAbility' }, false);
    elseif string.find(name, 'third eye', 1, true) then
        -- The global status overlay keeps THIRD_EYE_COUNTER_RATE equipped
        -- while Third Eye is present; never substitute generic JA gear.
        equipNamedSetIfNotClear('ThirdEye', false);
    elseif string.find(name, 'meditate', 1, true) then
        equipNamedSetIfNotClear('Meditate', false);
    elseif name == 'warding circle' then
        -- Hold the exact circle snapshot through activation; HandleDefault restores normal gear.
        equipNamedSetIfNotClear('WardingCircle', false);
    elseif name == 'ancient circle' then
        equipNamedSetIfNotClear('AncientCircle', false);
    elseif name == 'arcane circle' then
        equipNamedSetIfNotClear('ArcaneCircle', false);
    elseif name == 'holy circle' then
        equipNamedSetIfNotClear('HolyCircle', false);
    elseif name == 'flee' then
        equipNamedSetIfNotClear('Flee', false);
    elseif name == 'hide' then
        equipNamedSetIfNotClear('Hide', false);
    elseif name == 'camouflage' then
        equipNamedSetIfNotClear('Camouflage', false);
    elseif name == 'mug' then
        -- Apply only direct non-weapon Mug modifiers through resolution.
        -- HandleDefault restores the current combat or idle state.
        equipNamedSetIfNotClear('Mug', false);
    elseif name == 'charm' then
        equipFirstAvailable({ 'Charm', 'JobAbility' }, false);
    elseif name == 'chakra' then
        -- Chakra has no generic cure-potency lane. Missing exact gear is a
        -- no-op so unrelated JobAbility equipment cannot replace live gear.
        equipNamedSetIfNotClear('Chakra', false);
    elseif name == 'counterstance' then
        -- COUNTERSTANCE_EFFECT snapshots now; counter-rate/damage rows are
        -- held later by the global Counterstance-status overlay.
        equipNamedSetIfNotClear('Counterstance', false);
    elseif name == 'rampart' then
        -- Hold the duration snapshot through activation; HandleDefault restores normal gear.
        equipNamedSetIfNotClear('Rampart', false);
    elseif name == 'shield bash' then
        -- Apply only direct non-weapon modifiers. Preserve the live legal
        -- Main/shield pair and TP; HandleDefault restores the current state.
        equipNamedSetIfNotClear('ShieldBash', false);
    elseif name == 'cover' then
        -- Keep the normal activation enmity gear, then preload the sparse Body
        -- overlay. The global Cover-status condition holds it for live hits.
        equipFirstAvailable({ 'Enmity', 'JobAbility' }, false);
        equipNamedSetIfNotClear('CoverActive', false);
    elseif string.find(name, 'provoke', 1, true)
        or string.find(name, 'palisade', 1, true) or string.find(name, 'flash', 1, true) then
        equipFirstAvailable({ 'Enmity', 'JobAbility' }, false);
    elseif name == 'healing waltz' then
        equipFirstAvailable({ 'HealingWaltz', 'StatusRemoval', 'JobAbility' }, false);
    elseif string.find(name, 'waltz', 1, true) then
        equipFirstAvailable({ 'Waltz', 'Cure', 'JobAbility' }, false);
    elseif string.find(name, 'flourish', 1, true) then
        equipFirstAvailable({ 'Flourish', 'Steps', 'Accuracy', 'JobAbility' }, false);
    elseif string.find(name, 'step', 1, true) then
        equipFirstAvailable({ 'Steps', 'Accuracy', 'JobAbility' }, false);
    elseif string.find(name, 'samba', 1, true) then
        equipNamedSetIfNotClear('Samba', false);
    elseif actionType == 'jig' or actionType == 'jigs'
        or name == 'spectral jig' or name == 'chocobo jig' or name == 'chocobo jig ii' then
        -- Hold the duration snapshot through ability resolution; HandleDefault restores normal gear.
        equipFirstAvailable({ 'Jig', 'JobAbility' }, false);
    elseif string.find(name, 'high jump', 1, true) then
        if state.Playstyle == 'Accuracy' then
            if equipFirstAvailable({ 'HighJumpAccuracy', 'HighJump', 'JumpAccuracy', 'Jump', 'Weaponskill', 'JobAbility' }, false) then
                return;
            end
        end
        equipFirstAvailable({ 'HighJump', 'Jump', 'Weaponskill', 'JobAbility' }, false);
    elseif string.find(name, 'jump', 1, true) then
        if state.Playstyle == 'Accuracy' then
            if equipFirstAvailable({ 'JumpAccuracy', 'Jump', 'Weaponskill', 'JobAbility' }, false) then
                return;
            end
        end
        equipFirstAvailable({ 'Jump', 'Weaponskill', 'JobAbility' }, false);
    elseif name == 'reward' then
        -- Reward snapshots master gear while preserving weapons and the equipped pet-food Ammo.
        equipNamedSetIfNotClear('Reward', false);
    elseif actionType == 'ready' or name == 'ready' or name == 'sic' then
        profile.OddLuaPet.beginActionPin('ready_sic');
    else
        equipNamedSet('JobAbility', false);
    end
end

local function equipWeaponskill()
    local function isMagicalWeaponSkillName(name)
        return string.find(name, 'aeolian', 1, true) or string.find(name, 'cyclone', 1, true)
            or string.find(name, 'energy', 1, true) or string.find(name, 'red lotus', 1, true)
            or string.find(name, 'seraph', 1, true) or string.find(name, 'sanguine', 1, true)
            or string.find(name, 'wildfire', 1, true) or string.find(name, 'leaden', 1, true)
            or string.find(name, 'jinpu', 1, true) or string.find(name, 'koki', 1, true)
            or string.find(name, 'goten', 1, true) or string.find(name, 'kagero', 1, true);
    end

    local action = getAction();
    local name = action and action.Name;
    local key = weaponSkillRouteKey(name);
    local exactRoute = weaponSkillRoutes[key];
    local accuracyRoute = weaponSkillAccuracyRoutes[key];
    local normalizedName = normalize(name);
    local magicalWeaponSkill = isMagicalWeaponSkillName(normalizedName);
    if state.Playstyle == 'Accuracy' then
        if accuracyRoute and equipNamedSet(accuracyRoute, false) then
            return;
        end
    end
    if magicalWeaponSkill then
        local environment = getEnvironment();
        local element = action and action.Element;
        local candidates = {};
        if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, element) then
            table.insert(candidates, setNameForElement('WSElementalWeather', element));
        end
        if environment and environment.DayElement and elementMatches(environment.DayElement, element) then
            table.insert(candidates, setNameForElement('WSElementalDay', element));
        end
        if exactRoute then
            table.insert(candidates, exactRoute);
        end
        table.insert(candidates, 'WSElemental');
        table.insert(candidates, 'Elemental');
        table.insert(candidates, 'Weaponskill');
        equipFirstAvailable(candidates, false);
        return;
    end
    if exactRoute and equipNamedSet(exactRoute, false) then
        return;
    end
    if state.Playstyle == 'Accuracy' then
        equipFirstAvailable({ 'WeaponSkillAccuracy', 'Weaponskill' }, false);
    else
        equipNamedSet('Weaponskill', false);
    end
end

profile.OnLoad = function()
    if gSettings then
        gSettings.AllowAddSet = true;
        gSettings.AllowSyncEquip = true;
    end

    if scale and scale.Configure then
        scale.Configure({
            sets = sets,
            intents = setIntents,
            enabled = true,
            weaponLockEnabled = true,
            preferProfileItems = true,
            debug = false
        });
    end

    equipDefaultForPlayer(getPlayer(), true);
    message('OddLua dynamic profile loaded for Oddone_29938. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd help for commands and one-button setup.');
    message('Configured default Subjob=RDM. Use /lac fwd subjob for level-37 capabilities.');
    state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();
    oddLuaNumberRow.bindPalette();

end

profile.OnUnload = function()
    state.ReconcileEnabled = false;
    cancelPendingReconciliationSnapshot();
    state.ReconcileLastRecordedSignature = nil;
    state.BindingGeneration = oddLuaNumberRow.advanceBindingGeneration();
    oddLuaNumberRow.unbindPalette();
    unlockSecondarySlotLocks();

end

profile.HandleCommand = function(args)
    if scale and scale.HandleCommand and scale.HandleCommand(args) then
        return;
    end

    if not args or not args[1] then
        printOddLuaHelp();
        return;
    end

    local command = normalize(args[1]);
    local value = normalize(args[2]);

    if command == 'help' or command == '?' then
        printOddLuaHelp();
        return;
    elseif command == 'styles' or command == 'stylelist' then
        printStyleList();
        return;
    elseif command == 'styleprev' or command == 'styleback' then
        oddLuaNumberRow.cyclePlaystyle(-1);
    elseif command == 'stylenext' or command == 'stylefwd' then
        oddLuaNumberRow.cyclePlaystyle(1);
    elseif command == 'style' or command == 'playstyle' then
        if value == '' or value == 'status' then
            printStyleList();
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '.');
            printStyleList();
            return;
        end

        state.Playstyle = selected;
        if selected == 'Craft' and isEngaged(getPlayer()) then
            message('Style=Craft. Craft cannot equip while engaged.');
            equipDefaultForPlayer(getPlayer(), true);
            return;
        end

        message('Style=' .. state.Playstyle);
        equipDefaultForPlayer(getPlayer(), true);
    elseif command == 'lockstyle' or command == 'stylelock' then
        lockstyleCombatSet();
    elseif command == 'weaponsync' or command == 'syncweapons' then
        local synced, detail = profile.OddLuaRuntime.SyncActiveStyleWeapons();
        if synced == true then
            message('Weapon sync complete: style=' .. tostring(detail) .. '; Scale weapon lock restored.');
        else
            message('Weapon sync failed: ' .. tostring(detail or 'unknown error') .. '.');
        end
    elseif command == 'warp' then
        useWarpRing();
    elseif command == 'warpclear' then
        clearWarpRing();
    elseif command == 'buffitems' or command == 'buffitem' or command == 'buffoverlays' then
        profile.HandleBuffItemOverlayCommand(args);
    elseif command == 'burst' or command == 'magicburst' or command == 'mburst' then
        if value == '' or value == 'status' then
            message('Magic Burst mode=' .. (state.MagicBurstMode and 'on' or 'off') .. '; use /lac fwd burst on|off|status.');
            return;
        elseif value == 'on' then
            if type(sets['MagicBurst']) ~= 'table' or isClearSet(sets['MagicBurst']) then
                state.MagicBurstMode = false;
                message('Magic Burst mode unavailable: no resolved MagicBurst equipment set.');
                return;
            end
            state.MagicBurstMode = true;
            message('Magic Burst mode=on.');
        elseif value == 'off' then
            state.MagicBurstMode = false;
            message('Magic Burst mode=off.');
        else
            message('Unknown burst option. Use /lac fwd burst on|off|status.');
        end


    elseif command == 'guard' then
        if value == '' or value == 'status' then
            local eligible, reason = profile.OddLuaRuntime.GuardEligibility(getPlayer());
            local armed = state.IdleOverrideSet == 'Guard';
            message('Guard mode=' .. (armed and 'armed' or 'off') .. '; eligible=' .. (eligible and 'yes' or 'no') .. '; reason=' .. tostring(reason) .. '; use /lac fwd guard on|off|status.');
            return;
        elseif value == 'on' then
            if type(sets.Guard) ~= 'table' or isClearSet(sets.Guard) then
                message('Guard mode unavailable: no resolved Guard equipment set.');
                return;
            end
            local hasSkill, skillReason = profile.OddLuaRuntime.GuardSkillState(getPlayer());
            if hasSkill ~= true then
                message('Guard mode unavailable: ' .. tostring(skillReason) .. '.');
                return;
            end
            state.IdleOverrideSet = 'Guard';
            local eligible, reason = profile.OddLuaRuntime.GuardEligibility(getPlayer());
            equipDefaultForPlayer(getPlayer(), true);
            message('Guard mode=armed; active=' .. (eligible and 'yes' or 'no') .. '; reason=' .. tostring(reason) .. '.');
            return;
        elseif value == 'off' then
            if state.IdleOverrideSet ~= 'Guard' then
                message('Guard mode=off; override=' .. profile.OverrideStateText() .. ' unchanged.');
                return;
            end
            state.IdleOverrideSet = nil;
            equipDefaultForPlayer(getPlayer(), true);
            message('Guard mode=off. Normal combat/idle gear restored.');
            return;
        else
            message('Unknown guard option. Use /lac fwd guard on|off|status.');
            return;
        end

    elseif command == 'mode' or command == 'gearmode' or command == 'skillup' or command == 'proc' then
        local selectedMode = value;
        if command == 'proc' and selectedMode == '' then
            selectedMode = 'proc';
        elseif command == 'skillup' and selectedMode ~= 'magic' then
            selectedMode = 'combat';
        end
        if selectedMode == '' or selectedMode == 'status' then
            message('Gear mode=' .. tostring(state.ExplicitGearMode)
                .. '; available=' .. profile.OddLuaRuntime.ExplicitGearModeAvailabilityText()
                .. '; use /lac fwd mode combat|magic|proc|off|status.');
            return;
        end
        if selectedMode == 'combatskillup' or selectedMode == 'combat_skillup' then
            selectedMode = 'combat';
        elseif selectedMode == 'magicskillup' or selectedMode == 'magic_skillup' then
            selectedMode = 'magic';
        end
        if selectedMode == 'off' then
            state.ExplicitGearMode = 'off';
            equipDefaultForPlayer(getPlayer(), true);
            message('Gear mode=off. Normal combat and spell gear restored.');
            return;
        end
        if explicitGearModeSetNames[selectedMode] == nil then
            message('Unknown gear mode. Use /lac fwd mode combat|magic|proc|off|status.');
            return;
        end
        if explicitGearModeSetAvailable(selectedMode) ~= true then
            state.ExplicitGearMode = 'off';
            equipDefaultForPlayer(getPlayer(), true);
            message('Gear mode unavailable: no resolved ' .. tostring(explicitGearModeSetNames[selectedMode]) .. ' equipment set. Mode remains off.');
            return;
        end
        state.ExplicitGearMode = selectedMode;
        equipDefaultForPlayer(getPlayer(), true);
        if selectedMode == 'proc' then
            message('Gear mode=proc. This explicit choice deliberately swaps Main and may reset TP; no action is automated.');
        elseif selectedMode == 'combat' then
            message('Gear mode=combat. Owned combat skill-gain gear overlays only while engaged.');
        else
            message('Gear mode=magic. Owned magic skill-gain gear overlays only at spell resolution.');
        end
    elseif command == 'override' or command == 'defense' or command == 'def' or profile.DefenseAliases[command] ~= nil then
        if profile.HandleOverrideCommand(args) then
            equipDefaultForPlayer(getPlayer(), true);
        end
    elseif command == 'resist' or command == 'res' or profile.ResistAliases[command] ~= nil then
        if profile.HandleResistCommand(args) then
            equipDefaultForPlayer(getPlayer(), true);
        end
    elseif command == 'setmp' or command == 'addmp' or command == 'resetmp'
        or command == 'sethp' or command == 'addhp' or command == 'resethp' then
        local changed, handled = profile.HandleIdlePoolCommand(args);
        if changed and handled ~= true then
            equipDefaultForPlayer(getPlayer(), true);
        end
    elseif command == 'utility' then
        oddLuaNumberRow.equipUtilityIntent(value);
    elseif command == 'keypad' then
        if value == '' or value == 'status' or value == 'help' or value == 'list' or value == 'map' then
            oddLuaNumberRow.printPalette();
            return;
        elseif value == 'clear' or value == 'cleanup' or value == 'unbind' then
            oddLuaNumberRow.clearPaletteBinds();
            return;
        end
        oddLuaNumberRow.setPaletteEnabled(value);
    elseif command == 'palette' or command == 'numberrow' then
        if value == 'missing' then
            message('Not Applicable / Missing Equipment');
            return;
        end
        if value == 'clear' or value == 'cleanup' or value == 'unbind' then
            oddLuaNumberRow.clearPaletteBinds();
            return;
        end
        oddLuaNumberRow.setPaletteEnabled(value);
    elseif command == 'overlays' or command == 'overlay'
        or command == 'conditionals' or command == 'conditional' then
        profile.PrintConditionalOverlayStatus();
    elseif command == 'mechanics' then
        profile.OddLuaRuntime.HandleMechanicsCommand(args);
    elseif command == 'reconcile' then
        handleReconcileCommand(args);
    elseif command == 'updategear' or command == 'gearupdate' or command == 'refreshgear' or command == 'reprocessgear' or command == 'rebuildgear' then
        startOddLuaGearRefresh(args);
    elseif command == 'status' then
        local subjob, subjobName = currentSubjobProfile();
        local capabilityText = 'none';
        if subjob and subjob.capabilities then
            capabilityText = table.concat(subjob.capabilities, ',');
        end
        local keypadText = 'off';
        if state.NumberRowPaletteEnabled == true then
            keypadText = 'on';
        end
        local buffItemsText = profile.BuffItemOverlayStateText();
        message('Style=' .. state.Playstyle .. '; active=' .. activeCombatStyle() .. '; Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. capabilityText .. '; keypad=' .. keypadText .. '; buffitems=' .. buffItemsText .. '; burst=' .. (state.MagicBurstMode and 'on' or 'off') .. '; gearmode=' .. tostring(state.ExplicitGearMode) .. '; override=' .. profile.OverrideStateText() .. '; safety=' .. profile.OddLuaRuntime.ActiveSafetyReason(getPlayer()) .. '; mpfloor=' .. profile.IdlePoolStateText() .. '; help=/lac fwd help; styles=/lac fwd styles; keypad=/lac fwd keypad');
    elseif command == 'subjob' or command == 'sj' then
        local subjob, subjobName = currentSubjobProfile();
        if not subjob then
            message('Subjob=' .. tostring(subjobName or '') .. '; no configured level-37 subjob profile.');
            return;
        end
        local detail = normalize(args[2]);
        if detail == 'traits' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.traits, 'traits'));
        elseif detail == 'spells' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.spells, 'spells'));
        elseif detail == 'abilities' then
            message('Subjob=' .. tostring(subjobName or '') .. '; ' .. summarizeSubjobEntries(subjob.abilities, 'abilities'));
        else
            message('Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. table.concat(subjob.capabilities or {}, ',') .. '; use subjob traits|spells|abilities');
        end

    else
        message('Unknown command: ' .. tostring(args[1]) .. '. Use /lac fwd help.');
    end
end

profile.HandleDefault = function()
    equipDefaultForPlayer(getPlayer(), false);
end

profile.HandleAbility = function()
    equipAbility();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    local action = getAction();
    local name = normalize(action and action.Name);
    local skill = normalize(action and action.Skill);
    if skill == 'healing magic'
        and (string.find(name, 'cure', 1, true) == 1 or string.find(name, 'cura', 1, true) == 1) then
        if equipFirstAvailable({ 'CurePrecast', 'FastCast' }, false) then
            return;
        end
    end
    if skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        if equipFirstAvailable({ 'SongPrecast', 'FastCast' }, false) then
            return;
        end
    end
    if skill == 'elemental magic' and equipNamedSetIfNotClear('ElementalPrecast', false) then
        return;
    end
    equipNamedSet('FastCast', false);
    equipNamedSet('Precast', false);
end

profile.HandleMidcast = function()
    local action = getAction();
    if not action then
        return;
    end

    local name = normalize(action.Name);
    local skill = normalize(action.Skill);
    if name == 'flash' then
        equipFirstAvailable({ 'Flash', 'Enmity', 'Divine' }, false);
    elseif skill == 'divine magic'
        and (string.find(name, 'banish', 1, true) == 1 or string.find(name, 'holy', 1, true) == 1) then
        equipFirstAvailable({ 'DivineDamage', 'Divine', 'Midcast' }, false);
    elseif skill == 'divine magic' and name == 'repose' then
        equipFirstAvailable({ 'Divine', 'MagicAccuracy', 'Midcast' }, false);
    elseif name == 'cursna' then
        equipFirstAvailable({ 'Cursna', 'StatusRemoval' }, false);
    elseif profile.OddLuaRuntime.StatusRemovalSpells[name] == true then
        equipNamedSetIfNotClear('StatusRemoval', false);
    elseif skill == 'healing magic' then
        if string.find(name, 'cure', 1, true) == 1 or string.find(name, 'cura', 1, true) == 1 then
            local environment = getEnvironment();
            local candidates = {};
            if environment and environment.WeatherElement and elementMatches(environment.WeatherElement, 'Light') then
                table.insert(candidates, 'CureWeather_Light');
            end
            if environment and environment.DayElement and elementMatches(environment.DayElement, 'Light') then
                table.insert(candidates, 'CureDay_Light');
            end
            table.insert(candidates, 'Cure');
            table.insert(candidates, 'Healing');
            equipFirstAvailable(candidates, false);
        else
            equipNamedSet('Healing', false);
        end
    elseif skill == 'enhancing magic' then
        equipEnhancingMagic(name);
    elseif skill == 'enfeebling magic' then
        equipEnfeeblingMagic(name);
    elseif skill == 'divine magic' then
        equipFirstAvailable({ 'Divine', 'Midcast' }, false);
    elseif skill == 'elemental magic' then
        equipElementalMagic(action);
    elseif skill == 'dark magic' then
        equipDarkMagic(name);
    elseif skill == 'blue magic' then
        equipBlueMagic(action);
    elseif skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        equipSong(name);
    elseif skill == 'geomancy' then
        if string.sub(name, 1, 5) == 'indi-' then
            equipFirstAvailable({ 'IndiDuration', 'Geomancy', 'GeoMagic', 'Midcast' }, false);
        else
            equipFirstAvailable({ 'Geomancy', 'GeoMagic', 'Midcast' }, false);
        end
    elseif skill == 'summoning magic' or skill == 'summoning' then
        equipSummoning(name);
    elseif skill == 'ninjutsu' then
        equipNinjutsu(action);
    else
        return;
    end
    if profile.OddLuaRuntime.ShouldEquipConserveMP(getPlayer(), action) then
        equipNamedSetIfNotClear('ConserveMP', false);
    end
    profile.OddLuaRuntime.ApplyExplicitGearMode('midcast', false);
end

profile.HandlePreshot = function()
    if not equipNamedSet('Snapshot', false) then
        equipNamedSet('RangedPreshot', false);
    end
end

profile.HandleMidshot = function()
    -- Preshot is deliberately sparse Snapshot/Rapid Shot gear. Restore a
    -- complete ranged-combat base before applying the sparse midshot overlay,
    -- so unscored slots never retain preshot gear or arbitrary filler.
    if not equipNamedSetIfNotClear('RangedAccuracy', false) then
        equipNamedSetIfNotClear('Ranged', false);
    end
    equipNamedSetIfNotClear('RangedMidshot', false);
    if hasBuff('Barrage') then
        -- BARRAGE_COUNT is evaluated on this ranged attack, not when the
        -- ability applies its status.
        equipNamedSetIfNotClear('Barrage', false);
    end
end

profile.HandleWeaponskill = function()
    equipWeaponskill();
end

return profile;
