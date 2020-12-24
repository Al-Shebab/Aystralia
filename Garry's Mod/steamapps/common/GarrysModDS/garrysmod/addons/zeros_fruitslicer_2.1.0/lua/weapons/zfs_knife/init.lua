AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SWEP.Weight = 5

--SWEP:Initialize\\
--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.selectedEffect = 1
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:SlicerFruit()
	local tr = self.Owner:GetEyeTrace()
	self.Owner:DoAttackEvent()
	self:SendWeaponAnim(ACT_VM_MISSCENTER)

	local rnda = -self.Primary.Recoil
	local rndb = self.Primary.Recoil * math.random(-1, 1)
	self.Owner:ViewPunch(Angle(rnda, rndb, rnda))

	if zfs.f.InDistance(self.Owner:GetPos(), tr.HitPos, 100) then

		for i, k in pairs(zfs.EntList) do
			if IsValid(k) and zfs.fruits[k:GetClass()] and zfs.f.InDistance(tr.HitPos, k:GetPos(), 30) then
				zfs.f.Fruit_Interact(self.Owner,k)
				break
			end
		end
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:PrimaryAttack()
	self:SlicerFruit()
end

function SWEP:SecondaryAttack()
	self:SlicerFruit()
end

--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW) -- View model animation
	self.Owner:SetAnimation(PLAYER_IDLE) -- 3rd Person Animation
end

function SWEP:Reload()
	if ((self.lastReload or CurTime()) > CurTime()) then return end
	self.lastReload = CurTime() + 1
end

function SWEP:ShouldDropOnDie()
	return false
end
