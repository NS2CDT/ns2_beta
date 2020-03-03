-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\PowerPoint_Client.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/PowerPointLightHandler.lua")

PowerPoint.kDisabledColor = Color(0.5, 0.05, 0)
PowerPoint.kDisabledCommanderColor = Color(1, 0.05, 0.05)
PowerPoint.kAuxPowerCycleTime = 1.5
-- chance of a aux light flickering when powering up
PowerPoint.kAuxFlickerChance = 0
-- chance of a full light flickering when powering up
PowerPoint.kFullFlickerChance = 0.30

-- determines if aux lights will randomly fail after they have come on for a certain amount of time
PowerPoint.kAuxLightsFail = false

-- max varying delay to turn on full lights
PowerPoint.kMaxFullLightDelay = 4
-- min 2 seconds from repairing the node till the light goes on
PowerPoint.kMinFullLightDelay = 2
-- how long time for the light to reach full power (PowerOnTime was a bit brutal and give no chance for the flicker to work)
PowerPoint.kFullPowerOnTime = 4

-- max varying delay to turn on aux lights
PowerPoint.kMaxAuxLightDelay = 4

-- minimum time that aux lights are on before they start going out
PowerPoint.kAuxLightSafeTime = 20 -- short for testing, should be like 300 (5 minutes)
-- maximum time for a power point to stay on after the safe time
PowerPoint.kAuxLightFailTime = 20 -- short .. should be like 600 (10 minues)
-- how long time a light takes to go from full aux power to dead (last 1/3 of that time is spent flickering)
PowerPoint.kAuxLightDyingTime = 20

PowerPoint.kImpulseEffect = PrecacheAsset("cinematics/marine/powerpoint_impulse2.cinematic")
PowerPoint.kImpulseAtStructureEffect = PrecacheAsset("cinematics/marine/powerpoint_impulse_contract2.cinematic")

-- regulates impulse effect interval and 1.5 seconds later effect at structures
PowerPoint.kImpulseEffectFrequency = 25

function PowerPoint:GetShowHealthFor(player)
    return self:GetCanTakeDamage()
end

function PowerPoint:UpdatePoweredLights()

    PROFILE("PowerPoint:UpdatePoweredLights") 
    
    if not self.lightHandler then    
        self.lightHandler = PowerPointLightHandler():Init(self)
    end
    
    local time = Shared.GetTime()
    -- max 20 updates per second
    if self.lastUpdatedTime == nil or time - self.lastUpdatedTime > 0.05 then   
        self.lastUpdatedTime = time
        self.lightHandler:Run(self:GetLightMode())

        self:UpdateModelHighlight()
    end

end

function PowerPoint:CreateImpulseEffect()

    self.impulseEffect = Client.CreateCinematic(RenderScene.Zone_Default)
    self.impulseEffect:SetCinematic(PowerPoint.kImpulseEffect)        
    self.impulseEffect:SetRepeatStyle(Cinematic.Repeat_None)
    self.impulseEffect:SetCoords(self:GetCoords())
    
    self.lastImpulseEffect = Shared.GetTime()

end

function PowerPoint:CreateImpulseStructureEffect()

    if self.structuresAtLocation then
    
        for _, structureId in ipairs(self.structuresAtLocation:GetList()) do
        
            local structure = Shared.GetEntity(structureId)
        
            if structure ~= nil and structure.GetIsBuilt and structure:GetIsBuilt() then
            
                local structureImpulseEffect = Client.CreateCinematic(RenderScene.Zone_Default)
                local vec = self:GetOrigin() - structure:GetOrigin()   
                vec:Normalize()             
                local angles = Angles(self:GetAngles())
                
                angles.yaw = GetYawFromVector(vec)
                angles.pitch = GetPitchFromVector(vec)
                
                
                local effectCoords = angles:GetCoords()  
                effectCoords.origin = structure:GetOrigin()
                
                structureImpulseEffect:SetCoords(effectCoords)
                structureImpulseEffect:SetRepeatStyle(Cinematic.Repeat_None)
                structureImpulseEffect:SetCinematic(PowerPoint.kImpulseAtStructureEffect)
        
            end
        
        end
    
    end

end

function PowerPoint:RegisterStructure(structureId)

    if not self.structuresAtLocation then
        self.structuresAtLocation = unique_set()
    end
    
    self.structuresAtLocation:Insert(structureId)

end

function PowerPoint:UnregisterStructure(structureId)

    if not self.structuresAtLocation then
        self.structuresAtLocation = unique_set()
        return
    end
    
    self.structuresAtLocation:Remove(structureId)

end

function PowerPoint:OnDestroy()

    if self.lowPowerEffect then
        Client.DestroyCinematic(self.lowPowerEffect)
        self.lowPowerEffect = nil
    end

    if self.noPowerEffect then
        Client.DestroyCinematic(self.noPowerEffect)
        self.noPowerEffect = nil
    end

    self.structuresAtLocation = nil

    ScriptActor.OnDestroy(self)

end

function PowerPoint:GetShowCrossHairText()
    return self:GetPowerState() ~= PowerPoint.kPowerState.unsocketed
end

function PowerPoint:GetUnitNameOverride(viewer)

    local unitName = GetDisplayName(self)
    if not self:GetCanTakeDamage() then
        unitName = unitName .. " (" .. Locale.ResolveString("INDESTRUCTABLE") .. ")"
    end

    return unitName
    
end

-- Update Alien Vision highlight. Only highlight when Aliens can deal damage
function PowerPoint:UpdateModelHighlight()
    local canTakeDamage = self:GetCanTakeDamage()
    if not self.highlightModel and canTakeDamage then
        self.highlightModel = true
    elseif self.highlightModel and not canTakeDamage then
        self.highlightModel = false
    end

    self:SetHighlightNeedsUpdate()
end

function PowerPoint:OnUpdateRender()

    PROFILE("PowerPoint:OnUpdateRender")

    if self:GetIsSocketed() then

        local model = self:GetRenderModel()
        self:InstanceMaterials()
        
        if model then

            local amount = 0
            if self:GetIsPowering() then
                local animVal = (math.cos(Shared.GetTime()) + 1) / 2
                amount = 1 + (animVal * 5)
            end
            model:SetMaterialParameter("emissiveAmount", amount)

        end
        
    end
    
end

function PowerPoint:GetBuildFraction()
 
    if not self:GetIsBuilt() then
        return self.buildFraction * 100
    else
        return self:GetHealthScalar() * 100
    end
    
end

function PowerPoint:OnUpdatePoseParameters()
    self:SetPoseParam("build", self:GetBuildFraction())
end

-- Only highlight by ALien Vision when the PowerPoint can take damage
function PowerPoint:SetIsHighlightEnabled()
    if self.highlightModel then
        return 0.98 -- Marine Team
    end

    return 0
end

