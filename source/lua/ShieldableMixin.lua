--
-- lua\ShieldableMixin.lua
--

ShieldableMixin = CreateMixin( Shieldable )
ShieldableMixin.type = "Shieldable"

kOverShieldDuration = 0.5
kOverShieldDecayDuration = 4

-- Arbitrary, but in fact it's the same value as the max mucous shield amount
local kMaxShield = 250

ShieldableMixin.networkVars =
{
    overShielded = "boolean",
    overShieldRemaining = string.format("float (0 to %f by 1)", kMaxShield),
    lastOverShield = "private time",
}

function ShieldableMixin:__initmixin()

    PROFILE("ShieldableMixin:__initmixin")

    self.overShielded = false
    self.overShieldRemaining = 0
    self.lastOverShield = 0

    if Server then
        self.lastDecayTime = 0
    end

end

function ShieldableMixin:ClearShield()

    self.overShielded = false
    self.overShieldRemaining = 0

end

function ShieldableMixin:OnDestroy()

    if self:GetHasOverShield() then
        self:ClearShield()
    end

end

function ShieldableMixin:GetHasOverShield()
    return self.overShielded
end

function ShieldableMixin:GetOverShieldAmount()
    return self.overShieldRemaining
end

function ShieldableMixin:GetMaxOverShieldAmount()

    local maxRatio = 15
    local maxHealth = self:GetMaxHealth()
    local kShieldClassNameMap = {
        [Skulk.kMapName] = kBiteLeapVampirismScalar * maxHealth * maxRatio,
        [Gorge.kMapName] = kSpitVampirismScalar * maxHealth * maxRatio,
        [Lerk.kMapName] = kLerkBiteVampirismScalar * maxHealth * maxRatio,
        [Fade.kMapName] = kSwipeVampirismScalar * maxHealth * maxRatio,
        [Onos.kMapName] = kGoreVampirismScalar * maxHealth * maxRatio
    }

    return kShieldClassNameMap[self:GetMapName()] or 0
end

function ShieldableMixin:GetOverShieldPercentage()
    return (self:GetOverShieldAmount() / self:GetMaxOverShieldAmount())
end


-- Overshield duration and decay duration
-- @return totalDuration, fullDuration, DecayDuration
function ShieldableMixin:GetOverShieldDuration()
    return (kOverShieldDuration + kOverShieldDecayDuration), kOverShieldDuration, kOverShieldDecayDuration
end

function ShieldableMixin:GetOverShieldTimeRemaining()
    local percentLeft = 0
    local overShieldDuration = self:GetOverShieldDuration()

    if self.overShielded and self.lastOverShield > 0 then
        percentLeft = Clamp( math.abs( (self.lastOverShield + overShieldDuration) - Shared.GetTime() ) / overShieldDuration, 0.0, 1.0 )
    end

    return percentLeft
end

function ShieldableMixin:ShieldComputeDamageOverrideMixin(attacker, damage, damageType, hitPoint)
    if self:GetHasOverShield() then
        if damage < self.overShieldRemaining then
            self.overShieldRemaining = math.max(self.overShieldRemaining - damage, 0)
            damage = 0
        else
            damage = math.max(damage - self.overShieldRemaining, 0)
            self.overShieldRemaining = 0
        end
        if self.overShieldRemaining == 0 then
            self.overShielded = false
        end
    end
    return damage
end

local function SharedUpdate(self)
    if Server then

        local overShieldDuration = self:GetOverShieldDuration()

        self.overShielded = self.lastOverShield + overShieldDuration >= Shared.GetTime() and self.overShieldRemaining > 0
        if not self.overShielded and self.overShieldRemaining > 0 then
            self.overShieldRemaining = 0
        end

        if self.overShielded and self.overShieldRemaining > 0 then
            local decayStartTime = self.lastOverShield + kOverShieldDuration
            local decayEndTime = decayStartTime + kOverShieldDecayDuration
            local decayRatio = 1--(Shared.GetTime() - self.lastOverShield)

            local now = Shared.GetTime()
            if now > decayStartTime then

                local decayAmount = 0--(self.overShieldStartAmount * decayRatio)
                local elapsed = now - self.lastDecayTime
                local _, fullDuration, decayDuration = self:GetOverShieldDuration()
                local decayPerSecond = self.overShieldStartAmount / decayDuration
                decayAmount = elapsed * decayPerSecond

                self.overShieldRemaining = self.overShieldRemaining - decayAmount
            end

            self.lastDecayTime = now
        end


    end
end

function ShieldableMixin:OnProcessMove(input)
    SharedUpdate(self)
end

if Server then

    function ShieldableMixin:AddOverShield(shieldAmount)
        local time = Shared.GetTime()

        self.overShielded = true
        self.overShieldRemaining = Clamp(self.overShieldRemaining + shieldAmount, 0, self:GetMaxOverShieldAmount())
        self.overShieldStartAmount = self.overShieldRemaining
        self.lastOverShield = time
    end

end
