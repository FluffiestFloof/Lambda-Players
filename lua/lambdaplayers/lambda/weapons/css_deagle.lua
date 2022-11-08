table.Merge( _LAMBDAPLAYERSWEAPONS, {

    deagle = {
        model = "models/weapons/w_pist_deagle.mdl",
        origin = "Counter Strike: Source",
        prettyname = "Desert Eagle",
        holdtype = "revolver",
        bonemerge = true,
        keepdistance = 500,
        attackrange = 3250,

        clip = 7,
        tracername = "Tracer",
        damage = 16,
        spread = 0.1,
        rateoffire = 0.3,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        attacksnd = "Weapon_DEagle.Single",

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 1,
        reloadsounds = { 
            { 0, "Weapon_DEagle.Slideback" },
            { 0.3, "Weapon_DEagle.Clipout" }, 
            { 1.4, "Weapon_DEagle.Clipin" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "Weapon_DEagle.Deploy", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})