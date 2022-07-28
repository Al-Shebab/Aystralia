include('shared.lua')

surface.CreateFont("mg2.SIGN.XLARGE", {
	font = "Abel",
	size = 85,
})

surface.CreateFont("mg2.SIGN.LARGE", {
	font = "Abel",
	size = 70,
})

surface.CreateFont("mg2.SIGN.MEDIUM", {
	font = "Abel",
	size = 55,
})

surface.CreateFont("mg2.SIGN.SMALL", {
	font = "Abel",
	size = 40,
})

surface.CreateFont("mg2.SIGN.XSMALL", {
	font = "Abel",
	size = 30,
})

local signDisplayInfo = {
	["Level"] = {
		index = 1,
		getValue = function(gang) return gang:GetLevel() end
	},
	["Balance"] = {
		index = 2,
		getValue = function(gang) return mg2.gang:FormatCurrency(gang:GetBalance()) end
	},
	["Online Members"] = {
		index = 3,
		getValue = function(gang) 
			return table.Count(mg2.gang:GetOnlineMembers(gang:GetID()))
		end
	},
	["Territories"] = {
		index = 4,
		validate = function() return (MG2_TERRITORIES != nil) end,
		getValue = function(gang)
			return table.Count(MG2_TERRITORIES:GetClaimed(gang:GetID()))
		end
	},
	["Associations"] = {
		index = 5,
		validate = function() return (MG2_ASSOCIATIONS != nil) end,
		getValue = function(gang)
			return table.Count(MG2_ASSOCIATIONS:GetGangs(gang:GetID()))
		end
	},
}

function ENT:Draw()
	self:DrawModel()

	local gang = self:GetGang()
	
	if !(gang) then return end
	
	local maxs = self:OBBMaxs()
	local pos, ang = self:GetPos(), self:GetAngles()

	if (LocalPlayer():GetPos():DistToSqr(pos) > 100000) then return end

	local scale = 0.1
	local fullScale = (1 / scale)
	local w, h = (maxs.x * 2) * fullScale, (maxs.y * 2) * fullScale

	local gName, gLvl, gCol = (gang:GetName() || "UNKNOWN"), (gang:GetLevel() || 0), (gang:GetColor() || Color(255,255,255))
	local gMat = self:GetGangMaterial()
	
	ang:RotateAroundAxis(ang:Up(), 90)

	cam.Start3D2D(pos + ang:Up() * 4, ang, scale)
		local olSize = 7	  			-- Outline Size
		local padding = (olSize * 2)	-- Content Padding

		-- Sign Background
		draw.RoundedBoxEx(4, -(w/2), -(h/2), w, h, gCol, true, true, true, true)
		draw.RoundedBoxEx(4, -(w/2) + olSize, -(h/2) + olSize, w - (olSize * 2), h - (olSize * 2), Color(55,55,55), true, true, true, true)

		-- Gang Name
		local gnFont = "mg2.SIGN.MEDIUM"
		local gnW, gnH = zlib.util:GetTextSize(gName, gnFont)

		draw.SimpleText(gName, gnFont, 0, -(h/2) + padding, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		-- Gang Icon
		local gW, gH = 48, 48 -- Icon W, H
		
		if (gMat) then
			surface.SetMaterial(gMat)
			surface.DrawTexturedRect((w/2) - (padding + gW), -(h/2) + padding, gW, gH)
		end

		-- Gang Info
		local curIndex = 1

		for name,data in SortedPairsByMemberValue(signDisplayInfo, "index", false) do
			if (data.validate && !data.validate()) then continue end

			local val = (data.getValue && data.getValue(gang))

			if !(val) then continue end

			local iY = -(h/2) + padding + (curIndex * gnH) -- Y position of info
			local isY = (iY + (gnH * 0.85))				   -- Y position of info separators/horizontal lines
			
			-- Info Separator
			surface.SetDrawColor(130, 130, 130, 100)
			surface.DrawLine(-(w/2) + (padding*2), isY, (w/2) - (padding*2), isY)

			-- Info Text
			draw.SimpleText(name, "mg2.SIGN.SMALL", -(w/2) + (padding*2), iY, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText(val, "mg2.SIGN.SMALL", (w/2) - (padding*2), iY, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		
			curIndex = (curIndex + 1)
		end
	cam.End3D2D()
end