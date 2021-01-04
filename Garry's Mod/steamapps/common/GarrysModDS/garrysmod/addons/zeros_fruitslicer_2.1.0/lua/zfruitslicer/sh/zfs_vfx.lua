zfs = zfs or {}
zfs.f = zfs.f or {}

if SERVER then
	// Animation
	util.AddNetworkString("zfs_AnimEvent")

	local function ServerAnim(prop, anim, speed)
		local sequence = prop:LookupSequence(anim)
		prop:SetCycle(0)
		prop:ResetSequence(sequence)
		prop:SetPlaybackRate(speed)
		prop:SetCycle(0)
	end

	function zfs.f.CreateAnimTable(prop, anim, speed)
		ServerAnim(prop, anim, speed)
		net.Start("zfs_AnimEvent")
		local animInfo = {}
		animInfo.anim = anim
		animInfo.speed = speed
		animInfo.parent = prop
		net.WriteTable(animInfo)
		net.SendPVS(prop:GetPos())
	end

	//Effects
	util.AddNetworkString("zfs_FX")
	function zfs.f.CreateEffectTable(effect, sound, parent, angle, position, attach)
		local effectInfo = {}
		effectInfo.effect = effect
		effectInfo.pos = position
		effectInfo.ang = angle
		effectInfo.parent = parent
		effectInfo.attach = attach
		effectInfo.sound = sound

		net.Start("zfs_FX")
		net.WriteTable(effectInfo)
		net.Broadcast()
	end

	util.AddNetworkString("zfs_remove_FX")
	function zfs.f.RemoveEffectNamed(prop, effect, sound)
		net.Start("zfs_remove_FX")
		local effectInfo = {}
		effectInfo.effect = effect
		effectInfo.parent = prop
		effectInfo.sound = sound
		net.WriteTable(effectInfo)
		net.SendPVS(prop:GetPos())
	end
end

if CLIENT then



	function zfs.f.ParticleEffect(effect, pos, ang, ent)
		//if GetConVar("zfs_cl_vfx_particleeffects"):GetInt() == 1 then
			ParticleEffect(effect, pos, ang, ent)
		//end
	end

	function zfs.f.ParticleEffectAttach(effect, enum, ent, attachid)
		//if GetConVar("zfs_cl_vfx_particleeffects"):GetInt() == 1 then
			ParticleEffectAttach(effect, enum, ent, attachid)
		//end
	end

	// Animation
	function zfs.f.ClientAnim(prop, anim, speed)
		local sequence = prop:LookupSequence(anim)
		prop:SetCycle(0)
		prop:ResetSequence(sequence)
		prop:SetPlaybackRate(speed)
		prop:SetCycle(0)
	end

	net.Receive("zfs_AnimEvent", function(len)
		local animInfo = net.ReadTable()

		if (animInfo and IsValid(animInfo.parent) and animInfo.anim) then
			zfs.f.ClientAnim(animInfo.parent, animInfo.anim, animInfo.speed)
		end
	end)

	// Effects
	net.Receive("zfs_FX", function(len)
		local effectInfo = net.ReadTable()

		if effectInfo and IsValid(effectInfo.parent) then
			if effectInfo.sound then
				effectInfo.parent:EmitSound(effectInfo.sound)
			end

			if effectInfo.effect and zfs.f.InDistance(LocalPlayer():GetPos(), effectInfo.parent:GetPos(), 500) then
				if (effectInfo.attach) then
					zfs.f.ParticleEffectAttach(effectInfo.effect, PATTACH_POINT_FOLLOW, effectInfo.parent, effectInfo.attach)
				else
					zfs.f.ParticleEffect(effectInfo.effect, effectInfo.pos, effectInfo.ang, effectInfo.parent)
				end
			end
		end
	end)

	net.Receive("zfs_remove_FX", function(len)
		local effectInfo = net.ReadTable()

		if (effectInfo and IsValid(effectInfo.parent)) then
			if (effectInfo.sound) then
				effectInfo.parent:StopSound(effectInfo.sound)
			end

			if (effectInfo.effect) then
				effectInfo.parent:StopParticlesNamed(effectInfo.effect)
			end
		end
	end)
end
