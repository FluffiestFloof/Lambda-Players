local CurTime = CurTime
local random = math.random
local bullettbl = {}
table.Merge( _LAMBDAPLAYERSWEAPONS, {
--Missing random and proper muzzleflash/shell ejection
--Random dmg / rof
--TODO

    dualelites = {
        model = "models/weapons/w_pist_elite.mdl",
        origin = "Counter Strike: Source",
        prettyname = "Dual Berettas",
        holdtype = "duel",
        bonemerge = true,
        keepdistance = 300,
        attackrange = 1800,

        clip = 30,
        tracername = "Tracer",
        damage = 1, --7 to 12 (zeta)
        spread = 0.26,
        rateoffire = 0.125, -- 0.15 to 0.4 (zeta)
        muzzleflash = 1,
        shelleject = "ShellEject",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL,
        attacksnd = "Weapon_ELITE.Single",

        reloadtime = 3.5,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_DUEL,
        reloadanimationspeed = 1,

        OnEquip = function( lambda, wepent )
            wepent:EmitSound( "Weapon_ELITE.Deploy", 70, 100, 1, CHAN_WEAPON )
        end,

        callback = function( self, wepent, target )
            if self.l_Clip <= 0 then self:ReloadWeapon() return end

            self.l_WeaponUseCooldown = CurTime() + rateoffire

            wepent:EmitSound( TranslateRandomization( snd ), 70, 100, 1, CHAN_WEAPON )

            self:RemoveGesture( gesture )
            self:AddGesture( gesture )
            
            self:HandleMuzzleFlash( muzzleflash )
            self:HandleShellEject( shelleject )

            bullettbl.Attacker = self
            bullettbl.Damage = damage
            bullettbl.Force = damage
            bullettbl.HullSize = 5
            bullettbl.Num = num or 1
            bullettbl.TracerName = tracer or "Tracer"
            bullettbl.Dir = ( target:WorldSpaceCenter() - wepent:GetPos() ):GetNormalized()
            bullettbl.Src = wepent:GetPos()
            bullettbl.Spread = Vector( spread, spread, 0 )
            bullettbl.IgnoreEntity = self

            self.l_Clip = self.l_Clip - 1

            wepent:FireBullets( bullettbl )

            return true
        end,

        --[[preCallback = function(callback, zeta, wep, target, blockData)
            wep.Elites_WhichGunWillFire = (!wep.Elites_WhichGunWillFire and 1 or (wep.Elites_WhichGunWillFire == 1 and 2 or 1))
            local subString = (wep.Elites_WhichGunWillFire == 2 and "2" or "")

            blockData.shell = true
            local shellAttach = wep:GetAttachment(wep:LookupAttachment("shell"..subString))
            if shellAttach then
                local shellEject = EffectData()
                shellEject:SetOrigin(shellAttach.Pos)
                shellEject:SetAngles(shellAttach.Ang)
                shellEject:SetEntity(wep)
                util.Effect("ShellEject", shellEject)
            end

            blockData.muzzle = true
            local muzzleAttach = wep:GetAttachment(wep:LookupAttachment("muzzle"..subString))
            if muzzleAttach then
                local muzzleFlash = EffectData()
                muzzleFlash:SetOrigin(muzzleAttach.Pos)
                muzzleFlash:SetAngles(muzzleAttach.Ang)
                muzzleFlash:SetScale(0.5)
                util.Effect("MuzzleEffect", muzzleFlash)
            end]]--

            return blockData
        end,

        islethal = true,
    }

})