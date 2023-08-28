EFFECT.Mat = Material("effects/blood_core")

function EFFECT:Init(data)
    self.Position = data:GetOrigin()
    self.LifeTime = CurTime() + 1
    self.Emitter = ParticleEmitter(self.Position)

    -- Create the effect upon initialization
    local effectData = EffectData()
    effectData:SetOrigin(self.Position)
    effectData:SetMagnitude(5)
    effectData:SetScale(1)
    util.Effect("BloodImpact", effectData)

    for i = 1, 2 do -- Reduce the number of particles
        local particle = self.Emitter:Add("particle/particle_smokegrenade", self.Position)
        if particle then
            particle:SetVelocity(VectorRand() * 50) -- Reduce the velocity of the particles
            particle:SetLifeTime(0)
            particle:SetDieTime(math.Rand(1, 2))
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(0)
            particle:SetStartSize(math.Rand(3, 5)) -- Reduce the size of the particles
            particle:SetEndSize(0)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-2, 2))
            particle:SetColor(255, 0, 0)
            particle:SetGravity(Vector(0, 0, -300))
        end
    end
end

function EFFECT:Think()
    if CurTime() > self.LifeTime then return false end

    return true
end

function EFFECT:Render()
end
