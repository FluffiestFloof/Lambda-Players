if !IsMounted( "ep2" ) then return end

local IsValid = IsValid
local CurTime = CurTime
local CreateEntity = ents.Create
local VectorRand = VectorRand
local ShootSound = Sound( "NPC_Hunter.FlechetteShoot" )
local ShellOffPos = Vector( 3, 5, 5 )
local ShellOffAng = Angle( -180, 0, 0 )

table.Merge( _LAMBDAPLAYERSWEAPONS, {

    flechettegun = {
        model = "models/weapons/w_smg1.mdl",
        origin = "Garry's Mod",
        prettyname = "Flechette Gun",
        holdtype = "smg",
        bonemerge = true,
        waterproof = true,
        keepdistance = 400,
        attackrange = 1500,

        callback = function( self, wepent, target )
            local ent = CreateEntity( "hunter_flechette" )
            if !IsValid( ent ) then return true end

            wepent:EmitSound( ShootSound )

            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1 )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1 )

            self.l_WeaponUseCooldown = CurTime() + 0.1
            self:HandleMuzzleFlash( 1 )
            self:HandleShellEject( "ShellEject", ShellOffPos, ShellOffAng )

            local spawnPos = self:GetAttachmentPoint( "eyes" ).Pos
            local targetAng = ( target:WorldSpaceCenter() - spawnPos ):Angle()

            ent:SetPos( spawnPos + targetAng:Forward() * 32 )
            ent:SetAngles( targetAng )
            ent:SetOwner( self )
            ent:Spawn()
            ent:Activate()
            ent:SetVelocity( targetAng:Forward() * 2000 + VectorRand( -150, 150 ) )

            return true
        end,

        islethal = true
    }

})