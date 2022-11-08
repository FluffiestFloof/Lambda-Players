table.Merge( _LAMBDAPLAYERSWEAPONS, {
--TODO

    famas = {
        model = "models/weapons/w_rif_ak47.mdl",
        origin = "Counter Strike: Source",
        prettyname = "Famas",
        holdtype = "ar2",
        bonemerge = true,
        keepdistance = 400,
        attackrange = 2100,

        clip = 30,
        tracername = "Tracer",
        damage = 9,
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

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "Weapon_AK47.BoltPull", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})