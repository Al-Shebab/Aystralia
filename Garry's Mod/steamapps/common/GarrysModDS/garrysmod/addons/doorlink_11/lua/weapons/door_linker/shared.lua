function GetOBBCenter(target)
	return target:LocalToWorld(target:OBBCenter())
end

function GetOBBDist(a,b)
	return GetOBBCenter(a):Distance(GetOBBCenter(b))
end



if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Keys"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Door Linker"
SWEP.Instructions = " "
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModel                 = "models/weapons/v_pistol.mdl"
SWEP.WorldModel                 = "models/weapons/w_pistol.mdl"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "pistol"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("pistol")
	
	if CLIENT then
		self.EditorPanel = nil
	end
end

function SWEP:Holster( wep )
	if CLIENT then
		local PN = self:GetPanel()
		if PN then PN:Remove() end
	end
	return true
end

function SWEP:Deploy()
end

function SWEP:GetPanel()
	if !self.EditorPanel or !self.EditorPanel:IsValid() then
		return false
	else
		return self.EditorPanel
	end
end

function SWEP:PrimaryAttack()
	if CLIENT then
		local ET = LocalPlayer():GetEyeTrace()
		if ET.Entity and ET.Entity.DoorData then
			local EP = self:GetPanel()
			if EP then
				EP:AddDoor(ET.Entity)
			end
		end
	end
	self:SetNextSecondaryFire(CurTime()+0.2)
	self:SetNextPrimaryFire(CurTime()+0.2)
end

function SWEP:SecondaryAttack()
	if CLIENT then
		local ET = LocalPlayer():GetEyeTrace()
		if ET.Entity and ET.Entity.DoorData then
			local EP = self:GetPanel()
			if EP then
				EP:RemoveDoor(ET.Entity)
			end
		end
	end
	self:SetNextSecondaryFire(CurTime()+0.2)
	self:SetNextPrimaryFire(CurTime()+0.2)
end

function SWEP:Reload()
	if CLIENT then
		if !self.EditorPanel or !self.EditorPanel:IsValid() then
			self.EditorPanel = DoorLink_Editor_Open()
			MsgN("OPEN")
		end
	end
end

local BeamMAT = Material("effects/blueblacklargebeam")
function SWEP:DrawHUD()
	local EP = self:GetPanel()
	if EP then
		for k,v in pairs(DoorLink.Category) do
			if v.UniqueID == EP.SelectedUniqueID then
				local Sort = {}
				for a,b in pairs(v.Items) do
					local Ent = ents.GetByIndex(b)
					table.insert(Sort,Ent)
					
					local function DrawBeam(PEntity,NEntity)
						cam.Start3D(EyePos(), EyeAngles())
							   render.SetMaterial( BeamMAT )
								render.DrawBeam( GetOBBCenter(PEntity), 		
												GetOBBCenter(NEntity),
												 20,		// Width
												 math.Rand(0,1),														// Start tex coord
												 math.Rand(0,1) + GetOBBDist(PEntity,NEntity) / 1024,									// End tex coord
												 Color( 255, 0, 255, 255 ) 
												)		// Color (optional)
								
						cam.End3D()
					end
					
					-- Display mode
					if GetConVar("doorlink_rendermode"):GetInt() == 0 then
						for a = 1,(#Sort-1) do
							local PEntity = Sort[a]
							local NEntity = Sort[a+1]
							
							if PEntity and PEntity:IsValid() and NEntity and NEntity:IsValid() then							
								DrawBeam(PEntity,NEntity)
							end
						end
					else
						for a = 1,(#Sort) do
							for b = a,(#Sort) do
								local PEntity = Sort[a]
								local NEntity = Sort[b]
								if PEntity and PEntity:IsValid() and NEntity and NEntity:IsValid() then			
									DrawBeam(PEntity,NEntity)
								end
							end
						end
					end
				end
				
			end
		end
	end
end