table.Merge( _LAMBDAPLAYERSWEAPONS, {

    revolver = {
        model = "models/weapons/w_357.mdl",
        origin = "Half Life: 2",
        prettyname = "357. Revolver",
        holdtype = "revolver",
        bonemerge = true,
        keepdistance = 500,
        attackrange = 3500,

        clip = 6,
        tracername = "Tracer",
        damage = 40,
        spread = 0.08,
        rateoffire = 0.8,
        muzzleflash = 1,
        shelleject = "none",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        attacksnd = "weapons/357/357_fire2.wav",

        reloadtime = 3,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        reloadanimationspeed = 1,
        reloadsounds = { { 0, "weapons/357/357_reload1.wav" }, { 0.4, "weapons/357/357_reload3.wav" }, { 1.5, "weapons/357/357_reload4.wav" }, { 2.2, "weapons/357/357_spin1.wav" } },

        islethal = true,
    }

})