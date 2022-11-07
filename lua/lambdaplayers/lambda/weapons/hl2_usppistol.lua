table.Merge( _LAMBDAPLAYERSWEAPONS, {

    pistol = {
        model = "models/weapons/w_pistol.mdl",
        origin = "Half Life: 2",
        prettyname = "Pistol",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 350,
        attackrange = 2000,

        clip = 18,
        tracername = "Tracer",
        damage = 5,
        spread = 0.2,
        rateoffire = 0.2,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "weapons/pistol/pistol_fire2.wav",

        reloadtime = 1.8,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 1,
        reloadsounds = { { 0, "weapons/pistol/pistol_reload1.wav" } },

        islethal = true,
    }

})