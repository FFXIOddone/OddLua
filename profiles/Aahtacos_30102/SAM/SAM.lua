local profile = {};

local state = {
    Playstyle = 'StoreTP',
    WarpRingLocked = false,
    WarpUsePending = false,
    WarpClearPending = false,
    WarpUseAt = nil,
    WarpClearAt = nil,
};

local sets = {
    Playstyle_StoreTP = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_Accuracy = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Playstyle_WeaponSkill = {
        Main = 'Amanomurakumo',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Justice Torque',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Saotome Sune-Ate',
    },

    Playstyle_Evasion = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Hard Leather Ring',
        Ring2 = 'Water Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    StoreTP = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Accuracy = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    WeaponSkill = {
        Main = 'Amanomurakumo',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Justice Torque',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Saotome Sune-Ate',
    },

    Evasion = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Hard Leather Ring',
        Ring2 = 'Water Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Idle = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Darksteel Cap',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Mana Ring',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    Resting = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
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
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Darksteel Cap',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Mana Ring',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    PDT = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Darksteel Cap',
        Neck = 'Coral Gorget',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Sao. Domaru +1',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    MDT = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Suzaku\'s Sune-Ate',
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
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Neck = 'Spike Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Hybrid = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Darksteel Cap',
        Neck = 'Coral Gorget',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Sao. Domaru +1',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    TPAccuracy = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Precast = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    FastCast = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Midcast = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Cure = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Healing = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Enhancing = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    EnhancingDuration = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Stoneskin = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Refresh = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Darksteel Cap',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Mana Ring',
        Legs = 'Darksteel Subligar',
        Feet = 'Dst. Leggings',
    },

    Regen = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    SneakInvisible = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Barspell = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Phalanx = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Chain Choker',
        Ear1 = 'Merman\'s Earring',
        Ear2 = 'Coral Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sun Ring',
        Ring2 = 'Sun Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Aquaveil = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Haste = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Enfeebling = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Sleep = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Bind = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Gravity = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Silence = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Slow = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Paralyze = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Blind = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Dispel = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Dia = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Bio = {
        Main = 'Amanomurakumo',
        Sub = 'Tigris Grip',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Mana Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Saotome Sune-Ate',
    },

    Divine = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Elemental = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Nuke = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    DarkMagic = {
        Main = 'Amanomurakumo',
        Sub = 'Tigris Grip',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Mana Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Saotome Sune-Ate',
    },

    DrainAspir = {
        Main = 'Amanomurakumo',
        Sub = 'Tigris Grip',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Mana Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Saotome Sune-Ate',
    },

    Absorb = {
        Main = 'Amanomurakumo',
        Sub = 'Tigris Grip',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Mana Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Saotome Sune-Ate',
    },

    Stun = {
        Head = 'Myochin Kabuto',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    BlueMagic = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Neck = 'Spike Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    PhysicalBlueMagic = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Neck = 'Spike Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    MagicalBlueMagic = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Song = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Opal Ring',
        Ring2 = 'Mana Ring',
        Waist = 'Corsette',
    },

    SongDebuff = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Opal Ring',
        Ring2 = 'Mana Ring',
        Waist = 'Corsette',
    },

    SongBuff = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Opal Ring',
        Ring2 = 'Mana Ring',
        Waist = 'Corsette',
    },

    Geomancy = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
        Feet = 'Suzaku\'s Sune-Ate',
    },

    Summoning = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
    },

    BloodPactRage = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
    },

    BloodPactWard = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
    },

    AvatarPerp = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
    },

    Ninjutsu = {
        Main = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Utsusemi = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Ring1 = 'Mana Ring',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    NinjutsuEnfeeble = {
        Main = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Dusk Gloves',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Snapshot = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Dusk Trousers',
    },

    RangedPreshot = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Dusk Trousers',
    },

    Ranged = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Dusk Trousers',
    },

    RangedMidshot = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Dusk Trousers',
    },

    RangedAccuracy = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Sniper\'s Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Dusk Trousers',
    },

    RangedAttack = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Saotome Kabuto',
        Neck = 'Justice Torque',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Smilodon Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Dusk Trousers',
        Feet = 'Hmn. Sune-Ate',
    },

    QuickDraw = {
        Main = 'Garuda\'s Dagger',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Wing Earring',
        Ear2 = 'Wing Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Dusk Trousers',
    },

    Weaponskill = {
        Main = 'Amanomurakumo',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Justice Torque',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Saotome Sune-Ate',
    },

    WeaponSkillAccuracy = {
        Main = 'Amanomurakumo',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Justice Torque',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Saotome Sune-Ate',
    },

    WSElemental = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    JobAbility = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Eris\' Earring',
        Body = 'Sao. Domaru +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Enmity = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Eris\' Earring',
        Body = 'Sao. Domaru +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Waltz = {
        Main = 'Seiryu\'s Sword',
        Sub = 'Tigris Grip',
        Head = 'Genbu\'s Kabuto',
        Ear1 = 'Platinum Earring',
        Ear2 = 'Platinum Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Opal Ring',
        Waist = 'Corsette',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },

    Steps = {
        Main = 'Amanomurakumo',
        Head = 'Walahra Turban',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Samba = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Neck = 'Spike Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    Jump = {
        Main = 'Amanomurakumo',
        Sub = 'Seiryu\'s Sword',
        Head = 'Walahra Turban',
        Neck = 'Spike Necklace',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Dusk Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Sao. Koshi-Ate',
        Legs = 'Byakko\'s Haidate',
        Feet = 'Dusk Ledelsens',
    },

    PetReady = {
        Main = 'Amanomurakumo',
        Sub = 'Tigris Grip',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Saotome Sune-Ate',
    },

    PetMagic = {
        Main = 'Amanomurakumo',
        Sub = 'Tigris Grip',
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Merman\'s Earring',
        Body = 'Haubergeon +1',
        Hands = 'Ochimusha Kote',
        Ring1 = 'Venture Ring',
        Ring2 = 'Sniper\'s Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Fierce Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Saotome Sune-Ate',
    },

    PetTank = {
        Main = 'Tachi of Trials',
        Sub = 'Tigris Grip',
        Head = 'Genbu\'s Kabuto',
        Neck = 'Coral Gorget',
        Body = 'Sao. Domaru +1',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Water Ring',
        Ring2 = 'Lightning Ring',
        Back = 'Cerberus Mantle',
        Waist = 'Toxon Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Dusk Ledelsens',
    },

    Roll = {
        Head = 'Saotome Kabuto',
        Neck = 'Coral Gorget',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Sniper\'s Ring',
        Ring2 = 'Sniper\'s Ring',
        Waist = 'Corsette',
        Legs = 'Dusk Trousers',
    },

    Elemental_Fire = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Fire = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Fire = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Ice = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Ice = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Ice = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Wind = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Wind = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Wind = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Earth = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Earth = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Earth = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Thunder = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Thunder = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Thunder = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Lightning = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Lightning = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Lightning = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Water = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Water = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Water = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Light = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Light = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Light = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Elemental_Dark = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Weather_Dark = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },

    Day_Dark = {
        Head = 'Walahra Turban',
        Body = 'Kirin\'s Osode',
        Ring1 = 'Mana Ring',
        Waist = 'Ryl.Kgt. Belt',
    },
};

