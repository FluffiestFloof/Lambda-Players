local physgunGlowMat = Material("sprites/orangelight1")
local random = math.random
local math_min = math.min
local IsValid = IsValid
local TraceLine = util.TraceLine
local util_Effect = util.Effect
local tracetbl = {}

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    gravgun = {
        model = "models/weapons/w_physics.mdl",
        origin = "Garry's Mod",
        prettyname = "Gravity Gun",
        bonemerge = true,
        holdtype = "physgun",

        OnDamage = function( lambda, wepent, dmginfo )
            if IsValid( lambda ) then
                lambda:PreventWeaponSwitch( false )
            end
        end,

        OnEquip = function( lambda, wepent )
            lambda:Hook( "Think", "GravGunThink", function( )
                local find = lambda:FindInSphere( lambda:GetPos(), 150, function( ent ) if !ent:IsNPC() and ent:GetClass()=="prop_physics" and !ent:IsPlayer() and !ent:IsNextBot() and lambda:CanSee( ent ) and IsValid( ent:GetPhysicsObject() ) and lambda:HasPermissionToEdit( ent ) then return true end end )
                local prop = find[ random( #find ) ]

                lambda:LookTo( prop, 3 )

                lambda:SimpleTimer( 1, function() -- To let the lambda aim properly
                    if !IsValid( prop ) then return end
                    lambda:UseWeapon( prop )
                end)
            
            end, nil, 1) -- Let's not think too much
        end,

        callback = function( self, wepent, target )
            local trace = self:Trace( target:WorldSpaceCenter() )

            local phys = target:GetPhysicsObjectNum(0)

            if IsValid( phys ) then
                if self:GetRangeSquaredTo( target ) > ( 175 * 175 ) then print("toofar") wepent:EmitSound( "weapons/physcannon/physcannon_dryfire.wav", 70 ) return end
                wepent:EmitSound( "weapons/physcannon/superphys_launch"..random( 1, 3)..".wav", 70, random( 110, 120 ) )

                local totalMass = 0
                for i = 0, target:GetPhysicsObjectCount() - 1 do
                    local subphys = target:GetPhysicsObjectNum(i)
                    totalMass = totalMass + subphys:GetMass()
                end

                local actualMass = math_min(totalMass, 250)
                local mainPhys = target:GetPhysicsObject()

                for i = 0, target:GetPhysicsObjectCount() - 1 do
                    local subphys = target:GetPhysicsObjectNum(i)
                    local ratio = phys:GetMass() / totalMass
                    if subphys == mainPhys then
                        ratio = ratio + 0.5
                        ratio = math_min(ratio, 1.0)
                    else
                        ratio = ratio * 0.5
                    end

                    subphys:ApplyForceCenter( self:GetAimVector() * 15000 * ratio)
                    subphys:ApplyForceOffset( self:GetAimVector() * actualMass * 600 * ratio, trace.HitPos)
                end

                local muzzle = wepent:GetAttachment( wepent:LookupAttachment( "core" ) )

                -- Punt beam. Placeholder but close enough.
                local effect = EffectData()
                effect:SetStart( muzzle.Pos )
                effect:SetOrigin( target:GetPos() )
                effect:SetEntity( wepent )
                effect:SetScale( 4000 )
                util_Effect( "GaussTracer", effect, true, true)

                -- Simulate the spark that emits from punted object
                local effect = EffectData()
                effect:SetOrigin( target:WorldSpaceCenter() )
                effect:SetScale(2)
                effect:SetMagnitude(4)
                effect:SetRadius(3)
                util_Effect( "Sparks", effect, true, true)

                -- Glow. Placeholder.
                local effect = EffectData()
                effect:SetOrigin( muzzle.Pos )
                effect:SetScale(1)
                effect:SetMagnitude(2)
                effect:SetRadius(2)
                effect:SetFlags(1)
                util_Effect( "MuzzleFlash", effect, true, true)
            else
                wepent:EmitSound( "weapons/physcannon/physcannon_dryfire.wav", 70 )
            end

            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_PHYSGUN )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_PHYSGUN )
            
            return true
        end,

        OnUnequip = function( lambda, wepent )
            lambda:RemoveHook( "Think", "GravGunThink" )
        end,

        islethal = false,

    }

})
