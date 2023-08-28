AddCSLuaFile()
--DEFINE_BASECLASS("player")

-- Define the NPC
ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Model = "models/zombie/classic.mdl"
ENT.initHP = 150
ENT.NextRandomMove = 0

AccessorFunc( ENT, "m_iClass", "NPCClass" )
AccessorFunc( ENT, "m_fMaxYawSpeed", "MaxYawSpeed" )

ENT.m_iClass = CLASS_ZOMBIE

-- Initialize function
function ENT:Initialize()
    self:SetModel(self.Model) -- Set the model path
	if SERVER then
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
	self:SetHealth(self.initHP)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:CapabilitiesAdd( bit.bor( CAP_MOVE_GROUND, CAP_OPEN_DOORS, CAP_TURN_HEAD, CAP_WEAPON_MELEE_ATTACK1, CAP_WEAPON_MELEE_ATTACK2 )) -- Use the proper bitwise OR operator
	self:SetMoveType( MOVETYPE_STEP )
	end

end

function ENT:Think()
if SERVER then
	        if not self.NextThinkTime or CurTime() >= self.NextThinkTime then
            self:TaskStart_FindEnemy()
            self.NextThinkTime = CurTime() + 0.1 -- Set the next think time 1 second in the future
        end
	end
end

function ENT:TaskStart_FindEnemy()
	if SERVER then
	for k, v in ipairs( ents.FindInSphere( self:GetPos(), 2 ) ) do

		if ( v:IsValid() && v != self && v:GetClass() == CLASS_PLAYER ) then

			self:SetEnemy( v, true )
			self:UpdateEnemyMemory( v, v:GetPos() )
			self:TaskComplete()
			return
		end

	end

	self:SetEnemy( NULL )

end
end