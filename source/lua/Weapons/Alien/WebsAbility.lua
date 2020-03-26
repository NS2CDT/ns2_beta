-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\Weapons\Alien\WebsAbility.lua
--
--    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Weapons/Alien/StructureAbility.lua")

class 'WebsAbility' (StructureAbility)

local kMapOrigin = Vector(0,0,0)

WebsAbility.kFirstDropRange = kGorgeCreateDistance
WebsAbility.kSecondDropRange = WebsAbility.kFirstDropRange * 3
WebsAbility.kGroundedMinDistance = 0.3

function WebsAbility:GetEnergyCost()
    return kDropStructureEnergyCost
end

function WebsAbility:GetGhostModelName(ability)
    return Bomb.kModelName
end

function WebsAbility:GetDropStructureId()
    return kTechId.Web
end

function WebsAbility:AllowBackfacing()
    return true
end

function WebsAbility:GetSuffixName()
    return "web"
end

function WebsAbility:GetDropClassName()
    return "Web"
end

function WebsAbility:GetDropRange(lastClickedPosition)
    if not lastClickedPosition or lastClickedPosition == kMapOrigin then
        return WebsAbility.kFirstDropRange
    else
        return WebsAbility.kSecondDropRange
    end
end

function WebsAbility:OnStructureCreated(structure, lastClickedPosition)
    structure:SetEndPoint(lastClickedPosition)
end

function WebsAbility:GetIsPositionValid(displayOrigin, player, normal, lastClickedPosition, entity)

    local direction = player:GetViewCoords().zAxis
    local startPoint = displayOrigin + normal * 0.1
    local valid = lastClickedPosition == nil

    if lastClickedPosition and displayOrigin and startPoint ~= lastClickedPosition 
       and (lastClickedPosition - startPoint):GetLength() < kMaxWebLength and (lastClickedPosition - startPoint):GetLength() > kMinWebLength then
    
        -- check if we can create a web between the 2 point
        local webTrace = Shared.TraceRay(lastClickedPosition, startPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterAll())

        if webTrace.fraction >= 0.99 then

            local startGroundPos = GetGroundAtPosition(startPoint, EntityFilterAll(), PhysicsMask.Bullets)
            local endGroundPos = GetGroundAtPosition(lastClickedPosition, EntityFilterAll(), PhysicsMask.Bullets)
            local hasGroundedEndpoint = (startPoint.y - startGroundPos.y) <= WebsAbility.kGroundedMinDistance

            if hasGroundedEndpoint then
                valid = (lastClickedPosition.y - endGroundPos.y) > WebsAbility.kGroundedMinDistance
            else
                valid = true
            end

        end

    end

    return valid and (not entity or entity:isa("Tunnel") or entity:isa("Infestation")) and lastClickedPosition ~= kMapOrigin
    
end

function WebsAbility:GetDropMapName()
    return Web.kMapName
end

local kWebOffset = 0.1
function WebsAbility:ModifyCoords(coords)
    coords.origin = coords.origin + coords.yAxis * kWebOffset
end
