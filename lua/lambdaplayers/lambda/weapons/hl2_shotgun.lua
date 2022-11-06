local CurTime = CurTime
local bullettbl = {}
table.Merge( _LAMBDAPLAYERSWEAPONS, {
--Missing double barrel secondary attack

    shotgun = {
        model = "models/weapons/w_shotgun.mdl",
        origin = "Half Life: 2",
        prettyname = "SPAS 12",
        holdtype = "shotgun",
        bonemerge = true,
        keepdistance = 150,
        attackrange = 500,

        clip = 6,
        bulletcount = 7,
        tracername = "Tracer",
        damage = 8,
        spread = 0.1,

        reloadtime = 3,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        reloadanimationspeed = 1,

        callback = function( self, wepent, target )
            if self.l_Clip <= 0 then self:ReloadWeapon() return end

                self.l_WeaponUseCooldown = CurTime() + 1

                wepent:EmitSound( "Weapon_Shotgun.Single", 70, 100, 1, CHAN_WEAPON )

                self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN )
                self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN )
                
                self:HandleMuzzleFlash( 1 )

                -- To simulate pump action after the shot
                self:SimpleTimer(0.5, function()
                    wepent:EmitSound( "Weapon_Shotgun.Special1", 70, 100, 1, CHAN_WEAPON )
                    self:HandleShellEject( "ShotgunShellEject" )
                end)

                bullettbl.Attacker = self
                bullettbl.Damage = 8
                bullettbl.Force = 8
                bullettbl.HullSize = 5
                bullettbl.Num = 7
                bullettbl.TracerName = tracer or "Tracer"
                bullettbl.Dir = ( target:WorldSpaceCenter() - wepent:GetPos() ):GetNormalized()
                bullettbl.Src = wepent:GetPos()
                bullettbl.Spread = Vector( 0.1, 0.1, 0 )
                bullettbl.IgnoreEntity = self

                self.l_Clip = self.l_Clip - 1

                wepent:FireBullets( bullettbl )
            
            return true
        end,

        islethal = true,
    }

})