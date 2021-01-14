if not SERVER then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.MineCart_USE(minecart, ply)
	zrmine.f.Debug("zrmine.f.MineCart_USE")
	local mineBase = minecart:GetParent()

	if not IsValid(mineBase) then return end

	if mineBase.PublicEntity == false and not zrmine.f.IsOwner(ply, minecart) then
		zrmine.f.Notify(ply, zrmine.language.Module_DontOwn, 1)

		return
	end

	if (mineBase:GetCurrentState() == 1) then


		local harvestType = mineBase:GetMineResourceType()

		// The required pickaxe level
		local ReqLvl = zrmine.config.Pickaxe_OreRestriction[harvestType]

		// If we dont have a high enough level for that ore then we stop
		if ply.zrms.lvl < ReqLvl then
			local str = zrmine.language.OreRestriction
			str = string.Replace(str,"$OreType",harvestType)
			zrmine.f.Notify(ply, str .. " [Level " .. ReqLvl .. "]", 1)
			return
		end

		zrmine.f.Minebase_MineCartDown(mineBase, ply)
	end
end

function zrmine.f.MineCart_Unload(minecart)
	zrmine.f.Debug("zrmine.f.MineCart_Unload")
	zrmine.f.CreateNetEffect("minecart_unload",minecart)

	timer.Simple(1, function()
		if (IsValid(minecart)) then
			minecart:SetBodygroup(0, 0)
		end
	end)
end

function zrmine.f.MineCart_RollDown(minecart)
	zrmine.f.Debug("zrmine.f.MineCart_RollDown")
	zrmine.f.CreateNetEffect("minecart_down",minecart)
end
