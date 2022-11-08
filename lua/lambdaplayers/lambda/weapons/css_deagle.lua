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
        shelloffpos = Vector(0,-3,0),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        attacksnd = "weapons/deagle/deagle-1.wav",

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 1,
        reloadsounds = { 
            { 0, "weapons/deagle/de_slideback.wav" },
            { 0.3, "weapons/deagle/de_clipout.wav" }, 
            { 1.2, "weapons/deagle/de_clipin.wav" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "weapons/deagle/de_deploy.wav", 75, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})