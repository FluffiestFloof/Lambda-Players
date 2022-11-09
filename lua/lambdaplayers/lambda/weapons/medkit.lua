local random = math.random

table.Merge( _LAMBDAPLAYERSWEAPONS, {
--idk trying something

    medkit = {
        model = "models/weapons/w_medkit.mdl",
        origin = "Garry's Mod",
        prettyname = "Medkit",
        holdtype = "slam",
        ismelee = true,
        bonemerge = true,
        keepdistance = 10,
        attackrange = 50,

        clip = 100,

        OnEquip = function( lambda, wepent )
            lambda:Hook( "Think", "LambdaMedkit", function( )
                if self.l_Clip < 100 then
                    self.l_Clip = self.l_Clip + 2
                end
            end, nil, 1)
        end,

        callback = function( self, wepent, target )
            self.l_WeaponUseCooldown = CurTime() + 2.2

            wepent:EmitSound( "HealthKit.Touch", 70 )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM )
            
            -- To make sure damage syncs with the animation
            self:SimpleTimer( 0.75, function()
                if self:GetRangeSquaredTo( target ) > (65 * 65) then wepent:EmitSound("npc/zombie/claw_miss"..random(2)..".wav", 70) return end
                
                local dmg = random( 35, 55 )
                local dmginfo = DamageInfo()
                dmginfo:SetDamage( dmg )
                dmginfo:SetAttacker( self )
                dmginfo:SetInflictor( wepent )
                dmginfo:SetDamageType( DMG_SLASH )
                dmginfo:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * dmg )
                
                target:EmitSound( "npc/zombie/claw_strike"..random(3)..".wav", 70)
                
                -- HP regen on attacks
                if self:Health() < self:GetMaxHealth() * 2.25 and LambdaIsValid( target ) then
                    self:SetHealth( math_min( self:Health() + self:GetMaxHealth() * Rand(0.10, 0.25), self:GetMaxHealth() * 2.25 ) )
                end
                
                target:TakeDamageInfo( dmginfo )
            end)
            
            return true
        end,

        islethal = false,
    }

})