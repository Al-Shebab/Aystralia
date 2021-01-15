local origin = Vector(0, 0, 0)
local originTo = Vector(0, 0, 0)
local angle = Angle(0, 0, 0)
local angleTo = Angle(0, 0, 0)

hook.Add("CalcView", "Slawer.Mayor:CalcView", function(ply, pos, angles, fov )
	if not LocalPlayer():Alive() or not IsValid(Slawer.Mayor.LookingTo) or LocalPlayer():GetPos():DistToSqr(Slawer.Mayor.LookingTo:GetPos()) > 40000 then
		if Slawer.Mayor.EnabledClicker then
			gui.EnableScreenClicker(false)
			Slawer.Mayor.EnabledClicker = false
		end
		if IsValid(Slawer.Mayor.Menu) then Slawer.Mayor.Menu.pnlContent:SetVisible(false) end
		Slawer.Mayor.LookingTo = nil
		return
	end

	local view = {}

	local ang = Slawer.Mayor.LookingTo:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Right(), -05)

	origin = Slawer.Mayor.LookingTo:GetPos() + Slawer.Mayor.LookingTo:GetForward() * 27 +Slawer.Mayor.LookingTo:GetUp() * 2
	originTo = Lerp(RealFrameTime() * 8, originTo, origin)

	view.origin = originTo
	view.angles = ang
	view.fov = fov
	view.drawviewer = true

	Slawer.Mayor.ViewOrigin = view.origin
	Slawer.Mayor.EnabledClicker = true
	gui.EnableScreenClicker(true)

	return view
end)

local intNext = 0

hook.Add("KeyPress", "Slawer.Mayor:KeyPress", function(p, k)
	if intNext > CurTime() then return end
	if not p:Alive() then return end

	if k == IN_USE then
		local ent = LocalPlayer():GetEyeTrace().Entity

		if not IsValid(ent) then return end

		if ent:GetClass() == "slawer_mayor_computer" && Slawer.Mayor:CanUseComp(ent) then
			if Slawer.Mayor:HasAccess(LocalPlayer()) then
				Slawer.Mayor.LookingTo = ent
				Slawer.Mayor.Menu:Unlock()
				originTo = LocalPlayer():EyePos()
			else
				Slawer.Mayor.Menu.Lock:OnFail()
			end

			intNext = CurTime() + 0.5
		end
	end
end)

hook.Add("StartCommand", "Slawer.Mayor:RestrictMovingInComp", function(_, cmd)
	if IsValid(Slawer.Mayor.Menu) && IsValid(Slawer.Mayor.Menu.Lock) then
		if Slawer.Mayor.Menu.Lock:GetTall() < 600 then
			cmd:ClearMovement()
		end
	end
end)