local random = math.random
local CurTime = CurTime
local burst = false
local bullettbl = {}

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    glock = {
        model = "models/weapons/w_pist_glock18.mdl",
        origin = "Counter Strike: Source",
        prettyname = "Glock 18",
        holdtype = "pistol",
        bonemerge = true,
        keepdistance = 325,
        attackrange = 2000,

        clip = 20,

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
            if random(10) == 1 then
                burst = true
            end
        end,

        callback = function( self, wepent, target )
            if self.l_Clip <= 0 then self:ReloadWeapon() return end
            
            if burst and self.l_Clip >= 3 then
                self.l_WeaponUseCooldown = CurTime() + 0.5

                bullettbl.Num = 3

                self:SimpleTimer(0.05, function()
                    wepent:EmitSound( "Weapon_Glock.Single", 70, 100, 1, CHAN_WEAPON )
                end)
                self:SimpleTimer(0.1, function()
                    wepent:EmitSound( "Weapon_Glock.Single", 70, 100, 1, CHAN_WEAPON )
                end)

                self.l_Clip = self.l_Clip - 3
            else
                self.l_WeaponUseCooldown = CurTime() + 0.15
                bullettbl.Num = 1

                self.l_Clip = self.l_Clip - 1
            end

            wepent:EmitSound( "Weapon_Glock.Single", 70, 100, 1, CHAN_WEAPON )

            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL )
            
            self:HandleMuzzleFlash( 1 )
            self:HandleShellEject( "ShellEject" )

            bullettbl.Attacker = self
            bullettbl.Damage = 7
            bullettbl.Force = 7
            bullettbl.HullSize = 5
            bullettbl.TracerName = "Tracer"
            bullettbl.Dir = ( target:WorldSpaceCenter() - wepent:GetPos() ):GetNormalized()
            bullettbl.Src = wepent:GetPos()
            bullettbl.Spread = Vector( 0.16, 0.16, 0 )
            bullettbl.IgnoreEntity = self

            wepent:FireBullets( bullettbl )

            return true
        end,

        islethal = true,
    }

})