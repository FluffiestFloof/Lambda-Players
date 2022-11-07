local CurTime = CurTime
local random = math.random
table.Merge( _LAMBDAPLAYERSWEAPONS, {

    crossbow = {
        model = "models/weapons/w_crossbow.mdl",
        origin = "Half Life: 2",
        prettyname = "Crossbow",
        holdtype = "crossbow",
        bonemerge = true,
        keepdistance = 400,
        attackrange = 3500,

        clip = 1,

        reloadtime = 1.8,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimationspeed = 1,
        reloadsounds = { {0, "Weapon_Crossbow.Reload"}, {1, "Weapon_Crossbow.BoltElectrify"} },

        callback = function( self, wepent, target )
            if self.l_Clip <= 0 then self:ReloadWeapon() return end
            self.l_WeaponUseCooldown = CurTime() + 1.2

            wepent:EmitSound( "Weapon_Crossbow.Single", 70, 100, 1, CHAN_WEAPON )

            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW )

            local dir = (target:GetCenteroid() - wepent:GetPos() + Vector(random(-40,40),0,random(-50,50))):Angle()
    
            local bolt = ents.Create("crossbow_bolt")
            bolt:SetPos( self:GetCenteroid() + dir:Forward() * 64)
            bolt:SetAngles(dir)
            bolt:Spawn()
            bolt:Activate()
            bolt:SetVelocity( dir:Forward() * (self:WaterLevel() == 3 and 1500 or 2500) )

            local flySnd = CreateSound( bolt, "Weapon_Crossbow.BoltFly" )
            if flySnd then flySnd:Play() end
            bolt:CallOnRemove("lambdaplayer_crossbowbolt_"..bolt:EntIndex(), function()                    
                if flySnd then flySnd:Stop() end

                local find = FindInSphereFilt(bolt:GetPos(), 2, function(ent)
                    return (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer())
                end)
                if !IsValid(find[1]) then return end
                
                local dmg = DamageInfo()
                dmg:SetDamage(100)
                dmg:SetDamageType(bit.bor(DMG_BULLET, DMG_NEVERGIB))
                dmg:SetAttacker(self or bolt)
                dmg:SetInflictor(bolt)
                find[1]:TakeDamageInfo(dmg)
            end)

            self.l_Clip = self.l_Clip - 1
            
            return true
        end,

        islethal = true,
    }

})