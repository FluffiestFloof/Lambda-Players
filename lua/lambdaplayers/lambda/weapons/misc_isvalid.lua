local random = math.random
local CurTime = CurTime
local Effect = util.Effect

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    isvalid = {
        model = "models/lambdaplayers/validbar/w_validbar.mdl",
        origin = "Misc",
        prettyname = "IsValidBar",
        holdtype = "melee2",
        ismelee = true,
        bonemerge = true,
        keepdistance = 10,
        attackrange = 70,
        
        callback = function( self, wepent, target )
            if random(10) == 1 then
                self.l_WeaponUseCooldown = CurTime() + 1.5

                wepent:EmitSound( "Weapon_Crowbar.Single", 70, 100, 1, CHAN_WEAPON )
                self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )
                self:SetLayerPlaybackRate( self:AddGesture( ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND ), 0.6 )
                
                self:SimpleTimer( 0.8, function()
                    if self:GetRangeSquaredTo(target) > ( 70 * 70 ) then return end

                    if target:IsPlayer() then
                        self:Hook( "PlayerDeath", function(victim, inflictor, attacker)
                            if target == victim and wepent == inflictor and self == attacker then
                                print("blip")
                                target:GetRagdollEntity():Remove()
                            end
                            return false
                        end)-- Really didn't find a better way yet
                    
                    local dmg = DamageInfo()
                    dmg:SetDamage( target:GetMaxHealth()*5 )
                    dmg:SetAttacker( self )
                    dmg:SetInflictor( wepent )
                    dmg:SetDamageType( DMG_DISSOLVE )
                    dmg:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * 5 )
                    
                    target:EmitSound( "buttons/button15.wav", 90 )

                    local effect = EffectData()
                        effect:SetOrigin( target:WorldSpaceCenter() )
                        effect:SetMagnitude( 1 )
                        effect:SetScale( 2 )
                        effect:SetRadius( 4 )
                        effect:SetEntity( target )
                    Effect( "entity_remove", effect, true, true )
                    
                    target:TakeDamageInfo( dmg )


                end)
            else
                self.l_WeaponUseCooldown = CurTime() + 0.5

                wepent:EmitSound( "Weapon_Crowbar.Single", 70, 100, 1, CHAN_WEAPON )
                self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )
                self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )
                
                -- To make sure damage syncs with the animation
                self:SimpleTimer( 0.25, function()
                    if self:GetRangeSquaredTo(target) > ( 70 * 70 ) then return end
                    
                    local dmg = DamageInfo()
                    dmg:SetDamage( dmg:GetDamage()+3 )--thonk
                    dmg:SetAttacker( self )
                    dmg:SetInflictor( wepent )
                    dmg:SetDamageType( DMG_CLUB )
                    dmg:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * 5 )
                    
                    wepent:EmitSound( "EpicMetal.ImpactHard" )
                    wepent:EmitSound( "Flesh.ImpactHard" )
                    
                    target:TakeDamageInfo( dmg )
                end)
            end
            
            return true
        end,

        islethal = true,
    }

})