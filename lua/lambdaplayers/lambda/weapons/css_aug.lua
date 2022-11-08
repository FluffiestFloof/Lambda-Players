table.Merge( _LAMBDAPLAYERSWEAPONS, {

    aug = {
        model = "models/weapons/w_rif_aug.mdl",
        origin = "Counter Strike: Source",
        prettyname = "AUG",
        holdtype = "ar2",
        bonemerge = true,
        keepdistance = 400,
        attackrange = 2250,

        clip = 30,
        tracername = "Tracer",
        damage = 10,
        spread = 0.12,
        rateoffire = 0.10,
        muzzleflash = 1,
        shelleject = "RifleShellEject",
        shelloffpos = Vector(5,0,0),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "weapons/aug/aug-1.wav",

        reloadtime = 3,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimationspeed = 0.9,
        reloadsounds = { 
            { 0.1, "weapons/aug/aug_boltpull.wav" },
            { 0.8, "weapons/aug/aug_clipout.wav" },
            { 1.8, "weapons/aug/aug_clipin.wav" },
            { 2.3, "weapons/aug/aug_boltslap.wav" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "weapons/aug/aug_forearm.wav", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})