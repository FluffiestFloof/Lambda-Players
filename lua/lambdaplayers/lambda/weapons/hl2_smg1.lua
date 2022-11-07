local CurTime = CurTime
local random = math.random
local bullettbl = {}

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    smg = {
        model = "models/weapons/w_smg1.mdl",
        origin = "Half Life: 2",
        prettyname = "SMG",
        holdtype = "smg",
        bonemerge = true,
        keepdistance = 300,
        attackrange = 1500,

        clip = 45,

        reloadtime = 1.6,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimationspeed = 1,
        reloadsounds = { { 0, "Weapon_SMG1.Reload" } },

        callback = function( self, wepent, target )
            if self.l_Clip <= 0 then self:ReloadWeapon() return end

            -- Secondary grenade launcher
            if math.random(75) == 1 and self:GetRangeSquaredTo(target) <= (1000 * 1000) then
                self.l_WeaponUseCooldown = CurTime() + random(0.55, 0.75)

                wepent:EmitSound( "Weapon_AR2.Double", 70, 100, 1, CHAN_WEAPON )

                self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG )
                self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG )

                local vecThrow = ( (target:GetPos() + target:OBBCenter()) - wepent:GetPos() ):Angle()
    
                local grenade = ents.Create( "grenade_ar2" )
                if IsValid( grenade ) then
                    grenade:SetPos( (self:GetPos() + self:OBBCenter()) + vecThrow:Forward() * 32 + vecThrow:Up() * 32 )
                    grenade:SetAngles( vecThrow )
                    grenade:SetOwner( self )
                    grenade:Spawn()
                    grenade:SetVelocity( vecThrow:Forward()*1000 )
                    grenade:SetLocalAngularVelocity( AngleRand(-400, 400) )
                end
            else
                self.l_WeaponUseCooldown = CurTime() + 0.065

                wepent:EmitSound( "Weapon_SMG1.Single", 70, 100, 1, CHAN_WEAPON )

                self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1 )
                self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1 )

                self:HandleShellEject( "ShellEject" )
                self:HandleMuzzleFlash( 1 )

                bullettbl.Attacker = self
                bullettbl.Damage = 5
                bullettbl.Force = 5
                bullettbl.HullSize = 5
                bullettbl.Num = 1
                bullettbl.TracerName = tracer or "Tracer"
                bullettbl.Dir = ( target:WorldSpaceCenter() - wepent:GetPos() ):GetNormalized()
                bullettbl.Src = wepent:GetPos()
                bullettbl.Spread = Vector( 0.2, 0.2, 0 )
                bullettbl.IgnoreEntity = self

                self.l_Clip = self.l_Clip - 1

                wepent:FireBullets( bullettbl )
            end
            
            return true
        end,

        islethal = true,
    }

})