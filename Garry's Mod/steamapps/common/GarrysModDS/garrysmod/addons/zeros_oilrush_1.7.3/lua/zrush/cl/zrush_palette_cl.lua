if not CLIENT then return end

net.Receive("zrush_Palette_AddBarrel_net", function(len)
	local Palette = net.ReadEntity()
	local fuel_id = net.ReadInt(6)

	if fuel_id and IsValid(Palette) then

		if Palette.FuelList == nil then
			Palette.FuelList = {}
		end

		table.insert(Palette.FuelList,fuel_id)
	end
end)
