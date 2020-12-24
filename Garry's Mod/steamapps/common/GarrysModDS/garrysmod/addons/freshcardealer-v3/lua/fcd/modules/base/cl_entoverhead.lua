local findEnts = {}
findEnts[ 'freshcardealer' ] = {
	txt = function( ent )
		return fcd.getDealerName( ent )
	end
}
findEnts[ 'chopshop' ] = {
	txt = function( ent )
		return 'Chop Shop'
	end
}

function fcd.entOverheadDisplay()
	local hop = math.abs(math.cos(CurTime() * 1))

	for i, v in pairs( findEnts ) do
		for k, ent in pairs( ents.FindByClass( i ) ) do
			if ent:GetPos():Distance( LocalPlayer():GetPos() ) >= fcd.cfg.entDisplayDistance then continue end

			local pos = ent:GetPos() + Vector( 0, 0, 95 + hop * 15 )
			local ang = Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 )

			cam.Start3D2D( pos, ang, 0.1 )
		 		draw.SimpleText( '▶ ' .. v.txt(ent) .. ' ◀', 'fcd_font_150', 0, 0, fcd.cfg.entOverheadColor, 1 )
			cam.End3D2D()
		end
	end
end

hook.Add('PostDrawOpaqueRenderables', 'fcd.entOverheadDisplay', fcd.entOverheadDisplay)
