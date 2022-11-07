table.Merge( _LAMBDAPLAYERSWEAPONS, {
--Random dmg

    m249 = {
        model = "models/weapons/w_mach_m249para.mdl",
        origin = "Counter Strike: Source",
        prettyname = "M249 Para",
        holdtype = "ar2",
        bonemerge = true,
        keepdistance = 250,
        attackrange = 1250,
        addspeed = -50,

        clip = 100,
        tracername = "Tracer",
        damage = 4,-- 3 to 6
        spread = 0.25,
        rateoffire = 0.075,
        muzzleflash = 1,
        shelleject = "RifleShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "Weapon_M249.Single",

        reloadtime = 3.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimationspeed = 0.6,
        reloadsounds = { 
            { 0, "Weapon_M249.Coverup" }, 
            { 0.4, "Weapon_M249.Boxout" },
            { 1.6, "Weapon_M249.Boxin" },
            { 2.2, "Weapon_M249.Chain" },
            { 3, "Weapon_M249.Coverdown" }
        },

        islethal = true,
    }

})