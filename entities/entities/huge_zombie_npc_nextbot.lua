AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.baseHealth = 50

function ENT:Initialize()
	self.scale = 2.3
	self:SetModel( "models/Zombie/Classic.mdl" )
	self:SetModelScale(self.scale)
	self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
	self.Armor = 20 -- The maximum armor value for the NPC
	self:SetHealth(self.baseHealth)
end

function ENT:RunBehaviour()
    while true do
        self:StartActivity(ACT_WALK)
		local target = self:FindTarget()
        self.loco:SetDesiredSpeed(140) -- Resume the NPC's movement

        local targetPos = self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) * 4000
        local blocked = false

        local trace = util.TraceLine({
            start = self:GetPos(),
            endpos = targetPos,
            mask = MASK_SOLID
        })

        if trace.Hit then
            blocked = true
        end

        if not blocked then
            self:MoveToPos(targetPos)
			self:StartActivity(ACT_IDLE)
        end
    end
end


function ENT:Think()
    if SERVER then
        if not self.NextAttack or self.NextAttack < CurTime() then
            local target = self:FindTarget()
            if IsValid(target) then
				self.loco:SetDesiredSpeed(0) -- Stop the NPC from moving
                self.loco:FaceTowards(target:GetPos())
                self:StartActivity(ACT_MELEE_ATTACK1)
                local proj = ents.Create("zombie_proj")
                proj:SetPos(self:GetPos() + Vector(0, 0, 50))
                proj:SetAngles(self:GetAngles())
                proj:Spawn()
                self.NextAttack = CurTime() + 1.4 -- Set the next attack time to 2 seconds from now

                if not self.NextMoan or self.NextMoan < CurTime() then
                    self:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1, 14) .. ".wav")
                    self.NextMoan = CurTime() + 30 -- Set the next moan time to 30 seconds from now
                end
				self:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1, 14) .. ".wav")
            end
        else
            local target = self:FindTarget()
            if IsValid(target) then
                self.loco:FaceTowards(target:GetPos())
            end
			if not IsValid(target) then 
				self.loco:SetDesiredSpeed(600) -- Resume the NPC's movement
				self:StartActivity(ACT_WALK)
			end
        end
    end
end

function ENT:OnInjured(info)
	local dmg = info:GetDamage() -- Get the damage amount
	local dmgtype = info:GetDamageType() -- Get the damage type
	
	if self.Armor > 0 then -- Check if the NPC has any armor left
		if dmgtype == DMG_BULLET then -- Check if the damage type is bullet
			self.Armor = self.Armor - dmg * 0.5 -- Reduce the armor by half of the damage amount
		elseif dmgtype == DMG_BLAST then -- Check if the damage type is blast
			self.Armor = self.Armor - dmg * 0.75 -- Reduce the armor by three quarters of the damage amount
		else -- For any other damage type
			self.Armor = self.Armor - dmg * 0.25 -- Reduce the armor by a quarter of the damage amount
		end
		
		if self.Armor < 0 then self.Armor = 0 end -- Clamp the armor value to zero if it goes below
		
		info:SetDamage(0) -- Set the damage to zero so that the NPC does not lose health from this attack
		
	end
	
	if self.Armor == 0 then -- Check if the NPC's armor is broken
		self:EmitSound("npc/zombie/zombie_pain6.wav") -- Play a sound of pain
		self:SetMaterial("models/flesh") -- Change the material to flesh
		self:SetColor(Color(255, 0, 0)) -- Change the color to red		
	end
	
end

function ENT:FindTarget()
    if SERVER then
        local targets = ents.FindInSphere(self:GetPos(), self.SearchRadius)
        for _, target in pairs(targets) do
            if target:IsPlayer() and target:Alive() then
                return target
            end
        end
        return nil
    end
end