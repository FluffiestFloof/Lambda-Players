local CurTime = CurTime
local random = math.random
local Rand = math.Rand
local IsValid = IsValid
local Effect = util.Effect
local ScreenShake = util.ScreenShake
local BlastDamage = util.BlastDamage

local convar = CreateLambdaConvar( "lambdaplayers_weapons_paigsentrybuster", 0, true, false, true, "If Lambda that spawn with the PAIG should act like the Sentry Buster. TF2 REQUIRED!", 0, 1, { type = "Bool", name = "PAIG - Enable Sentry Buster Mode", category = "Weapon Utilities" } )

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    paig = {
        model = "models/weapons/w_grenade.mdl",
        origin = "Misc",
        prettyname = "Punch Activated Impact Grenade",
        holdtype = "grenade",
        killicon = "npc_grenade_frag",
        ismelee = true,
        bonemerge = true,
        keepdistance = 5,
        attackrange = 50,
        addspeed = 50,

        OnEquip = function( lambda, wepent )
            if IsMounted( "tf" ) then wepent.tf2mounted = true end -- If user doesn't have TF2, don't do anything special with PAIG
            
            if wepent.tf2mounted and GetConVar( "lambdaplayers_weapons_paigsentrybuster" ):GetBool() then
                wepent.PAIG_SBLoop = CreateSound( wepent, "mvm/sentrybuster/mvm_sentrybuster_loop.wav" )
                lambda:EmitSound( "mvm/sentrybuster/mvm_sentrybuster_intro.wav" )
                wepent:CallOnRemove("lambda_paig_sb_stopsound" ..wepent:EntIndex(), function()
                    if wepent.PAIG_SBLoop then wepent.PAIG_SBLoop:Stop() wepent.PAIG_SBLoop = nil end
                end)
                lambda:SimpleTimer( 0.3, function()
                    if wepent.PAIG_SBLoop then wepent.PAIG_SBLoop:Play() end
                end)
            else
                wepent:EmitSound( "weapons/pinpull.wav", 70 )
            end

        end,

        OnUnequip = function( lambda, wepent )
            if wepent.tf2mounted then lambda:StopSound( "mvm/sentrybuster/mvm_sentrybuster_loop.wav" ) end
        end,

        -- Stop sound on death
        OnDamage = function( lambda, wepent, dmginfo )
            if IsValid( lambda ) and dmginfo:GetDamage() > lambda:Health() then
                lambda:ManipulateBoneAngles( lambda:LookupBone("ValveBiped.Bip01_Spine"), angle_zero )
                if wepent.PAIG_SBLoop then wepent.PAIG_SBLoop:Stop() end
            end
        end,

        callback = function( self, wepent, target )
            self.l_WeaponUseCooldown = CurTime() + 4
            local dur = 0.3

            if wepent.tf2mounted and GetConVar( "lambdaplayers_weapons_paigsentrybuster" ):GetBool() then
                dur = SoundDuration("mvm/sentrybuster/mvm_sentrybuster_spin.wav")
                
                wepent:EmitSound( "mvm/sentrybuster/mvm_sentrybuster_spin.wav" )
                if wepent.PAIG_SBLoop then wepent.PAIG_SBLoop:Stop() end

                -- Simulate the Sentry Buster spin. Might cause issues?
                self:Hook( "Think", "PAIGSpin", function( )
                    self:ManipulateBoneAngles( self:LookupBone("ValveBiped.Bip01_Spine"), Angle( 0, 0, CurTime() * 600 ) )
                end, nil, 0.001)
            else
                wepent:EmitSound( "WeaponFrag.Throw", 70 )
                self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE )
                self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE )
            end

            --[[for _, v in ipairs( ents.FindByClass( "npc_lambdaplayer" ) ) do
                if v != self and v:GetRangeSquaredTo ( self ) <= ( 400*400 ) and v:Visible( self ) and LambdaIsValid( v ) then
                    v:SimpleTimer( Rand( 0.1, 0.5 ), function()
                        if LambdaIsValid( v ) then return end
                        --v:SetState( "Panic" )
                        --Play random scream
                    end)
                end
            end]]
            
            self:SimpleTimer( dur, function()
                if !IsValid( self ) or !IsValid( wepent ) then if wepent.tf2mounted then self:ManipulateBoneAngles( self:LookupBone("ValveBiped.Bip01_Spine"), Angle( 0, 0, 0 ) ) end return end
                
                local effect = EffectData()
                effect:SetOrigin( wepent:GetPos() )
                Effect( "Explosion", effect, true, true )
                
                BlastDamage( self, self, wepent:GetPos(), 400, 1000 )

                if wepent.tf2mounted and GetConVar( "lambdaplayers_weapons_paigsentrybuster" ):GetBool() then
                    ScreenShake( wepent:GetPos(), 25, 5, 3, 1000 )
                        
                    ParticleEffect( "fluidSmokeExpl_ring_mvm", wepent:GetPos() + Vector( 50, 50, 25 ), wepent:GetAngles() )
                    ParticleEffect( "fluidSmokeExpl_ring_mvm", wepent:GetPos() + Vector( -50, -50, 25 ), wepent:GetAngles() )
                    ParticleEffect( "fluidSmokeExpl_ring_mvm", wepent:GetPos() + Vector( -50, 50, 25 ), wepent:GetAngles() )
                    ParticleEffect( "fluidSmokeExpl_ring_mvm", wepent:GetPos() + Vector( 50, -50, 25 ), wepent:GetAngles() )
                    ParticleEffect( "fluidSmokeExpl_ring_mvm", wepent:GetPos() + Vector( -50, -50, 25 ), wepent:GetAngles() )
                    ParticleEffect( "fluidSmokeExpl_ring_mvm", wepent:GetPos() + Vector( 50, -50, 25 ), wepent:GetAngles() )
    
                    for _, v in ipairs( ents.FindInSphere( wepent:GetPos(), 1000 ) ) do
                        if IsValid( v ) and v:IsPlayer() then
                            local screenfade_rand = random( 1, 2 )
                            if screenfade_rand == 1 then
                                v:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), 1.0, 0.1)
                            elseif screenfade_rand == 2 then
                                v:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 120), 1.0, 0.1)
                            end
                        end
                    end
                    self:StopSound( "mvm/sentrybuster/mvm_sentrybuster_spin.wav" )
                    self:ManipulateBoneAngles( self:LookupBone("ValveBiped.Bip01_Spine"), Angle( 0, 0, 0 ) )
                else
                    wepent:EmitSound( "BaseExplosionEffect.Sound" , 90 )
                end

            end)
            
            return true
        end,

        islethal = true,
    }
    

})