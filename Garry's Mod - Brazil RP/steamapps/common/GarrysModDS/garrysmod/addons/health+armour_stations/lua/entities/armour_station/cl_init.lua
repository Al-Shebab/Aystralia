--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile()
include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
	self:SetColor( Color( 0, 161, 255, 255 ) )
	self:SetMaterial( "models/shiny" )

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")
	
	local health_amount = self:GetNWInt("Armour_amount")

	surface.SetFont("HUDNumber5")
	local text = "Armour"
	local text2 = "Station"
	local TextWidth = surface.GetTextSize(text)
	local TextWidth4 = surface.GetTextSize(text2)
	local TextWidth2 = surface.GetTextSize(owner)
	local TextWidth3 = surface.GetTextSize(health_amount)

	Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up() * 8, Ang, 0.11)-- 11.5
		draw.RoundedBox( 8, -100, -100, 200, 170, Color( 36, 36, 36, 255 ) ) -- Color( 255, 0, 0, 255 )
		draw.WordBox(2, -TextWidth*0.5, -90, text, "HUDNumber5", Color(0, 161, 255, 0), Color(0, 255, 63,255))
		draw.WordBox(2, -TextWidth4*0.5, -60, text2, "HUDNumber5", Color(0, 255, 63, 0), Color(0, 255, 63,255))
		draw.RoundedBox( 8, -50, -20, 105, 80, Color( 29, 0, 255, 255 ) ) -- Color( 255, 0, 0, 255 )
		draw.WordBox(2, -TextWidth3*0.5, 0, health_amount, "HUDNumber5", Color(140, 0, 0, 0), Color(0, 255, 63,255))
	cam.End3D2D()
	
	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	
	cam.Start3D2D(Pos + Ang:Up() * 10.5, Ang, 0.11)-- 11.5
		draw.RoundedBox( 8, -100, -70, 200, 60, Color( 36, 36, 36, 255 ) ) -- Color( 255, 0, 0, 255 )
		draw.WordBox(2, -TextWidth2*0.5, -60, owner, "HUDNumber5", Color(140, 0, 0, 0), Color(0, 255, 63,255))
		--surface.SetDrawColor( 255, 255, 255, 255 )
		--surface.SetMaterial( Material( "icon16/star.png" ) )
		--surface.DrawTexturedRect( 0, 0, 128, 128 )
	cam.End3D2D()
	
end

function ENT:Think()
end
