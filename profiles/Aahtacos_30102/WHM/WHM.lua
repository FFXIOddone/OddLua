local profile = {};

local state = {
    Playstyle = 'Cure',
    WarpRingLocked = false,
    WarpUsePending = false,
    WarpClearPending = false,
    WarpUseAt = nil,
    WarpClearAt = nil,
};

local sets = {
    Playstyle_Cure = {
        Main = 'Ash Staff',
    },

    Playstyle_FastCast = {
        Main = 'Ash Staff',
    },

    Playstyle_IdleRefresh = {
        Main = 'Ash Staff',
    },

    Playstyle_Damage = {
        Main = 'Ash Staff',
    },

    Cure = {
        Main = 'Ash Staff',
    },

    FastCast = {
        Main = 'Ash Staff',
    },

    IdleRefresh = {
        Main = 'Ash Staff',
    },

    Damage = {
        Main = 'Ash Staff',
    },

    Idle = {
        Main = 'Ash Staff',
    },

    Resting = {
        Main = 'Ash Staff',
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
        Main = 'Ash Staff',
    },

    PDT = {
        Main = 'Ash Staff',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
    },

    MDT = {
        Main = 'Ash Staff',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
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
        Main = 'Ash Staff',
    },

    Hybrid = {
        Main = 'Ash Staff',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
    },

    TPAccuracy = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    Precast = {
        Main = 'Ash Staff',
    },

    Midcast = {
        Main = 'Ash Staff',
    },

    Healing = {
        Main = 'Ash Staff',
    },

    Enhancing = {
        Main = 'Ash Staff',
    },

    EnhancingDuration = {
        Main = 'Ash Staff',
    },

    Stoneskin = {
        Main = 'Ash Staff',
    },

    Refresh = {
        Main = 'Ash Staff',
    },

    Regen = {
        Main = 'Ash Staff',
    },

    SneakInvisible = {
        Main = 'Ash Staff',
    },

    Barspell = {
        Main = 'Ash Staff',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
    },

    Phalanx = {
        Main = 'Ash Staff',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
    },

    Aquaveil = {
        Main = 'Ash Staff',
    },

    Haste = {
        Main = 'Ash Staff',
    },

    Enfeebling = {
        Main = 'Ash Staff',
    },

    Sleep = {
        Main = 'Ash Staff',
    },

    Bind = {
        Main = 'Ash Staff',
    },

    Gravity = {
        Main = 'Ash Staff',
    },

    Silence = {
        Main = 'Ash Staff',
    },

    Slow = {
        Main = 'Ash Staff',
    },

    Paralyze = {
        Main = 'Ash Staff',
    },

    Blind = {
        Main = 'Ash Staff',
    },

    Dispel = {
        Main = 'Ash Staff',
    },

    Dia = {
        Main = 'Ash Staff',
    },

    Bio = {
        Main = 'Ash Staff',
        Ring1 = 'Venture Ring',
    },

    Divine = {
        Main = 'Ash Staff',
    },

    Elemental = {
        Main = 'Ash Staff',
    },

    Nuke = {
        Main = 'Ash Staff',
    },

    DarkMagic = {
        Main = 'Ash Staff',
        Ring1 = 'Venture Ring',
    },

    DrainAspir = {
        Main = 'Ash Staff',
        Ring1 = 'Venture Ring',
    },

    Absorb = {
        Main = 'Ash Staff',
        Ring1 = 'Venture Ring',
    },

    Stun = {
        Main = 'Ash Staff',
    },

    BlueMagic = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    PhysicalBlueMagic = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    MagicalBlueMagic = {
        Main = 'Ash Staff',
    },

    Song = {
        Main = 'Ash Staff',
    },

    SongDebuff = {
        Main = 'Ash Staff',
    },

    SongBuff = {
        Main = 'Ash Staff',
    },

    Geomancy = {
        Main = 'Ash Staff',
    },

    Summoning = {
        Main = 'Ash Staff',
    },

    BloodPactRage = {
        Main = 'Ash Staff',
    },

    BloodPactWard = {
        Main = 'Ash Staff',
    },

    AvatarPerp = {
        Main = 'Ash Staff',
    },

    Ninjutsu = {
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

    Utsusemi = {
        Main = 'Ash Staff',
    },

    NinjutsuEnfeeble = {
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
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    RangedPreshot = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    Ranged = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    RangedMidshot = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    RangedAccuracy = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    RangedAttack = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
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

    Weaponskill = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
        Ring1 = 'Venture Ring',
    },

    WeaponSkillAccuracy = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
        Ring1 = 'Venture Ring',
    },

    WSElemental = {
        Main = 'Ash Staff',
    },

    JobAbility = {
        Main = 'Ash Staff',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
    },

    Enmity = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
    },

    Waltz = {
        Main = 'Ash Staff',
    },

    Steps = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    Samba = {
        Main = 'Ash Staff',
    },

    Jump = {
        Main = 'Ash Staff',
        Sub = 'Debahocho',
    },

    PetReady = {
        Ring1 = 'Venture Ring',
    },

    PetMagic = {
        Ring1 = 'Venture Ring',
    },

    PetTank = {
        Main = 'Ash Staff',
        Head = 'Destrier Beret',
        Body = 'Field Tunica',
        Hands = 'Bonewrk. Cuffs',
        Legs = 'Galkan Braguette',
        Feet = 'Sprinter\'s Shoes',
    },

    Roll = {
        Main = 'Ash Staff',
    },

    Elemental_Fire = {
        Main = 'Ash Staff',
    },

    Weather_Fire = {
        Main = 'Ash Staff',
    },

    Day_Fire = {
        Main = 'Ash Staff',
    },

    Elemental_Ice = {
        Main = 'Ash Staff',
    },

    Weather_Ice = {
        Main = 'Ash Staff',
    },

    Day_Ice = {
        Main = 'Ash Staff',
    },

    Elemental_Wind = {
        Main = 'Ash Staff',
    },

    Weather_Wind = {
        Main = 'Ash Staff',
    },

    Day_Wind = {
        Main = 'Ash Staff',
    },

    Elemental_Earth = {
        Main = 'Ash Staff',
    },

    Weather_Earth = {
        Main = 'Ash Staff',
    },

    Day_Earth = {
        Main = 'Ash Staff',
    },

    Elemental_Thunder = {
        Main = 'Ash Staff',
    },

    Weather_Thunder = {
        Main = 'Ash Staff',
    },

    Day_Thunder = {
        Main = 'Ash Staff',
    },

    Elemental_Lightning = {
        Main = 'Ash Staff',
    },

    Weather_Lightning = {
        Main = 'Ash Staff',
    },

    Day_Lightning = {
        Main = 'Ash Staff',
    },

    Elemental_Water = {
        Main = 'Ash Staff',
    },

    Weather_Water = {
        Main = 'Ash Staff',
    },

    Day_Water = {
        Main = 'Ash Staff',
    },

    Elemental_Light = {
        Main = 'Ash Staff',
    },

    Weather_Light = {
        Main = 'Ash Staff',
    },

    Day_Light = {
        Main = 'Ash Staff',
    },

    Elemental_Dark = {
        Main = 'Ash Staff',
    },

    Weather_Dark = {
        Main = 'Ash Staff',
    },

    Day_Dark = {
        Main = 'Ash Staff',
    },
};

