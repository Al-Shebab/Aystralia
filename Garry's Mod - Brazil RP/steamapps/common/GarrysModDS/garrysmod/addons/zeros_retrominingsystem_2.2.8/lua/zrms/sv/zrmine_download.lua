if CLIENT then return end

resource.AddSingleFile("materials/entities/zrms_conveyorbelt_c_left.png")
resource.AddSingleFile("materials/entities/zrms_conveyorbelt_c_right.png")
resource.AddSingleFile("materials/entities/zrms_conveyorbelt_n.png")
resource.AddSingleFile("materials/entities/zrms_conveyorbelt_s.png")
resource.AddSingleFile("materials/entities/zrms_crusher.png")
resource.AddSingleFile("materials/entities/zrms_inserter.png")

resource.AddSingleFile("materials/entities/zrms_refiner_bronze.png")
resource.AddSingleFile("materials/entities/zrms_refiner_coal.png")
resource.AddSingleFile("materials/entities/zrms_refiner_gold.png")
resource.AddSingleFile("materials/entities/zrms_refiner_iron.png")
resource.AddSingleFile("materials/entities/zrms_refiner_silver.png")

resource.AddSingleFile("materials/entities/zrms_sorter_bronze.png")
resource.AddSingleFile("materials/entities/zrms_sorter_coal.png")
resource.AddSingleFile("materials/entities/zrms_sorter_gold.png")
resource.AddSingleFile("materials/entities/zrms_sorter_iron.png")
resource.AddSingleFile("materials/entities/zrms_sorter_silver.png")

resource.AddSingleFile("materials/entities/zrms_splitter.png")

if zrmine.config.EnableResourceAddfile then
	zrmine = zrmine or {}
	zrmine.force = zrmine.force or {}

	function zrmine.force.AddDir(path)
		local files, folders = file.Find(path .. "/*", "GAME")

		for k, v in pairs(files) do
			resource.AddFile(path .. "/" .. v)
		end

		for k, v in pairs(folders) do
			zrmine.force.AddDir(path .. "/" .. v)
		end
	end
	resource.AddSingleFile("particles/zrms_crusher_vfx.pcf")
	resource.AddSingleFile("particles/zrms_melter_vfx.pcf")
	resource.AddSingleFile("particles/zrms_mine_vfx.pcf")
	resource.AddSingleFile("particles/zrms_ore_vfx.pcf")
	resource.AddSingleFile("particles/zrms_pickaxe_vfx.pcf")
	resource.AddSingleFile("particles/zrms_refiner_vfx.pcf")
	resource.AddSingleFile("particles/zrms_resource_vfx.pcf")
	resource.AddSingleFile("resource/fonts/Imperial Web.ttf")
	resource.AddSingleFile("resource/fonts/Imperial.otf")
	resource.AddSingleFile("materials/entities/zrms_basket.png")
	resource.AddSingleFile("materials/entities/zrms_basket_bronze.png")
	resource.AddSingleFile("materials/entities/zrms_basket_coal.png")
	resource.AddSingleFile("materials/entities/zrms_basket_gold.png")
	resource.AddSingleFile("materials/entities/zrms_basket_iron.png")
	resource.AddSingleFile("materials/entities/zrms_basket_silver.png")
	resource.AddSingleFile("materials/entities/zrms_gravelcrate.png")
	resource.AddSingleFile("materials/entities/zrms_melter.png")
	resource.AddSingleFile("materials/entities/zrms_mineentrance_base.png")
	resource.AddSingleFile("materials/entities/zrms_resource_bronze.png")
	resource.AddSingleFile("materials/entities/zrms_resource_coal.png")
	resource.AddSingleFile("materials/entities/zrms_resource_gold.png")
	resource.AddSingleFile("materials/entities/zrms_resource_iron.png")
	resource.AddSingleFile("materials/entities/zrms_resource_silver.png")
	resource.AddSingleFile("materials/entities/zrms_storagecrate.png")
	resource.AddSingleFile("materials/vgui/entities/zrms_builder.vmt")
	resource.AddSingleFile("materials/vgui/entities/zrms_builder.vtf")
	resource.AddSingleFile("materials/vgui/entities/zrms_pickaxe.vmt")
	resource.AddSingleFile("materials/vgui/entities/zrms_pickaxe.vtf")

	zrmine.force.AddDir("sound/zrms")
	zrmine.force.AddDir("materials/zerochain/zrms")
	zrmine.force.AddDir("models/zerochain/props_mining")
	zrmine.force.AddDir("materials/zerochain/props_mining")
else
	resource.AddWorkshop("1311178246") -- Zeros Retro Mine Contentpack
end
