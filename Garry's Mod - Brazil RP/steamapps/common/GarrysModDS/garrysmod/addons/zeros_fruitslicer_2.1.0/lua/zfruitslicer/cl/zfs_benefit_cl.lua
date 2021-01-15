if not CLIENT then return end

// Effects
net.Receive("zfs_benefit_FX", function(len)

	local effect = net.ReadString()
	local ply = net.ReadEntity()
	local duration = net.ReadFloat()

	if effect and IsValid(ply) and duration then
		zfs.f.ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ply, 0)
		timer.Simple(duration, function()
			if IsValid(ply) and effect and duration then
				ply:StopParticlesNamed(effect)
			end
		end)
	end
end)


// Screeneffects
local ScreenEffectAmount = 0
local screeneffect = nil
local screeneffect_duration = -1

net.Receive("zfs_screeneffect", function(len)

	local ScreenEffectName = net.ReadString()
	local duration = net.ReadFloat()

	if (duration and IsValid(LocalPlayer()) and ScreenEffectName) then
		screeneffect = ScreenEffectName
		screeneffect_duration = duration
		ScreenEffectAmount = 100 * screeneffect_duration

		timer.Simple(screeneffect_duration, function()
			ScreenEffectAmount = 100

			timer.Simple(3, function()
				screeneffect = nil
				screeneffect_duration = -1
			end)
		end)
	end
end)

net.Receive("zfs_screeneffect_stop", function(len)

	ScreenEffectAmount = 0
	screeneffect = nil
	screeneffect_duration = -1
end)

if not timer.Exists("zfs_screeneffect_counter") then
	zfs.f.Timer_Create("zfs_screeneffect_counter",0.1,0,function()
		if (ScreenEffectAmount or 0) > 0 then
			ScreenEffectAmount = ScreenEffectAmount - 10
		end
	end)
end

hook.Add("RenderScreenspaceEffects", "a_zfs_screeneffect", function()
	if (ScreenEffectAmount or 0) > 0 then
		local alpha = 1 / (100 * screeneffect_duration) * ScreenEffectAmount

		if (screeneffect == "MDMA") then
			DrawBloom(alpha * 0.3, alpha * 2, alpha * 8, alpha * 8, 15, 1, 1, 0.3, 0.7)
			DrawMotionBlur(0.1 * alpha, alpha, 0)
			local tab = {}
			tab["$pp_colour_colour"] = math.Clamp(1 * alpha, 1, 2)
			tab["$pp_colour_contrast"] = math.Clamp(1.2 * alpha, 1, 2)
			tab["$pp_colour_brightness"] = math.Clamp(-0.2 * alpha, 0, 1)
			tab["$pp_colour_addb"] = 0.3 * alpha
			tab["$pp_colour_addr"] = 0.5 * alpha
			DrawColorModify(tab)
		elseif (screeneffect == "CACTI") then
			DrawBloom(alpha * 0.3, alpha * 2, alpha * 8, alpha * 8, 15, 1, 1, 0, 0)
			DrawMotionBlur(0.2 * alpha, alpha * 2, 0)
			DrawSunbeams(25, 15, 15, 15, 15)
			local tab = {}
			tab["$pp_colour_colour"] = math.Clamp(1 * alpha, 1, 2)
			tab["$pp_colour_contrast"] = math.Clamp(1.3 * alpha, 1, 2)
			tab["$pp_colour_brightness"] = math.Clamp(-0.2 * alpha, 0, 1)
			tab["$pp_colour_addr"] = 0.4 * alpha
			tab["$pp_colour_addg"] = 0.2 * alpha
			DrawColorModify(tab)
		end
	end
end)
