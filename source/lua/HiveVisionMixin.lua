-- ======= Copyright (c) 2012, Unknown Worlds Entertainment, Inc. All rights reserved. ==========
--
-- lua\HiveVision.lua
--
--    Created by:   Max McGuire (max@unknownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

HiveVisionMixin = CreateMixin( HiveVisionMixin )
HiveVisionMixin.type = "HiveVision"

HiveVisionMixin.expectedMixins =
{
    Team = "For making friendly players visible",
    Model = "For copying bonecoords and drawing model in view model render zone.",
}

function HiveVisionMixin:__initmixin()
    
    PROFILE("HiveVisionMixin:__initmixin")
    
    if Client then
        self.hiveSightVisible = false
        self.nextFriendlyHiveVisionCheck = 0
        self.timeHiveVisionChanged = 0
        self.lastParasited = false
        self.lastBlighted = false
    end

end

if Client then

    function HiveVisionMixin:OnModelChanged(index)
        self.hiveSightVisible = false
        self.timeHiveVisionChanged = 0
    end

    function HiveVisionMixin:OnDestroy()

        if self.hiveSightVisible then
            local model = self:GetRenderModel()
            if model ~= nil then
                HiveVision_RemoveModel( model )
                --DebugPrint("%s remove model", self:GetClassName())
            end
        end
        
    end
    
    local function GetMaxDistanceFor(player)
    
        if player:isa("AlienCommander") then
            return 63
        end

        return 33
    
    end
    
    local function GetIsObscurred(viewer, target)
    
        local targetOrigin = HasMixin(target, "Target") and target:GetEngagementPoint() or target:GetOrigin()
        local eyePos = GetEntityEyePos(viewer)
    
        local trace = Shared.TraceRay(eyePos, targetOrigin, CollisionRep.LOS, PhysicsMask.All, EntityFilterAll())
        
        if trace.fraction == 1 then
            return false
        end
            
        return true    
    
    end

    function HiveVisionMixin:OnUpdate(deltaTime)   

        PROFILE("HiveVisionMixin:OnUpdate")
        -- Determine if the entity should be visible on hive sight
        local parasited = HasMixin(self, "ParasiteAble") and self:GetIsParasited()
        local blighted = HasMixin(self, "BlightAble") and self:GetIsBlighted()

        local visible = parasited or blighted
        local player = Client.GetLocalPlayer()
        local now = Shared.GetTime()
        local recentHPChange = false

        if HasMixin(self, "Combat") then
            if self.timeHiveVisionChanged < self:GetTimeLastDamageTaken() or self.timeHiveVisionChanged < self.timeLastHealed then
                recentHPChange = true
            end
        end

        if blighted and self.timeHiveVisionChanged < self.timeBlighted then
            recentHPChange = true
        end

        if Client.GetLocalClientTeamNumber() == kSpectatorIndex
              and self:isa("Alien") 
              and Client.GetOutlinePlayers()
              and not self.hiveSightVisible then

            local model = self:GetRenderModel()
            if model ~= nil then
            
                HiveVision_AddModel( model )
                   
                self.hiveSightVisible = true    
                self.timeHiveVisionChanged = now
                
            end
        
        end
        
        -- check the distance here as well. seems that the render mask is not correct for newly created models or models which get destroyed in the same frame
        local friendlyAlien = player ~= nil and (player:isa("Alien") or player:isa("AlienCommander") or player:isa("AlienSpectator")) and (player:GetOrigin() - self:GetOrigin()):GetLength() <= GetMaxDistanceFor(player)
        friendlyAlien = friendlyAlien and self:isa("Player") and player ~= self and GetAreFriends(self, player)

        if friendlyAlien then
            -- Make friendly players always show up - even if not obscured
            visible = friendlyAlien
        end

        -- Update the visibility status.
        if ((recentHPChange and not friendlyAlien) or
                (self.lastParasited ~= parasited) or
                (self.lastBlighted ~= blighted) or
                (visible ~= self.hiveSightVisible and self.timeHiveVisionChanged + 1 < now)) then
        
            local model = self:GetRenderModel()
            if model ~= nil then

                if visible then

                    local outlineColor = nil

                    if friendlyAlien then

                        if self:isa("Gorge") then
                            outlineColor = kHiveVisionOutlineColor.DarkGreen -- Friendly Gorge
                        else
                            outlineColor = kHiveVisionOutlineColor.Green -- Other friendly aliens
                        end
                    else -- Enemy Marine players/structures

                        if blighted then

                            local eHP
                            local maxEHP

                            if self:GetIgnoreHealth() then
                                eHP = self:GetArmor() * kHealthPointsPerArmor
                                maxEHP = self:GetMaxArmor() * kHealthPointsPerArmor
                            else
                                eHP = self:GetHealth() + self:GetArmor() * kHealthPointsPerArmor
                                maxEHP = self:GetMaxHealth() + self:GetMaxArmor() * kHealthPointsPerArmor
                            end

                            local isPlayer = self:isa("Player")
                            if isPlayer then
                                if eHP > 225 then
                                    outlineColor = kHiveVisionOutlineColor.Blue
                                elseif eHP > 150 then
                                    outlineColor = kHiveVisionOutlineColor.Yellow
                                else
                                    outlineColor = kHiveVisionOutlineColor.Red
                                end
                            else
                                local eHPFrac = eHP / maxEHP
                                if eHPFrac > 0.66 then
                                    outlineColor = kHiveVisionOutlineColor.Blue
                                elseif eHPFrac > 0.33 then
                                    outlineColor = kHiveVisionOutlineColor.Yellow
                                else
                                    outlineColor = kHiveVisionOutlineColor.Red
                                end
                            end
                        elseif parasited then
                            outlineColor = kHiveVisionOutlineColor.White
                        end
                    end

                    HiveVision_AddModel( model,  outlineColor)
                    --DebugPrint("%s add model", self:GetClassName())
                else
                    HiveVision_RemoveModel( model )
                    --DebugPrint("%s remove model", self:GetClassName())
                end 
                   
                self.hiveSightVisible = visible    
                self.timeHiveVisionChanged = now
                self.lastParasited = parasited
                self.lastBlighted = blighted
                
            end
            
        end
            
    end

end
