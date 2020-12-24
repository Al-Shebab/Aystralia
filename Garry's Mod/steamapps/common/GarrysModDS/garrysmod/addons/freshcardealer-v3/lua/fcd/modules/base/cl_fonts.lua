for i = 1, 150 do
	surface.CreateFont("fcd_font_"..i, {
		font = fcd.cfg.font,
		size = i,
		weight = 500
	})
end
