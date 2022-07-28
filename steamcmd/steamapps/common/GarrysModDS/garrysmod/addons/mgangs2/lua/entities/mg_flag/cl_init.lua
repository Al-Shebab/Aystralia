include('shared.lua')

surface.CreateFont("mg2.TERFLAG.XLARGE", {
	font = "Abel",
	size = 85,
})

surface.CreateFont("mg2.TERFLAG.LARGE", {
	font = "Abel",
	size = 70,
})

surface.CreateFont("mg2.TERFLAG.MEDIUM", {
	font = "Abel",
	size = 55,
})

surface.CreateFont("mg2.TERFLAG.SMALL", {
	font = "Abel",
	size = 40,
})

surface.CreateFont("mg2.TERFLAG.XSMALL", {
	font = "Abel",
	size = 30,
})

local material = Material("sprites/splodesprite")

function ENT:Draw()
	self:DrawModel()

	local claimPly = self:GetClaimingPly()

	local sTID = tonumber(self:GetTerritoryID())
	local terr = MG2_TERRITORIES:Get(sTID)

	if (!terr or !(self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= 170000)) then return false end

	local tName, tDesc = terr:GetName(), terr:GetDescription()
	local tData = terr:GetClaimed()

	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos() + Vector(0,0,self:OBBMaxs().z + 75)

	if (mg2.lang) then
		local contMsg, uncontMsg = mg2.lang:GetTranslation("territory.ControlledBy", (tData && tData.gangName or "NIL")), mg2.lang:GetTranslation("territory.CurrentlyUncontrolled")
		local bcByMsg = (IsValid(claimPly) && mg2.lang:GetTranslation("territory.BeingClaimedBy", (claimPly:Nick() or "NIL")) .. " (" .. math.floor(self:GetClaimStart() - CurTime()) .. "s)!")

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		cam.Start3D2D(pos, Angle(ang.x, ang.y, ang.z), 0.5)
			draw.DrawText("'" .. tName .. "' " .. mg2.lang:GetTranslation("territory"), "mg2.TERFLAG.LARGE", 0, -20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText(tDesc, "mg2.TERFLAG.XSMALL", 0, 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText(tData && contMsg || bcByMsg || uncontMsg, "mg2.TERFLAG.XSMALL", 0, 70, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

function ENT:Think()
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:ClientAnim(anim, speed)
	local sequence = self:LookupSequence(anim)

	self:SetCycle(0)
	self:ResetSequence(sequence)
	self:SetPlaybackRate(speed)
	self:SetCycle(0)
end

--[[
	Networking
]]
net.Receive("mg2.flagpost.AnimEvent", function(len, ply)
	local animInfo = net.ReadTable()

	if !(animInfo) then return end

	if (IsValid(animInfo.parent) && animInfo.parent != nil && animInfo.anim) then
		if (animInfo.ClientAnim) then
			animInfo.parent:ClientAnim(animInfo.anim, animInfo.speed)
		end
	end
end)
