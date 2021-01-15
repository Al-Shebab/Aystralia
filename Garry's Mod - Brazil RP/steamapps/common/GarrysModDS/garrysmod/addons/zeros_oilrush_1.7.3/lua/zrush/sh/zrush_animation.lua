zrush = zrush or {}
zrush.f = zrush.f or {}

if SERVER then
	// Animation
	util.AddNetworkString("zrush_AnimEvent")

	function zrush.f.PlayAnimation(prop, anim, speed)
		zrush.f.PlayServerAnimation(prop, anim, speed)
		local animInfo = {}
		animInfo.anim = anim
		animInfo.speed = speed
		animInfo.ent = prop
		net.Start("zrush_AnimEvent")
		net.WriteTable(animInfo)
		net.SendPVS(prop:GetPos())
	end

	function zrush.f.PlayServerAnimation(ent, anim, speed)
		local sequence = ent:LookupSequence(anim)
		ent:SetCycle(0)
		ent:ResetSequence(sequence)
		ent:SetPlaybackRate(speed)
		ent:SetCycle(0)
	end
end

if CLIENT then
	// Animation
	net.Receive("zrush_AnimEvent", function(len)
		zrush.f.Debug("zrush_AnimEvent Len: " .. len)
		local animInfo = net.ReadTable()

		if animInfo and IsValid(animInfo.ent) and animInfo.anim and animInfo.speed then
			zrush.f.PlayClientAnimation(animInfo.ent, animInfo.anim, animInfo.speed)
		end
	end)

	function zrush.f.PlayClientAnimation(ent, anim, speed)
		local sequence = ent:LookupSequence(anim)
		ent:SetCycle(0)
		ent:ResetSequence(sequence)
		ent:SetPlaybackRate(speed)
		ent:SetCycle(0)
	end
end
