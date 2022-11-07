table.Merge( _LAMBDAPLAYERSWEAPONS, {

    fiveseven = {
        model = "models/weapons/w_pist_fiveseven.mdl",
        origin = "Counter Strike: Source",
        prettyname = "Five-Seven",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 300,
        attackrange = 2000,

        clip = 20,
        tracername = "Tracer",
        damage = 6, -- 3 to 10
        spread = 0.16,
        rateoffire = 0.4, -- 0.15 to 0.6
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "Weapon_FiveSeven.Single",

        reloadtime = 1.5,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 1,
        reloadsounds = { 
            {0, 'Weapon_FiveSeven.Slideback'},
            {0.4, 'Weapon_FiveSeven.Clipout'},
            {0.9, 'Weapon_FiveSeven.Clipin'},
            {1.5, 'Weapon_FiveSeven.Sliderelease'}
        },

        islethal = true,
    }

})