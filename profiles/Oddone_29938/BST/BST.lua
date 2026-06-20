local profile = {};

local state = {
    Playstyle = 'Damage',
    NumberRowPaletteEnabled = true,
    WarpRingLocked = false,
    SecondarySlotLocks = {},
    SecondarySlotLockContextSetNames = nil,
    MechanicsProbes = false,
    MechanicsExecution = false,
    ReconcileEnabled = true,
    ReconcileSnapshotSeq = 0,
    ReconcilePendingSnapshot = nil,
    ReconcileScanScheduled = false,
    ReconcileScanToken = 0,
    ReconcileLastRecordedSignature = nil,
    ReconcileLast = nil,
    ReconcileLogDirectoryReady = false,
    ReconcileLastWriteError = nil,
    StableEquipForcePending = false,
    OddLuaRefreshPending = false,
    OddLuaRefreshLastStatus = 'none',

};

local sets = {
    Playstyle_Damage = {
        Main = 'Octave Club',
        Sub = 'Hunahpu',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Playstyle_Accuracy = {
        Main = 'Octave Club',
        Sub = 'Hunahpu',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Playstyle_PetDamage = {
        Main = 'Viking Axe',
        Sub = 'Cmb.Cst. Axe',
        Head = 'Aurum Armet',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Battle Boots',
    },

    Playstyle_PetTank = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Wilderness Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Leather Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cappa',
        Waist = 'Marid Belt',
        Legs = 'Monster Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Damage = {
        Main = 'Octave Club',
        Sub = 'Hunahpu',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Accuracy = {
        Main = 'Octave Club',
        Sub = 'Hunahpu',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    PetDamage = {
        Main = 'Viking Axe',
        Sub = 'Cmb.Cst. Axe',
        Head = 'Aurum Armet',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Battle Boots',
    },

    PetTank = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Wilderness Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Leather Ring',
        Ring2 = 'Snow Ring',
        Back = 'Oneiros Cappa',
        Waist = 'Marid Belt',
        Legs = 'Monster Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Idle = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Colossus\'s Earring',
        Body = 'Darksteel Harness',
        Hands = 'Trainer\'s Gloves',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    Resting = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Relaxing Earring',
        Ear2 = 'Star Earring',
        Body = 'Brigandine',
        Hands = 'Ogre Gloves',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Karka Ring',
        Back = 'Ram Mantle',
        Waist = 'Marid Belt',
        Legs = 'Monster Trousers',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    InCity = {
        Body = 'Kupo Suit',
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
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Colossus\'s Earring',
        Body = 'Darksteel Harness',
        Hands = 'Trainer\'s Gloves',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    PDT = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Ryl.Sqr. Collar',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Darksteel Harness',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Alert Ring',
        Ring2 = 'Corneus Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Marid Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    MDT = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Walahra Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Green Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Emerald Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Marid Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
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
        Main = 'Octave Club',
        Sub = 'Hunahpu',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Hybrid = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Ryl.Sqr. Collar',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Pagondas Earring',
        Body = 'Darksteel Harness',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Alert Ring',
        Ring2 = 'Corneus Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Marid Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    TPAccuracy = {
        Main = 'Octave Club',
        Sub = 'Hunahpu',
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Precast = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    FastCast = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    Midcast = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Cure = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Brigandine',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Healing = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Brigandine',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Enhancing = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    EnhancingDuration = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    Stoneskin = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Brigandine',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Refresh = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Colossus\'s Earring',
        Body = 'Darksteel Harness',
        Hands = 'Trainer\'s Gloves',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    Regen = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Star Earring',
        Body = 'Brigandine',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    SneakInvisible = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    Barspell = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Walahra Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Green Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Emerald Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Marid Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Phalanx = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Walahra Turban',
        Neck = 'Colossus\'s Torque',
        Ear1 = 'Star Earring',
        Ear2 = 'Green Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Emerald Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Marid Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Aquaveil = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    Haste = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    Enfeebling = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Sleep = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Bind = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Gravity = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Silence = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Slow = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Paralyze = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Blind = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Dispel = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Dia = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Bio = {
        Main = 'Viking Axe',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Venture Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Divine = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Elemental = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Nuke = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    DarkMagic = {
        Main = 'Viking Axe',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Venture Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    DrainAspir = {
        Main = 'Viking Axe',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Venture Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Absorb = {
        Main = 'Viking Axe',
        Sub = 'Thorin\'s Shield',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Venture Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Stun = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Star Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Insect Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Ninjutsu = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Morion Tathlum',
        Head = 'Walahra Turban',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Swift Gages',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Waist = 'Headlong Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Siren\'s Sollerets',
    },

    Utsusemi = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Walahra Turban',
        Neck = 'Beak Necklace',
        Ear1 = 'Loquac. Earring',
        Body = 'Brigandine',
        Hands = 'Swift Gages',
        Ring1 = 'Tamas Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Feet = 'Siren\'s Sollerets',
    },

    NinjutsuEnfeeble = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Morion Tathlum',
        Head = 'Walahra Turban',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Swift Gages',
        Ring1 = 'Snow Ring',
        Ring2 = 'Insect Ring',
        Waist = 'Headlong Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Siren\'s Sollerets',
    },

    Weaponskill = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Moepapa Medal',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Ram Mantle',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WeaponSkillAccuracy = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Moepapa Medal',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Ram Mantle',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WSElemental = {
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    JobAbility = {
        Main = 'Hunahpu',
        Sub = 'Thorin\'s Shield',
        Head = 'Walahra Turban',
        Neck = 'Bird Whistle',
        Ear1 = 'Eris\' Earring',
        Ear2 = 'Colossus\'s Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Swift Gages',
        Ring1 = 'Corneus Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Legs = 'Monster Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Enmity = {
        Main = 'Octave Club',
        Sub = 'Sipar',
        Head = 'Walahra Turban',
        Neck = 'Bird Whistle',
        Ear1 = 'Eris\' Earring',
        Ear2 = 'Colossus\'s Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Swift Gages',
        Ring1 = 'Corneus Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Colossus\'s Mantle',
        Waist = 'Headlong Belt',
        Legs = 'Monster Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    PetReady = {
        Main = 'Viking Axe',
        Sub = 'Cmb.Cst. Axe',
        Head = 'Aurum Armet',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Battle Boots',
    },

    PetMagic = {
        Main = 'Viking Axe',
        Sub = 'Cmb.Cst. Axe',
        Head = 'Aurum Armet',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Battle Boots',
    },

    Elemental_Fire = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Fire = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Fire = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Ice = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Ice = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Ice = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Wind = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Wind = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Wind = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Earth = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Earth = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Earth = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Thunder = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Thunder = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Thunder = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Lightning = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Lightning = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Lightning = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Water = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Water = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Water = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Light = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Light = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Light = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Elemental_Dark = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Weather_Dark = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Day_Dark = {
        Main = 'Hunahpu',
        Sub = 'Sipar',
        Ammo = 'Hedgehog Bomb',
        Head = 'Faerie Hairpin',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Mountain Gaiters',
    },

    Waltz = {
        Head = 'Genbu\'s Kabuto',
        Neck = 'Beast Whistle',
        Ear1 = 'Mythril Earring',
        Ear2 = 'Mythril Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Corneus Ring',
        Ring2 = 'Alert Ring',
        Back = 'Oneiros Cappa',
        Waist = 'Marid Belt',
        Legs = 'Dst. Codpiece',
        Feet = 'Siren\'s Sollerets',
    },

    Samba = {
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    Steps = {
        Head = 'Walahra Turban',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Aesir Ear Pendant',
        Body = 'Scp. Harness +1',
        Hands = 'Swift Gages',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Headlong Belt',
        Legs = 'Coeurl Trousers',
        Feet = 'Siren\'s Sollerets',
    },

    WS_Wasp_Sting = {
        Head = 'Empress Hairpin',
        Neck = 'Moepapa Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Brigandine',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Ram Mantle',
        Waist = 'Warwolf Belt',
        Legs = 'Monster Trousers',
        Feet = 'Adsilio Boots +1',
    },

    WSAcc_Wasp_Sting = {
        Head = 'Aurum Armet',
        Neck = 'Moepapa Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Ram Mantle',
        Waist = 'Warwolf Belt',
        Legs = 'Monster Trousers',
        Feet = 'Adsilio Boots +1',
    },

    WS_Gust_Slash = {
        Head = 'Empress Hairpin',
        Neck = 'Moepapa Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Back = 'Ram Mantle',
        Waist = 'Salire Belt',
        Legs = 'Monster Trousers',
        Feet = 'Adsilio Boots +1',
    },

    WSAcc_Gust_Slash = {
        Head = 'Aurum Armet',
        Neck = 'Moepapa Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ryl.Sqr. Mufflers',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Snow Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Monster Trousers',
        Feet = 'Adsilio Boots +1',
    },

    WS_Shadowstitch = {
        Head = 'Monster Helm',
        Neck = 'Flower Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Pearl Ring',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Dst. Codpiece',
        Feet = 'Siren\'s Sollerets',
    },

    WSAcc_Shadowstitch = {
        Head = 'Monster Helm',
        Neck = 'Flower Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Trainer\'s Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Dst. Codpiece',
        Feet = 'Siren\'s Sollerets',
    },

    WS_Energy_Steal = {
        Head = 'Aurum Armet',
        Neck = 'Storm Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WSAcc_Energy_Steal = {
        Head = 'Aurum Armet',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WS_Fast_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Moepapa Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Brutal Earring',
        Body = 'Brigandine',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Garnet Ring',
        Back = 'Ram Mantle',
        Waist = 'Warwolf Belt',
        Legs = 'Monster Trousers',
        Feet = 'Adsilio Boots +1',
    },

    WSAcc_Fast_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Brutal Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Monster Trousers',
        Feet = 'Adsilio Boots +1',
    },

    WS_Burning_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Ogre Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Burning_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Flat_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Flat_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Shining_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Hands = 'Ogre Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    WSAcc_Shining_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Karka Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    WS_Circle_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Circle_Blade = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Spirits_Within = {
        Head = 'Aurum Armet',
        Neck = 'Storm Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WSAcc_Spirits_Within = {
        Head = 'Aurum Armet',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WS_Smash_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Smash_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Gale_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Gale_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Avalanche_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Avalanche_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Spinning_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Spinning_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Rampage = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Brutal Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Rampage = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Brutal Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Calamity = {
        Head = 'Genbu\'s Kabuto',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Titanis Earring',
        Body = 'Brigandine',
        Hands = 'Ogre Gloves',
        Ring1 = 'Corneus Ring',
        Ring2 = 'Venture Ring',
        Back = 'Oneiros Cappa',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Calamity = {
        Head = 'Genbu\'s Kabuto',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Titanis Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Corneus Ring',
        Ring2 = 'Venture Ring',
        Back = 'Oneiros Cappa',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Mistral_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Mistral_Axe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Dark_Harvest = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Monster Jackcoat',
        Hands = 'Ogre Gloves',
        Ring1 = 'Snow Ring',
        Ring2 = 'Zircon Ring',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Dark_Harvest = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Portus Annulet',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Nightmare_Scythe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    WSAcc_Nightmare_Scythe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    WS_Spinning_Scythe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Aife\'s Medal',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    WSAcc_Spinning_Scythe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Star Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Karka Ring',
        Back = 'Accura Cape',
        Waist = 'Salire Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    WS_Vorpal_Scythe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Vorpal_Scythe = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Brainshaker = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Brainshaker = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_Starlight = {
        Head = 'Aurum Armet',
        Neck = 'Storm Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WSAcc_Starlight = {
        Head = 'Aurum Armet',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Guerilla Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Monster Belt',
        Legs = 'Republic Subligar',
        Feet = 'Adsilio Boots +1',
    },

    WS_Skullbreaker = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_Skullbreaker = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WS_True_Strike = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
    },

    WSAcc_True_Strike = {
        Head = 'Conqueror\'s Helm',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Wilderness Earring',
        Body = 'Scp. Harness +1',
        Hands = 'Ogre Gloves',
        Ring1 = 'Venture Ring',
        Ring2 = 'Portus Annulet',
        Back = 'Accura Cape',
        Waist = 'Warwolf Belt',
        Legs = 'Republic Subligar',
        Feet = 'Agrona\'s Leggings',
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
profile.Packer = {};
profile.GetThreatEntities = nil;

local subjobs = {
    DNC = {
        level = 37,
        capabilities = {
            'waltz',
            'samba',
            'steps',
            'dual_wield',
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
            { name = 'drain_samba_ii', level = 35, recast = 60, recastId = 216, ce = 1, ve = 300 },
            { name = 'healing_waltz', level = 35, recast = 8, recastId = 215, ce = 1, ve = 300 },
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
    WAR = {
        level = 37,
        capabilities = {
            'provoke',
            'attack_boost',
            'defense_boost',
            'melee_burst',
        },
        abilities = {
            { name = 'provoke', level = 5, recast = 30, recastId = 5, ce = 1, ve = 1800 },
            { name = 'berserk', level = 15, recast = 300, recastId = 1, ce = 1, ve = 80 },
            { name = 'defender', level = 25, recast = 180, recastId = 3, ce = 1, ve = 80 },
            { name = 'warcry', level = 35, recast = 300, recastId = 2, ce = 1, ve = 300 },
        },
        traits = {
            { name = 'resist virus', level = 5, rank = 1, mod = 'VIRUSRES', value = 10 },
            { name = 'defense bonus', level = 10, rank = 1, mod = 'DEF', value = 10 },
            { name = 'double attack', level = 25, rank = 1, mod = 'DOUBLE_ATTACK', value = 10 },
            { name = 'attack bonus', level = 30, rank = 1, mod = 'ATT', value = 10 },
            { name = 'attack bonus', level = 30, rank = 1, mod = 'RATT', value = 10 },
            { name = 'max hp boost', level = 30, rank = 1, mod = 'BASE_HP', value = 30 },
            { name = 'resist virus', level = 35, rank = 2, mod = 'VIRUSRES', value = 15 },
            { name = 'smite', level = 35, rank = 1, mod = 'SMITE', value = 25 },
        },
        spells = {
        },
    },
    WHM = {
        level = 37,
        capabilities = {
            'cure',
            'status_removal',
            'protect_shell',
            'sneak_invisible',
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
    THF = {
        level = 37,
        capabilities = {
            'sneak_attack',
            'treasure_hunter',
            'evasion',
            'flee',
            'dual_wield',
        },
        abilities = {
            { name = 'steal', level = 5, recast = 300, recastId = 60, ce = 1, ve = 300 },
            { name = 'sneak_attack', level = 15, recast = 60, recastId = 64, ce = 1, ve = 0 },
            { name = 'flee', level = 25, recast = 300, recastId = 62, ce = 1, ve = 80 },
            { name = 'trick_attack', level = 30, recast = 60, recastId = 66, ce = 1, ve = 0 },
            { name = 'mug', level = 35, recast = 300, recastId = 65, ce = 1, ve = 300 },
        },
        traits = {
            { name = 'gilfinder', level = 5, rank = 1, mod = 'GILFINDER', value = 1 },
            { name = 'evasion bonus', level = 10, rank = 1, mod = 'EVA', value = 10 },
            { name = 'treasure hunter', level = 15, rank = 1, mod = 'TREASURE_HUNTER', value = 1 },
            { name = 'resist gravity', level = 20, rank = 1, mod = 'GRAVITYRES', value = 10 },
            { name = 'evasion bonus', level = 30, rank = 2, mod = 'EVA', value = 22 },
        },
        spells = {
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
    Playstyle_Damage = 'TP',
    Playstyle_Accuracy = 'Accuracy',
    Playstyle_PetDamage = 'PetDamage',
    Playstyle_PetTank = 'PetTank',
    Damage = 'TP',
    Accuracy = 'Accuracy',
    PetDamage = 'PetDamage',
    PetTank = 'PetTank',
    Idle = 'Idle',
    Resting = 'Idle',
    InCity = 'Movement',
    Movement = 'Movement',
    Movement_City = 'Movement',
    Movement_Night = 'Movement',
    Movement_DuskToDawn = 'Movement',
    Aftercast = 'Idle',
    PDT = 'PDT',
    MDT = 'MDT',
    Crafting = 'Crafting',
    TP = 'TP',
    Hybrid = 'TP',
    TPAccuracy = 'Accuracy',
    Precast = 'FastCast',
    FastCast = 'FastCast',
    Midcast = 'MagicAccuracy',
    Cure = 'Cure',
    Healing = 'Healing',
    Enhancing = 'Enhancing',
    EnhancingDuration = 'Enhancing',
    Stoneskin = 'Enhancing',
    Refresh = 'Enhancing',
    Regen = 'Healing',
    SneakInvisible = 'Enhancing',
    Barspell = 'Enhancing',
    Phalanx = 'Enhancing',
    Aquaveil = 'Enhancing',
    Haste = 'Enhancing',
    Enfeebling = 'Enfeebling',
    Sleep = 'Enfeebling',
    Bind = 'Enfeebling',
    Gravity = 'Enfeebling',
    Silence = 'Enfeebling',
    Slow = 'Enfeebling',
    Paralyze = 'Enfeebling',
    Blind = 'Enfeebling',
    Dispel = 'Enfeebling',
    Dia = 'Enfeebling',
    Bio = 'DarkMagic',
    Divine = 'Cure',
    Elemental = 'Nuke',
    Nuke = 'Nuke',
    DarkMagic = 'DarkMagic',
    DrainAspir = 'DarkMagic',
    Absorb = 'DarkMagic',
    Stun = 'DarkMagic',
    Ninjutsu = 'Ninjutsu',
    Utsusemi = 'FastCast',
    NinjutsuEnfeeble = 'Ninjutsu',
    Weaponskill = 'Weaponskill',
    WeaponSkillAccuracy = 'Weaponskill',
    WSElemental = 'Weaponskill',
    JobAbility = 'TP',
    Enmity = 'Enmity',
    PetReady = 'PetDamage',
    PetMagic = 'PetDamage',
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
    Waltz = 'Cure',
    Samba = 'TP',
    Steps = 'Accuracy',
    WS_Wasp_Sting = 'TP',
    WSAcc_Wasp_Sting = 'TP',
    WS_Gust_Slash = 'TP',
    WSAcc_Gust_Slash = 'TP',
    WS_Shadowstitch = 'TP',
    WSAcc_Shadowstitch = 'TP',
    WS_Energy_Steal = 'TP',
    WSAcc_Energy_Steal = 'TP',
    WS_Fast_Blade = 'TP',
    WSAcc_Fast_Blade = 'TP',
    WS_Burning_Blade = 'TP',
    WSAcc_Burning_Blade = 'TP',
    WS_Flat_Blade = 'TP',
    WSAcc_Flat_Blade = 'TP',
    WS_Shining_Blade = 'TP',
    WSAcc_Shining_Blade = 'TP',
    WS_Circle_Blade = 'TP',
    WSAcc_Circle_Blade = 'TP',
    WS_Spirits_Within = 'TP',
    WSAcc_Spirits_Within = 'TP',
    WS_Smash_Axe = 'TP',
    WSAcc_Smash_Axe = 'TP',
    WS_Gale_Axe = 'TP',
    WSAcc_Gale_Axe = 'TP',
    WS_Avalanche_Axe = 'TP',
    WSAcc_Avalanche_Axe = 'TP',
    WS_Spinning_Axe = 'TP',
    WSAcc_Spinning_Axe = 'TP',
    WS_Rampage = 'TP',
    WSAcc_Rampage = 'TP',
    WS_Calamity = 'TP',
    WSAcc_Calamity = 'TP',
    WS_Mistral_Axe = 'TP',
    WSAcc_Mistral_Axe = 'TP',
    WS_Dark_Harvest = 'TP',
    WSAcc_Dark_Harvest = 'TP',
    WS_Nightmare_Scythe = 'TP',
    WSAcc_Nightmare_Scythe = 'TP',
    WS_Spinning_Scythe = 'TP',
    WSAcc_Spinning_Scythe = 'TP',
    WS_Vorpal_Scythe = 'TP',
    WSAcc_Vorpal_Scythe = 'TP',
    WS_Brainshaker = 'TP',
    WSAcc_Brainshaker = 'TP',
    WS_Starlight = 'TP',
    WSAcc_Starlight = 'TP',
    WS_Skullbreaker = 'TP',
    WSAcc_Skullbreaker = 'TP',
    WS_True_Strike = 'TP',
    WSAcc_True_Strike = 'TP',
    BlueMagic = 'BlueMagic',
    PhysicalBlueMagic = 'BlueMagic',
    MagicalBlueMagic = 'Nuke',
    Song = 'Song',
    SongDebuff = 'Song',
    SongBuff = 'Song',
    Geomancy = 'MagicAccuracy',
    Summoning = 'MagicAccuracy',
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
    Jump = 'Weaponskill',
    Roll = 'Roll',
};

local styleAliases = {
    damage = 'Damage',
    accuracy = 'Accuracy',
    petdamage = 'PetDamage',
    pettank = 'PetTank',
};

local playstyleNames = {
    'Damage',
    'Accuracy',
    'PetDamage',
    'PetTank',
};

local numberRowBindings = {
    { key = '1', label = 'Style-', literal = '/lac fwd styleprev', kind = 'action', toggle = '' },
    { key = '2', label = 'Style+', literal = '/lac fwd stylenext', kind = 'action', toggle = '' },
    { key = '3', label = 'Styles', literal = '/lac fwd styles', kind = 'action', toggle = '' },
    { key = '4', label = 'Warp', literal = '/lac fwd warp', kind = 'action', toggle = '' },
    { key = '5', label = 'Lockstyle', literal = '/lac fwd lockstyle', kind = 'action', toggle = '' },
    { key = '6', label = 'Status', literal = '/lac fwd status', kind = 'action', toggle = '' },
    { key = '7', label = 'Craft', literal = '/lac fwd utility craft', kind = 'utility', toggle = '' },
    { key = '8', label = 'Move', literal = '/lac fwd utility movement', kind = 'utility', toggle = '' },
    { key = '9', label = 'Auto 1', literal = '/lac fwd palette missing', kind = 'toggle', toggle = '' },
    { key = '0', label = 'Auto 2', literal = '/lac fwd palette missing', kind = 'toggle', toggle = '' },
    { key = '-', label = 'Job 1', literal = '/lac fwd palette missing', kind = 'job', toggle = '' },
    { key = '=', label = 'Job 2', literal = '/lac fwd palette missing', kind = 'job', toggle = '' },
};

local DEFAULT_PLAYSTYLE = 'Damage';
local STYLE_COMMANDS_TEXT = 'damage|accuracy|petdamage|pettank';
local oddLuaRefresh = {
    launcher = 'C:\\Users\\jakeb\\Projects\\FFXI Personal Server\\OddLua\\Run-OddLuaGameRefresh.cmd',
    statusPath = 'C:\\Users\\jakeb\\Projects\\FFXI Personal Server\\OddLua\\reports\\game-refresh\\latest-status.json',
    delaySeconds = 12,
    resourceDelaySeconds = 18,
    pollSeconds = 5,
    maxPolls = 48,
};

local setSecondarySlotLocks = {
    InCity = {
        Body = { 'Legs' },
    },
};

local nativeDualWieldMainJobs = {
    DNC = true,
    NIN = true,
};

local setRequiresDualWieldSub = {
    Playstyle_Damage = true,
    Playstyle_Accuracy = true,
    Playstyle_PetDamage = true,
    Damage = true,
    Accuracy = true,
    PetDamage = true,
    TP = true,
    TPAccuracy = true,
    PetReady = true,
    PetMagic = true,
};

local conditionalEquips = {
    Playstyle_Damage = {
        {
            condition = { type = 'mp_gt', name = '100', threshold = 100 },
            slots = { Ring2 = 'Oneiros Ring' },
        },
    },
    Damage = {
        {
            condition = { type = 'mp_gt', name = '100', threshold = 100 },
            slots = { Ring2 = 'Oneiros Ring' },
        },
    },
    TP = {
        {
            condition = { type = 'mp_gt', name = '100', threshold = 100 },
            slots = { Ring2 = 'Oneiros Ring' },
        },
    },
    Samba = {
        {
            condition = { type = 'mp_gt', name = '100', threshold = 100 },
            slots = { Ring2 = 'Oneiros Ring' },
        },
    },
};

local mechanicsSwapPlanner = {
    ['loaded'] = true,
    ['plannerVersion'] = 2,
    ['baselineSet'] = 'Aftercast',
    ['supportedOpportunities'] = { 'hp_bridge_swap', 'mp_bridge_swap', 'negative_tick_avoidance' },
    ['transitions'] = {},
    ['skippedTransitions'] = {},
};
mechanicsSwapPlanner.transitions['Damage'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Damage',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Sub',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 50,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Accuracy'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Accuracy',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Sub',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 50,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['PetDamage'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'PetDamage',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16676,
            ['item'] = 'Viking Axe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Sub',
            ['itemId'] = 16669,
            ['item'] = 'Cmb.Cst. Axe',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['PetTank'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'PetTank',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 12690,
            ['item'] = 'Seiryu\'s Kote',
            ['reason'] = 'pool delta HP+30, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
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
            ['slot'] = 'Ring1',
            ['itemId'] = 13469,
            ['item'] = 'Leather Ring',
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
            ['itemId'] = 12434,
            ['item'] = 'Genbu\'s Kabuto',
            ['reason'] = 'pool delta MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 28490,
            ['item'] = 'Wilderness Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10972,
            ['item'] = 'Oneiros Cappa',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 210,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 0,
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
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 12580,
            ['item'] = 'Darksteel Harness',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
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
            ['itemId'] = 16263,
            ['item'] = 'Beak Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 175,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ring1',
            ['itemId'] = 15545,
            ['item'] = 'Tamas Ring',
            ['reason'] = 'pool delta MP+30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
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
            ['slot'] = 'Ring2',
            ['itemId'] = 11632,
            ['item'] = 'Karka Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14792,
            ['item'] = 'Relaxing Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 13570,
            ['item'] = 'Ram Mantle',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 129,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 172,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['InCity'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'InCity',
    ['actions'] = {
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 25726,
            ['item'] = 'Kupo Suit',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 0,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 0,
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 12690,
            ['item'] = 'Seiryu\'s Kote',
            ['reason'] = 'pool delta HP+30, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 12580,
            ['item'] = 'Darksteel Harness',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
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
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
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
            ['slot'] = 'Ring1',
            ['itemId'] = 11635,
            ['item'] = 'Alert Ring',
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
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12434,
            ['item'] = 'Genbu\'s Kabuto',
            ['reason'] = 'pool delta MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13104,
            ['item'] = 'Ryl.Sqr. Collar',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 182,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 30,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta HP-10, MP+10',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 9,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 102,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Sub',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 50,
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 12690,
            ['item'] = 'Seiryu\'s Kote',
            ['reason'] = 'pool delta HP+30, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 12580,
            ['item'] = 'Darksteel Harness',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
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
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
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
            ['slot'] = 'Ring1',
            ['itemId'] = 11635,
            ['item'] = 'Alert Ring',
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
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12434,
            ['item'] = 'Genbu\'s Kabuto',
            ['reason'] = 'pool delta MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13104,
            ['item'] = 'Ryl.Sqr. Collar',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 182,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 30,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Sub',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 50,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 30,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 210,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 30,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 210,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 30,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 210,
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Body',
            ['itemId'] = 12580,
            ['item'] = 'Darksteel Harness',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12839,
            ['item'] = 'Darksteel Subligar',
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
            ['itemId'] = 16263,
            ['item'] = 'Beak Necklace',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear1',
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
    },
    ['warnings'] = {},
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 130,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 175,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 10942,
            ['item'] = 'Aife\'s Medal',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 30,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 210,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta HP-10, MP+10',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 9,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 102,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 15991,
            ['item'] = 'Star Earring',
            ['reason'] = 'pool delta HP-10, MP+10',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 11590,
            ['item'] = 'Colossus\'s Torque',
            ['reason'] = 'pool delta MP-20',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 162,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 9,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 102,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16676,
            ['item'] = 'Viking Axe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 71,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 180,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16676,
            ['item'] = 'Viking Axe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 71,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 180,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16676,
            ['item'] = 'Viking Axe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 71,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 180,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16676,
            ['item'] = 'Viking Axe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 71,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 180,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
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
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 170,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
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
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-27',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 106,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 53,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Ear1',
            ['itemId'] = 14812,
            ['item'] = 'Loquac. Earring',
            ['reason'] = 'pool delta HP-10, MP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 115,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 190,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
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
            ['itemId'] = 15827,
            ['item'] = 'Insect Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ammo',
            ['itemId'] = 18136,
            ['item'] = 'Morion Tathlum',
            ['reason'] = 'pool delta MP-27',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 106,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 53,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 13570,
            ['item'] = 'Ram Mantle',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 13570,
            ['item'] = 'Ram Mantle',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 120,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
            ['reason'] = 'pool delta HP+10, MP+10',
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
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Sub',
            ['itemId'] = 27633,
            ['item'] = 'Thorin\'s Shield',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 13417,
            ['item'] = 'Eris\' Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 188,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 80,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Ear2',
            ['itemId'] = 16058,
            ['item'] = 'Colossus\'s Earring',
            ['reason'] = 'pool delta HP+10, MP+10',
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
            ['slot'] = 'Main',
            ['itemId'] = 18852,
            ['item'] = 'Octave Club',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 10761,
            ['item'] = 'Portus Annulet',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15941,
            ['item'] = 'Headlong Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 13417,
            ['item'] = 'Eris\' Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 158,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 80,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['PetReady'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'PetReady',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16676,
            ['item'] = 'Viking Axe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Sub',
            ['itemId'] = 16669,
            ['item'] = 'Cmb.Cst. Axe',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['PetMagic'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'PetMagic',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 16676,
            ['item'] = 'Viking Axe',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12980,
            ['item'] = 'Battle Boots',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Sub',
            ['itemId'] = 16669,
            ['item'] = 'Cmb.Cst. Axe',
            ['reason'] = 'pool delta HP-30',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Head',
            ['itemId'] = 15195,
            ['item'] = 'Faerie Hairpin',
            ['reason'] = 'pool delta HP-70, MP+5',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Main',
            ['itemId'] = 20826,
            ['item'] = 'Hunahpu',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ammo',
            ['itemId'] = 17277,
            ['item'] = 'Hedgehog Bomb',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 15348,
            ['item'] = 'Mountain Gaiters',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Back',
            ['itemId'] = 11547,
            ['item'] = 'Colossus\'s Mantle',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Sub',
            ['itemId'] = 12361,
            ['item'] = 'Sipar',
            ['reason'] = 'pool delta HP-30',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 150,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Waist',
            ['itemId'] = 15890,
            ['item'] = 'Marid Belt',
            ['reason'] = 'pool delta HP+22, MP-25',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15371,
            ['item'] = 'Dst. Codpiece',
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
            ['itemId'] = 11630,
            ['item'] = 'Corneus Ring',
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12434,
            ['item'] = 'Genbu\'s Kabuto',
            ['reason'] = 'pool delta MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13110,
            ['item'] = 'Beast Whistle',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 13328,
            ['item'] = 'Mythril Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10972,
            ['item'] = 'Oneiros Cappa',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 132,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['Samba'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'Samba',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 50,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Head',
            ['itemId'] = 15270,
            ['item'] = 'Walahra Turban',
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
            ['slot'] = 'Hands',
            ['itemId'] = 28050,
            ['item'] = 'Swift Gages',
            ['reason'] = 'pool delta HP-5, MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Legs',
            ['itemId'] = 12831,
            ['item'] = 'Coeurl Trousers',
            ['reason'] = 'pool delta HPP-1',
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
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 14813,
            ['item'] = 'Brutal Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 105,
            ['sourcePercent'] = 0,
            ['targetPercent'] = -1,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 50,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 15224,
            ['item'] = 'Empress Hairpin',
            ['reason'] = 'pool delta HP-65, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 13570,
            ['item'] = 'Ram Mantle',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 16,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 14,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 13570,
            ['item'] = 'Ram Mantle',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 41,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 15224,
            ['item'] = 'Empress Hairpin',
            ['reason'] = 'pool delta HP-65, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 13570,
            ['item'] = 'Ram Mantle',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 23,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 25,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 14640,
            ['item'] = 'Snow Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 12687,
            ['item'] = 'Ryl.Sqr. Mufflers',
            ['reason'] = 'pool delta HP-20, MP-20',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 37,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 25,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15371,
            ['item'] = 'Dst. Codpiece',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 15080,
            ['item'] = 'Monster Helm',
            ['reason'] = 'pool delta HP-31, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13094,
            ['item'] = 'Flower Necklace',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 79,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Feet',
            ['itemId'] = 27492,
            ['item'] = 'Siren\'s Sollerets',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Hands',
            ['itemId'] = 14871,
            ['item'] = 'Trainer\'s Gloves',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 15371,
            ['item'] = 'Dst. Codpiece',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 15080,
            ['item'] = 'Monster Helm',
            ['reason'] = 'pool delta HP-31, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Neck',
            ['itemId'] = 13094,
            ['item'] = 'Flower Necklace',
            ['reason'] = 'pool delta MP-20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Waist',
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 79,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 20,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 13570,
            ['item'] = 'Ram Mantle',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 52,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 22,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Legs',
            ['itemId'] = 15125,
            ['item'] = 'Monster Trousers',
            ['reason'] = 'pool delta HP+17',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 62,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 46,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 37,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 37,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
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
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 25,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 37,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 37,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
            ['sourcePercent'] = 0,
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
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Smash_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Smash_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Smash_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Smash_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Gale_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Gale_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Gale_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Gale_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Avalanche_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Avalanche_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Avalanche_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Avalanche_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Spinning_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Spinning_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Spinning_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Spinning_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Rampage'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Rampage',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Rampage'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Rampage',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Calamity'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Calamity',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13703,
            ['item'] = 'Brigandine',
            ['reason'] = 'pool delta HP+10, MP+10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14765,
            ['item'] = 'Titanis Earring',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12434,
            ['item'] = 'Genbu\'s Kabuto',
            ['reason'] = 'pool delta MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10972,
            ['item'] = 'Oneiros Cappa',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 60,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 22,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Calamity'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Calamity',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ear2',
            ['itemId'] = 14765,
            ['item'] = 'Titanis Earring',
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
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Ring2',
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Head',
            ['itemId'] = 12434,
            ['item'] = 'Genbu\'s Kabuto',
            ['reason'] = 'pool delta MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 10972,
            ['item'] = 'Oneiros Cappa',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 70,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Mistral_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Mistral_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Mistral_Axe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Mistral_Axe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Dark_Harvest'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Dark_Harvest',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 15095,
            ['item'] = 'Monster Jackcoat',
            ['reason'] = 'pool delta HP+21',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 46,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 37,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Dark_Harvest'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Dark_Harvest',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 14808,
            ['item'] = 'Novio Earring',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 37,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Nightmare_Scythe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Nightmare_Scythe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
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
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 57,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Nightmare_Scythe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Nightmare_Scythe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
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
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 57,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Spinning_Scythe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Spinning_Scythe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
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
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 57,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Spinning_Scythe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Spinning_Scythe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
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
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 12924,
            ['item'] = 'Magic Cuisses',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 12946,
            ['item'] = 'Suzaku\'s Sune-Ate',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Waist',
            ['itemId'] = 28425,
            ['item'] = 'Salire Belt',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 57,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WS_Vorpal_Scythe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WS_Vorpal_Scythe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.transitions['WSAcc_Vorpal_Scythe'] = {
    ['sourceSet'] = 'Aftercast',
    ['targetSet'] = 'WSAcc_Vorpal_Scythe',
    ['actions'] = {
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 28272,
            ['item'] = 'Adsilio Boots +1',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 16155,
            ['item'] = 'Aurum Armet',
            ['reason'] = 'pool delta HP-50, MP-50',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Hands',
            ['itemId'] = 15052,
            ['item'] = 'Guerilla Gloves',
            ['reason'] = 'pool delta HP-16, MP-16',
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
            ['itemId'] = 15875,
            ['item'] = 'Monster Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 24,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 4,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
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
            ['phase'] = 'equip_pool_gain',
            ['slot'] = 'Body',
            ['itemId'] = 13734,
            ['item'] = 'Scp. Harness +1',
            ['reason'] = 'pool delta HP+20',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_mixed',
            ['slot'] = 'Hands',
            ['itemId'] = 13706,
            ['item'] = 'Ogre Gloves',
            ['reason'] = 'pool delta HP-20, HPP+10, MP-8',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Legs',
            ['itemId'] = 14260,
            ['item'] = 'Republic Subligar',
            ['reason'] = 'ordinary target equip',
        },
        {
            ['key'] = 'equip_target',
            ['phase'] = 'equip_target',
            ['slot'] = 'Feet',
            ['itemId'] = 14162,
            ['item'] = 'Agrona\'s Leggings',
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
            ['itemId'] = 10870,
            ['item'] = 'Venture Ring',
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
            ['slot'] = 'Head',
            ['itemId'] = 27779,
            ['item'] = 'Conqueror\'s Helm',
            ['reason'] = 'pool delta HP-25, MP-50',
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
            ['itemId'] = 15294,
            ['item'] = 'Warwolf Belt',
            ['reason'] = 'pool delta MP-25',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Ear1',
            ['itemId'] = 16057,
            ['item'] = 'Aesir Ear Pendant',
            ['reason'] = 'pool delta HP-10, MP-10',
        },
        {
            ['key'] = 'pool_bridge_transition',
            ['phase'] = 'equip_pool_loss',
            ['slot'] = 'Back',
            ['itemId'] = 11532,
            ['item'] = 'Accura Cape',
            ['reason'] = 'pool delta HP-20, MP-20',
        },
    },
    ['warnings'] = { 'final_hp_pool_lower', 'hp_percent_or_conversion_requires_runtime_probe', 'final_mp_pool_lower' },
    ['poolSummaries'] = {
        ['HP'] = {
            ['sourceFlat'] = 130,
            ['targetFlat'] = 45,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 10,
        },
        ['MP'] = {
            ['sourceFlat'] = 175,
            ['targetFlat'] = 12,
            ['sourcePercent'] = 0,
            ['targetPercent'] = 0,
        },
    },
};
mechanicsSwapPlanner.skippedTransitions['Movement'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Movement_City'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Movement_Night'] = 'utility_set';
mechanicsSwapPlanner.skippedTransitions['Movement_DuskToDawn'] = 'utility_set';
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
    ['self-destruct'] = 'MagicalBlueMagic',
    ['sheep song'] = 'Enfeebling',
    ['sickle slash'] = 'PhysicalBlueMagic',
    ['smite of rage'] = 'PhysicalBlueMagic',
    ['soporific'] = 'Enfeebling',
    ['sound blast'] = 'Enfeebling',
    ['spinal cleave'] = 'PhysicalBlueMagic',
    ['spiral spin'] = 'PhysicalBlueMagic',
    ['sprout smack'] = 'PhysicalBlueMagic',
    ['stinking gas'] = 'Enfeebling',
    ['sub-zero smash'] = 'PhysicalBlueMagic',
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
    ['warm-up'] = 'Enhancing',
    ['whirl of rage'] = 'PhysicalBlueMagic',
    ['white wind'] = 'Cure',
    ['wild carrot'] = 'Cure',
    ['wild oats'] = 'PhysicalBlueMagic',
    ['wind breath'] = 'MagicalBlueMagic',
    ['yawn'] = 'Enfeebling',
    ['zephyr mantle'] = 'Enhancing',
};

local weaponSkillRoutes = {
    ['avalanche_axe'] = 'WS_Avalanche_Axe',
    ['brainshaker'] = 'WS_Brainshaker',
    ['burning_blade'] = 'WS_Burning_Blade',
    ['calamity'] = 'WS_Calamity',
    ['circle_blade'] = 'WS_Circle_Blade',
    ['dark_harvest'] = 'WS_Dark_Harvest',
    ['energy_steal'] = 'WS_Energy_Steal',
    ['fast_blade'] = 'WS_Fast_Blade',
    ['flat_blade'] = 'WS_Flat_Blade',
    ['gale_axe'] = 'WS_Gale_Axe',
    ['gust_slash'] = 'WS_Gust_Slash',
    ['mistral_axe'] = 'WS_Mistral_Axe',
    ['nightmare_scythe'] = 'WS_Nightmare_Scythe',
    ['rampage'] = 'WS_Rampage',
    ['shadowstitch'] = 'WS_Shadowstitch',
    ['shining_blade'] = 'WS_Shining_Blade',
    ['skullbreaker'] = 'WS_Skullbreaker',
    ['smash_axe'] = 'WS_Smash_Axe',
    ['spinning_axe'] = 'WS_Spinning_Axe',
    ['spinning_scythe'] = 'WS_Spinning_Scythe',
    ['spirits_within'] = 'WS_Spirits_Within',
    ['starlight'] = 'WS_Starlight',
    ['true_strike'] = 'WS_True_Strike',
    ['vorpal_scythe'] = 'WS_Vorpal_Scythe',
    ['wasp_sting'] = 'WS_Wasp_Sting',
};

local weaponSkillAccuracyRoutes = {
    ['avalanche_axe'] = 'WSAcc_Avalanche_Axe',
    ['brainshaker'] = 'WSAcc_Brainshaker',
    ['burning_blade'] = 'WSAcc_Burning_Blade',
    ['calamity'] = 'WSAcc_Calamity',
    ['circle_blade'] = 'WSAcc_Circle_Blade',
    ['dark_harvest'] = 'WSAcc_Dark_Harvest',
    ['energy_steal'] = 'WSAcc_Energy_Steal',
    ['fast_blade'] = 'WSAcc_Fast_Blade',
    ['flat_blade'] = 'WSAcc_Flat_Blade',
    ['gale_axe'] = 'WSAcc_Gale_Axe',
    ['gust_slash'] = 'WSAcc_Gust_Slash',
    ['mistral_axe'] = 'WSAcc_Mistral_Axe',
    ['nightmare_scythe'] = 'WSAcc_Nightmare_Scythe',
    ['rampage'] = 'WSAcc_Rampage',
    ['shadowstitch'] = 'WSAcc_Shadowstitch',
    ['shining_blade'] = 'WSAcc_Shining_Blade',
    ['skullbreaker'] = 'WSAcc_Skullbreaker',
    ['smash_axe'] = 'WSAcc_Smash_Axe',
    ['spinning_axe'] = 'WSAcc_Spinning_Axe',
    ['spinning_scythe'] = 'WSAcc_Spinning_Scythe',
    ['spirits_within'] = 'WSAcc_Spirits_Within',
    ['starlight'] = 'WSAcc_Starlight',
    ['true_strike'] = 'WSAcc_True_Strike',
    ['vorpal_scythe'] = 'WSAcc_Vorpal_Scythe',
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

local mountedStatusBuffs = {
    chocobo = true,
    mount = true,
    mounted = true,
};

local mountedStatusIds = { 252 };

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
    text = '[Oddone BST] ' .. tostring(text or '');
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
    message('Quick start: /lac fwd help | styles | status | lockstyle | warp | subjob | mechanics help | reconcile status | refreshgear.');
    message('Current style=' .. tostring(state.Playstyle) .. '; default=' .. tostring(DEFAULT_PLAYSTYLE) .. '.');
    printStyleList();
    message('Lockstyle: /lac fwd lockstyle equips the TP set first, then /lockstyle on.');
    message('Reconciliation: /lac fwd reconcile on|off|status|last.');
    message('Gear refresh: /lac fwd refreshgear queues /gearexport full, rebuilds OddLua, applies profiles, then reloads on success.');
    message('One-button macros: review/load keybindings.txt; F-keys run /lac fwd commands.');
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
        message('OddLua gear refresh failed: ' .. tostring(detail or '') .. '; status=' .. oddLuaRefresh.statusPath);
        return;
    end

    state.OddLuaRefreshLastStatus = status or 'running';
    if attempt >= oddLuaRefresh.maxPolls then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh still running or status unavailable after polling; check ' .. oddLuaRefresh.statusPath);
        return;
    end

    if not scheduleTask(oddLuaRefresh.pollSeconds, function()
        pollOddLuaRefreshStatus(attempt + 1);
    end) then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh poll scheduling failed; check ' .. oddLuaRefresh.statusPath);
    end
end

local function launchOddLuaGearRefresh()
    if not ashita or not ashita.misc or not ashita.misc.execute then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed: ashita.misc.execute unavailable. Run the refresh script manually.');
        return false;
    end

    local ok, err = pcall(function()
        ashita.misc.execute(oddLuaRefresh.launcher, '');
    end);
    if not ok then
        state.OddLuaRefreshPending = false;
        message('OddLua gear refresh failed to launch: ' .. tostring(err));
        return false;
    end

    message('OddLua refresh launched. Polling status; log root is reports/game-refresh.');
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
        message('OddLua gear refresh failed: scheduler unavailable after gearexport. Run ' .. oddLuaRefresh.launcher .. ' manually.');
    end
end


local reconciliationConfig = {
    schema = 'oddlua.reconcile.v1',
    player = 'Oddone',
    playerId = '29938',
    job = 'BST',
    logPath = 'logs/oddlua-reconcile-Oddone_29938-BST.jsonl',
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

local function reconciliationObservedName(entry)
    if type(entry) == 'string' then
        return entry;
    elseif type(entry) == 'table' then
        if entry.Name ~= nil then
            return entry.Name;
        end
        if type(entry.Resource) == 'table' and type(entry.Resource.Name) == 'table' then
            return entry.Resource.Name[1];
        end
        if type(entry.Item) == 'table' and entry.Item.Name ~= nil then
            return entry.Item.Name;
        end
    end
    return nil;
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

    local observed = {};
    for _, slot in ipairs(reconciliationConfig.slotOrder) do
        local name = reconciliationObservedName(equipment[slot]);
        if name ~= nil and tostring(name) ~= '' then
            observed[slot] = tostring(name);
        end
    end
    return observed, nil;
end

local function reconciliationNamesMatch(expected, observed)
    local expectedText = normalize(expected);
    local observedText = normalize(observed);
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
    parts[#parts + 1] = '"sequence":' .. tostring(snapshot.sequence or 0);
    parts[#parts + 1] = '"timestamp":' .. tostring(snapshot.timestamp or 0);
    parts[#parts + 1] = '"set":' .. reconciliationJsonEscape(snapshot.set);
    parts[#parts + 1] = '"status":' .. reconciliationJsonEscape(snapshot.status);
    parts[#parts + 1] = '"force":' .. reconciliationJsonBool(snapshot.force == true);
    parts[#parts + 1] = '"repair":' .. reconciliationJsonBool(snapshot.repair == true);
    parts[#parts + 1] = '"repairQueued":' .. reconciliationJsonBool(snapshot.repairQueued == true);
    parts[#parts + 1] = '"playstyle":' .. reconciliationJsonEscape(snapshot.playstyle);
    parts[#parts + 1] = '"intent":' .. reconciliationJsonEscape(snapshot.intent);
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

local function reconciliationDelayForSet(setName)
    local intent = normalize(setIntents[setName] or '');
    if intent == 'idle' or intent == 'movement' or intent == 'tp' then
        return 0.35;
    end
    return 0.08;
end

local function reconciliationCanRepairIntent(intent)
    local intentText = normalize(intent or '');
    return intentText == 'tp' or intentText == 'idle' or intentText == 'movement';
end

local repairReconciliationMismatch;

local function cancelPendingReconciliationSnapshot()
    state.ReconcilePendingSnapshot = nil;
    state.ReconcileScanScheduled = false;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
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

    local observed, reason = observeReconciliationEquipment();
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

    snapshot.sequence = pending.sequence;
    snapshot.timestamp = nowSeconds();
    snapshot.force = pending.force == true;
    snapshot.repair = pending.repair == true;
    snapshot.repairQueued = false;
    snapshot.playstyle = pending.playstyle;
    snapshot.intent = pending.intent;
    if snapshot.status == 'mismatch' and repairReconciliationMismatch then
        snapshot.repairQueued = repairReconciliationMismatch(pending);
    end
    state.ReconcileLast = snapshot;
    state.ReconcileLastRecordedSignature = pending.signature;
    writeReconciliationSnapshot(snapshot);

    if snapshot.status == 'mismatch' and snapshot.repairQueued ~= true then
        local repairText = '';
        if snapshot.repair == true then
            repairText = '; repair=failed';
        end
        message('Reconcile mismatch set=' .. tostring(pending.set) .. '; slots=' .. reconciliationMismatchSlots(snapshot.mismatches) .. repairText .. '; log=' .. reconciliationConfig.logPath);
    end
end

local function scheduleReconciliationSnapshot(setName, expectedSet, force, repair)
    if state.ReconcileEnabled ~= true then
        return;
    end

    local expected = reconciliationExpectedMap(expectedSet);
    local signature = reconciliationExpectedSignature(setName, expected);
    if repair ~= true and signature == state.ReconcileLastRecordedSignature then
        if state.ReconcilePendingSnapshot and state.ReconcilePendingSnapshot.repair == true and state.ReconcilePendingSnapshot.signature == signature then
            return;
        end
        cancelPendingReconciliationSnapshot();
        return;
    end

    state.ReconcileSnapshotSeq = (state.ReconcileSnapshotSeq or 0) + 1;
    state.ReconcilePendingSnapshot = {
        sequence = state.ReconcileSnapshotSeq,
        set = setName,
        expected = expected,
        force = force == true,
        repair = repair == true,
        playstyle = state.Playstyle,
        intent = setIntents[setName] or '',
        signature = signature,
    };

    if state.ReconcileScanScheduled == true then
        return;
    end

    state.ReconcileScanScheduled = true;
    state.ReconcileScanToken = (state.ReconcileScanToken or 0) + 1;
    local token = state.ReconcileScanToken;
    if not scheduleTask(reconciliationDelayForSet(setName), function()
        recordPendingReconciliationSnapshot(token);
    end) then
        recordPendingReconciliationSnapshot(token);
    end
end

repairReconciliationMismatch = function(pending)
    if type(pending) ~= 'table' then
        return false;
    end
    if pending.repair == true or not reconciliationCanRepairIntent(pending.intent) then
        return false;
    end
    if type(pending.expected) ~= 'table' or next(pending.expected) == nil then
        return false;
    end

    local repaired = false;
    if scale and scale.ForceEquipSet then
        local ok = pcall(function()
            scale.ForceEquipSet(pending.set, pending.expected, pending.intent);
        end);
        repaired = ok == true;
    elseif gFunc and gFunc.ForceEquipSet then
        local ok = pcall(function()
            gFunc.ForceEquipSet(pending.expected);
        end);
        repaired = ok == true;
    elseif gFunc and gFunc.EquipSet then
        local ok = pcall(function()
            gFunc.EquipSet(pending.expected);
        end);
        repaired = ok == true;
    end

    if repaired == true then
        scheduleReconciliationSnapshot(pending.set, pending.expected, true, true);
    end
    return repaired;
end

local function handleReconcileCommand(args)
    local command = normalize(args and args[2]);
    if command == 'on' then
        state.ReconcileEnabled = true;
        message('Reconciliation snapshots enabled; log=' .. reconciliationConfig.logPath);
    elseif command == 'off' then
        state.ReconcileEnabled = false;
        message('Reconciliation snapshots disabled.');
    elseif command == 'status' or command == '' then
        local lastStatus = 'none';
        if state.ReconcileLast and state.ReconcileLast.status then
            lastStatus = tostring(state.ReconcileLast.status);
        end
        message('Reconcile enabled=' .. tostring(state.ReconcileEnabled == true) .. '; last=' .. lastStatus .. '; log=' .. reconciliationConfig.logPath .. '; use reconcile on|off|status|last.');
    elseif command == 'last' then
        if not state.ReconcileLast then
            message('Reconcile last: none yet; log=' .. reconciliationConfig.logPath);
            return;
        end
        message('Reconcile last set=' .. tostring(state.ReconcileLast.set) .. '; status=' .. tostring(state.ReconcileLast.status) .. '; mismatches=' .. reconciliationMismatchSlots(state.ReconcileLast.mismatches) .. '; log=' .. reconciliationConfig.logPath);
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
    if gData and gData.GetPlayer then
        return gData.GetPlayer();
    end
    return nil;
end

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
    message('Mechanics execution is disabled for this profile slice; use probes to validate timing before promotion.');
end

local function handleMechanicsCommand(args)
    local subcommand = normalize(args and args[2]);
    if subcommand == '' or subcommand == 'status' then
        mechanicsStatus();
        return;
    elseif subcommand == 'help' then
        message('mechanics status | mechanics list | mechanics warnings | mechanics skipped | mechanics probes on|off | mechanics plan <set> | mechanics probe <set>');
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
    end
    message('Unknown mechanics command. Use mechanics help.');
end

local function getAction()
    if gData and gData.GetAction then
        return gData.GetAction();
    end
    return nil;
end

local function getEnvironment()
    if gData and gData.GetEnvironment then
        local ok, environment = pcall(gData.GetEnvironment);
        if ok then
            if environment and AshitaCore and AshitaCore.GetMemoryManager then
                local okZone, zoneId = pcall(function()
                    return AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
                end);
                if okZone then
                    environment.ZoneId = zoneId;
                end
            end
            return environment;
        end
    end
    return nil;
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
    if not gData or not gData.GetBuffCount then
        return 0;
    end

    local ok, count = pcall(gData.GetBuffCount, name);
    if ok and type(count) == 'number' then
        return count;
    end
    return 0;
end

local function hasBuff(name)
    if name == nil or tostring(name) == '' then
        return false;
    end
    return getBuffCount(name) > 0;
end

local function hasDangerousStatus()
    for name in pairs(dangerousStatusBuffs) do
        if hasBuff(name) then
            return true;
        end
    end
    for _, id in ipairs(dangerousStatusIds) do
        if hasBuff(id) then
            return true;
        end
    end
    return false;
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
    return nativeDualWieldMainJobs['BST'] == true;
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

    for name, _ in pairs(mountedStatusBuffs) do
        if hasBuff(name) then
            return true;
        end
    end
    for _, id in ipairs(mountedStatusIds) do
        if hasBuff(id) then
            return true;
        end
    end
    return false;
end

local function isOnFoot(player)
    return not isMounted(player);
end

local function canEquipMovement(player, environment)
    if isCity(environment) then
        return true;
    end
    return not isEngaged(player) and isOnFoot(player);
end

local function shouldEquipInCityMovement(player, environment)
    return isCity(environment);
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

local function playerTp(player)
    if not player then
        return 0;
    end
    return tonumber(player.TP or player.tp or player.TacticalPoints or player.tacticalPoints or 0) or 0;
end

local function isEmergencyHp(player)
    local hpp = playerHpp(player);
    return hpp ~= nil and hpp <= 35;
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
    local candidates = { 'PDT', 'Playstyle_Safe', 'Safe', 'Survival', 'Tank', 'Evasion', 'Hybrid', 'MDT' };
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
        return defensiveSet;
    end
    local tp = playerTp(player);
    if tp < OVERT_DEFENSE_TP_UNLOCK then
        return defensiveSet;
    end
    return nil;
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

local function applyConditionalEquipsForSet(setName, force)
    if not conditionals or not conditionals.ApplyForSet then
        return false;
    end

    return conditionals.ApplyForSet(conditionalEquips, setName, {
        force = force,
        gFunc = gFunc,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        state = state,
    });
end

local reconciliationProtectedWeaponSlots = {
    Main = true,
    Sub = true,
    Range = true,
};

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

local function reconciliationEquipContext(force)
    return {
        force = force,
        gFunc = gFunc,
        getEnvironment = getEnvironment,
        getPlayer = getPlayer,
        hasBuff = hasBuff,
        state = state,
    };
end

local function conditionalOverlayForSet(setName, force)
    if not conditionals or not conditionals.BuildOverlay then
        return {};
    end

    local ok, overlay = pcall(function()
        return conditionals.BuildOverlay(conditionalEquips[setName], reconciliationEquipContext(force));
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
    return expectedSet;
end

local function isStableEquipIntent(setName)
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

local function equipNamedSet(setName, force)
    local set = sets[setName];
    if not set then
        return false;
    end

    releaseSecondarySlotLocksNotInSet(setName);
    local setToEquip = setWithSubjobLegalOffhand(setName, set);
    local effectiveForce = stableEquipForceForSet(setName, setToEquip, force);

    if state.WarpRingLocked == true then
        local lockedSet = applyWarpRingLock(setToEquip);
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(lockedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(lockedSet);
        end
        applyConditionalEquipsForSet(setName, effectiveForce);
        applySecondarySlotLocksForSet(setName);
        local equippedSet = resolvedReconciliationExpectedSet(setName, lockedSet, lockedSet, effectiveForce);
        scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
        markStableEquipForceNeeded(setName, effectiveForce);
        return true;
    end

    local appliedSet = setToEquip;
    if isClearSet(setToEquip) then
        if effectiveForce == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(setToEquip);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(setToEquip);
        end
    elseif effectiveForce == true and scale and scale.ForceEquipSet then
        appliedSet = scale.ForceEquipSet(setName, setToEquip, setIntents[setName]);
    elseif effectiveForce == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(setToEquip);
    elseif scale and scale.EquipSet then
        appliedSet = scale.EquipSet(setName, setToEquip, setIntents[setName]);
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(setToEquip);
    end
    applyConditionalEquipsForSet(setName, effectiveForce);
    applySecondarySlotLocksForSet(setName);
    local equippedSet = resolvedReconciliationExpectedSet(setName, setToEquip, appliedSet, effectiveForce);
    scheduleReconciliationSnapshot(setName, equippedSet, effectiveForce);
    markStableEquipForceNeeded(setName, effectiveForce);
    return true;
end

local function equipNamedSetIfNotClear(setName, force)
    local set = sets[setName];
    if not set or isClearSet(set) then
        return false;
    end
    return equipNamedSet(setName, force);
end

local function equipOvertDefensiveSet(setName)
    if not setName then
        return false;
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
        scale.SetWeaponLockEnabled(false);
    end
    local ok, equipped = pcall(equipNamedSet, setName, true);
    if scale and scale.SetWeaponLockEnabled then
        scale.SetWeaponLockEnabled(previousWeaponLockEnabled);
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
        gFunc.ForceEquipSet(setToEquip);
        return true;
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(setToEquip);
        return true;
    end
    return false;
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
    for _, setName in ipairs(setNames or {}) do
        if setName and equipNamedSetIfNotClear(setName, force) then
            return true;
        end
    end
    return false;
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
        return 'Damage';
    end
    return state.Playstyle;
end

local function equipCombatStyle(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        if equipNamedSet(setNameFor('Damage'), force) then
            return true;
        end
        return equipNamedSet('TP', force);
    end

    local activeSet = setNameFor(activeCombatStyle());
    if equipNamedSet(activeSet, force) then
        return true;
    end
    if equipNamedSet('TP', force) then
        return true;
    end
    return equipNamedSet('Playstyle_Damage', force);
end

local function lockstyleCombatSet()
    if not equipNamedSet('TP', true) then
        if not equipNamedSet(setNameFor('Damage'), true) then
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
    if isClearSet(sets['Aftercast']) then
        return setNames;
    end

    addSecondarySlotLockSetNameIfNotClear(setNames, 'Aftercast');
    if #setNames == 0 then
        if isClearSet(sets['Idle']) then
            return setNames;
        end
        addSecondarySlotLockSetNameIfNotClear(setNames, 'Idle');
    end
    addMovementSecondarySlotLockSetNames(setNames, player, environment);
    return setNames;
end

local function equipBaseIdleState(player, force)
    if isClearSet(sets['Aftercast']) then
        equipNamedSet('Aftercast', force);
        return true;
    end

    local equipped = equipNamedSetIfNotClear('Aftercast', force);
    if not equipped then
        if isClearSet(sets['Idle']) then
            equipNamedSet('Idle', force);
            return true;
        end
        equipped = equipNamedSetIfNotClear('Idle', force);
    end

    equipMovement(player, getEnvironment(), force);
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
    if hasDangerousStatus() then
        equipNamedSet('PDT', force);
    elseif player and isEngaged(player) then
        local defensiveSet = shouldEquipOvertDefense(player);
        if defensiveSet then
            local equippedDefensive = equipOvertDefensiveSet(defensiveSet);
            if equippedDefensive then
                return;
            end
        end
        if isEmergencyHp(player) then
            equipNamedSet('PDT', force);
        else
            equipCombatStyle(force);
        end
    elseif state.Playstyle == 'Craft' then
        if not equipNamedSet('Crafting', force) then
            equipNamedSet('Idle', force);
        end
    elseif player and isResting(player) then
        equipNamedSet('Resting', force);
    else
        equipIdleState(player, force);
    end
end

local oddLuaNumberRow = {
    renderEvent = 'oddlua_number_row_Oddone_29938_BST',
    imgui = nil,
    overlayRegistered = false,
    utilityFallbacks = {
        craft = { 'Craft', 'Fishing', 'Gathering', 'Clamming', 'Movement', 'Resting', 'Treasure', 'Survival' },
        movement = { 'Movement', 'Movement_City', 'Movement_Night', 'Movement_DuskToDawn', 'InCity', 'Survival' },
    },
};

if type(require) == 'function' then
    local ok, loaded = pcall(require, 'imgui');
    if ok and loaded then
        oddLuaNumberRow.imgui = loaded;
    end
end

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
    queueTypedCommand('/bind 1 /lac fwd styleprev', -1);
    queueTypedCommand('/bind 2 /lac fwd stylenext', -1);
    queueTypedCommand('/bind 3 /lac fwd styles', -1);
    queueTypedCommand('/bind 4 /lac fwd warp', -1);
    queueTypedCommand('/bind 5 /lac fwd lockstyle', -1);
    queueTypedCommand('/bind 6 /lac fwd status', -1);
    queueTypedCommand('/bind 7 /lac fwd utility craft', -1);
    queueTypedCommand('/bind 8 /lac fwd utility movement', -1);
    queueTypedCommand('/bind 9 /lac fwd palette missing', -1);
    queueTypedCommand('/bind 0 /lac fwd palette missing', -1);
    queueTypedCommand('/bind - /lac fwd palette missing', -1);
    queueTypedCommand('/bind = /lac fwd palette missing', -1);
end

function oddLuaNumberRow.unbindPalette()
    queueTypedCommand('/unbind 1', -1);
    queueTypedCommand('/unbind 2', -1);
    queueTypedCommand('/unbind 3', -1);
    queueTypedCommand('/unbind 4', -1);
    queueTypedCommand('/unbind 5', -1);
    queueTypedCommand('/unbind 6', -1);
    queueTypedCommand('/unbind 7', -1);
    queueTypedCommand('/unbind 8', -1);
    queueTypedCommand('/unbind 9', -1);
    queueTypedCommand('/unbind 0', -1);
    queueTypedCommand('/unbind -', -1);
    queueTypedCommand('/unbind =', -1);
end

function oddLuaNumberRow.setPaletteEnabled(value)
    local enabled = oddLuaNumberRow.setBooleanValue(state.NumberRowPaletteEnabled, value);
    state.NumberRowPaletteEnabled = enabled;
    if enabled then
        oddLuaNumberRow.bindPalette();
        message('OddLua number row palette: on');
    else
        oddLuaNumberRow.unbindPalette();
        message('OddLua number row palette: off');
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

function oddLuaNumberRow.toggleIsOn(binding)
    if not binding or binding.toggle == nil or binding.toggle == '' then
        return false;
    end
    return state[binding.toggle] == true;
end

function oddLuaNumberRow.renderOverlay()
    if state.NumberRowPaletteEnabled ~= true or oddLuaNumberRow.imgui == nil then
        return;
    end
    local imgui = oddLuaNumberRow.imgui;
    local flags = 0;
    if bit and bit.bor then
        flags = bit.bor(
            ImGuiWindowFlags_NoDecoration or 0,
            ImGuiWindowFlags_AlwaysAutoResize or 0,
            ImGuiWindowFlags_NoMove or 0,
            ImGuiWindowFlags_NoSavedSettings or 0,
            ImGuiWindowFlags_NoFocusOnAppearing or 0,
            ImGuiWindowFlags_NoNav or 0
        );
    end
    local onColor = { 0.78, 1.0, 0.72, 1.0 };
    local offColor = { 0.35, 0.40, 0.36, 1.0 };
    local neutralColor = { 0.90, 0.94, 0.90, 1.0 };
    local title = 'OddLua Oddone_29938 BST';
    if imgui.SetNextWindowPos then
        imgui.SetNextWindowPos({ 16, 8 }, ImGuiCond_Always or 0);
    end
    if imgui.SetNextWindowBgAlpha then
        imgui.SetNextWindowBgAlpha(0.42);
    end
    if imgui.Begin and imgui.Begin(title .. '##numberrow', true, flags) then
        imgui.TextColored(neutralColor, title);
        for index, binding in ipairs(numberRowBindings) do
            if index > 1 and imgui.SameLine then
                imgui.SameLine();
            end
            if binding.kind == 'toggle' and binding.toggle ~= '' then
                if oddLuaNumberRow.toggleIsOn(binding) then
                    imgui.TextColored(onColor, binding.key .. ' ' .. binding.label);
                else
                    imgui.TextColored(offColor, binding.key .. ' ' .. binding.label);
                end
            else
                imgui.TextColored(neutralColor, binding.key .. ' ' .. binding.label);
            end
        end
    end
    if imgui.End then
        imgui.End();
    end
end

function oddLuaNumberRow.registerOverlay()
    if oddLuaNumberRow.overlayRegistered == true or oddLuaNumberRow.imgui == nil or not ashita or not ashita.events then
        return;
    end
    ashita.events.register('d3d_present', oddLuaNumberRow.renderEvent, oddLuaNumberRow.renderOverlay);
    oddLuaNumberRow.overlayRegistered = true;
end

function oddLuaNumberRow.unregisterOverlay()
    if oddLuaNumberRow.overlayRegistered ~= true or not ashita or not ashita.events then
        return;
    end
    ashita.events.unregister('d3d_present', oddLuaNumberRow.renderEvent);
    oddLuaNumberRow.overlayRegistered = false;
end

local function equipBlueMagic(name)
    local route = blueMagicRoutes[normalize(name)];
    if route and equipNamedSet(route, false) then
        return;
    end
    equipFirstAvailable({ 'BlueMagic', 'PhysicalBlueMagic', 'MagicalBlueMagic', 'Midcast' }, false);
end

local function equipElementalMagic(action)
    action = action or {};
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
end

local function equipEnhancingMagic(name)
    local value = normalize(name);
    if string.find(value, 'stoneskin', 1, true) then
        equipFirstAvailable({ 'Stoneskin', 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
    elseif string.find(value, 'refresh', 1, true) then
        equipFirstAvailable({ 'Refresh', 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
    elseif string.find(value, 'regen', 1, true) then
        equipFirstAvailable({ 'Regen', 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
    elseif string.find(value, 'sneak', 1, true) or string.find(value, 'invisible', 1, true) or string.find(value, 'deodorize', 1, true) then
        equipFirstAvailable({ 'SneakInvisible', 'Enhancing', 'Midcast' }, false);
    elseif string.find(value, 'bar', 1, true) == 1 then
        equipFirstAvailable({ 'Barspell', 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
    elseif string.find(value, 'phalanx', 1, true) then
        equipFirstAvailable({ 'Phalanx', 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
    elseif string.find(value, 'aquaveil', 1, true) then
        equipFirstAvailable({ 'Aquaveil', 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
    elseif string.find(value, 'haste', 1, true) then
        equipFirstAvailable({ 'Haste', 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'EnhancingDuration', 'Enhancing', 'Midcast' }, false);
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
    elseif string.find(value, 'blind', 1, true) then
        equipFirstAvailable({ 'Blind', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'dispel', 1, true) or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({ 'Dispel', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'dia', 1, true) then
        equipFirstAvailable({ 'Dia', 'Enfeebling', 'Midcast' }, false);
    elseif string.find(value, 'bio', 1, true) then
        equipFirstAvailable({ 'Bio', 'DarkMagic', 'Enfeebling', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'Enfeebling', 'Midcast' }, false);
    end
end

local function equipDarkMagic(name)
    local value = normalize(name);
    if string.find(value, 'drain', 1, true) or string.find(value, 'aspir', 1, true) then
        equipFirstAvailable({ 'DrainAspir', 'DarkMagic', 'Midcast' }, false);
    elseif string.find(value, 'absorb', 1, true) then
        equipFirstAvailable({ 'Absorb', 'DarkMagic', 'Midcast' }, false);
    elseif string.find(value, 'stun', 1, true) then
        equipFirstAvailable({ 'Stun', 'DarkMagic', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'DarkMagic', 'Midcast' }, false);
    end
end

local function equipSong(name)
    local value = normalize(name);
    if string.find(value, 'elegy', 1, true) or string.find(value, 'requiem', 1, true)
        or string.find(value, 'threnody', 1, true) or string.find(value, 'lullaby', 1, true)
        or string.find(value, 'finale', 1, true) then
        equipFirstAvailable({ 'SongDebuff', 'Song', 'Midcast' }, false);
    else
        equipFirstAvailable({ 'SongBuff', 'Song', 'Midcast' }, false);
    end
end

local function equipNinjutsu(name)
    local value = normalize(name);
    if string.find(value, 'utsusemi', 1, true) then
        equipFirstAvailable({ 'Utsusemi', 'Precast', 'FastCast' }, false);
    elseif string.find(value, 'kurayami', 1, true) or string.find(value, 'hojo', 1, true)
        or string.find(value, 'jubaku', 1, true) or string.find(value, 'dokumori', 1, true) then
        equipFirstAvailable({ 'NinjutsuEnfeeble', 'Ninjutsu', 'Midcast' }, false);
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

local function equipAbility()
    local action = getAction();
    local name = normalize(action and action.Name);
    local actionType = normalize(action and action.Type);
    if actionType == 'quick draw' then
        equipFirstAvailable({ 'QuickDraw', 'MagicAccuracy', 'Midcast' }, false);
    elseif actionType == 'corsair roll' then
        equipFirstAvailable({ 'Roll', 'JobAbility' }, false);
    elseif actionType == 'blood pact: rage' then
        equipFirstAvailable({ 'BloodPactRage', 'PetReady', 'JobAbility' }, false);
    elseif actionType == 'blood pact: ward' then
        equipFirstAvailable({ 'BloodPactWard', 'PetTank', 'JobAbility' }, false);
    elseif string.find(name, 'third eye', 1, true) then
        equipFirstAvailable({ 'ThirdEye', 'JobAbility' }, false);
    elseif string.find(name, 'meditate', 1, true) then
        equipFirstAvailable({ 'Meditate', 'JobAbility' }, false);
    elseif string.find(name, 'provoke', 1, true) or string.find(name, 'sentinel', 1, true)
        or string.find(name, 'warcry', 1, true) or string.find(name, 'cover', 1, true)
        or string.find(name, 'palisade', 1, true) or string.find(name, 'flash', 1, true) then
        equipFirstAvailable({ 'Enmity', 'JobAbility' }, false);
    elseif string.find(name, 'waltz', 1, true) then
        equipFirstAvailable({ 'Waltz', 'Cure', 'JobAbility' }, false);
    elseif string.find(name, 'step', 1, true) then
        equipFirstAvailable({ 'Steps', 'Accuracy', 'JobAbility' }, false);
    elseif string.find(name, 'samba', 1, true) then
        equipFirstAvailable({ 'Samba', 'TP', 'JobAbility' }, false);
    elseif string.find(name, 'jump', 1, true) then
        equipFirstAvailable({ 'Jump', 'Weaponskill', 'JobAbility' }, false);
    elseif string.find(name, 'ready', 1, true) or string.find(name, 'sic', 1, true) then
        equipFirstAvailable({ 'PetReady', 'PetDamage', 'JobAbility' }, false);
    else
        equipNamedSet('JobAbility', false);
    end
end

local function equipWeaponskill()
    local action = getAction();
    local name = action and action.Name;
    local key = weaponSkillRouteKey(name);
    local exactRoute = weaponSkillRoutes[key];
    local accuracyRoute = weaponSkillAccuracyRoutes[key];
    if state.Playstyle == 'Accuracy' then
        if accuracyRoute and equipNamedSet(accuracyRoute, false) then
            return;
        end
    end
    if exactRoute and equipNamedSet(exactRoute, false) then
        return;
    end
    local normalizedName = normalize(name);
    if state.Playstyle == 'Accuracy' then
        equipFirstAvailable({ 'WeaponSkillAccuracy', 'Weaponskill' }, false);
    elseif string.find(normalizedName, 'aeolian', 1, true) or string.find(normalizedName, 'cyclone', 1, true)
        or string.find(normalizedName, 'energy', 1, true) or string.find(normalizedName, 'red lotus', 1, true)
        or string.find(normalizedName, 'seraph', 1, true) or string.find(normalizedName, 'sanguine', 1, true)
        or string.find(normalizedName, 'wildfire', 1, true) or string.find(normalizedName, 'leaden', 1, true)
        or string.find(normalizedName, 'jinpu', 1, true) or string.find(normalizedName, 'koki', 1, true)
        or string.find(normalizedName, 'goten', 1, true) or string.find(normalizedName, 'kagero', 1, true) then
        equipFirstAvailable({ 'WSElemental', 'Elemental', 'Weaponskill' }, false);
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

    message('OddLua dynamic profile loaded for Oddone_29938. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd help for commands and one-button setup.');
    message('Configured default Subjob=NIN. Use /lac fwd subjob for level-37 capabilities.');
    oddLuaNumberRow.bindPalette();
    oddLuaNumberRow.registerOverlay();

end

profile.OnUnload = function()
    oddLuaNumberRow.unregisterOverlay();
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
    elseif command == 'warp' then
        useWarpRing();
    elseif command == 'warpclear' then
        clearWarpRing();
    elseif command == 'utility' then
        oddLuaNumberRow.equipUtilityIntent(value);
    elseif command == 'palette' or command == 'numberrow' then
        if value == 'missing' then
            message('Not Applicable / Missing Equipment');
            return;
        end
        oddLuaNumberRow.setPaletteEnabled(value);
    elseif command == 'mechanics' then
        handleMechanicsCommand(args);
    elseif command == 'reconcile' then
        handleReconcileCommand(args);
    elseif command == 'refreshgear' or command == 'reprocessgear' or command == 'rebuildgear' then
        startOddLuaGearRefresh(args);
    elseif command == 'status' then
        local subjob, subjobName = currentSubjobProfile();
        local capabilityText = 'none';
        if subjob and subjob.capabilities then
            capabilityText = table.concat(subjob.capabilities, ',');
        end
        message('Style=' .. state.Playstyle .. '; active=' .. activeCombatStyle() .. '; Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. capabilityText .. '; help=/lac fwd help; styles=/lac fwd styles');
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
    if skill == 'healing magic' then
        if string.find(name, 'cure', 1, true) or string.find(name, 'curaga', 1, true) then
            equipNamedSet('Cure', false);
        else
            equipNamedSet('Healing', false);
        end
    elseif skill == 'enhancing magic' then
        equipEnhancingMagic(name);
    elseif skill == 'enfeebling magic' then
        equipEnfeeblingMagic(name);
    elseif skill == 'divine magic' then
        equipNamedSet('Divine', false);
    elseif skill == 'elemental magic' then
        equipElementalMagic(action);
    elseif skill == 'dark magic' then
        equipDarkMagic(name);
    elseif skill == 'blue magic' then
        equipBlueMagic(name);
    elseif skill == 'singing' or skill == 'stringed instrument' or skill == 'wind instrument' then
        equipSong(name);
    elseif skill == 'geomancy' then
        equipNamedSet('Geomancy', false);
    elseif skill == 'summoning magic' or skill == 'summoning' then
        equipSummoning(name);
    elseif skill == 'ninjutsu' then
        equipNinjutsu(name);
    end
end

profile.HandlePreshot = function()
    if not equipNamedSet('Snapshot', false) then
        equipNamedSet('RangedPreshot', false);
    end
end

profile.HandleMidshot = function()
    equipFirstAvailable({ 'RangedMidshot', 'RangedAccuracy', 'Ranged' }, false);
end

profile.HandleWeaponskill = function()
    equipWeaponskill();
end

return profile;
