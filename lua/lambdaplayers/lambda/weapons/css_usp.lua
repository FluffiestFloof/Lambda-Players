local random = math.random
local CurTime = CurTime
local silenced = false

table.Merge( _LAMBDAPLAYERSWEAPONS, {
--Allow Lambda to attach silencer on spawn randomly

    usp = {
        model = "models/weapons/w_pist_usp.mdl",
        origin = "Counter Strike: Source",
        prettyname = "USP-45",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 350,
        attackrange = 2000,

        clip = 12,
        tracername = "Tracer",
        damage = 10,
        spread = 0.14,
        rateoffire = 0.18,
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "Weapon_USP.Single", --Weapon_USP.SilencedShot
        --Weapon_USP.AttachSilencer

        reloadtime = 2.7,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimationspeed = 0.8,
        reloadsounds = { 
            { 0, "Weapon_USP.Slideback2" },
            { 0.4, "Weapon_USP.Clipout" },
            { 1.3, "Weapon_USP.Clipin" },
            { 2, "Weapon_USP.Sliderelease" }
        },

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "Weapon_USP.Slideback", 70, 100, 1, CHAN_WEAPON )
        end,

        islethal = true,
    }

})