profile.Sets = sets;
profile.Packer = {};

local subjobs = {
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
    RNG = {
        level = 37,
        capabilities = {
            'ranged_accuracy',
            'sharpshot',
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
            { name = 'recycle', level = 35, rank = 2, mod = 'RECYCLE', value = 20 },
        },
        spells = {
        },
    },
    THF = {
        level = 37,
        capabilities = {
            'sneak_attack',
            'treasure_hunter',
            'evasion',
            'flee',
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
    Playstyle_StoreTP = 'TP',
    Playstyle_Accuracy = 'Accuracy',
    Playstyle_WeaponSkill = 'WS',
    Playstyle_Evasion = 'Evasion',
    StoreTP = 'TP',
    Accuracy = 'Accuracy',
    WeaponSkill = 'WS',
    Evasion = 'Evasion',
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
    storetp = 'StoreTP',
    accuracy = 'Accuracy',
    weaponskill = 'WeaponSkill',
    evasion = 'Evasion',
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
    text = '[Aahtacos SAM] ' .. tostring(text or '');
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
    return 'WAR';
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
        return 'StoreTP';
    end
    return state.Playstyle;
end

local function equipCombatStyle(force)
    if state.Playstyle == 'Craft' and isEngaged(getPlayer()) then
        message('Craft cannot equip while engaged.');
        if equipNamedSet(setNameFor('StoreTP'), force) then
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
    return equipNamedSet('Playstyle_StoreTP', force);
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

    message('OddLua dynamic profile loaded for Aahtacos_30102. Default combat style: ' .. state.Playstyle .. '. Use /lac fwd style storetp|accuracy|weaponskill|evasion.');
    message('Configured default Subjob=WAR. Use /lac fwd subjob for level-37 capabilities.');
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
            message('Current style: ' .. state.Playstyle .. '. Use style storetp|accuracy|weaponskill|evasion.');
            return;
        end

        local selected = styleAliases[value];
        if not selected then
            message('Unknown style: ' .. tostring(args[2]) .. '. Use style storetp|accuracy|weaponskill|evasion.');
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
