AddCSLuaFile()
zfs = zfs or {}
zfs.utility = zfs.utility or {}

zfs.utility.BenefitsIcons = zfs.utility.BenefitsIcons or {}
zfs.utility.BenefitsIcons["Health"] = Material("materials/zfruitslicer/ui/zfs_ui_benefit_health_icon.png", "smooth")
zfs.utility.BenefitsIcons["ParticleEffect"] = Material("materials/zfruitslicer/ui/zfs_ui_benefit_vfx_icon.png", "smooth")
zfs.utility.BenefitsIcons["SpeedBoost"] = Material("materials/zfruitslicer/ui/zfs_ui_benefit_speedboost_icon.png", "smooth")
zfs.utility.BenefitsIcons["AntiGravity"] = Material("materials/zfruitslicer/ui/zfs_ui_benefit_antigravity_icon.png", "smooth")
zfs.utility.BenefitsIcons["Ghost"] = Material("materials/zfruitslicer/ui/zfs_ui_benefit_ghost_icon.png", "smooth")
zfs.utility.BenefitsIcons["Drugs"] = Material("materials/zfruitslicer/ui/zfs_ui_benefit_drugs_icon.png", "smooth")

zfs.default_materials = zfs.default_materials or {}
zfs.default_materials["zfs_ui_assmble"] = Material("materials/zfruitslicer/ui/zfs_ui_assmble.png", "smooth")
zfs.default_materials["zfs_ui_desamble"] = Material("materials/zfruitslicer/ui/zfs_ui_desamble.png", "smooth")
zfs.default_materials["fs_ui_storage"] = Material("materials/zfruitslicer/ui/fs_ui_storage.png", "smooth")
zfs.default_materials["zfs_ui_productbg"] = Material("materials/zfruitslicer/ui/zfs_ui_productbg.png", "smooth")
zfs.default_materials["zfs_ui_takeacup"] = Material("materials/zfruitslicer/ui/zfs_ui_takeacup.png", "smooth")
zfs.default_materials["zfs_ui_starttheblender"] = Material("materials/zfruitslicer/ui/zfs_ui_starttheblender.png", "smooth")
zfs.default_materials["zfs_ui_slicefruit"] = Material("materials/zfruitslicer/ui/zfs_ui_slicefruit.png", "smooth")
zfs.default_materials["zfs_ui_product_hover"] = Material("materials/zfruitslicer/ui/zfs_ui_product_hover.png", "smooth")
zfs.default_materials["zfs_ui_makeproduct"] = Material("materials/zfruitslicer/ui/zfs_ui_makeproduct.png", "smooth")
zfs.default_materials["zfs_ui_chooseswetener"] = Material("materials/zfruitslicer/ui/zfs_ui_chooseswetener.png", "smooth")


zfs.default_materials["zfs_ui_sellbox_main"] = Material("materials/zfruitslicer/ui/zfs_ui_sellbox_main.png", "smooth")
zfs.default_materials["zfs_ui_sellbox_indicator"] = Material("materials/zfruitslicer/ui/zfs_ui_sellbox_indicator.png", "smooth")
zfs.default_materials["zfs_ui_sellbox_button"] = Material("materials/zfruitslicer/ui/zfs_ui_sellbox_button.png", "smooth")
zfs.default_materials["zfs_ui_sellbox_close"] = Material("materials/zfruitslicer/ui/zfs_ui_sellbox_close.png", "smooth")
zfs.default_materials["fs_ui_bar"] = Material("materials/zfruitslicer/ui/fs_ui_bar.png", "smooth")
zfs.default_materials["zfs_ui_changeprice"] = Material("materials/zfruitslicer/ui/zfs_ui_changeprice.png", "smooth")


zfs.default_materials["zfs_melon"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_watermelon.png", "smooth")
zfs.default_materials["zfs_banana"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_banana.png", "smooth")
zfs.default_materials["zfs_coconut"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_coconut.png", "smooth")
zfs.default_materials["zfs_pomegranate"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_pomegranate.png", "smooth")
zfs.default_materials["zfs_strawberry"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_strawberry.png", "smooth")
zfs.default_materials["zfs_kiwi"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_kiwi.png", "smooth")
zfs.default_materials["zfs_lemon"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_lemon.png", "smooth")
zfs.default_materials["zfs_orange"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_orange.png", "smooth")
zfs.default_materials["zfs_apple"] = Material("materials/zfruitslicer/ui/ingrediens/zfs_apple.png", "smooth")



zfs.default_colors = zfs.default_colors or {}

zfs.default_colors["white01"] = Color(255, 255, 255, 255)
zfs.default_colors["white02"] = Color(255, 255, 255, 100)
zfs.default_colors["white03"] = Color(150, 150, 150)
zfs.default_colors["white04"] = Color(200, 200, 200)
zfs.default_colors["white05"] = Color(125, 125, 125, 255)
zfs.default_colors["white06"] = Color(225, 225, 225, 255)
zfs.default_colors["white05"] = Color(100, 100, 100)
zfs.default_colors["white07"] = Color(255, 255, 255, 75)

zfs.default_colors["black01"] = Color(0, 0, 0, 0)
zfs.default_colors["black02"] = Color(0, 0, 0, 255)
zfs.default_colors["black03"] = Color(0, 0, 0, 200)
zfs.default_colors["black04"] = Color(25, 25, 25)
zfs.default_colors["black05"] = Color(40, 40, 40)
zfs.default_colors["black06"] = Color(75, 75, 75, 255)
zfs.default_colors["black07"] = Color(0, 0, 0, 150)
zfs.default_colors["black08"] = Color(0, 0, 0, 25)
zfs.default_colors["black09"] = Color(0, 0, 0, 100)
zfs.default_colors["black10"] = Color(0, 0, 0, 125)

zfs.default_colors["green01"] = Color(148, 167, 142, 255)
zfs.default_colors["green02"] = Color(109, 151, 106, 255)
zfs.default_colors["green03"] = Color(0, 200, 0, 255)
zfs.default_colors["green04"] = Color(125, 255, 125)
zfs.default_colors["green05"] = Color(155, 206, 160, 255)
zfs.default_colors["green06"] = Color(57, 181, 75, 255)
zfs.default_colors["green07"] = Color(141, 198, 63)
zfs.default_colors["green08"] = Color(25, 150, 25)

zfs.default_colors["cyan01"] = Color(0, 200, 200, 255)
zfs.default_colors["cyan02"] = Color(0, 125, 255)

zfs.default_colors["yellow01"] = Color(230, 236, 202, 255)

zfs.default_colors["red01"] = Color(151, 106, 106, 255)
zfs.default_colors["red02"] = Color(255, 90, 70)
zfs.default_colors["red03"] = Color(255, 60, 50)
zfs.default_colors["red04"] = Color(172, 46, 46)
zfs.default_colors["red05"] = Color(218, 28, 92, 255)
zfs.default_colors["red06"] = Color(175, 50, 50)
zfs.default_colors["red07"] = Color(255, 0, 0)
zfs.default_colors["red08"] = Color(255, 110, 102, 255)
zfs.default_colors["red09"] = Color(239, 64, 54, 255)
zfs.default_colors["red10"] = Color(255, 25, 25)

zfs.default_colors["blue01"] = Color(45, 45, 70)
zfs.default_colors["blue02"] = Color(0, 165, 213, 255)
zfs.default_colors["blue03"] = Color(57, 95, 178)
