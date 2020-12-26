
local PANEL = {}

sKore.AccessorFunc(PANEL, "title", "Title", sKore.FORCE_STRING, sKore.invalidateLayout)
sKore.AccessorFunc(PANEL, "description", "Description", sKore.FORCE_STRING, sKore.invaldiateLayout)
sKore.AccessorFunc(PANEL, "favouriteCategory", "FavouriteCategory", sKore.FORCE_BOOL, sKore.invaldiateLayout)

function PANEL:Init()
	self.model = vgui.Create("MCircularModelPanel", self)
	self.model:SetCursor("arrow")
	self.model.LayoutEntity = function() return end

	self.titleLabel = vgui.Create("DLabel", self)
	self.titleLabel:SetFont("sF4MenuItemTitle")
	self.titleLabel:SetWrap(true)
	self.titleLabel:SetPaintedManually(true)
	self.titleLabel:Dock(TOP)

	self.descriptionLabel = vgui.Create("DLabel", self)
	self.descriptionLabel:SetFont("sF4MenuItemDescription")
	self.descriptionLabel:SetWrap(true)
	self.descriptionLabel:SetPaintedManually(true)
	self.descriptionLabel:Dock(TOP)

	self.frame.updateOnSearch[self] = true
	self.jobCommand = ""
	self.team = 0

	self.becomeButton = vgui.Create("MFlatButton", self)
	self.becomeButton:SetPaintedManually(true)
	self.becomeButton.DoClick = function()
		DarkRP.setPreferredJobModel(self.team, self.model:GetModel())
		RunConsoleCommand("darkrp", self.jobCommand)
		self.frame:Close(true)
	end

	self.favouriteButton = vgui.Create("MFlatButton", self)
	self.favouriteButton:SetPaintedManually(true)
	self.favouriteButton.DoClick = function()
		if self:IsFavourited() then
			sKore.fileTable["favourites"]["jobs"][self.team] = nil
		else
			sKore.fileTable["favourites"] = sKore.fileTable["favourites"] or {}
			sKore.fileTable["favourites"]["jobs"] = sKore.fileTable["favourites"]["jobs"] or {}
			sKore.fileTable["favourites"]["jobs"][self.team] = team.GetName(self.team)
			file.Write(sKore.filePath, util.TableToJSON(sKore.fileTable))
		end
		self.frame:InvalidateChildren(true)
	end

	self.scale = 1

	self:SetPaintShadow(false)
	self:SetElevation(0)
	self:SetFavouriteCategory(false)
	self:SetTitle("")
	self:SetDescription("")
end

function PANEL:IsFavourited()
	return sKore.fileTable["favourites"]
		   and sKore.fileTable["favourites"]["jobs"]
		   and sKore.fileTable["favourites"]["jobs"][self.team] == team.GetName(self.team)
end

function PANEL:SizeToContentsY()
	local height = math.max(
		self.model.y + self.model:GetTall(),
		self.becomeButton.y + self.becomeButton:GetTall()
	) + sKore.scaleR(12)
	height = height * self.scale
	self:SetTall(height)
end

function PANEL:SetJobTable(jobTable)
	if !istable(jobTable) then error("'jobTable' argument is not a table!", 2) end

	self:SetTitle(jobTable.name)
	self:SetDescription(jobTable.description)
	self.becomeButton:SetText(jobTable.vote and "#f4menu_voteJob" or "#f4menu_becomeJob")
	self.jobCommand = (jobTable.vote and "vote" or "") .. jobTable.command
	self.team = jobTable.team

	if isstring(jobTable.model) then
		self.model:SetModel(jobTable.model)
		self.model:SetMouseInputEnabled(false)
	else
		local index = 1
		self.model:SetModel(jobTable.model[1])
		self.model.DoClick = function()
			index = (index % #jobTable.model) + 1
			self.model:SetModel(jobTable.model[index])
		end
		self.model:SetCursor("hand")
	end
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
	self.descriptionLabel:PaintManual()
	self.becomeButton:PaintManual()
	self.favouriteButton:PaintManual()
	sKore.drawShadows(self)
end

function PANEL:PerformLayout(width, height)
	self.model:SetSize(sKore.scale(92), sKore.scale(92))
	self.model:SetPos(sKore.scale(16), sKore.scale(16))
	self.model:SetFOV(60)
	self.model:SetCamPos(Vector(15, -10, 65))
	self.model:SetLookAt(Vector(3, 0, 65))

	local textColour = sKore.getBackgroundTextColour(sKore.HIGH_EMPHASIS)
	local leftMargin = self.model.x + self.model:GetWide() + sKore.scale(16)
	local title = sKore.getPhrase(self:GetTitle())
	local description = sKore.getPhrase(self:GetDescription())

	self.titleLabel:DockMargin(leftMargin, sKore.scale(14), sKore.scale(8), 0)
	self.titleLabel:SetText(title)
	self.titleLabel:SetTextColor(textColour)
	self.titleLabel:SizeToContentsY()

	self.descriptionLabel:DockMargin(leftMargin, sKore.scale(8), sKore.scale(8), 0)
	self.descriptionLabel:SetText(description)
	self.descriptionLabel:SetTextColor(textColour)
	self.descriptionLabel:SizeToContentsY()

	self.becomeButton:SizeToContents()
	self.becomeButton:SetPos(
		width - self.becomeButton:GetWide() - sKore.scale(16),
		self.descriptionLabel.y + self.descriptionLabel:GetTall() + sKore.scale(16)
	)

	local favourited = self:IsFavourited()
	self.favouriteButton:SetText(favourited and "#f4menu_unfavourite" or "#f4menu_favourite")
	self.favouriteButton:SizeToContents()
	self.favouriteButton:SetPos(
		self.becomeButton.x - self.favouriteButton:GetWide() - sKore.scale(16),
		self.becomeButton.y
	)
	self.favouriteButton:SetVisible(sF4Menu.config["enableFavourites"])

	self:SizeToContentsY()

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

derma.DefineControl("MJobItem", "", PANEL, "MPanel")
