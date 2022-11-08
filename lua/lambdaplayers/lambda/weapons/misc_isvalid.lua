local random = math.random
local CurTime = CurTime
local Rand = math.Rand

table.Merge( _LAMBDAPLAYERSWEAPONS, {
--A really meme weapon that I don't think is worth it

    isvalid = {
        model = "models/lambdaplayers/validbar/w_validbar.mdl",
        origin = "Misc",
        prettyname = "IsValid()",
        holdtype = "melee2",
        ismelee = true,
        bonemerge = true,
        keepdistance = 10,
        attackrange = 70,
        
        callback = function( self, wepent, target )
            self.l_WeaponUseCooldown = CurTime() + 0.5

            wepent:EmitSound( "", 70, 100, 1, CHAN_WEAPON )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )
            
            -- To make sure damage syncs with the animation
            self:SimpleTimer(0.25, function()
                if self:GetRangeSquaredTo(target) > (70 * 70) then return end
                
                local dmg = DamageInfo()
                dmg:SetDamage( 5 )
                dmg:SetAttacker( self )
                dmg:SetInflictor( wepent )
                dmg:SetDamageType( DMG_CLUB )
                dmg:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * 5 )
                
                target:EmitSound( "", 70)
                
                target:TakeDamageInfo( dmg )
            end)
            
            return true
        end,

        islethal = true,
    }

})