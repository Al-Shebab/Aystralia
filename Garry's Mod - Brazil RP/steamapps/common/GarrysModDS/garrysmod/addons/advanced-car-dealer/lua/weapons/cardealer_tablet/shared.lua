SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to use"

SWEP.ViewModel				= Model( "models/stim/venatuss/car_dealer/tablet/c_tablet.mdl" )
SWEP.WorldModel 			= Model( "models/stim/venatuss/car_dealer/tablet/w_tablet.mdl" )

SWEP.UseHands				= true

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Car dealer"
SWEP.PrintName				= "Tablet"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

if SERVER then

util.AddNetworkString( "Unfocus.CarDealer.Tablet" )

net.Receive( "Unfocus.CarDealer.Tablet", function( len, ply ) 
	if IsValid( ply:GetActiveWeapon() ) and ply:GetActiveWeapon():GetClass() == "cardealer_tablet" then
		ply:GetActiveWeapon():Unfocus()
	end
end )

end

function SWEP:Unfocus()
	if CLIENT then 
		LocalPlayer():UnLock()
		net.Start( "Unfocus.CarDealer.Tablet" )
		net.SendToServer()
	end
	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self:SetHoldType( "slam" )
	--self.Owner:SetFOV( 0, 1 )
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if self.NextFire and self.NextFire > CurTime() then return end
	--self.Owner:SetFOV( 65, 1 )

	self.NextFire = CurTime() + self.Primary.Delay

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	
	self:SetHoldType( "pistol" )

	if CLIENT then
		LocalPlayer():Lock()
		timer.Simple( 1.2, function()
			local eTablet = LocalPlayer():GetViewModel()

			local attachmentTop, attachmentBottom = eTablet:LookupAttachment( "topleft" ), eTablet:LookupAttachment( "bottomright" )
			local topLeft, bottomRight = eTablet:GetAttachment( attachmentTop ), eTablet:GetAttachment( attachmentBottom )

			topleft, bottomright = topLeft.Pos:ToScreen(), bottomRight.Pos:ToScreen()	
			
			AdvCarDealer.OpenTablet( self, topleft, bottomright )
		end )
	end
end

function SWEP:SetupDataTables()
end

function SWEP:Initialize()
	self:SetHoldType( "slam" )
end

function SWEP:OnRemove()
	if CLIENT and LocalPlayer().UnLock and isfunction( LocalPlayer().UnLock ) then
		LocalPlayer():UnLock()
	end
end

function SWEP:Holster()
	if CLIENT and LocalPlayer().UnLock and isfunction( LocalPlayer().UnLock ) then
		LocalPlayer():UnLock()
	end
    return true
end