SWEP.Author				 = "Mikael #"
SWEP.Spawnable			 = true
SWEP.AdminSpawnable		 = false
SWEP.PrintName			 = "Bitcoin USB"
SWEP.ViewModel			 = "models/customhq/usb_v.mdl"
SWEP.WorldModel			 = "models/customhq/usb_w.mdl"
SWEP.UseHands 		     = true
SWEP.HoldType 			 = "melee2"
SWEP.DrawAmmo 			 = false
SWEP.Primary.ClipSize 	 = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo 		 = "none"
SWEP.Primary.AmmoType    = "none"
SWEP.Secondary.Ammo      = "none"
SWEP.DrawCrosshair       = true
SWEP.UseHands 			 = true
SWEP.ViewModelFOV 		 = 53

SWEP.Offset = {
	Pos = {
		Up = -1,
		Right = 0,
		Forward = 1,
	},
	Ang = {
		Up = 350,
		Right = 60,
		Forward = -15,
	}
}
 
function SWEP:DrawWorldModel()
	local hand, offset, rotate
	if !IsValid( self.Owner ) then
		self:DrawModel( )
		return
	end
 
	if !self.Hand then
		self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
	end
 
	hand = self.Owner:GetAttachment( self.Hand )
 
	if !hand then
		self:DrawModel( )
		return
	end
 
	offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up
	hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
	hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
	hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )
	self:SetRenderOrigin( hand.Pos + offset )
	self:SetRenderAngles( hand.Ang )
	self:DrawModel( )
end

function SWEP:PrimaryAttack() 
	if CLIENT then return end
	
	local ply = self.Owner
	local trace = ply:GetEyeTrace()
	local ent = trace.Entity
	local class = ent:GetClass()
	
	if !( ply:GetPos():Distance(ent:GetPos()) <= 200) then
		return
	end
	
	if class == "bit_case" then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		timer.Simple( 3, function()
			if !IsValid(self) && !IsValid(ent) then return end
			self:SendWeaponAnim(ACT_VM_IDLE)
			if (ent:GetHarddisk() >= 500) then
				if !(ent:GetBitCoin() <= 0) then	
					self.bitcoin = ((self.bitcoin || 0) + ent:GetBitCoin())
					ent:SetGBused(0)
					ent:SetBitCoin(0)	
				end
			end
		end)
	elseif class == "bit_npc" then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		if !(self.bitcoin <= 0) then
			timer.Simple( 3, function()
				if !IsValid(self) && !IsValid(ent) then return end
				self:SendWeaponAnim(ACT_VM_IDLE)
				local bit = (self.bitcoin * bitmine.BitCoinPrice)
				ply:addMoney( bit )
				ply:ChatPrint("You just received "..bit.."$ for a harddisk with "..self.bitcoin.." bitcoins.")
				self.bitcoin = 0
			end)
		end
	end
end

function SWEP:SecondaryAttack() 
	if ( CLIENT ) || (self.bitcoin == nil) then return end
	local ply = self.Owner
	ply:ChatPrint("This USB holds: "..self.bitcoin.." bitcoins.")
end