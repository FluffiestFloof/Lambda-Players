table.Merge( _LAMBDAPLAYERSWEAPONS, {
--Make random between burst or single shot on spawn

    glock = {
        model = "models/weapons/w_pist_glock18.mdl",
        origin = "Counter Strike: Source",
        prettyname = "Glock 18",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 350,
        attackrange = 2000,

        clip = 1,
        tracername = "Tracer",
        damage = 5, --4 to 8
        spread = 0.15,
        rateoffire = 0.2, --0.08 to 0.28
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "Weapon_Glock.Single",

        reloadtime = 2.3,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 0.85,
        reloadsounds = { 
            { 0, "Weapon_Glock.Slideback" },
            { 0.4, "Weapon_Glock.Clipout" },
            { 1.3, "Weapon_Glock.Clipin" },
            { 2, "Weapon_Glock.Sliderelease" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "Weapon_Glock.Slideback", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})