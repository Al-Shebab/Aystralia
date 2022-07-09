local L = F4Menu.GetTranslation

local function getMaxOfTeam(job)
    if not job.max or job.max == 0 then return '∞' end
    if job.max % 1 == 0 then return tostring(job.max) end

    return tostring(math.floor(job.max * #player.GetAll()))
end

local PANEL = {}

function PANEL:Init()
	self:EnableVerticalScrollbar()

  local function onJobClick(jobPanel)
    self:OpenOverlay(jobPanel.Job)
  end

  local function isLastIteration(array, index)
		return next(array, index) == nil
	end

  local categories = DarkRP.getCategories().jobs

  for index, category in pairs(categories) do
    local members = category.members
    if not members or #members == 0 then continue end
    local categoryPanel = vgui.Create('OSXCategory')
    categoryPanel:SetName(category.name)
    self:AddItem(categoryPanel)

    for index, job in pairs(members) do
      local isLast = isLastIteration(members, index)
      local panel = vgui.Create('OSXJob')
  		panel:SetJob(job)
      panel:OnClick(onJobClick)
      panel:SetIsLast(isLast)
  		categoryPanel:AddItem(panel)
    end
  end
end

function PANEL:OpenOverlay(job)
	local w, h = self:GetSize()
	local overlay = vgui.Create('OSXJobOverlay', self)
	overlay:SetSize(w, h)
	overlay:Open(job)
end

function PANEL:Refresh()
	if not ValidPanel(self) then return end
	for k,v in pairs(self.Items) do
		v:Refresh()
	end
	self:InvalidateLayout()
end

function PANEL:Paint(w, h)
	draw.RoundedBoxEx(8, 0, 0, w, h, F4Menu.Colors.Background, false, false, false, true)
end

vgui.Register('OSXJobs', PANEL, 'OSXPanelList')

local PANEL = {}

function PANEL:Init()
	self:SetTall(144)
	self:DockPadding(40, 26, 40, 26)

	self.Model = vgui.Create('OSXModelImage', self)
	self.Model:Dock(LEFT)
	self.Model:SetWide(92)
	self.Model:SetFullSize(92, 92)
	self.Model:SetModel('')
	self.Model.OnMouseReleased = function(...) self:OnMouseReleased(...) end

	self.InfoBox = vgui.Create('Panel', self)
	self.InfoBox:Dock(FILL)
	self.InfoBox:DockMargin(20, 0, 0, 0)
	self.InfoBox.OnMouseReleased = function(...) self:OnMouseReleased(...) end

	self.Right = vgui.Create('DLabel', self.InfoBox)
	self.Right:DockMargin(0, 5, 0, 0)
	self.Right:Dock(RIGHT)
	self.Right:SetFont('OSXContextMenu')
	self.Right:SetContentAlignment(8)
	self.Right:SetText('')
	self.Right:SetColor(F4Menu.Colors.TextSmall)
	self.Right:SizeToContents()
	self.Right.OnMouseReleased = function(...) self:OnMouseReleased(...) end

	self.Title = vgui.Create('DLabel', self.InfoBox)
	self.Title:Dock(TOP)
	self.Title:SetFont('OSXItem')
	self.Title:SetText('')
	self.Title:SetColor(F4Menu.Colors.Text)
	self.Title:SizeToContents()
	self.Title.OnMouseReleased = function(...) self:OnMouseReleased(...) end

	self.Description = vgui.Create('DLabel', self.InfoBox)
	self.Description:Dock(FILL)
	self.Description:DockMargin(0, 6, 0, 0)
	self.Description:SetFont('OSXContextMenu')
	self.Description:SetContentAlignment(8)
	self.Description:SetWrap(true)
	self.Description:SetText('')
	self.Description:SetColor(F4Menu.Colors.Text)
	self.Description:SizeToContents()
	self.Description.OnMouseReleased = function(...) self:OnMouseReleased(...) end

	self.Description.PaintOver = function(label, w, h)
		local gradient = surface.GetTextureID('vgui/gradient_up')
		local gradientColor = (self.Hovered or self:IsChildHovered()) and F4Menu.Colors.ItemSelected or F4Menu.Colors.Background

		surface.SetTexture(gradient)
		surface.SetDrawColor(gradientColor)
		surface.DrawTexturedRect(0, h/2 + 1, w, h/2)
	end

  self:SetIsLast(false)
end

function PANEL:SetIsLast(isLast)
	self.Last = isLast
end

function PANEL:IsLast()
	return self.Last
end

function PANEL:OnClick(callback)
  self.OnMouseReleased = function(self)
    callback(self)
  end
end

function PANEL:SetJob(job)
	self.Job = job

	local model = isfunction(job.PlayerSetModel) and job.PlayerSetModel(LocalPlayer()) or istable(job.model) and job.model[1] or job.model
	self.Model:SetModel(model)

	self.Title:SetText(job.name)
	self.Title:SizeToContents()

	self:Refresh()

	local jobDescription = DarkRP.deLocalise(job.description or ''):gsub('  +', '')

	self.Description:SetText(jobDescription)
	self.Description:SizeToContents()
end

function PANEL:Refresh()
	self.Right:SetText(string.format('%s/%s', team.NumPlayers(self.Job.team), getMaxOfTeam(self.Job)))
	self.Right:SizeToContents()
	self:Show()
	self:SetTall(144)
end

function PANEL:Paint(w, h)
  if not self:IsLast() then
	  draw.RoundedBox(0, 20, h - 1, w - 40, 1, F4Menu.Colors.Border)
  end
	if self.Hovered or self:IsChildHovered() then
		draw.RoundedBox(8, 10, (h - 115) / 2, w - 20, 115, F4Menu.Colors.ItemSelected)
	end
end

vgui.Register('OSXJob', PANEL, 'Panel')

local PANEL = {}

function PANEL:Init()
	self.BackgroundAlpha = 0
	self.Opened = true

	self.SubMenu = vgui.Create('Panel', self)
	self.SubMenu.Paint = function(self, w, h)
		draw.RoundedBoxEx(8, 0, 0, w, h, F4Menu.Colors.Background, false, false, false, true)
		draw.RoundedBox(0, 0, 0, 1, h, F4Menu.Colors.Border)
	end

	self.Button = vgui.Create('OSXButton', self.SubMenu)
	self.Button:Dock(BOTTOM)
	self.Button:DockMargin(130, 0, 130, 30)
	self.Button:SetText('')

	self.Top = vgui.Create('Panel', self.SubMenu)
	self.Top:Dock(TOP)
	self.Top:SetTall(80)

	self.Title = vgui.Create('DLabel', self.Top)
	self.Title:Dock(FILL)
	self.Title:DockMargin(30, 25, 30, 0)
	self.Title:SetColor(F4Menu.Colors.Text)
	self.Title:SetAutoStretchVertical(true)
	self.Title:SetFont('OSXBigTitle')
	self.Title:SetText('')

	self.Right = vgui.Create('DLabel', self.Top)
	self.Right:DockMargin(0, 35, 40, 0)
	self.Right:Dock(RIGHT)
	self.Right:SetFont('OSXContextMenu')
	self.Right:SetContentAlignment(8)
	self.Right:SetText('')
	self.Right:SetColor(F4Menu.Colors.TextSmall)
	self.Right:SizeToContents()

	self.Description = vgui.Create('DLabel', self.SubMenu)
	self.Description:Dock(TOP)
	self.Description:DockMargin(30, 0, 30, 0)
	self.Description:SetWrap(true)
	self.Description:SetAutoStretchVertical(true)
	self.Description:SetFont('OSXContextMenu')
	self.Description:SetColor(F4Menu.Colors.Text)
	self.Description:SetText('')

	self.WeaponsTitle = vgui.Create('DLabel', self.SubMenu)
	self.WeaponsTitle:Dock(TOP)
	self.WeaponsTitle:DockMargin(30, 25, 30, 0)
	self.WeaponsTitle:SetColor(F4Menu.Colors.Text)
	self.WeaponsTitle:SetAutoStretchVertical(true)
	self.WeaponsTitle:SetFont('OSXTitle')
	self.WeaponsTitle:SetText(L'weapons')

	self.Weapons = vgui.Create('DLabel', self.SubMenu)
	self.Weapons:Dock(TOP)
	self.Weapons:DockMargin(30, 12, 30, 0)
	self.Weapons:SetColor(F4Menu.Colors.Text)
	self.Weapons:SetAutoStretchVertical(true)
	self.Weapons:SetFont('OSXContextMenu')
	self.Weapons:SetText('')

  local arrowSize = 56

  self.ModelSelector = vgui.Create('Panel', self.SubMenu)
  self.ModelSelector:Dock(BOTTOM)
  self.ModelSelector:SetTall(200)
  self.ModelSelector:DockMargin(126 - arrowSize, 60, 126 - arrowSize, 60)

	self.Model = vgui.Create('OSXModelImage', self.ModelSelector)
	self.Model:Dock(FILL)
	self.Model:SetTall(200)
	self.Model:SetFullSize(200, 200)
	self.Model:SetModel('')
  self.Model:CenterHorizontal()

  self.Selectors = {}

  self.Selectors.Left = vgui.Create('OSXArrow', self.ModelSelector)
  self.Selectors.Left:Dock(LEFT)
  self.Selectors.Left:SetOrigin(LEFT)
  self.Selectors.Left:SetWide(arrowSize)

  self.Selectors.Right = vgui.Create('OSXArrow', self.ModelSelector)
  self.Selectors.Right:Dock(RIGHT)
  self.Selectors.Right:SetOrigin(RIGHT)
  self.Selectors.Right:SetWide(arrowSize)
end

function PANEL:SetModels(models)
  if istable(models) then
    local team = self.Job.team
    local preferredModel = DarkRP.getPreferredJobModel(team)
    local selected = table.KeyFromValue(models, preferredModel) or 1
    
    local function setModel(model)
      DarkRP.setPreferredJobModel(team, model)
      self.Model:SetModel(model)
    end

    self.Selectors.Left.OnMouseReleased = function()
      selected = selected - 1 > 0 and selected - 1 or #models
      setModel(models[selected])
    end

    self.Selectors.Right.OnMouseReleased = function()
      selected = selected + 1 <= #models and selected + 1 or 1
      setModel(models[selected])
    end

    self.Model:SetModel(models[selected])
    self.Selectors.Left:SetCursor('hand')
    self.Selectors.Right:SetCursor('hand')
  else
    self.Selectors.Left.Paint = function() end
    self.Selectors.Right.Paint = function() end
    self.Model:SetModel(models)
  end
end

local getWepName = fn.FOr{fn.FAnd{weapons.Get, fn.Compose{fn.Curry(fn.GetValue, 2)('PrintName'), weapons.Get}}, fn.Id}
local getWeaponNames = fn.Curry(fn.Map, 2)(getWepName)
local weaponString = fn.Compose{fn.Curry(fn.Flip(table.concat), 2)('\n'), fn.Curry(fn.Seq, 2)(table.sort), getWeaponNames, table.Copy}

function PANEL:Open(job)
	local w, h = self:GetSize()

  self.Job = job

	self.SubMenu:SetPos(w, 0)
	self.SubMenu:SetSize(453, h)
	self.SubMenu:MoveTo(w - 453, 0, 0.25, 0, mina.EaseIn)

	self.Title:SetText(job.name)
	self.Right:SetText(string.format('%s/%s', team.NumPlayers(job.team), getMaxOfTeam(job)))
	self.Description:SetText(job.description:gsub('  +', ''))

	local model = isfunction(job.PlayerSetModel)
    and job.PlayerSetModel(LocalPlayer())
    or job.model

  self:SetModels(model)

	if not job.weapons or #job.weapons == 0 then
		self.WeaponsTitle:Remove()
		self.Weapons:Remove()
	else
		local jobWeapons = weaponString(job.weapons)
		self.Weapons:SetText(jobWeapons)
	end

	if job.vote or job.RequiresVote and job.RequiresVote(LocalPlayer(), job.team) then
		self.Button:SetText(DarkRP.getPhrase('create_vote_for_job'))
		self.Button.DoClick = function()
			if F4Menu.CloseOnJobChange then
				f4Frame:Close()
			end
			RunConsoleCommand('darkrp', 'vote' .. job.command)
		end
	else
		self.Button:SetText(DarkRP.getPhrase('become_job'))
		self.Button.DoClick = function()
			if F4Menu.CloseOnJobChange then
				f4Frame:Close()
			end
			RunConsoleCommand('darkrp', job.command)
		end
	end
end

function PANEL:Close()
	local w = self:GetWide()
	self.Opened = false
	self.SubMenu:MoveTo(w, 0, 0.25, 0, mina.EaseInOut, function()
		self:Remove()
	end)
end

function PANEL:OnMouseReleased()
	self:Close()
end

function PANEL:Paint(w, h)
	self.BackgroundAlpha = math.Approach(self.BackgroundAlpha, self.Opened and 200 or 0, FrameTime() * 1200)
	local overlayColor = ColorAlpha(F4Menu.Colors.OverlayColor, self.BackgroundAlpha)
	draw.RoundedBoxEx(F4Menu.Colors.BorderRadius, 0, 0, w, h, overlayColor, false, false, false, true)
end

vgui.Register('OSXJobOverlay', PANEL)
