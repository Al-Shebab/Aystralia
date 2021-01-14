AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("zrmine_config.lua")

SWEP.Weight = 5

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.LastSwitch = -1
	self.LastPrimary = -1
	self.LastSecondary = -1
end


// Build Entity
function SWEP:PrimaryAttack()
	if CurTime() < self.LastPrimary then return end

	zrmine.f.Swep_Primary(self.Owner,self)

	self.LastPrimary = CurTime() + 0.5
end

// Deconstruct Entity
function SWEP:SecondaryAttack()
	if CurTime() < self.LastSecondary then return end

	zrmine.f.Swep_Secondary(self.Owner, self)

	self.LastSecondary = CurTime() + 0.5
end


function SWEP:Reload() end


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.Owner:SetAnimation(PLAYER_IDLE)
end

function SWEP:ShouldDropOnDie()
	return false
end
