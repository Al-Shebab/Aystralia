if CLIENT then return end
zfs = zfs or {}
zfs.force = zfs.force or {}

resource.AddSingleFile("materials/entities/zfs_shop.png")
resource.AddSingleFile("materials/entities/zfs_smoothie.png")

if zfs.config.EnableResourceAddfile then
	function zfs.force.AddDir(path)
		local files, folders = file.Find(path .. "/*", "GAME")

		for k, v in pairs(files) do
			resource.AddFile(path .. "/" .. v)
		end

		for k, v in pairs(folders) do
			zfs.force.AddDir(path .. "/" .. v)
		end
	end

	zfs.force.AddDir("materials/zfruitslicer/ui")
	zfs.force.AddDir("materials/particles/fruitslicer")
	zfs.force.AddDir("materials/zerochain/fruitslicerjob")

	zfs.force.AddDir("models/zerochain/fruitslicerjob")

	resource.AddSingleFile("particles/zfruitslicer_banana_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_benefits_effects.pcf")
	resource.AddSingleFile("particles/zfruitslicer_coconut_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_frezze_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_kiwi_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_melon_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_orange_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_sell_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_strawberry_vfx.pcf")
	resource.AddSingleFile("particles/zfruitslicer_sweetener_vfx.pcf")

	resource.AddSingleFile("resource/fonts/nexa-bold.ttf")
	resource.AddSingleFile("resource/fonts/nexa-light-webfont.ttf")

	zfs.force.AddDir("sound/zfs")
else
	resource.AddWorkshop("1272277353") // ZerosFruitSlicer Contentpack
end
