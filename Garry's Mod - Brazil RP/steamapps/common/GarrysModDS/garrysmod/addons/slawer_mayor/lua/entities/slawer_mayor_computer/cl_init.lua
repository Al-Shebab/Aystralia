include( "shared.lua" )

function ENT:CreateMenu()
	Slawer.Mayor.Menu = vgui.Create("Slawer.Mayor:Menu")
end

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 40000 then
		if IsValid(Slawer.Mayor.Menu) then
			Slawer.Mayor.Menu:LoadLockScreen()
			Slawer.Mayor.Menu:Remove()
			gui.EnableScreenClicker(false)
		end
		return
	end

	if not IsValid(Slawer.Mayor.Menu) then self:CreateMenu() end

	local Pos = self:GetPos() + self:GetUp() * 12.4 + self:GetForward() * -1.18 + self:GetRight() * 21.8
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Up(),90)
	Ang:RotateAroundAxis(Ang:Forward(),85.8)

		Slawer.Mayor.Start3D2D( Pos, Ang, 0.04 )
			Slawer.Mayor.Menu:SlawerMayorPaint3D2D()
		Slawer.Mayor.End3D2D()
end

function ENT:OnRemove()
	Slawer.Mayor.FocusEntry = nil
	if Slawer.Mayor.LookingTo then
		gui.EnableScreenClicker(false)
		Slawer.Mayor.LookingTo = nil
	end
	if IsValid(Slawer.Mayor.FakeTextEntry) then Slawer.Mayor.FakeTextEntry:Remove() end
	if IsValid(Slawer.Mayor.Menu) then Slawer.Mayor.Menu:Remove() end
end