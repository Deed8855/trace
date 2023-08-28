-- In server-side code
--include("shared.lua")  -- Include the shared file

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Energy = 400

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_debris/concrete_chunk01a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)

        local angle = self:GetAngles()
        angle.x = math.random(60, 140)
        angle.y = math.random(60, 140)
        self:SetAngles(angle)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end

        self:SetColor(Color(0, 0, 255))
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
    end
end

function ENT:OnTakeDamage(dmginfo)
    local attacker = dmginfo:GetAttacker()
    if attacker:IsPlayer() and attacker:GetActiveWeapon():GetClass() == "weapon_crowbar" then
        local playerPower = GetPlayerPower(attacker)
        if playerPower < 1000 then
            if self.Energy > 0 then
                local energyLost = math.min(self.Energy, dmginfo:GetDamage())
                self.Energy = self.Energy - energyLost
                SetPlayerPower(attacker, math.min(1000, playerPower + energyLost))
                attacker:ChatPrint("Your power is: "..tostring(GetPlayerPower(attacker)))
                if self.Energy == 0 then
                    attacker:ChatPrint("No more energy left!")
                else
                    attacker:ChatPrint("Energy: " .. tostring(self.Energy))
                end
            end

            self:EmitSound("npc/dog/dog_pneumatic1.wav")
        else
            -- Play a sound effect when the player's power is full
            self:EmitSound("npc/roller/mine/rmine_blades_out3.wav")
			attacker:ChatPrint("Your power is full!")
        end
    end
    local color = math.max(50, (self.Energy / 400) * 255)
    self:SetColor(Color(0, 0, color))
end

function ENT:Think()
    if SERVER then
        self.Energy = math.min(400, self.Energy + 100 / 60)
        local color = math.max(50, (self.Energy / 400) * 255)
        self:SetColor(Color(0, 0, color))
    end
    self:NextThink(CurTime() + 1)
    return true
end







