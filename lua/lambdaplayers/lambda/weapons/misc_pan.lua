local random = math.random
local CurTime = CurTime
local Rand = math.Rand
table.Merge( _LAMBDAPLAYERSWEAPONS, {

    pan = {
        model = "models/lambdaplayers/pan/w_pan.mdl",
        origin = "Misc",
        prettyname = "Frying Pan",
        holdtype = "melee",
        ismelee = true,
        bonemerge = true,
        keepdistance = 10,
        attackrange = 70,
        
        callback = function( self, wepent, target )
            self.l_WeaponUseCooldown = CurTime() + 0.5

            wepent:EmitSound( "lambdaplayers/pan/pan_miss.wav", 70, 100, 1, CHAN_WEAPON )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )
            
            -- To make sure damage syncs with the animation
            self:SimpleTimer(0.25, function()
                if self:GetRangeSquaredTo(target) > (70 * 70) then return end
                
                local dmg = 15
                local dmginfo = DamageInfo()
                dmginfo:SetDamage(dmg)
                dmginfo:SetAttacker(self)
                dmginfo:SetInflictor(wepent)
                dmginfo:SetDamageType(DMG_CLUB)
                dmginfo:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * dmg )
                
                target:EmitSound("lambdaplayers/pan/melee_frying_pan_0"..random(4)..".wav", 70)
                
                target:TakeDamageInfo( dmginfo )
            end)
            
            return true
        end,

        islethal = true,
    }

})