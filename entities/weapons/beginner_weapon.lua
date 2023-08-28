AddCSLuaFile()

-- Define the SWEP
SWEP.PrintName = "Beginner weapon for gamemode"
SWEP.Author = "Your Name"
SWEP.Instructions = "Left click to use"
SWEP.Spawnable = false
-- In your SWEP's shared.lua file
SWEP.Slot = 2 -- Change this to a different number
SWEP.SlotPos = 1


-- Set the view model and world model
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

-- Set the primary fire settings
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = "weapons/pistol/pistol_fire2.wav"

-- Set the secondary fire settings
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Delay = 0.5

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    if not self:CanPrimaryAttack() then return end
    self:EmitSound(self.Primary.Sound)
    self:ShootEffects(self)
    --self:TakePrimaryAmmo(1)
    if SERVER then
    local ent = ents.Create("beginner_proj")
    if not IsValid(ent) then return end
    ent:SetOwner(self.Owner)
    ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
    ent:SetAngles(self.Owner:EyeAngles())
    ent:Spawn()
    local phys = ent:GetPhysicsObject()
    if not IsValid(phys) then ent:Remove() return end
    local velocity = self.Owner:GetAimVector()
    velocity = velocity * 15000*8
    phys:ApplyForceCenter(velocity)
	end
end


