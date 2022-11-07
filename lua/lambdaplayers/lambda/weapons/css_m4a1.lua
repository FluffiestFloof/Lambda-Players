table.Merge( _LAMBDAPLAYERSWEAPONS, {
--Do random on pew pew and silencer on spawn random

    m4a1 = {
        model = "models/weapons/w_rif_m4a1.mdl",
        origin = "Counter Strike: Source",
        prettyname = "M4A1",
        holdtype = "ar2",
        bonemerge = true,
        keepdistance = 300,
        attackrange = 1500,

        clip = 30,
        tracername = "Tracer",
        damage = 6, -- 4 to 10
        spread = 0.15,
        rateoffire = 0.11,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "Weapon_M4A1.Single",

        reloadtime = 3.1,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimationspeed = 0.65,
        reloadsounds = { 
            { 0, "Weapon_M4A1.Clipout" },
            { 1.4, "Weapon_M4A1.Clipin" },
            { 2.5, "Weapon_M4A1.Boltpull" },
        },

        islethal = true,
    }

})