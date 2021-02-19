-- Seconds to pass until Pickpocketing is done (default: 10)
local PPConfig_Duration = 15

-- Minimum money that can be stolen from the player (default: 400)
local PPConfig_MoneyFrom = 1000

-- Maximumum money that can be stolen from the player (default: 700)
local PPConfig_MoneyTo = 25000

-- Seconds to wait until next Pickpocketing (default: 60)
local PPConfig_Wait = 300

-- Distance able to be stolen from (default: 100)
local PPConfig_Distance = 75

-- Should stealing emit a silent sound (true or false) (default: true)
local PPConfig_Sound = false

-- Hold down to keep Pickpocketing (true or false) (default: false)
local PPConfig_Hold = false

if SERVER then
	
	if PPConfig_Sound then
		resource.AddFile( "sound/pickpocket/pick.wav" )
	end
	
	AddCSLuaFile( "shared.lua" )
	
	util.AddNetworkString( "pickpocket_time" )
	
else
	
	SWEP.PrintName = "Pickpocket"
	SWEP.Slot = 0
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
end

SWEP.Base = "weapon_base"

SWEP.Instructions = "Left-click for Pickpocketing"
SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model( "models/weapons/c_crowbar.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_crowbar.mdl" )

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

//Initialize\\
function SWEP:Initialize()
	self:SetWeaponHoldType( "normal" )
end

if CLIENT then
	
	net.Receive( "pickpocket_time", function()
		local wep = net.ReadEntity()

		wep.IsPickpocketing = true
		wep.StartPick = CurTime()
		wep.EndPick = CurTime() + PPConfig_Duration
	end )
	
end

//Primary Attack\\
function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
	
	if self.IsPickpocketing then return end

	local trace = self.Owner:GetEyeTrace()
	local e = trace.Entity
	
	if not IsValid( e ) or not e:IsPlayer() or trace.HitPos:Distance( self.Owner:GetShootPos() ) > PPConfig_Distance then
		
		if CLIENT then
			self.Owner:PrintMessage( HUD_PRINTTALK, "Can't pickpocket from here!" )
		end
		
		return
		
	end

	if SERVER then
		
		self.IsPickpocketing = true
		self.StartPick = CurTime()
		
		net.Start( "pickpocket_time" )
		net.WriteEntity( self )
		net.Send(self.Owner)
		
		self.EndPick = CurTime() + PPConfig_Duration
		
	end
	
	self:SetWeaponHoldType( "pistol" )
	
	if SERVER then
			
		if PPConfig_Sound then
			self.Owner:EmitSound( Sound( "pickpocket/pick.wav" ) )
		end
		
		timer.Create( "PickpocketSounds", 1, PPConfig_Duration, function()
			
			if not self:IsValid() then
				return
			end
			
			if PPConfig_Sound then
				self.Owner:EmitSound( Sound( "pickpocket/pick.wav" ) )
			end
			
		end )
		
	end
	
	if CLIENT then
		
		self.Dots = self.Dots or ""
		
		timer.Create( "PickpocketDots", 0.5, 0, function()
			
			if not self:IsValid() then
				timer.Destroy( "PickpocketDots" )
				return
			end
			
			local len = string.len( self.Dots )
			local dots = { [0] = ".", [1] = "..", [2] = "...", [3] = "" }
			
			self.Dots = dots[len]
			
		end )
		
	end
	
end

//Holster\\
function SWEP:Holster()

	self.IsPickpocketing = false
	
	if SERVER then
		timer.Destroy( "PickpocketSounds" )
	end
	
	if CLIENT then
		timer.Destroy( "PickpocketDots" )
	end
	
	return true
end

//OnRemove\\
function SWEP:OnRemove()
	self:Holster()
end

//Pickpocket Succeed\\
function SWEP:Succeed()
	
	self.IsPickpocketing = false
	
	self:SetWeaponHoldType( "normal" )

	self.Weapon:SetNextPrimaryFire( CurTime() + PPConfig_Wait )
	
	local trace = self.Owner:GetEyeTrace()
	
	if SERVER then
		timer.Destroy( "PickpocketSounds" )
	end
	
	if CLIENT then
		timer.Destroy( "PickpocketDots" )
	end
	
	local money = math.random ( PPConfig_MoneyFrom, PPConfig_MoneyTo )
	
	if trace.Entity:getDarkRPVar( "money" ) < money then
		money = trace.Entity:getDarkRPVar( "money" )
	end
	
	if SERVER then
		
		DarkRP.payPlayer( trace.Entity, self.Owner, money )
		
	end
	
	if CLIENT then
		
		if money > 0 then
			self.Owner:PrintMessage( HUD_PRINTTALK, "Pickpocketing succeeded, you stole $" .. money .. "" )
		else
			self.Owner:PrintMessage( HUD_PRINTTALK, "Pickpocketing succeeded, but your victim's wallet was empty." )
		end
		
	end
	
end

//Pickpocket Fail\\
function SWEP:Fail()
	
	self.IsPickpocketing = false
	
	self:SetWeaponHoldType( "normal" )
	
	if SERVER then
		timer.Destroy( "PickpocketSounds" )
	end
	
	if CLIENT then
		timer.Destroy( "PickpocketDots" )
	end
	
	if CLIENT then
		self.Owner:PrintMessage( HUD_PRINTTALK, "Pickpocketing failed." )
	end
	
end

//Think\\
function SWEP:Think()
	
	local ended = false
	
	if self.IsPickpocketing and self.EndPick then
		
		local trace = self.Owner:GetEyeTrace()
		
		if not IsValid( trace.Entity ) and not ended then
			ended = true
			self:Fail()
		end
		
		if trace.HitPos:Distance( self.Owner:GetShootPos() ) > PPConfig_Distance and not ended then
			ended = true
			self:Fail()
		end
		
		if PPConfig_Hold and not self.Owner:KeyDown( IN_ATTACK ) and not ended then
			ended = true
			self:Fail()
		end
		
		if self.EndPick <= CurTime() and not ended then
			ended = true
			self:Succeed()
		end
		
	end
	
end

//Draw HUD\\
function SWEP:DrawHUD()
	
	if self.IsPickpocketing and self.EndPick then
		
		self.Dots = self.Dots or ""
		
		local w = ScrW()
		local h = ScrH()
		local x, y, width, height = w / 2 - w / 10, h / 2 - 60, w / 5, h / 15
		
		draw.RoundedBox( 8, x, y, width, height, Color( 10, 10, 10, 120 ) )

		local time = self.EndPick - self.StartPick
		local curtime = CurTime() - self.StartPick
		local status = math.Clamp( curtime / time, 0, 1)
		local BarWidth = status * ( width - 16 )
		local cornerRadius = math.Min( 8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2 )
		
		draw.RoundedBox( cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color( 255 - ( status * 255 ), 0 + ( status * 255 ), 0, 255 ) )

		draw.DrawNonParsedSimpleText( "Pickpocketing" .. self.Dots, "Trebuchet24", w / 2, y + height / 2, Color( 255, 255, 255, 255 ), 1, 1 )
		
	end
	
end

//Secondary Attack\\
function SWEP:SecondaryAttack()
end
