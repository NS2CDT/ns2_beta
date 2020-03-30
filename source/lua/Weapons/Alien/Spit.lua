-- ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\Weapons\Alien\Spit.lua
--
--    Created by:   Andreas Urwalek (andi@unknownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/DamageMixin.lua")
Script.Load("lua/SharedDecal.lua")

PrecacheAsset("materials/infestation/spit_decal.surface_shader")

class 'Spit' (PredictedProjectile)

Spit.kMapName = "spit"
Spit.kDamage = kSpitDamage
Spit.kClearOnImpact = true
Spit.kClearOnEnemyImpact = true

local networkVars =
{
}

local kSpitLifeTime = 8

Spit.kProjectileCinematic = PrecacheAsset("cinematics/alien/gorge/dripping_slime.cinematic")
Spit.kRadius = 0.15

AddMixinNetworkVars(TeamMixin, networkVars)

function Spit:OnCreate()

    PredictedProjectile.OnCreate(self)
    
    InitMixin(self, DamageMixin)
    
    if Server then
        self:AddTimedCallback(Spit.TimeUp, kSpitLifeTime)
    end

end

function Spit:GetDeathIconIndex()
    return kDeathMessageIcon.Spit
end

function Spit:GetVampiricLeechScalar()
    return kSpitVampirismScalar
end

function Spit:GetBlightCategory( fromTechId )
    if fromTechId == self:GetWeaponTechId() then
        return kBlightCategory.Primary
    else
        return kBlightCategory.None
    end
end

function Spit:GetWeaponTechId()
    return kTechId.Spit
end

function Spit:GetMaxFocusBonusDamage()
    return kSpitFocusDamageBonusAtMax
end

function Spit:GetFocusAttackCooldown()
    return kSpitFocusAttackSlowAtMax
end

if Server then

    local function OrderBabblerToAttack(this, target, targetPos)
        local owner = this:GetOwner()
        if not owner then return end

        local orig = owner:GetOrigin()
        for _, babbler in ipairs(GetEntitiesForTeamWithinRange("Babbler", owner:GetTeamNumber(), orig, 6))
        do
            if babbler:GetOwner() == owner and not babbler:GetIsClinged() then
                babbler:SetMoveType(kBabblerMoveType.Attack, target, targetPos, true)
            end
        end
    end

    function Spit:ProcessHit(targetHit, surface, normal, hitPoint)

        if self:GetOwner() ~= targetHit then
            self:DoDamage(kSpitDamage, targetHit, hitPoint, normal, "none", false, false)
            OrderBabblerToAttack(self, targetHit, hitPoint)
        elseif self:GetOwner() == targetHit then
            --a little hacky
            local player = self:GetOwner()
            if player then
                local eyePos = player:GetEyePos()
                local viewCoords = player:GetViewCoords()
                local trace = Shared.TraceRay(eyePos, eyePos + viewCoords.zAxis * 1.5, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterOneAndIsa(player, "Babbler"))
                if trace.fraction ~= 1 then
                    local entity = trace.entity
                    self:DoDamage(kSpitDamage, entity, hitPoint, normal, "none", false, false)
                end
            end
        end

        self:TriggerEffects("spit_hit", { effecthostcoords = self:GetCoords() })

        DestroyEntity(self)

    end
  
    function Spit:TimeUp()

        DestroyEntity(self)
        return false
        
    end
    
end

Shared.LinkClassToMap("Spit", Spit.kMapName, networkVars)