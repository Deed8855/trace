AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Model = "models/props_junk/wood_crate001a.mdl"

function ENT:Initialize()
    if SERVER then
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_NONE)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_NONE)
        self:SetRenderMode(RENDERMODE_NORMAL)
        self:SetColor(Color(255, 255, 255, 0))
        timer.Simple(60, function() if IsValid(self) then self:Remove() end end) -- Remove the entity after 60 seconds
		self:SetInitialDirection()
    end
end

function ENT:Think()
    if SERVER then
        -- Shoot the projectile in a straight line
        self:SetPos(self:GetPos() + self:GetForward() * 100)

	local trace = util.TraceHull({
    start = self:GetPos(),
    endpos = self:GetPos() + self:GetForward() * 230,
    filter = self,
    mins = Vector(-10, -10, -10), -- Set the minimum bounds of the box
    maxs = Vector(10, 10, 10) -- Set the maximum bounds of the box
	})

        if trace.Hit then
            if trace.Entity:IsPlayer() then
                local dmginfo = DamageInfo()
                dmginfo:SetAttacker(self)
                dmginfo:SetInflictor(self)
                dmginfo:SetDamage(math.random(10, 30))
                trace.Entity:TakeDamageInfo(dmginfo)
            end
            self:Remove() -- Remove the entity upon hitting an object
        end
    end

    if CLIENT then
        local effectData = EffectData()
        effectData:SetOrigin(self:GetPos())
        util.Effect("zombie_proj_effect", effectData)
    end
end

-- Get the target of the projectile
function ENT:GetTarget()
    local targets = ents.FindInSphere(self:GetPos(), 1000)
    for _, target in pairs(targets) do
        if target:IsPlayer() then
            return target
        end
    end
    return nil
end

-- Predict where the player will be by the time the projectile hits
function ENT:PredictTargetPos(target)
    local dist = self:GetPos():Distance(target:GetPos())
    local timeToHit = dist / 700 -- Calculate the time it will take for the projectile to hit the target
    local targetPos = target:GetPos() + target:GetVelocity() * timeToHit -- Predict the player's future position based on their current velocity and the time it will take for the projectile to hit them
    return targetPos
end

-- Set the projectile's initial direction based on the predicted position of its target
function ENT:SetInitialDirection()
    local target = self:GetTarget()
    if IsValid(target) and target:IsPlayer() then
        local targetPos = self:PredictTargetPos(target)
        local dir = (targetPos - self:GetPos()):GetNormalized()
        dir.z = dir.z + 0.05 -- Add some upward movement to the projectile
        self:SetAngles(dir:Angle())
    end
end

-- Call ENT:SetInitialDirection when the projectile is created to set its initial direction based on its predicted target position.

-- In the zombie_proj.lua file
function ENT:Draw()
    if CLIENT then
        -- Draw a small red glowing orb
        local size = 100
        local color = Color(255, 0, 0, 255)
        render.SetMaterial(Material("sprites/glow04_noz"))
        render.DrawSprite(self:GetPos(), size, size, color)
    end
end
