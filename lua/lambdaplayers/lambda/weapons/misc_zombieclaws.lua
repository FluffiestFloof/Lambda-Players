local random = math.random
table.Merge( _LAMBDAPLAYERSWEAPONS, {
-- Missing a lot from the Zeta version
-- Missing leap attack, regen overtime, hp on kill

    zombieclaws = {
        model = "models/hunter/plates/plate.mdl",
        origin = "Misc",
        prettyname = "Zombie Claws",
        holdtype = "zombie",
        ismelee = true,
        nodraw = true,
        keepdistance = 30,
        attackrange = 65,
        addspeed = 100,
        OnEquip = function( lambda, wepent )
            --I'm sure this is fine will not cause a single issue :)
            lambda:Hook( "EntityTakeDamage", "ZombieClawsETD", function( target, dmginfo )
                if target == lambda then
                    dmginfo:ScaleDamage( 0.75 )
                end
            end)
        end,
        
        OnUnequip = function( lambda, wepent )
            --Can't test it but I hope it works
            lambda:RemoveHook( "EntityTakeDamage", "ZombieClawsETD" )
        end,
        
        callback = function( self, wepent, target )
            self.l_WeaponUseCooldown = CurTime() + 1.25

            wepent:EmitSound( "npc/zombie/zo_attack"..random(2)..".wav", 70, 100, 1, CHAN_WEAPON )
            self:RemoveGesture( ACT_GMOD_GESTURE_RANGE_ZOMBIE )
            self:AddGesture( ACT_GMOD_GESTURE_RANGE_ZOMBIE )
            
            -- To make sure damage syncs with the animation
            timer.Simple(0.75, function()
                if !IsValid(self) or self:GetIsDead() or !IsValid(target) or self:GetRangeTo(target) > (65) then return end
                
                local dmg = random(35,55)
                local dmginfo = DamageInfo()
                dmginfo:SetDamage(dmg)
                dmginfo:SetAttacker(self)
                dmginfo:SetInflictor(wepent)
                dmginfo:SetDamageType(DMG_SLASH)
                dmginfo:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * dmg )
                
                target:EmitSound("npc/zombie/claw_strike"..random(3)..".wav", 70)
                -- HP regen on attacks
                -- check if target:Alive because currently lambda just keep attacking the player entity
                if self:Health() < self:GetMaxHealth() * 2.25 then
                    self:SetHealth(math.min(self:Health() + self:GetMaxHealth() * math.Rand(0.10, 0.25), self:GetMaxHealth() * 2.25))
                end
                
                
                
                target:TakeDamageInfo( dmginfo )
            end)
            
            return true
        end,
        
        islethal = true,
    }

})