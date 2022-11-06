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
            self.l_WeaponUseCooldown = CurTime() + Rand(0.8, 0.95)

            wepent:EmitSound( "npc/zombie/claw_miss1.wav", 70, 100, 1, CHAN_WEAPON )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )
            
            -- To make sure damage syncs with the animation
            self:SimpleTimer(0.25, function()
                if self:GetRangeTo(target) > (70) then return end
                
                local dmg = random(25,30)
                local dmginfo = DamageInfo()
                dmginfo:SetDamage(dmg)
                dmginfo:SetAttacker(self)
                dmginfo:SetInflictor(wepent)
                dmginfo:SetDamageType(DMG_CLUB)
                dmginfo:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * dmg )
                
                wepent:EmitSound("physics/metal/metal_sheet_impact_hard"..random(6,7)..".wav", 70)
                wepent:EmitSound("physics/body/body_medium_impact_hard"..random(6)..".wav", 70)
                
                target:TakeDamageInfo( dmginfo )
            end)
            
            return true
        end,

        islethal = true,
    }

})