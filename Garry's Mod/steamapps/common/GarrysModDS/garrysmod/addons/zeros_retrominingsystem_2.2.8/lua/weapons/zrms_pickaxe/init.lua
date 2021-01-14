AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("zrmine_config.lua")
SWEP.Weight = 5

--SWEP:Initialize\\
--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	zrmine.f.Pickaxe_Initialize(self)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	// Updates the viewmodel skin
	zrmine.f.Pickaxe_UpdateVMSkin(self,self.Owner)
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	zrmine.f.Pickaxe_Primary(self.Owner,self)
end


function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	zrmine.f.Pickaxe_Secondary(self.Owner, self)
end

--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW) -- View model animation
	self.Owner:SetAnimation(PLAYER_IDLE) -- 3rd Person Animation
	zrmine.f.Pickaxe_UpdateLvlVar(self,self.Owner)
end

function SWEP:Reload()
end

function SWEP:ShouldDropOnDie()
	return false
end
