AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Model = "models/props_junk/wood_crate001a.mdl"

function ENT:Initialize()
if SERVER then
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
	end
end
