table.Merge( _LAMBDAPLAYERSWEAPONS, {

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
        damage = 11,
        spread = 0.13,
        rateoffire = 0.13,
        muzzleflash = 1,
        shelleject = "RifleShellEject",
        shelloffpos = Vector(-1,-5,-5),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "Weapon_AK47.Single",

        reloadtime = 2.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimationspeed = 0.9,
        reloadsounds = { 
            { 0.1, "weapons/ak47/ak47_clipout.wav" },
            { 1.4, "weapons/ak47/ak47_clipin.wav" },
            { 1.9, "weapons/ak47/ak47_boltpull.wav" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "weapons/ak47/ak47_boltpull.wav", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})