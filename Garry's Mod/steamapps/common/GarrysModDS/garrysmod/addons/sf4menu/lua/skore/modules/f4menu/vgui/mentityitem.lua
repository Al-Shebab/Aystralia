
local PANEL = {}

sKore.AccessorFunc(PANEL, "title", "Title", sKore.FORCE_STRING, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "description", "Description", sKore.FORCE_STRING, sKore.invaldiateLayout)
sKore.AccessorFunc(PANEL, "favouriteCategory", "FavouriteCategory", sKore.FORCE_BOOL, sKore.invaldiateLayout)
sKore.AccessorFunc(PANEL, "fovModifer", "FOVModifier", sKore.FORCE_NUMBER, sKore.invaldiateLayout)
sKore.AccessorFunc(PANEL, "distanceModifier", "DistanceModifier", sKore.FORCE_NUMBER, sKore.invaldiateLayout)
sKore.AccessorFunc(PANEL, "entityType", "EntityType", sKore.FORCE_STRING, sKore.invaldiateLayout)

function PANEL:Init()
	self.model = vgui.Create("MCircularModelPanel", self)
	self.model:SetCursor("arrow")

	self.titleLabel = vgui.Create("DLabel", self)
	self.titleLabel:SetFont("sF4MenuItemTitle")
	self.titleLabel:SetWrap(true)
	self.titleLabel:SetPaintedManually(true)
	self.titleLabel:Dock(TOP)

	self.priceLabel = vgui.Create("DLabel", self)
	self.priceLabel:SetFont("sF4MenuItemDescription")
	self.priceLabel:SetWrap(true)
	self.priceLabel:SetPaintedManually(true)
	self.priceLabel:Dock(TOP)

	self.command = {"say", ""}
	self.purchaseButton = vgui.Create("MFlatButton", self)
	self.purchaseButton:SetPaintedManually(true)
	self.purchaseButton.DoClick = function()
		RunConsoleCommand(self.command[1], self.command[2])
	end

	self.favouriteButton = vgui.Create("MFlatButton", self)
	self.favouriteButton:SetPaintedManually(true)
	self.favouriteButton.DoClick = function()
		local entityType = self:GetEntityType()
		if entityType == "" then return end
		if self:IsFavourited() then
			sKore.fileTable["favourites"][entityType][self.command[#self.command]] = nil
		else
			sKore.fileTable["favourites"] = sKore.fileTable["favourites"] or {}
			sKore.fileTable["favourites"][entityType] = sKore.fileTable["favourites"][entityType] or {}
			sKore.fileTable["favourites"][entityType][self.command[#self.command]] = self:GetTitle()
			file.Write(sKore.filePath, util.TableToJSON(sKore.fileTable))
		end
		self.frame:InvalidateChildren(true)
	end

	self.scale = 1
	self.frame.updateOnSearch[self] = true

	self:SetPaintShadow(false)
	self:SetElevation(0)
	self:SetFavouriteCategory(false)
	self:SetTitle("")
	self:SetDescription("")
	self:SetFOVModifier(1)
	self:SetDistanceModifier(1)
	self:SetEntityType("")
end

function PANEL:IsFavourited()
	local entityType = self:GetEntityType()
	return sKore.fileTable["favourites"]
		   and sKore.fileTable["favourites"][entityType]
		   and sKore.fileTable["favourites"][entityType][self.command[#self.command]] == self:GetTitle()
end

function PANEL:SizeToContentsY()
	local height = self.model.y + self.model:GetTall() + sKore.scaleR(16)
	height = height * self.scale
	self:SetTall(height)
end

function PANEL:SetEntityTable(entityTable)
	if !istable(entityTable) then error("'entityTable' argument is not a table!", 2) end
	self:SetTitle(entityTable.name)
	self:SetDescription(entityTable.price == 0 and sKore.getPhrase("#f4menu_freePrice") or DarkRP.formatMoney(entityTable.price)) -- 76561198166995690
	self.model:SetModel(entityTable.model)
	self.model:SetMouseInputEnabled(false)
	self.purchaseButton:SetText("#f4menu_buyButton")
end

function PANEL:Open(instantly)
	if self.opening == true then return end
	if self.scale == 1 then return end
	if instantly then self.scale = 1 return end
	self.opening = true
	local origin = self.scale
	local offset = 1 - origin

	self.animation = self:NewAnimation(0.25 * math.abs(offset), 0, -1, function(animation)
		if self.animation != animation then return end
		self.animation = nil
		self.opening = nil
	end)
	self.animation.Think = function(animation, panel, fraction)
		if self.animation != animation then return end
		self.scale = origin + offset * fraction
		self:InvalidateLayout(true)
	end
end

function PANEL:Close(instantly)
	if self.opening == false then return end
	if self.scale == 0 then return end
	if instantly then self.scale = 0 return end
	self.opening = false
	local origin = self.scale
	local offset = 0 - origin

	self.animation = self:NewAnimation(0.25 * math.abs(offset), 0, -1, function(animation)
		if self.animation != animation then return end
		self.animation = nil
		self.opening = nil
	end)
	self.animation.Think = function(animation, panel, fraction)
		if self.animation != animation then return end
		self.scale = origin + offset * fraction
		self:InvalidateLayout(true)
	end
end

function PANEL:Paint(width, height)
	draw.RoundedBox(0, 0, 0, width, sKore.scaleRC(1, 1), sKore.getShadowColour())
	self.titleLabel:PaintManual()
	self.priceLabel:PaintManual()
	self.purchaseButton:PaintManual()
	self.favouriteButton:PaintManual()
	sKore.drawShadows(self)
end

function PANEL:PerformLayout(width, height)
	self.model:SetSize(sKore.scale(92), sKore.scale(92))
	self.model:SetPos(sKore.scale(16), sKore.scale(16))
	local entity = self.model:GetEntity()
	if entity then
		local size = entity:GetModelRadius()
		local minBounds, maxBounds = entity:GetModelBounds()
		local midBounds = (minBounds + maxBounds) / 2
		self.model:SetFOV(3 * size * self:GetFOVModifier())
		self.model:SetCamPos(Vector(30, 30, 20) * self:GetDistanceModifier())
		self.model:SetLookAt(midBounds)
	end

	self:SizeToContentsY()

	local textColour = sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS)
	local leftMargin = self.model.x + self.model:GetWide() + sKore.scale(16)
	local title = sKore.getPhrase(self:GetTitle())
	local description = sKore.getPhrase(self:GetDescription())

	self.titleLabel:DockMargin(leftMargin, sKore.scale(14), sKore.scale(8), 0)
	self.titleLabel:SetText(title)
	self.titleLabel:SetTextColor(textColour)
	self.titleLabel:SizeToContentsY()

	self.priceLabel:DockMargin(leftMargin, sKore.scale(8), sKore.scale(8), 0)
	self.priceLabel:SetText(description)
	self.priceLabel:SetTextColor(textColour)
	self.priceLabel:SizeToContentsY()

	self.purchaseButton:SizeToContents()
	self.purchaseButton:SetPos(
		width - self.purchaseButton:GetWide() - sKore.scale(16),
		self:GetTall() - self.purchaseButton:GetTall() - sKore.scale(12)
	)

	local favourited = self:IsFavourited()
	self.favouriteButton:SetText(favourited and "#f4menu_unfavourite" or "#f4menu_favourite")
	self.favouriteButton:SizeToContents()
	self.favouriteButton:SetPos(
		self.purchaseButton.x - self.favouriteButton:GetWide() - sKore.scale(16),
		self.purchaseButton.y
	)
	self.favouriteButton:SetVisible(sF4Menu.config["enableFavourites"])


	if self:IsFavouriteCategory() and !favourited then
		self:Close()
	else
		local searchBar = self.frame.searchBar
		if searchBar then
			searchBar = searchBar:lower()
			if string.find(title:lower(), searchBar, 1, true) or string.find(description:lower(), searchBar, 1, true) then
				self:Open()
			else
				self:Close()
			end
		else
			self:Open()
		end
	end
end

function PANEL:SetBackgroundColor(...) self.model:SetBackgroundColor(...) end
function PANEL:GetBackgroundColor(...) self.model:GetBackgroundColor(...) end

derma.DefineControl("MEntityItem", "", PANEL, "MPanel")
