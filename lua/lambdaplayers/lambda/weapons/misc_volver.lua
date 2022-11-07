local random = math.random
local CurTime = CurTime
local bullettbl = {}

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    volver = {
        model = "models/weapons/w_357.mdl",
        origin = "Misc",
        prettyname = "Volver",
        holdtype = "revolver",
        bonemerge = true,
        keepdistance = 550,
        attackrange = 3500,

        clip = 1,

        reloadtime = 3,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        reloadanimationspeed = 1,
        reloadsounds = { 
            { 0, "weapons/357/357_reload1.wav" }, 
            { 0.4, "weapons/357/357_reload4.wav" }, 
            { 1.5, "weapons/357/357_reload3.wav" }, 
            { 2.2, "weapons/357/357_spin1.wav" } 
        },

        --[[Draw = function( lambda, wepent )
            if IsValid( wepent ) then
                wepent:SetModelScale(wepent:GetModelScale() * 5, 1)
            end
        end,]]--Really want to make a very big one tbh

        callback = function( self, wepent, target )
            if self.l_Clip <= 0 then self:ReloadWeapon() return end

            self.l_WeaponUseCooldown = CurTime() + 5

            wepent:EmitSound( "weapons/pistol/pistol_empty.wav", 70, 100, 1, CHAN_WEAPON )

            self:SimpleTimer( 1, function()
                if !IsValid( self ) or !IsValid( target ) or !IsValid( wepent ) then return end
                wepent:EmitSound( "weapons/357/357_fire2.wav", 70, random(98,102), 1, CHAN_WEAPON )
                self:EmitSound( "ambient/explosions/explode_4.wav", 70, 100, 1, CHAN_WEAPON )
                self:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav",90)

                self:HandleMuzzleFlash( 7 )

                local pos = target:GetPos()+target:OBBCenter()

                bullettbl.Attacker = self
                bullettbl.Damage = 1000
                bullettbl.Force = 1000
                bullettbl.HullSize = 5
                bullettbl.Num = 1
                bullettbl.TracerName = "AR2Tracer"
                bullettbl.Dir = ( target:WorldSpaceCenter() - wepent:GetPos() ):GetNormalized()
                bullettbl.Src = wepent:GetPos()
                bullettbl.Spread = Vector( 0.05, 0.05, 0 )
                bullettbl.IgnoreEntity = self
                
                wepent:FireBullets( bullettbl )

                util.ScreenShake(self:GetPos(), 10, 170, 3, 1500)
                
                local dmg = DamageInfo()
                dmg:SetDamage( self:Health() * 100000 )
                dmg:SetDamageType( DMG_BLAST) 
                dmg:SetAttacker( self )
                dmg:SetInflictor( self )
                dmg:SetDamageForce( self:GetForward()*-80000000 )
                self:TakeDamageInfo( dmg )
            end)
            
            return true
        end,

        islethal = true,
    }

})