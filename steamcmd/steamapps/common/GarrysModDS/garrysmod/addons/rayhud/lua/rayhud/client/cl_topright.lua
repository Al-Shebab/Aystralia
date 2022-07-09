-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.2.5

local HeightTbl = {}
local PanelsTbl = {}

local width = 410 * RayUI.Scale

local x = RayHUD.OffsetX
local y = RayHUD.OffsetY

local ply = LocalPlayer()

RayHUD.LawsPanel = RayUI.Configuration.GetConfig( "LawsPanel" )
RayHUD.WantedList = RayUI.Configuration.GetConfig( "WantedList" )

local TopRightPanels = {
	{
		Name = function() return ply:getAgendaTable() and ply:getAgendaTable().Title or "" end,
		Icon = RayUI.Icons.Document,
		Text = function() return ply:getDarkRPVar("agenda") and ply:getDarkRPVar("agenda") or "" end,
		Show = function() return ply:getAgendaTable() and ply:getDarkRPVar("agenda") and ply:getDarkRPVar("agenda") != "" end,
		OnTab = function() return false end
	},
	{
		Name = function() return RayUI.GetPhrase("hud", "lockdown") end,
		Icon = RayUI.Icons.House,
		Text = function() return RayUI.GetPhrase("hud", "lockdown_init") end,
		Show = function() return GetGlobalBool("DarkRP_LockDown") end,
		OnTab = function() return false end
	},
	{
		Name = function() return RayUI.GetPhrase("hud", "laws") end,
		Icon = RayUI.Icons.Law,
		Text = function()
			local laws = ""
			local space = "\n"

			for i = 1, #DarkRP.getLaws() do
				if i == #DarkRP.getLaws() then
					space = ""
				end
				laws = laws .. "" .. i .. ": " .. DarkRP.getLaws()[i] .. space
			end

			return laws
		end,
		Show = function()
			return (DarkRP.getLaws() and DarkRP.getLaws() != "") and (RayHUD.LawsPanel == "Always Show" or (RayHUD.LawsPanel == "Show when opening scoreboard" and ply:KeyDown( IN_SCORE )))
		end,
		OnTab = function() return RayHUD.LawsPanel == "Show when opening scoreboard" end
	},
	{
		Name = function() return "Wanted List" end,
		Icon = RayUI.Icons.Handcuffs,
		Text = function()
			local WantedList = ""
			local space = "\n"

			for k, v in ipairs(player.GetAll()) do
				if v:getDarkRPVar("wanted") == true then
					WantedList = WantedList .. v:Nick() .. " - wanted for '" .. v:getDarkRPVar("wantedReason") .. "'" .. space
				end
			end

			return WantedList
		end,
		Show = function()
			for k, v in ipairs(player.GetAll()) do
				if v:getDarkRPVar("wanted") == true then
					return RayHUD.WantedList == "Always Show" or (RayHUD.WantedList == "Show when opening scoreboard" and ply:KeyDown( IN_SCORE ))
				end
			end
		end,
		OnTab = function() return RayHUD.WantedList == "Show when opening scoreboard" end
	},
}

local function UpdatePos(SetSize)
	timer.Simple(0, function()
		for k, v in ipairs(PanelsTbl) do

			if !SetSize then v:SizeTo(width, 55 * RayUI.Scale + v:GetChild(0):GetTall(), 0.25) end

			if HeightTbl[k] then table.remove( HeightTbl, k ) end

			if !v:IsVisible() then
				if !HeightTbl[k - 1] then
					table.insert( HeightTbl, k, 0 )
				else
					table.insert( HeightTbl, k, HeightTbl[k - 1] )
				end
			else
				if !HeightTbl[k - 1] then
					table.insert( HeightTbl, k, 55 * RayUI.Scale + v:GetChild(0):GetTall() + y )
				else
					table.insert( HeightTbl, k, (55 * RayUI.Scale + v:GetChild(0):GetTall()) +  HeightTbl[k - 1] + 12 * RayUI.Scale )
				end
			end

			v:MoveTo( ScrW() - width - x, y + (HeightTbl[k - 1] and (HeightTbl[k - 1]) or 0), 0.25)
		end
	end)
end

for i = 1, #TopRightPanels do

	local ActivePanel = TopRightPanels[i]

	local Panel = vgui.Create("RayHUD:DPanel")
	Panel:SetPos(ScrW() - width - x, y )
	Panel:ParentToHUD()
	Panel:SetAlpha(0)
	Panel:SetVisible(false)
	Panel.Paint = function(self, w, h)
		RayUI:DrawBlur(self)
		RayUI:DrawMaterialBox(ActivePanel.Name(), 0, 0, w, h, ActivePanel.Icon)
	end
	if ActivePanel.OnTab() then
		Panel.OnTab = true
	else
		Panel.OnTab = false
	end

	local TextPanel = vgui.Create("DLabel", Panel)
	TextPanel:SetFont("RayUI:Small2")
	TextPanel:SetText(DarkRP.deLocalise(ActivePanel.Text()))
	TextPanel:SetPos(10 * RayUI.Scale, 48 * RayUI.Scale)
	TextPanel:SetWide(width - 20 * RayUI.Scale)
	TextPanel:SetAutoStretchVertical( true )
	TextPanel:SetWrap(true)

	timer.Simple(0, function() if !Panel:IsValid() then return end; Panel:SetSize( width, 55 * RayUI.Scale + TextPanel:GetTall() ) end)
	table.insert( PanelsTbl, i, Panel )

	timer.Create("RayHUD:UpdateTopRight_" .. i, 1, 0, function()
		local Text = ActivePanel.Text()
			
		if TextPanel:GetText() != Text then
			TextPanel:SetText(DarkRP.deLocalise(ActivePanel.Text()))
			
			timer.Simple(0, function() UpdatePos() end)
		end

		if ActivePanel.Show() then
			if Panel:IsVisible() then return end

			Panel:SetVisible(true)
			Panel:SizeTo(-1, Panel:GetChildren()[1]:GetTall() + 55 * RayUI.Scale, 0.25, 0, -1)
			Panel:AlphaTo(255, 0.25)
			UpdatePos()
		else
			if !Panel:IsVisible() then return end

			Panel:AlphaTo(0, 0.25, 0, function()
				Panel:SetVisible(false)
				UpdatePos(true)
			end)

			UpdatePos()
		end
	end)

	hook.Add("RayHUD:Reload", "RayHUD:UnloadTopRight", function()
		timer.Remove("RayHUD:UpdateTopRight_" .. i)
	end)
end