local CurTime = CurTime
local random = math.random
local Rand = math.Rand
local Effect = util.Effect
local ScreenShake = util.ScreenShake
local BlastDamage = util.BlastDamage
--local convar = CreateLambdaConvar( "lambdaplayers_weapons_paigsentrybuster", 0, true, false, true, "If Lambda that spawn with the PAIG have the ability to act like the Sentry Buster from TF2.", 0, 1, { type = "Bool", name = "PAIG - Enable Sentry Buster Mode", category = "Weapon Utilities" } )

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    paig = {
        model = "models/weapons/w_grenade.mdl",
        origin = "Misc",
        prettyname = "Punch Activated Impact Grenade",
        holdtype = "grenade",
        ismelee = true,
        bonemerge = true,
        keepdistance = 5,
        attackrange = 50,
        addspeed = 50,

        OnEquip = function( lambda, wepent )
            if IsMounted('tf') then tf2=true end -- If user doesn't have TF2, the convar is pretty much useless

            if tf2 and GetConVar( "lambdaplayers_weapons_paigsentrybuster" ):GetBool() then
                lambda:EmitSound( "mvm/sentrybuster/mvm_sentrybuster_intro.wav" )
                lambda:SimpleTimer( 0.3, function()
                    lambda:EmitSound( "mvm/sentrybuster/mvm_sentrybuster_loop.wav" )
                end)
            else
                wepent:EmitSound( "weapons/pinpull.wav", 70 )
            end
        end,

        OnUnequip = function( lambda, wepent )
            lambda:StopSound( "mvm/sentrybuster/mvm_sentrybuster_loop.wav" )
        end,

        -- Stop sound on death
        OnDamage = function( lambda, wepent, dmginfo )
            print(lambda:Health())
            if IsValid( lambda ) and lambda:GetIsDead() then
                lambda:StopSound( "mvm/sentrybuster/mvm_sentrybuster_loop.wav" )
            end
        end,

        callback = function( self, wepent, target )
            self.l_WeaponUseCooldown = CurTime() + 4
            local dur = 0.3

            if tf2 and GetConVar( "lambdaplayers_weapons_paigsentrybuster" ):GetBool() then
                dur = SoundDuration("mvm/sentrybuster/mvm_sentrybuster_spin.wav")
                wepent:EmitSound( "mvm/sentrybuster/mvm_sentrybuster_spin.wav" )
                self:StopSound( "mvm/sentrybuster/mvm_sentrybuster_loop.wav" )

                --[[self:Hook( "Think", "PAIGSpin", function( )
                    self:ManipulateBoneAngles( self:LookupBone("ValveBiped.Bip01_Spine"), Angle( 0, 0, RealTime() * 460 ) )
                    print(self:Health())
                    if self:Health() < 1 then -- very hacky fix
                        self:ManipulateBoneAngles( self:LookupBone("ValveBiped.Bip01_Spine"), Angle( 0, 0, RealTime()*0 ) )
                        self:StopSound( "mvm/sentrybuster/mvm_sentrybuster_loop.wav" )
                        self:StopSound( "mvm/sentrybuster/mvm_sentrybuster_spin.wav" )
                    end
                end, nil, 0.001)]] -- An interesting idea that cause more problem than it's worth
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
                        --v:GetRandomSound()
                        --Play random scream
                    end)
                end
            end]]
            
            self:SimpleTimer( dur, function()
                if !IsValid( self ) or !IsValid( wepent ) then self:ManipulateBoneAngles( self:LookupBone("ValveBiped.Bip01_Spine"), Angle( 0, 0, 0 ) ) return end
                
                local effect = EffectData()
                effect:SetOrigin( wepent:GetPos() )
                Effect( "Explosion", effect, true, true )
                
                BlastDamage( self, self, wepent:GetPos(), 400, 1000 )

                if tf2 and GetConVar( "lambdaplayers_weapons_paigsentrybuster" ):GetBool() then
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