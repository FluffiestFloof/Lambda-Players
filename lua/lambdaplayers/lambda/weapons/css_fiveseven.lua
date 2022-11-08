table.Merge( _LAMBDAPLAYERSWEAPONS, {

    fiveseven = {
        model = "models/weapons/w_pist_fiveseven.mdl",
        origin = "Counter Strike: Source",
        prettyname = "Five-Seven",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 400,
        attackrange = 2500,

        clip = 20,
        tracername = "Tracer",
        damage = 9,
        spread = 0.12,
        rateoffire = 0.2,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "Weapon_FiveSeven.Single",

        reloadtime = 2.7,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 0.65,
        reloadsounds = { 
            { 0, "Weapon_FiveSeven.Slideback" },
            { 0.6, "Weapon_FiveSeven.Clipout" },
            { 1.8, "Weapon_FiveSeven.Clipin" },
            { 2.5, "Weapon_FiveSeven.Sliderelease" }
        },

        islethal = true,
    }

})