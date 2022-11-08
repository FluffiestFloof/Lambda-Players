table.Merge( _LAMBDAPLAYERSWEAPONS, {

    p228 = {
        model = "models/weapons/w_pist_p228.mdl",
        origin = "Counter Strike: Source",
        prettyname = "P228",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 350,
        attackrange = 2000,

        clip = 13,
        tracername = "Tracer",
        damage = 8,
        spread = 0.15,
        rateoffire = 0.16,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "Weapon_P228.Single",

        reloadtime = 2.7,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 0.8,
        reloadsounds = { 
            { 0, "Weapon_P228.Slideback" },
            { 0.4, "Weapon_P228.Clipout" },
            { 1.3, "Weapon_P228.Clipin" },
            { 2, "Weapon_P228.Sliderelease" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "Weapon_P228.Slidepull", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})