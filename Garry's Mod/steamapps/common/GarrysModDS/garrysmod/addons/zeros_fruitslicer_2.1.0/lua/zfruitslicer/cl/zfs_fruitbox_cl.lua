if (not CLIENT) then return end
zfs = zfs or {}
zfs.f = zfs.f or {}


//////////////////////////////////////////////////////////////
/////////////////////// Initialize ///////////////////////////
//////////////////////////////////////////////////////////////
function zfs.f.Fruitbox_Draw(Fruitbox)
	if zfs.f.InDistance(LocalPlayer():GetPos(), Fruitbox:GetPos(), 300) then

		cam.Start3D2D(Fruitbox:LocalToWorld(Vector(0,0,17)), Fruitbox:LocalToWorldAngles(Angle(0,0,0)), 0.2)

			surface.SetDrawColor(zfs.default_colors["white01"])
			surface.SetMaterial(zfs.default_materials[Fruitbox.FruitType])
			surface.DrawTexturedRect(-50, -50, 100, 100)

			draw.DrawText(tostring(Fruitbox.FruitAmount), "zfs_buttonfont01", 0, -12, zfs.default_colors["white01"], TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
