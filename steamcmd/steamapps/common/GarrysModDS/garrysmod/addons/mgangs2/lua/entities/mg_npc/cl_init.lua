include('shared.lua')

surface.CreateFont("mg2.NPC.NAME", {
	font = "Abel",
	size = 122,
	bold = true,
})

surface.CreateFont("mg2.NPC.NAME.SMALL", {
	font = "Abel",
	size = 82,
	bold = true,
})

function ENT:Draw()
	self:DrawModel()

	if !(self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= 75000) then return false end

	-- Name
	local npc = self:GetNPC()
	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos() + Vector(0,0,self:OBBMaxs().z + 45)

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)

	cam.Start3D2D(pos, Angle(ang.x, ang.y, ang.z), 0.1)
		if (npc != nil) then
			draw.DrawText(npc:GetTitle(), "mg2.NPC.NAME", 0, 70, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText(npc:GetDescription(), "mg2.NPC.NAME.SMALL", 0, 175, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end