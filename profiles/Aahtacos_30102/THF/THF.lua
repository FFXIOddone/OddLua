local profile = {};
profile.OddLuaBuildToken = 'A8998DDEC5D58BCC05320C3409B6E5C7AA3C9122D77B5EFE96798FB5EE0A9C92';


local state = {
    Playstyle = 'Melt',
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
    Playstyle_Melt = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Octave Club',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Playstyle_Dagger = {
        Main = 'Garuda\'s Dagger',
        Sub = 'Corrosive Kukri',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Playstyle_Safe = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Octave Club',
        Head = 'Crow Beret',
        Neck = 'Focus Collar',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Crow Jupon',
        Hands = 'Crow Bracers',
        Ring1 = 'Hard Leather Ring',
        Ring2 = 'Water Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Crow Hose',
        Feet = 'Tiger Ledelsens',
    },

    Playstyle_Treasure = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Octave Club',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Playstyle_Craft = {
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

    Melt = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Octave Club',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Dagger = {
        Main = 'Garuda\'s Dagger',
        Sub = 'Corrosive Kukri',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Safe = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Octave Club',
        Head = 'Crow Beret',
        Neck = 'Focus Collar',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Crow Jupon',
        Hands = 'Crow Bracers',
        Ring1 = 'Hard Leather Ring',
        Ring2 = 'Water Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Crow Hose',
        Feet = 'Tiger Ledelsens',
    },

    Treasure = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Octave Club',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Craft = {
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

    Idle = {
        Head = 'Super Ribbon',
        Neck = 'Field Torque',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Field Rope',
        Legs = 'Linen Slops',
        Feet = 'Dst. Leggings',
    },

    IdleCity = {
        Head = 'Super Ribbon',
        Body = 'Kupo Suit',
        Legs = 'remove',
    },

    IdleCombat = {
        Sub = 'Thorin\'s Shield',
        Head = 'Darksteel Cap',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Nebimonite Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    IdleMaxMP = {
        Head = 'Super Ribbon',
        Body = 'Brigandine',
        Ring1 = 'Mana Ring',
        Legs = 'Linen Slops',
    },

    IdleMaxHP = {
        Head = 'Super Ribbon',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Nebimonite Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    IdleNonCombat = {
        Head = 'Super Ribbon',
        Body = 'Brigandine',
        Legs = 'Linen Slops',
    },

    Resting = {
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
        Head = 'Super Ribbon',
        Neck = 'Field Torque',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Field Rope',
        Legs = 'Linen Slops',
        Feet = 'Dst. Leggings',
    },

    Dt = {
        Sub = 'Thorin\'s Shield',
        Head = 'Darksteel Cap',
        Neck = 'Field Torque',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Nebimonite Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    PDT = {
        Sub = 'Thorin\'s Shield',
        Head = 'Darksteel Cap',
        Neck = 'Field Torque',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Nebimonite Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    MDT = {
        Sub = 'Thorin\'s Shield',
        Head = 'Darksteel Cap',
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Bonewrk. Cuffs',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Nebimonite Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    FireRes = {
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
    },

    IceRes = {
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Feet = 'Tiger Ledelsens',
    },

    WindRes = {
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
    },

    EarthRes = {
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Hands = 'Bonewrk. Cuffs',
    },

    ThunderRes = {
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
    },

    LightningRes = {
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
    },

    WaterRes = {
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
    },

    LightRes = {
        Head = 'Darksteel Cap',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Ring1 = 'Opal Ring',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    DarkRes = {
        Head = 'Darksteel Cap',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
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
        Main = 'Ifrit\'s Blade',
        Sub = 'Bloody Blade',
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Mrc.Cpt. Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Hybrid = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Bloody Blade',
        Head = 'Darksteel Cap',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    TPAccuracy = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Bloody Blade',
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    CombatSkillup = {
        Head = 'Sprout Beret',
    },

    MagicSkillup = {
        Head = 'Sprout Beret',
    },

    Proc = {
        Main = 'Corrosive Kukri',
    },

    Precast = {
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

    FastCast = {
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

    SIRD = {
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

    Midcast = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Cure = {
        Head = 'Crow Beret',
        Body = 'Crow Jupon',
        Hands = 'Crow Bracers',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Crow Hose',
    },

    Healing = {
        Head = 'Crow Beret',
        Body = 'Crow Jupon',
        Hands = 'Crow Bracers',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Crow Hose',
    },

    Enhancing = {
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

    EnhancingDuration = {
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

    Spikes = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
    },

    Refresh = {
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

    Regen = {
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

    SneakInvisible = {
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

    Barspell = {
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

    Phalanx = {
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

    Aquaveil = {
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

    Haste = {
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

    Enfeebling = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Sleep = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Bind = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Burn = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Choke = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Drown = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Frost = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Gravity = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Silence = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Slow = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Paralyze = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Poison = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Rasp = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Shock = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Blind = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Dispel = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Dia = {
        Legs = 'Linen Slops',
    },

    Bio = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Divine = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Nuke = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    DarkMagic = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Absorb = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Stun = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Ninjutsu = {
        Head = 'Crow Beret',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Crow Jupon',
        Hands = 'Crow Bracers',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Crow Hose',
    },

    Utsusemi = {
        Head = 'Crow Beret',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Crow Jupon',
        Hands = 'Crow Bracers',
        Legs = 'Crow Hose',
    },

    NinjutsuEnfeeble = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weaponskill = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Mrc.Cpt. Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WeaponSkillAccuracy = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Mrc.Cpt. Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WSElemental = {
        Head = 'Super Ribbon',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Brigandine',
        Hands = 'Mrc.Cpt. Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    JobAbility = {
        Ear1 = 'Eris\' Earring',
    },

    Enmity = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Bloody Blade',
        Ear1 = 'Eris\' Earring',
    },

    Elemental_Fire = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Fire = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Fire = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Ice = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Ice = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Ice = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Wind = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Wind = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Wind = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Earth = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Earth = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Earth = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Thunder = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Thunder = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Thunder = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Lightning = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Lightning = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Lightning = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Water = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Water = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Water = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Light = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Light = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Light = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Elemental_Dark = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Weather_Dark = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    Day_Dark = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    DualWield = {
        Main = 'Ifrit\'s Blade',
        Sub = 'Bloody Blade',
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Field Rope',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Waltz = {
        Head = 'Super Ribbon',
        Body = 'Brigandine',
        Hands = 'Crow Bracers',
        Ring1 = 'Opal Ring',
        Waist = 'Corsette',
        Legs = 'Crow Hose',
    },

    Steps = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    Flourish = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    DrainAspir = {
        Head = 'Super Ribbon',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Linen Slops',
    },

    WS_Combo = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Combo = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Shoulder_Tackle = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Shoulder_Tackle = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Backhand_Blow = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Backhand_Blow = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Spinning_Attack = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Spinning_Attack = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Wasp_Sting = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Wasp_Sting = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Gust_Slash = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Body = 'Brigandine',
        Ring1 = 'Rajas Ring',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Gust_Slash = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Shadowstitch = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Opal Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Corsette',
        Legs = 'Noct Brais',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Shadowstitch = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Corsette',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Viper_Bite = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Viper_Bite = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Cyclone = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Body = 'Brigandine',
        Ring1 = 'Rajas Ring',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Cyclone = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Energy_Steal = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Energy_Steal = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Energy_Drain = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Energy_Drain = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Dancing_Edge = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Corsette',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Dancing_Edge = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Exactitude Mantle',
        Waist = 'Corsette',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Shark_Bite = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Mrc.Cpt. Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Shark_Bite = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Hands = 'Mrc.Cpt. Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Fast_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Noct Gaiters',
    },

    WSAcc_Fast_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Burning_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
    },

    WSAcc_Burning_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Flat_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Flat_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Shining_Blade = {
        Head = 'Super Ribbon',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
    },

    WSAcc_Shining_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Circle_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Circle_Blade = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Spirits_Within = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Spirits_Within = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Brainshaker = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Brainshaker = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Starlight = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Starlight = {
        Head = 'Super Ribbon',
        Neck = 'Focus Collar',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_Skullbreaker = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_Skullbreaker = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    WS_True_Strike = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Garrison Hose',
        Feet = 'Tiger Ledelsens',
    },

    WSAcc_True_Strike = {
        Head = 'Super Ribbon',
        Neck = 'Spike Necklace',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Brigandine',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Noct Brais',
        Feet = 'Noct Gaiters',
    },

    DivineDamage = {
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

    Geomancy = {
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
    Hands = {
        ['dusk gloves'] = true,
    },
    Legs = {
        ['dusk trousers'] = true,
    },
    Feet = {
        ['dusk ledelsens'] = true,
    },
};
profile.Packer = {};
profile.GetThreatEntities = nil;

local subjobs = {
    NIN = {
        level = 33,
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
        },
    },
    WAR = {
        level = 33,
        capabilities = {
            'provoke',
            'berserk',
            'aggressor',
            'attack_boost',
            'defense_boost',
            'melee_burst',
        },
        abilities = {
            { name = 'provoke', level = 5, recast = 30, recastId = 5, ce = 1, ve = 1800 },
            { name = 'berserk', level = 15, recast = 300, recastId = 1, ce = 1, ve = 80 },
            { name = 'defender', level = 25, recast = 180, recastId = 3, ce = 1, ve = 80 },
        },
        traits = {
            { name = 'resist virus', level = 5, rank = 1, mod = 'VIRUSRES', value = 10 },
            { name = 'defense bonus', level = 10, rank = 1, mod = 'DEF', value = 10 },
            { name = 'double attack', level = 25, rank = 1, mod = 'DOUBLE_ATTACK', value = 10 },
            { name = 'attack bonus', level = 30, rank = 1, mod = 'ATT', value = 10 },
            { name = 'attack bonus', level = 30, rank = 1, mod = 'RATT', value = 10 },
            { name = 'max hp boost', level = 30, rank = 1, mod = 'BASE_HP', value = 30 },
        },
        spells = {
        },
    },
    DNC = {
        level = 33,
        capabilities = {
            'waltz',
            'samba',
            'steps',
            'flourish',
            'dual_wield',
            'jig',
        },
        abilities = {
            { name = 'sambas', level = 5, recast = 0, recastId = 216, ce = 0, ve = 0 },
            { name = 'drain_samba', level = 5, recast = 60, recastId = 216, ce = 1, ve = 300 },
            { name = 'waltzes', level = 15, recast = 0, recastId = 217, ce = 0, ve = 0 },
            { name = 'curing_waltz', level = 15, recast = 6, recastId = 217, ce = 0, ve = 0 },
            { name = 'steps', level = 20, recast = 0, recastId = 220, ce = 0, ve = 0 },
            { name = 'flourishes_i', level = 20, recast = 0, recastId = 0, ce = 0, ve = 0 },
            { name = 'quickstep', level = 20, recast = 5, recastId = 220, ce = 1, ve = 0 },
            { name = 'animated_flourish', level = 20, recast = 30, recastId = 221, ce = 1, ve = 1000 },
            { name = 'aspir_samba', level = 25, recast = 60, recastId = 216, ce = 1, ve = 300 },
            { name = 'divine_waltz', level = 25, recast = 13, recastId = 225, ce = 0, ve = 0 },
            { name = 'spectral_jig', level = 25, recast = 30, recastId = 218, ce = 1, ve = 300 },
            { name = 'jigs', level = 25, recast = 0, recastId = 218, ce = 0, ve = 0 },
            { name = 'curing_waltz_ii', level = 30, recast = 8, recastId = 186, ce = 0, ve = 0 },
            { name = 'box_step', level = 30, recast = 5, recastId = 220, ce = 1, ve = 0 },
            { name = 'desperate_flourish', level = 30, recast = 20, recastId = 221, ce = 1, ve = 0 },
        },
        traits = {
            { name = 'evasion bonus', level = 15, rank = 1, mod = 'EVA', value = 10 },
            { name = 'dual wield', level = 20, rank = 1, mod = 'DUAL_WIELD', value = 10 },
            { name = 'resist slow', level = 20, rank = 1, mod = 'SLOWRES', value = 10 },
            { name = 'subtle blow', level = 25, rank = 1, mod = 'SUBTLE_BLOW', value = 5 },
            { name = 'accuracy bonus', level = 30, rank = 1, mod = 'ACC', value = 10 },
            { name = 'accuracy bonus', level = 30, rank = 1, mod = 'RACC', value = 10 },
        },
        spells = {
        },
    },
    RNG = {
        level = 33,
        capabilities = {
            'ranged_accuracy',
            'sharpshot',
            'barrage',
            'scavenge',
        },
        abilities = {
            { name = 'sharpshot', level = 1, recast = 300, recastId = 124, ce = 1, ve = 600 },
            { name = 'scavenge', level = 10, recast = 180, recastId = 121, ce = 1, ve = 80 },
            { name = 'camouflage', level = 20, recast = 300, recastId = 123, ce = 1, ve = 80 },
            { name = 'barrage', level = 30, recast = 300, recastId = 125, ce = 1, ve = 600 },
        },
        traits = {
            { name = 'alertness', level = 5, rank = 1, mod = 'NONE', value = 0 },
            { name = 'accuracy bonus', level = 10, rank = 1, mod = 'ACC', value = 10 },
            { name = 'accuracy bonus', level = 10, rank = 1, mod = 'RACC', value = 10 },
            { name = 'rapid shot', level = 15, rank = 1, mod = 'RAPID_SHOT', value = 25 },
            { name = 'resist poison', level = 20, rank = 1, mod = 'POISONRES', value = 10 },
            { name = 'recycle', level = 20, rank = 1, mod = 'RECYCLE', value = 10 },
            { name = 'accuracy bonus', level = 30, rank = 2, mod = 'ACC', value = 22 },
            { name = 'accuracy bonus', level = 30, rank = 2, mod = 'RACC', value = 22 },
            { name = 'damage limit+', level = 30, rank = 1, mod = 'DAMAGE_LIMIT', value = 10 },
        },
        spells = {
        },
    },
    SAM = {
        level = 33,
        capabilities = {
            'store_tp',
            'meditate',
            'third_eye',
            'weapon_skill',
            'warding_circle',
        },
        abilities = {
            { name = 'warding_circle', level = 5, recast = 300, recastId = 135, ce = 1, ve = 20 },
            { name = 'third_eye', level = 15, recast = 60, recastId = 133, ce = 1, ve = 0 },
            { name = 'hasso', level = 25, recast = 60, recastId = 138, ce = 1, ve = 300 },
            { name = 'meditate', level = 30, recast = 180, recastId = 134, ce = 320, ve = 0 },
        },
        traits = {
            { name = 'resist blind', level = 5, rank = 1, mod = 'BLINDRES', value = 10 },
            { name = 'store tp', level = 10, rank = 1, mod = 'STORETP', value = 10 },
            { name = 'zanshin', level = 20, rank = 1, mod = 'ZANSHIN', value = 15 },
            { name = 'resist blind', level = 25, rank = 2, mod = 'BLINDRES', value = 15 },
            { name = 'store tp', level = 30, rank = 2, mod = 'STORETP', value = 15 },
        },
        spells = {
        },
    },
    DRK = {
        level = 33,
        capabilities = {
            'last_resort',
            'souleater',
            'dark_magic',
            'attack_boost',
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
    Playstyle_Melt = 'TP',
    Playstyle_Dagger = 'TP',
    Playstyle_Safe = 'PDT',
    Playstyle_Treasure = 'TP',
    Playstyle_Craft = 'Crafting',
    Melt = 'TP',
    Dagger = 'TP',
    Safe = 'PDT',
    Treasure = 'TP',
    Craft = 'Crafting',
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
    Crafting = 'Crafting',
    TP = 'TP',
    Hybrid = 'TP',
    TPAccuracy = 'Accuracy',
    CombatSkillup = 'TP',
    MagicSkillup = 'MagicAccuracy',
    Proc = 'TP',
    Precast = 'FastCast',
    FastCast = 'FastCast',
    SIRD = 'SIRD',
    Midcast = 'MagicAccuracy',
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
    Nuke = 'Nuke',
    DarkMagic = 'DarkMagic',
    Absorb = 'DarkMagic',
    Stun = 'DarkMagic',
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
    DualWield = 'TP',
    Waltz = 'Cure',
    Steps = 'Accuracy',
    Flourish = 'Flourish',
    DrainAspir = 'DarkMagic',
    WS_Combo = 'Weaponskill',
    WSAcc_Combo = 'WeaponSkillAccuracy',
    WS_Shoulder_Tackle = 'Weaponskill',
    WSAcc_Shoulder_Tackle = 'WeaponSkillAccuracy',
    WS_Backhand_Blow = 'Weaponskill',
    WSAcc_Backhand_Blow = 'WeaponSkillAccuracy',
    WS_Spinning_Attack = 'Weaponskill',
    WSAcc_Spinning_Attack = 'WeaponSkillAccuracy',
    WS_Wasp_Sting = 'Weaponskill',
    WSAcc_Wasp_Sting = 'WeaponSkillAccuracy',
    WS_Gust_Slash = 'Weaponskill',
    WSAcc_Gust_Slash = 'WeaponSkillAccuracy',
    WS_Shadowstitch = 'Weaponskill',
    WSAcc_Shadowstitch = 'WeaponSkillAccuracy',
    WS_Viper_Bite = 'Weaponskill',
    WSAcc_Viper_Bite = 'WeaponSkillAccuracy',
    WS_Cyclone = 'Weaponskill',
    WSAcc_Cyclone = 'WeaponSkillAccuracy',
    WS_Energy_Steal = 'Weaponskill',
    WSAcc_Energy_Steal = 'WeaponSkillAccuracy',
    WS_Energy_Drain = 'Weaponskill',
    WSAcc_Energy_Drain = 'WeaponSkillAccuracy',
    WS_Dancing_Edge = 'Weaponskill',
    WSAcc_Dancing_Edge = 'WeaponSkillAccuracy',
    WS_Shark_Bite = 'Weaponskill',
    WSAcc_Shark_Bite = 'WeaponSkillAccuracy',
    WS_Fast_Blade = 'Weaponskill',
    WSAcc_Fast_Blade = 'WeaponSkillAccuracy',
    WS_Burning_Blade = 'Weaponskill',
    WSAcc_Burning_Blade = 'WeaponSkillAccuracy',
    WS_Flat_Blade = 'Weaponskill',
    WSAcc_Flat_Blade = 'WeaponSkillAccuracy',
    WS_Shining_Blade = 'Weaponskill',
    WSAcc_Shining_Blade = 'WeaponSkillAccuracy',
    WS_Circle_Blade = 'Weaponskill',
    WSAcc_Circle_Blade = 'WeaponSkillAccuracy',
    WS_Spirits_Within = 'Weaponskill',
    WSAcc_Spirits_Within = 'WeaponSkillAccuracy',
    WS_Brainshaker = 'Weaponskill',
    WSAcc_Brainshaker = 'WeaponSkillAccuracy',
    WS_Starlight = 'Weaponskill',
    WSAcc_Starlight = 'WeaponSkillAccuracy',
    WS_Skullbreaker = 'Weaponskill',
    WSAcc_Skullbreaker = 'WeaponSkillAccuracy',
    WS_True_Strike = 'Weaponskill',
    WSAcc_True_Strike = 'WeaponSkillAccuracy',
    DivineDamage = 'Idle',
    BlueMagic = 'BlueMagic',
    PhysicalBlueMagic = 'PhysicalBlueMagic',
    MagicalBlueMagic = 'Nuke',
    Song = 'Song',
    SongPrecast = 'SongPrecast',
    SongDebuff = 'SongDebuff',
    SongBuff = 'SongBuff',
    Geomancy = 'MagicAccuracy',
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
    Samba = 'TP',
    Jump = 'Weaponskill',
    PetReady = 'PetDamage',
    PetMagic = 'PetMagic',
    PetTank = 'PetTank',
    Roll = 'Roll',
};

local styleAliases = {
    melt = 'Melt',
    dagger = 'Dagger',
    safe = 'Safe',
    treasure = 'Treasure',
    craft = 'Craft',
};

local playstyleNames = {
    'Melt',
    'Dagger',
    'Safe',
    'Treasure',
    'Craft',
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

local DEFAULT_PLAYSTYLE = 'Melt';
local STYLE_COMMANDS_TEXT = 'melt|dagger|safe|treasure|craft';
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
};

local nativeDualWieldMainJobs = {
    DNC = 20,
    NIN = 10,
    THF = 20,
};

local setRequiresDualWieldSub = {
    Playstyle_Melt = true,
    Playstyle_Dagger = true,
    Playstyle_Safe = true,
    Playstyle_Treasure = true,
    Melt = true,
    Dagger = true,
    Safe = true,
    Treasure = true,
    TP = true,
    Hybrid = true,
    TPAccuracy = true,
    Enmity = true,
    DualWield = true,
};

local conditionalEquips = {};

profile.BuffItemOverlays = {
    Playstyle_Safe = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Tiger Ledelsens' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    Playstyle_Craft = {
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
    },
    Safe = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Tiger Ledelsens' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    Craft = {
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
    },
    Idle = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Dst. Leggings' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    IdleCity = {
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
    },
    IdleMaxMP = {
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
    },
    IdleMaxHP = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Dst. Leggings' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    IdleNonCombat = {
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
    },
    Resting = {
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
    },
    Aftercast = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Dst. Leggings' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    MDT = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Dst. Leggings' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    FireRes = {
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
    },
    IceRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Tiger Ledelsens' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    WindRes = {
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
    },
    EarthRes = {
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
    },
    ThunderRes = {
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
    },
    LightningRes = {
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
    },
    WaterRes = {
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
    },
    LightRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Dst. Leggings' },
            item = {
                ['id'] = 15754,
                ['name'] = 'Sprinter\'s Shoes',
                ['effect'] = 'quickening',
                ['sourcePath'] = 'scripts\\items\\sprinters_shoes.lua',
            },
        },
    },
    DarkRes = {
        {
            condition = { type = 'missing_status', name = 'quickening', buffs = { 'quickening', 176 } },
            slots = { Feet = 'Sprinter\'s Shoes' },
            afterUse = { Feet = 'Dst. Leggings' },
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
            ['available'] = false,
            ['reason'] = 'no_safe_hp_to_mp_bridge',
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
mechanicsSwapPlanner.transitions['Melt'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Melt',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Dagger'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Dagger',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17627,
            ['item'] = 'Garuda\'s Dagger',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 16494,
            ['item'] = 'Corrosive Kukri',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Safe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Safe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13546,
            ['item'] = 'Hard Leather Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ring2',
            ['itemId'] = 13565,
            ['item'] = 'Water Ring',
            ['reason'] = 'pool delta HPP+15, MPP-15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13316,
            ['item'] = 'Platinum Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13316,
            ['item'] = 'Platinum Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15242,
            ['item'] = 'Crow Beret',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14498,
            ['item'] = 'Crow Jupon',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 15578,
            ['item'] = 'Crow Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Treasure'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Treasure',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12964,
            ['item'] = 'Dst. Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 10926,
            ['item'] = 'Field Torque',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 11769,
            ['item'] = 'Field Rope',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13565,
            ['item'] = 'Water Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13564,
            ['item'] = 'Lightning Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 5,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'pool delta HP+30',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12964,
            ['item'] = 'Dst. Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 10926,
            ['item'] = 'Field Torque',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 15300,
            ['item'] = 'Nebimonite Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring1',
            ['itemId'] = 13565,
            ['item'] = 'Water Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 13564,
            ['item'] = 'Lightning Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12452,
            ['item'] = 'Darksteel Cap',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 40,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'pool delta HP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 15048,
            ['item'] = 'Bonewrk. Cuffs',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12964,
            ['item'] = 'Dst. Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13083,
            ['item'] = 'Chain Choker',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 15300,
            ['item'] = 'Nebimonite Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12452,
            ['item'] = 'Darksteel Cap',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 40,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
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
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['IceRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'IceRes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['WindRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WindRes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['EarthRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'EarthRes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 15048,
            ['item'] = 'Bonewrk. Cuffs',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['ThunderRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'ThunderRes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13083,
            ['item'] = 'Chain Choker',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['LightningRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'LightningRes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13083,
            ['item'] = 'Chain Choker',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['WaterRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WaterRes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13083,
            ['item'] = 'Chain Choker',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Ring1',
            ['itemId'] = 13443,
            ['item'] = 'Opal Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12964,
            ['item'] = 'Dst. Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12452,
            ['item'] = 'Darksteel Cap',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['DarkRes'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'DarkRes',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 15048,
            ['item'] = 'Bonewrk. Cuffs',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12964,
            ['item'] = 'Dst. Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12452,
            ['item'] = 'Darksteel Cap',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 16556,
            ['item'] = 'Bloody Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 12726,
            ['item'] = 'Mrc.Cpt. Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 16556,
            ['item'] = 'Bloody Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12964,
            ['item'] = 'Dst. Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12452,
            ['item'] = 'Darksteel Cap',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
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
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 16556,
            ['item'] = 'Bloody Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11530,
            ['item'] = 'Exactitude Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['reason'] = 'pool delta HP-5, MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['reason'] = 'pool delta HP-5, MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 10,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Proc'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Proc',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16494,
            ['item'] = 'Corrosive Kukri',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Midcast'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Midcast',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Cure'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Cure',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15242,
            ['item'] = 'Crow Beret',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14498,
            ['item'] = 'Crow Jupon',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 15578,
            ['item'] = 'Crow Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Healing'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Healing',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15242,
            ['item'] = 'Crow Beret',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14498,
            ['item'] = 'Crow Jupon',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 15578,
            ['item'] = 'Crow Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Enfeebling'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Enfeebling',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Sleep'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Sleep',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Bind'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Bind',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Burn'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Burn',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Choke'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Choke',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Drown'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Drown',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Frost'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Frost',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Gravity'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Gravity',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Silence'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Silence',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Slow'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Slow',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Paralyze'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Paralyze',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Poison'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Poison',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Rasp'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Rasp',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Shock'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Shock',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Blind'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Blind',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Dispel'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Dispel',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Dia'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Dia',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Bio'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Bio',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Divine'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Divine',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['DarkMagic'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'DarkMagic',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Absorb'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Absorb',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Stun'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Stun',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Ninjutsu'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Ninjutsu',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13316,
            ['item'] = 'Platinum Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13316,
            ['item'] = 'Platinum Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15242,
            ['item'] = 'Crow Beret',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14498,
            ['item'] = 'Crow Jupon',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 15578,
            ['item'] = 'Crow Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Utsusemi'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Utsusemi',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13316,
            ['item'] = 'Platinum Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13316,
            ['item'] = 'Platinum Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 15242,
            ['item'] = 'Crow Beret',
            ['reason'] = 'pool delta HP-5, MP-5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Body',
            ['itemId'] = 14498,
            ['item'] = 'Crow Jupon',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 15578,
            ['item'] = 'Crow Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 0,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['NinjutsuEnfeeble'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'NinjutsuEnfeeble',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['Weaponskill'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Weaponskill',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 12726,
            ['item'] = 'Mrc.Cpt. Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WeaponSkillAccuracy'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WeaponSkillAccuracy',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 12726,
            ['item'] = 'Mrc.Cpt. Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSElemental'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSElemental',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 12726,
            ['item'] = 'Mrc.Cpt. Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13322,
            ['item'] = 'Wing Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13322,
            ['item'] = 'Wing Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['itemId'] = 13417,
            ['item'] = 'Eris\' Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 16556,
            ['item'] = 'Bloody Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13417,
            ['item'] = 'Eris\' Earring',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['DualWield'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'DualWield',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 17665,
            ['item'] = 'Ifrit\'s Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 16556,
            ['item'] = 'Bloody Blade',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 11769,
            ['item'] = 'Field Rope',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11530,
            ['item'] = 'Exactitude Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Waltz'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Waltz',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13443,
            ['item'] = 'Opal Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14907,
            ['item'] = 'Crow Bracers',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13271,
            ['item'] = 'Corsette',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 15578,
            ['item'] = 'Crow Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Steps'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Steps',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11530,
            ['item'] = 'Exactitude Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Flourish'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Flourish',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11530,
            ['item'] = 'Exactitude Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12857,
            ['item'] = 'Linen Slops',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 20,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Combo'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Combo',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Combo'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Combo',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Shoulder_Tackle'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Shoulder_Tackle',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Shoulder_Tackle'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Shoulder_Tackle',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Backhand_Blow'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Backhand_Blow',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Backhand_Blow'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Backhand_Blow',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Spinning_Attack'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Spinning_Attack',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Spinning_Attack'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Spinning_Attack',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Wasp_Sting'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Wasp_Sting',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Wasp_Sting'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Wasp_Sting',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Gust_Slash'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Gust_Slash',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Gust_Slash'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Gust_Slash',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11530,
            ['item'] = 'Exactitude Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Shadowstitch'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Shadowstitch',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13443,
            ['item'] = 'Opal Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13271,
            ['item'] = 'Corsette',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Shadowstitch'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Shadowstitch',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13271,
            ['item'] = 'Corsette',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Viper_Bite'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Viper_Bite',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Viper_Bite'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Viper_Bite',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Cyclone'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Cyclone',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = -15,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Cyclone'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Cyclone',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11530,
            ['item'] = 'Exactitude Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Energy_Steal'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Energy_Steal',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Energy_Steal'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Energy_Steal',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Energy_Drain'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Energy_Drain',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Energy_Drain'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Energy_Drain',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Dancing_Edge'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Dancing_Edge',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13271,
            ['item'] = 'Corsette',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Dancing_Edge'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Dancing_Edge',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13271,
            ['item'] = 'Corsette',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11530,
            ['item'] = 'Exactitude Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Shark_Bite'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Shark_Bite',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 12726,
            ['item'] = 'Mrc.Cpt. Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Shark_Bite'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Shark_Bite',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 12726,
            ['item'] = 'Mrc.Cpt. Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Fast_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Fast_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15543,
            ['item'] = 'Rajas Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Fast_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Fast_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Burning_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Burning_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Burning_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Burning_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Flat_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Flat_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Flat_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Flat_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Shining_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Shining_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Shining_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Shining_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Circle_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Circle_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Circle_Blade'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Circle_Blade',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Spirits_Within'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Spirits_Within',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Spirits_Within'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Spirits_Within',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Starlight'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Starlight',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13280,
            ['item'] = 'Sniper\'s Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 16301,
            ['item'] = 'Focus Collar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 13678,
            ['item'] = 'Sniper\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12958,
            ['item'] = 'Tiger Ledelsens',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14314,
            ['item'] = 'Garrison Hose',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta MPP+15',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring2',
            ['itemId'] = 13485,
            ['item'] = 'Sun Ring',
            ['reason'] = 'pool delta HPP+15',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15151,
            ['item'] = 'Super Ribbon',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15311,
            ['item'] = 'Noct Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Neck',
            ['itemId'] = 13061,
            ['item'] = 'Spike Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 13220,
            ['item'] = 'Ryl.Kgt. Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 13406,
            ['item'] = 'Merman\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 13312,
            ['item'] = 'Coral Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 16231,
            ['item'] = 'Smilodon Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 14323,
            ['item'] = 'Noct Brais',
            ['reason'] = 'pool delta MP-5',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower', 'mp_percent_or_conversion_requires_runtime_probe' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 15,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 20,
            ['targetFlat'] = 15,
            ['sourcePercent'] = -15,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.skippedTransitions['Craft'] = 'utility_set';
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
    ['backhand_blow'] = 'WS_Backhand_Blow',
    ['brainshaker'] = 'WS_Brainshaker',
    ['burning_blade'] = 'WS_Burning_Blade',
    ['circle_blade'] = 'WS_Circle_Blade',
    ['combo'] = 'WS_Combo',
    ['cyclone'] = 'WS_Cyclone',
    ['dancing_edge'] = 'WS_Dancing_Edge',
    ['energy_drain'] = 'WS_Energy_Drain',
    ['energy_steal'] = 'WS_Energy_Steal',
    ['fast_blade'] = 'WS_Fast_Blade',
    ['flat_blade'] = 'WS_Flat_Blade',
    ['gust_slash'] = 'WS_Gust_Slash',
    ['shadowstitch'] = 'WS_Shadowstitch',
    ['shark_bite'] = 'WS_Shark_Bite',
    ['shining_blade'] = 'WS_Shining_Blade',
    ['shoulder_tackle'] = 'WS_Shoulder_Tackle',
    ['skullbreaker'] = 'WS_Skullbreaker',
    ['spinning_attack'] = 'WS_Spinning_Attack',
    ['spirits_within'] = 'WS_Spirits_Within',
    ['starlight'] = 'WS_Starlight',
    ['true_strike'] = 'WS_True_Strike',
    ['viper_bite'] = 'WS_Viper_Bite',
    ['wasp_sting'] = 'WS_Wasp_Sting',
};

local weaponSkillAccuracyRoutes = {
    ['backhand_blow'] = 'WSAcc_Backhand_Blow',
    ['brainshaker'] = 'WSAcc_Brainshaker',
    ['burning_blade'] = 'WSAcc_Burning_Blade',
    ['circle_blade'] = 'WSAcc_Circle_Blade',
    ['combo'] = 'WSAcc_Combo',
    ['cyclone'] = 'WSAcc_Cyclone',
    ['dancing_edge'] = 'WSAcc_Dancing_Edge',
    ['energy_drain'] = 'WSAcc_Energy_Drain',
    ['energy_steal'] = 'WSAcc_Energy_Steal',
    ['fast_blade'] = 'WSAcc_Fast_Blade',
    ['flat_blade'] = 'WSAcc_Flat_Blade',
    ['gust_slash'] = 'WSAcc_Gust_Slash',
    ['shadowstitch'] = 'WSAcc_Shadowstitch',
    ['shark_bite'] = 'WSAcc_Shark_Bite',
    ['shining_blade'] = 'WSAcc_Shining_Blade',
    ['shoulder_tackle'] = 'WSAcc_Shoulder_Tackle',
    ['skullbreaker'] = 'WSAcc_Skullbreaker',
    ['spinning_attack'] = 'WSAcc_Spinning_Attack',
    ['spirits_within'] = 'WSAcc_Spirits_Within',
    ['starlight'] = 'WSAcc_Starlight',
    ['true_strike'] = 'WSAcc_True_Strike',
    ['viper_bite'] = 'WSAcc_Viper_Bite',
    ['wasp_sting'] = 'WSAcc_Wasp_Sting',
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
    text = '[Aahtacos THF] ' .. tostring(text or '');
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
    message('Quick start: /lac fwd help | styles | status | keypad | lockstyle | weaponsync | warp | subjob | buffitems | pdt | fireres | mode.');
    message('Current style=' .. tostring(state.Playstyle) .. '; default=' .. tostring(DEFAULT_PLAYSTYLE) .. '.');
    printStyleList();
    message('Lockstyle: /lac fwd lockstyle equips the TP set first, then /lockstyle on.');
    message('Weapon sync: /lac fwd weaponsync deliberately equips only the active style Main/Sub/Range through Scale and may reset TP; the weapon lock is restored immediately.');
    message('Keypad macros: /lac fwd keypad shows keypad map; /lac fwd keypad off disables; /lac fwd keypad clear unbinds keypad and old number-row keys.');
    message('Buff item overlays: /lac fwd buffitems on|off|status.');
    message('Conditional overlays: /lac fwd overlays.');
    message('Magic Burst mode: /lac fwd burst on|off|status (default off).');




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
    player = 'Aahtacos',
    playerId = '30102',
    job = 'THF',
    logPath = 'logs/oddlua-reconcile-Aahtacos_30102-THF.jsonl',
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
        { 'Bloody Blade', 'bloody_blade' },
        { 'Bonewrk. Cuffs', 'boneworkers_cuffs', 'bonewrk._cuffs' },
        { 'Brigandine', 'brigandine', 'brigandine_armor' },
        { 'Chain Choker', 'chain_choker' },
        { 'Coral Earring', 'coral_earring' },
        { 'Corrosive Kukri', 'corrosive_kukri' },
        { 'Corsette', 'corsette' },
        { 'Crow Beret', 'crow_beret' },
        { 'Crow Bracers', 'crow_bracers' },
        { 'Crow Hose', 'crow_hose' },
        { 'Crow Jupon', 'crow_jupon' },
        { 'Darksteel Cap', 'darksteel_cap' },
        { 'Darksteel Subligar', 'darksteel_subligar' },
        { 'Dst. Leggings', 'darksteel_leggings', 'dst._leggings' },
        { 'Eris\' Earring', 'eris_earring' },
        { 'Exactitude Mantle', 'exactitude_mantle' },
        { 'Field Rope', 'field_rope' },
        { 'Field Torque', 'field_torque' },
        { 'Focus Collar', 'focus_collar' },
        { 'Garrison Hose', 'garrison_hose' },
        { 'Garuda\'s Dagger', 'garudas_dagger' },
        { 'Hard Leather Ring', 'hard_leather_ring' },
        { 'Ifrit\'s Blade', 'ifrits_blade' },
        { 'Kupo Suit', 'kupo_suit' },
        { 'Lightning Ring', 'lightning_ring' },
        { 'Linen Slops', 'linen_slops' },
        { 'Mana Ring', 'mana_ring' },
        { 'Merman\'s Earring', 'mermans_earring' },
        { 'Mrc.Cpt. Gloves', 'mercenary_captains_gloves', 'mrc.cpt._gloves' },
        { 'Nebimonite Belt', 'nebimonite_belt' },
        { 'Noct Brais', 'noct_brais' },
        { 'Noct Gaiters', 'noct_gaiters' },
        { 'Octave Club', 'octave_club' },
        { 'Opal Ring', 'opal_ring' },
        { 'Platinum Earring', 'platinum_earring' },
        { 'Rajas Ring', 'rajas_ring' },
        { 'Ryl.Kgt. Belt', 'royal_knights_belt', 'ryl.kgt._belt' },
        { 'Smilodon Mantle', 'smilodon_mantle' },
        { 'Sniper\'s Mantle', 'snipers_mantle' },
        { 'Sniper\'s Ring', 'snipers_ring' },
        { 'Spike Necklace', 'spike_necklace' },
        { 'Sprout Beret', 'sprout_beret' },
        { 'Sun Ring', 'sun_ring' },
        { 'Super Ribbon', 'super_ribbon' },
        { 'Thorin\'s Shield', 'thorfinn_shield' },
        { 'Tiger Ledelsens', 'tiger_ledelsens' },
        { 'Water Ring', 'water_ring' },
        { 'Wing Earring', 'wing_earring' },
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
    return 'NIN';
end

local function currentSubjobProfile()
    local subjob = activeSubjob();
    return subjobs[subjob], subjob;
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
    local minimumLevel = nativeDualWieldMainJobs['THF'];
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
    if state.IdleOverrideSet ~= nil
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
        return 'Melt';
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
        if equipNamedSet(setNameFor('Melt'), force) then
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
    return equipNamedSet('Playstyle_Melt', force);
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
        if not equipNamedSet(setNameFor('Melt'), true) then
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
        elseif state.IdleOverrideSet ~= nil then
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
    message('OddLua dynamic profile loaded for Aahtacos_30102. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd help for commands and one-button setup.');
    message('Configured default Subjob=NIN. Use /lac fwd subjob for level-37 capabilities.');
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
