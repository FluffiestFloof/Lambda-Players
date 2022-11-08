table.Merge( _LAMBDAPLAYERSWEAPONS, {

    mp5 = {
        model = "models/weapons/w_smg_mp5.mdl",
        origin = "Counter Strike: Source",
        prettyname = "MP5",
        holdtype = "smg",
        bonemerge = true,
        keepdistance = 400,
        attackrange = 1750,

        clip = 30,
        tracername = "Tracer",
        damage = 6,--4 to 8 (zeta)
        spread = 0.11,
        rateoffire = 0.09,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "Weapon_MP5Navy.Single",

        reloadtime = 2.6,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimationspeed = 0.85,
        reloadsounds = { 
            { 0.1, "Weapon_MP5Navy.Clipout" },
            { 0.9, "Weapon_MP5Navy.Clipin" },
            { 2.2, "Weapon_MP5Navy.Slideback" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "Weapon_MP5Navy.Slideback", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})