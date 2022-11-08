local random = math.random
local CurTime = CurTime
local silenced = false
local bullettbl = {}

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    usp = {
        model = "models/weapons/w_pist_usp.mdl",
        origin = "Counter Strike: Source",
        prettyname = "USP-45",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 350,
        attackrange = 2000,

        clip = 12,

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
            if random(10) == 1 then
                silenced = true
                wepent:SetModel( "models/weapons/w_pist_usp_silencer.mdl" )
            end
        end,

        callback = function( self, wepent, target )
            if self.l_Clip <= 0 then self:ReloadWeapon() return end

            self.l_WeaponUseCooldown = CurTime() + 0.18

            if silenced then
                wepent:EmitSound( "Weapon_USP.SilencedShot", 70, 100, 1, CHAN_WEAPON )
                self:HandleMuzzleFlash( 0 )
            else
                wepent:EmitSound( "Weapon_USP.Single", 70, 100, 1, CHAN_WEAPON )
                self:HandleMuzzleFlash( 1 )
            end

            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL )
            
            self:HandleShellEject( "ShellEject" )

            bullettbl.Attacker = self
            bullettbl.Damage = 11
            bullettbl.Force = 11
            bullettbl.HullSize = 5
            bullettbl.Num = 1
            bullettbl.TracerName = "Tracer"
            bullettbl.Dir = ( target:WorldSpaceCenter() - wepent:GetPos() ):GetNormalized()
            bullettbl.Src = wepent:GetPos()
            bullettbl.Spread = Vector( 0.14, 0.14, 0 )
            bullettbl.IgnoreEntity = self

            self.l_Clip = self.l_Clip - 1

            wepent:FireBullets( bullettbl )

            return true
        end,

        islethal = true,
    }

})