profile.Sets = sets;
profile.Packer = {};

local subjobs = {
    SCH = {
        level = 37,
        capabilities = {
            'light_arts',
            'dark_arts',
            'sublimation',
            'stratagems',
            'cure',
            'sneak_invisible',
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
    RDM = {
        level = 37,
        capabilities = {
            'fast_cast',
            'cure',
            'enfeeble',
            'enhancing',
            'sneak_invisible',
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
    BLM = {
        level = 37,
        capabilities = {
            'elemental_magic',
            'warp',
            'sleep',
            'magic_burst',
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
    SMN = {
        level = 37,
        capabilities = {
            'auto_refresh',
            'avatar_support',
            'mp_sustain',
        },
        abilities = {
            { name = 'assault', level = 1, recast = 5, recastId = 170, ce = 0, ve = 0 },
            { name = 'retreat', level = 1, recast = 5, recastId = 171, ce = -10, ve = 0 },
            { name = 'release', level = 1, recast = 5, recastId = 172, ce = -10, ve = 0 },
            { name = 'blood_pact_rage', level = 1, recast = 60, recastId = 173, ce = 1, ve = 300 },
            { name = 'blood_pact_ward', level = 1, recast = 60, recastId = 174, ce = 1, ve = 300 },
            { name = 'healing_ruby', level = 1, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'searing_light', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'regal_scratch', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'altana_s_favor', level = 1, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'howling_moon', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'punch', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'inferno', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'rock_throw', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'earthen_fury', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'barracuda_dive', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'tidal_wave', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'claw', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'aerial_blast', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'axe_kick', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'diamond_dust', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'shock_strike', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'judgment_bolt', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'camisado', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'ruinous_omen', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'clarsach_call', level = 1, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'welt', level = 1, recast = 60, recastId = 173, ce = 0, ve = 60 },
            { name = 'katabatic_blades', level = 1, recast = 0, recastId = 300, ce = 0, ve = 60 },
            { name = 'lunatic_voice', level = 1, recast = 0, recastId = 300, ce = 0, ve = 60 },
            { name = 'chinook', level = 1, recast = 0, recastId = 300, ce = 0, ve = 60 },
            { name = 'bitter_elegy', level = 1, recast = 0, recastId = 300, ce = 0, ve = 60 },
            { name = 'poison_nails', level = 5, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'moonlit_charge', level = 5, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'crescent_fang', level = 10, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'fire_ii', level = 10, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'stone_ii', level = 10, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'water_ii', level = 10, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'aero_ii', level = 10, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'blizzard_ii', level = 10, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'thunder_ii', level = 10, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'raise_ii', level = 15, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'thunderspark', level = 19, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'somnolence', level = 20, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'lunar_cry', level = 21, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'rock_buster', level = 21, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'burning_strike', level = 23, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'shining_ruby', level = 24, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'mewing_lullaby', level = 25, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'aerial_armor', level = 25, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'roundhouse', level = 25, recast = 60, recastId = 173, ce = 0, ve = 60 },
            { name = 'tail_whip', level = 26, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'frost_armor', level = 28, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'nightmare', level = 29, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'reraise_ii', level = 30, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'double_punch', level = 30, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'rolling_thunder', level = 31, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'lunar_roar', level = 32, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'slowga', level = 33, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'megalith_throw', level = 35, recast = 60, recastId = 173, ce = 1, ve = 60 },
            { name = 'whispering_wind', level = 36, recast = 60, recastId = 174, ce = 1, ve = 60 },
            { name = 'ultimate_terror', level = 37, recast = 60, recastId = 174, ce = 1, ve = 60 },
        },
        traits = {
            { name = 'max mp boost', level = 10, rank = 1, mod = 'BASE_MP', value = 10 },
            { name = 'clear mind', level = 15, rank = 1, mod = 'MPHEAL', value = 3 },
            { name = 'resist slow', level = 20, rank = 1, mod = 'SLOWRES', value = 10 },
            { name = 'auto refresh', level = 25, rank = 1, mod = 'REFRESH', value = 1 },
            { name = 'max mp boost', level = 30, rank = 2, mod = 'BASE_MP', value = 20 },
            { name = 'clear mind', level = 30, rank = 2, mod = 'MPHEAL', value = 6 },
        },
        spells = {
            { name = 'air_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
            { name = 'cait_sith', level = 1, mp = 0, cast = 1000, recast = 60000 },
            { name = 'carbuncle', level = 1, mp = 5, cast = 5000, recast = 5000 },
            { name = 'dark_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
            { name = 'diabolos', level = 1, mp = 15, cast = 5000, recast = 5000 },
            { name = 'earth_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
            { name = 'fenrir', level = 1, mp = 15, cast = 5000, recast = 5000 },
            { name = 'fire_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
            { name = 'garuda', level = 1, mp = 7, cast = 5000, recast = 5000 },
            { name = 'ice_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
            { name = 'ifrit', level = 1, mp = 7, cast = 5000, recast = 5000 },
            { name = 'leviathan', level = 1, mp = 7, cast = 5000, recast = 5000 },
            { name = 'light_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
            { name = 'ramuh', level = 1, mp = 7, cast = 5000, recast = 5000 },
            { name = 'shiva', level = 1, mp = 7, cast = 5000, recast = 5000 },
            { name = 'siren', level = 1, mp = 7, cast = 5000, recast = 5000 },
            { name = 'thunder_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
            { name = 'titan', level = 1, mp = 7, cast = 5000, recast = 5000 },
            { name = 'water_spirit', level = 1, mp = 10, cast = 1000, recast = 5000 },
        },
    },
    NIN = {
        level = 37,
        capabilities = {
            'dual_wield',
            'shadows',
            'ninjutsu',
            'subtle_blow',
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
    Playstyle_Cure = 'Cure',
    Playstyle_FastCast = 'FastCast',
    Playstyle_IdleRefresh = 'Refresh',
    Playstyle_Damage = 'TP',
    Cure = 'Cure',
    FastCast = 'FastCast',
    IdleRefresh = 'Refresh',
    Damage = 'TP',
    Idle = 'Idle',
    Resting = 'Idle',
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
    Midcast = 'MagicAccuracy',
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
    Ninjutsu = 'Ninjutsu',
    Utsusemi = 'FastCast',
    NinjutsuEnfeeble = 'Ninjutsu',
    Snapshot = 'RangedPreshot',
    RangedPreshot = 'RangedPreshot',
    Ranged = 'RangedAccuracy',
    RangedMidshot = 'RangedAccuracy',
    RangedAccuracy = 'RangedAccuracy',
    RangedAttack = 'RangedAttack',
    QuickDraw = 'QuickDraw',
    Weaponskill = 'Weaponskill',
    WeaponSkillAccuracy = 'Weaponskill',
    WSElemental = 'Weaponskill',
    JobAbility = 'TP',
    Enmity = 'Enmity',
    Waltz = 'Cure',
    Steps = 'Accuracy',
    Samba = 'TP',
    Jump = 'Weaponskill',
    PetReady = 'PetDamage',
    PetMagic = 'PetDamage',
    PetTank = 'PetTank',
    Roll = 'Roll',
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
};

local styleAliases = {
    cure = 'Cure',
    fastcast = 'FastCast',
    idlerefresh = 'IdleRefresh',
    damage = 'Damage',
};

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

local function message(text)
    text = '[Aahtacos WHM] ' .. tostring(text or '');
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

local function getPlayer()
    if gData and gData.GetPlayer then
        return gData.GetPlayer();
    end
    return nil;
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

local function hasDangerousStatus()
    for name in pairs(dangerousStatusBuffs) do
        if getBuffCount(name) > 0 then
            return true;
        end
    end
    for _, id in ipairs(dangerousStatusIds) do
        if getBuffCount(id) > 0 then
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
    return '';
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

local function equipNamedSet(setName, force)
    local set = sets[setName];
    if not set then
        return false;
    end

    if state.WarpRingLocked == true then
        local lockedSet = applyWarpRingLock(set);
        if force == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(lockedSet);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(lockedSet);
        end
        return true;
    end

    if isClearSet(set) then
        if force == true and gFunc and gFunc.ForceEquipSet then
            gFunc.ForceEquipSet(set);
        elseif gFunc and gFunc.EquipSet then
            gFunc.EquipSet(set);
        end
    elseif force == true and scale and scale.ForceEquipSet then
        scale.ForceEquipSet(setName, set, setIntents[setName]);
    elseif force == true and gFunc and gFunc.ForceEquipSet then
        gFunc.ForceEquipSet(set);
    elseif scale and scale.EquipSet then
        scale.EquipSet(setName, set, setIntents[setName]);
    elseif gFunc and gFunc.EquipSet then
        gFunc.EquipSet(set);
    end
    return true;
end

local function equipNamedSetIfNotClear(setName, force)
    local set = sets[setName];
    if not set or isClearSet(set) then
        return false;
    end
    return equipNamedSet(setName, force);
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

local function clearWarpRing()
    state.WarpRingLocked = false;
    state.WarpUsePending = false;
    state.WarpClearPending = false;
    state.WarpUseAt = nil;
    state.WarpClearAt = nil;

    if forceEquipInlineSet({ Ring2 = 'remove' }, true) then
        message('Warp Ring removed from Ring2.');
    else
        message('Warp Ring cleanup failed: unable to force Ring2 remove.');
    end
end

local function processWarpRingTimers()
    local handled = false;
    local now = nowSeconds();

    if state.WarpRingLocked == true and state.WarpUsePending == true and state.WarpUseAt and now >= state.WarpUseAt then
        handled = true;
        state.WarpUsePending = false;
        forceEquipInlineSet({ Ring2 = 'Warp Ring' });
        local useQueued = queueTypedCommand('/item "Warp Ring" <me>', 1);
        if useQueued then
            message('Warp Ring use queued after 9 seconds.');
        else
            message('Warp Ring use failed: unable to queue item command.');
        end
    end

    if state.WarpClearPending == true and state.WarpClearAt and now >= state.WarpClearAt then
        handled = true;
        clearWarpRing();
    end

    return handled;
end

local function useWarpRing()
    state.WarpRingLocked = true;
    if not forceEquipInlineSet({ Ring2 = 'Warp Ring' }) then
        state.WarpRingLocked = false;
        message('Warp Ring equip failed: unable to force Ring2.');
        return;
    end

    local now = nowSeconds();
    state.WarpUsePending = true;
    state.WarpClearPending = true;
    state.WarpUseAt = now + 9;
    state.WarpClearAt = now + 30;

    local useScheduled = scheduleTask(9, processWarpRingTimers);
    local cleanupScheduled = scheduleTask(30, processWarpRingTimers);
    if useScheduled and cleanupScheduled then
        message('Warp Ring armed: Ring2 locked; use in 9 seconds; Ring2 cleanup at 30 seconds.');
    else
        message('Warp Ring armed with default-tick fallback: Ring2 locked; use in 9 seconds; Ring2 cleanup at 30 seconds.');
    end
end

local function equipFirstAvailable(setNames, force)
    for _, setName in ipairs(setNames or {}) do
        if setName and equipNamedSet(setName, force) then
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
        return 'Cure';
    end
    return state.Playstyle;
end

local function equipCombatStyle(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        if equipNamedSet(setNameFor('Cure'), force) then
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
    return equipNamedSet('Playstyle_Cure', force);
end

local function equipMovement(environment, force)
    local equipped = false;

    if equipNamedSetIfNotClear('Movement', force) then
        equipped = true;
    end
    if isCity(environment) and equipNamedSetIfNotClear('Movement_City', force) then
        equipped = true;
    end
    if isNight(environment) and equipNamedSetIfNotClear('Movement_Night', force) then
        equipped = true;
    end
    if isDuskToDawn(environment) and equipNamedSetIfNotClear('Movement_DuskToDawn', force) then
        equipped = true;
    end

    return equipped;
end

local function equipIdleState(player, force)
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

    equipMovement(getEnvironment(), force);
    if equipped then
        return true;
    end
    return equipNamedSet('Idle', force);
end

local function equipDefaultForPlayer(player, force)
    if hasDangerousStatus() then
        equipNamedSet('PDT', force);
    elseif player and isEngaged(player) and isEmergencyHp(player) then
        equipNamedSet('PDT', force);
    elseif player and isEngaged(player) then
        equipCombatStyle(force);
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

local function equipBlueMagic()
    local active = activeCombatStyle();
    if active == 'MagicalBlue' and equipNamedSet('Playstyle_MagicalBlue', false) then
        return;
    elseif active == 'PhysicalBlue' and equipNamedSet('Playstyle_PhysicalBlue', false) then
        return;
    end
    equipNamedSet('BlueMagic', false);
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
    local name = normalize(action and action.Name);
    if state.Playstyle == 'Accuracy' then
        equipFirstAvailable({ 'WeaponSkillAccuracy', 'Weaponskill' }, false);
    elseif string.find(name, 'aeolian', 1, true) or string.find(name, 'cyclone', 1, true)
        or string.find(name, 'energy', 1, true) or string.find(name, 'red lotus', 1, true)
        or string.find(name, 'seraph', 1, true) or string.find(name, 'sanguine', 1, true)
        or string.find(name, 'wildfire', 1, true) or string.find(name, 'leaden', 1, true)
        or string.find(name, 'jinpu', 1, true) or string.find(name, 'koki', 1, true)
        or string.find(name, 'goten', 1, true) or string.find(name, 'kagero', 1, true) then
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

    message('OddLua dynamic profile loaded for Aahtacos_30102. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd style cure|fastcast|idlerefresh|damage.');
    message('Use /lac fwd subjob for level-37 subjob capabilities.');
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if scale and scale.HandleCommand and scale.HandleCommand(args) then
        return;
    end

    if not args or not args[1] then
        return;
    end

    local command = normalize(args[1]);
    local value = normalize(args[2]);

    if command == 'style' or command == 'playstyle' then
        if value == '' or value == 'status' then
            message('Current style: ' .. state.Playstyle .. '. Use style cure|fastcast|idlerefresh|damage.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style cure|fastcast|idlerefresh|damage.');
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
    elseif command == 'warp' then
        useWarpRing();
    elseif command == 'warpclear' then
        clearWarpRing();
    elseif command == 'status' then
        local subjob, subjobName = currentSubjobProfile();
        local capabilityText = 'none';
        if subjob and subjob.capabilities then
            capabilityText = table.concat(subjob.capabilities, ',');
        end
        message('Style=' .. state.Playstyle .. '; active=' .. activeCombatStyle() .. '; Subjob=' .. tostring(subjobName or '') .. '; capabilities=' .. capabilityText);
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
    end
end

profile.HandleDefault = function()
    local handledWarpTimer = processWarpRingTimers();
    if handledWarpTimer and state.WarpRingLocked ~= true then
        return;
    end
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
        equipBlueMagic();
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
