
local PANEL = {}

function PANEL:Init()
	self:SetPaintShadow(false)
	self:SetDrawShadows(false)
end

function PANEL:SetPalette(rawPalette)
	if !istable(rawPalette) then error("'rawPalette' argument is not a table!", 2) end
	self.rawPalette = table.Reverse(rawPalette)
	self.palette = {}
	for _, themeName in ipairs(self.rawPalette) do
		local themeTable = sKore.getThemeByName(themeName)
		table.insert(self.palette, {themeTable:GetPrimaryColour(sKore.PRIMARY_DARK), themeTable:GetPrimaryColour(sKore.PRIMARY)})
	end
end

function PANEL:GetCursorAngle()
	local x, y = self:GetWide() / 2, self:GetTall() / 2
	local mousex, mousey = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
	local hypotenuse = math.Distance(x, y, mousex, mousey)

	local cos = (mousex - x) / hypotenuse
	local angle = mousey < y and math.acos(cos) or math.rad(360) - math.acos(cos)
	return angle
end

function PANEL:Paint(width, height)
	if !self.palette then return end
	local x, y = width / 2, height / 2
	local radius = math.min(x, y)
	local segmentCount = #self.palette
	local archDots = math.Clamp(math.ceil(math.pi * radius / 20 / segmentCount), math.ceil(30 / segmentCount), math.floor(1024 / segmentCount))
	local circleDots = archDots * segmentCount

	local inRange = false
	local cursorAngle
	if self:IsHovered() then
		local distance = math.Distance(x, y, self:ScreenToLocal(gui.MouseX(), gui.MouseY()))
		inRange = radius * 0.4 <= distance and distance <= radius
		self:SetCursor(inRange and "hand" or "arrow")
		cursorAngle = self:GetCursorAngle()
	end

	draw.NoTexture()
	surface.SetDrawColor(sKore.getShadowColour())
	sKore.drawCircle(x, y, radius)

	local isHoveredGlobal = false
	for segment, colours in pairs(self.palette) do
		segment = segment - 1
		local innerArch, mediumArch, outerArch = {}, {}, {}
		for i = 0, archDots do
			local angle = math.rad(((segment * archDots + i) / circleDots) * 360 + 90)
			table.insert(innerArch, {
				["x"] = x + math.cos(angle) * radius * 0.4,
				["y"] = y - math.sin(angle) * radius * 0.4
			})
			table.insert(mediumArch, {
				["x"] = x + math.cos(angle) * radius * 0.6,
				["y"] = y - math.sin(angle) * radius * 0.6
			})
			table.insert(outerArch, {
				["x"] = x + math.cos(angle) * (radius - sKore.scale(4, 4)),
				["y"] = y - math.sin(angle) * (radius - sKore.scale(4, 4))
			})
		end

		local startAngle = math.rad((segment / segmentCount) * 360 + 90)
		if startAngle > 2 * math.pi then startAngle = startAngle - 2 * math.pi end
		local endAngle = math.rad(((segment + 1) / segmentCount) * 360 + 90)
		if endAngle > 2 * math.pi then endAngle = endAngle - 2 * math.pi end

		local isHovered
		if inRange and !isHoveredGlobal then
			if endAngle < startAngle then
				isHoveredGlobal = cursorAngle >= startAngle or cursorAngle <= endAngle
			else
				isHoveredGlobal = cursorAngle >= startAngle and cursorAngle <= endAngle
			end
			isHovered = isHoveredGlobal
		else
			isHovered = false
		end

		local darkSegment = table.Copy(innerArch)
		table.Add(darkSegment, table.Reverse(mediumArch))
		surface.SetDrawColor(colours[1])
		surface.DrawPoly(darkSegment)

		local lightSegment = table.Copy(mediumArch)
		table.Add(lightSegment	, table.Reverse(outerArch))
		surface.SetDrawColor(colours[2])
		surface.DrawPoly(lightSegment)

		if isHovered then
			local wholeSegment = innerArch
			table.Add(wholeSegment	, table.Reverse(outerArch))
			surface.SetDrawColor(Color(255, 255, 255, input.IsMouseDown(MOUSE_FIRST) and 40 or 20))
			surface.DrawPoly(wholeSegment)
		end
	end
end

function PANEL:OnMousePressed(mousecode)
	local x, y = self:GetWide() / 2, self:GetTall() / 2
	local radius = math.min(x, y)
	local distance = math.Distance(x, y, self:ScreenToLocal(gui.MouseX(), gui.MouseY()))
	local inRange = radius * 0.4 <= distance and distance <= radius

	if inRange then
		self:MouseCapture(true)
		self.pressed = true
	end
end

function PANEL:OnMouseReleased(mousecode)
	self:MouseCapture(false)
	if !self.pressed then return end
	self.pressed = nil

	local x, y = self:GetWide() / 2, self:GetTall() / 2
	local radius = math.min(x, y)
	local segmentCount = #self.palette

	local inRange = false
	local cursorAngle
	if self:IsHovered() then
		local distance = math.Distance(x, y, self:ScreenToLocal(gui.MouseX(), gui.MouseY()))
		inRange = radius * 0.4 <= distance and distance <= radius
		if !inRange then return end
		cursorAngle = self:GetCursorAngle()
	end

	for segment, colors in pairs(self.palette) do
		local startAngle = math.rad(((segment - 1) / segmentCount) * 360 + 90)
		if startAngle > 2 * math.pi then startAngle = startAngle - 2 * math.pi end
		local endAngle = math.rad((segment / segmentCount) * 360 + 90)
		if endAngle > 2 * math.pi then endAngle = endAngle - 2 * math.pi end

		local isHovered
		if inRange then
			if endAngle < startAngle then
				isHovered = cursorAngle >= startAngle or cursorAngle <= endAngle
			else
				isHovered = cursorAngle >= startAngle and cursorAngle <= endAngle
			end
			if isHovered then
				local themeName = self.rawPalette[segment]
				local theme = sKore.getThemeByName(themeName)
				if theme:HasPermission() then
					local themeID = theme:GetID()
					if themeID != sKore.getActiveThemeID() then
						sKore.themeConvar:SetString(themeID)
						self.frame:CreateSnackbar(sKore.getPhrase("#customization_themeChangedSuccessfully", theme:GetName()), 1.5)
					else
						self.frame:CreateSnackbar(sKore.getPhrase("#customization_themeAlreadyInUse", theme:GetName()), 1.5)
					end
				else
					self.frame:CreateSnackbar(theme:GetFailMessage(), 1.5)
				end
				break
			end
		end
	end
end

derma.DefineControl("MCircularPalette", "", PANEL, "MPanel")
