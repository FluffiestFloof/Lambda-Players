table.Merge( _LAMBDAPLAYERSWEAPONS, {
-- Missing secondary grenade launcher attack

    mp7 = {
        model = "models/weapons/w_smg1.mdl",
        origin = "Half Life: 2",
        prettyname = "MP7",
        holdtype = "smg",
        bonemerge = true,
        keepdistance = 300,
        attackrange = 1500,

        clip = 45,
        tracername = "Tracer",
        damage = 5,
        spread = 0.2,
        rateoffire = 0.065,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
        attacksnd = "Weapon_SMG1.Single",

        reloadtime = 1.6,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimationspeed = 1,
        reloadsounds = { { 0, "Weapon_SMG1.Reload" } },

        islethal = true,
    }

})