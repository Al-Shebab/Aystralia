if (not CLIENT) then return end

//Animation
net.Receive("zfs_sweetener_AnimEvent", function(len)

	local anim = net.ReadString()
	local ent = net.ReadEntity()

	if IsValid(ent) and anim then
		zfs.f.ClientAnim(ent, anim, 1)
	end
end)

//Effects
net.Receive("zfs_sweetener_FX", function(len)
	local ent = net.ReadEntity()
	local effect = net.ReadString()

	if IsValid(ent) and effect then
		zfs.f.ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ent, 1)
	end
end)
