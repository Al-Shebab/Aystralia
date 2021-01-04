include("shared.lua")
SWEP.PrintName = "Knife" -- The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self.Owner:DoAttackEvent()
	self:SendWeaponAnim(ACT_VM_MISSCENTER)
end

function SWEP:SecondaryAttack()
	self.Owner:DoAttackEvent()
	self:SendWeaponAnim(ACT_VM_MISSCENTER)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Equip()
end
