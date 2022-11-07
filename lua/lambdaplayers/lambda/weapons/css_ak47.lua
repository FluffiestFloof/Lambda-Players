table.Merge( _LAMBDAPLAYERSWEAPONS, {
--Real CSS reload time?
--Do random on pew pew

    ak47 = {
        model = "models/weapons/w_rif_ak47.mdl",
        origin = "Counter Strike: Source",
        prettyname = "AK47",
        holdtype = "ar2",
        bonemerge = true,
        keepdistance = 400,
        attackrange = 2100,

        clip = 30,
        tracername = "Tracer",
        damage = 9, -- 8 to 13
        spread = 0.13,
        rateoffire = 0.13,
        muzzleflash = 1,
        shelleject = "RifleShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "Weapon_AK47.Single",

        reloadtime = 2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimationspeed = 0.9,
        reloadsounds = { 
            { 0, "Weapon_AK47.Clipout" },
            { 0.8, "Weapon_AK47.Clipin" },
            { 1.5, "Weapon_AK47.BoltPull" }
        },

        islethal = true,
    }

})