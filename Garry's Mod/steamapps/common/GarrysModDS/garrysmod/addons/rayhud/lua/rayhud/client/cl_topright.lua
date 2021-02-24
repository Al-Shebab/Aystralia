-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

local HeightTbl = {}
local PanelsTbl = {}

local width = 410 * RayHUD.Scale

local x = 12 * RayHUD.Scale
local y = x

local ply = LocalPlayer()

CreateClientConVar("rayhud_laws_mode", RayHUD.Cfg.LawsPanel, true, false)
CreateClientConVar("rayhud_wantedlist_mode", RayHUD.Cfg.WantedList, true, false)

RayHUD.LawsPanel = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.LawsPanel or GetConVar( "rayhud_laws_mode" ):GetInt())
RayHUD.WantedList = (!RayHUD.Cfg.EditableForPlayers and RayHUD.Cfg.WantedList or GetConVar( "rayhud_wantedlist_mode" ):GetInt())

local TopRightPanels = {
	{
		Name = function() return ply:getAgendaTable() and ply:getAgendaTable().Title or "" end,
		Icon = FlatUI.Icons.Document,
		Text = function() return ply:getDarkRPVar("agenda") and ply:getDarkRPVar("agenda") or "" end,
		Show = function() return ply:getAgendaTable() and ply:getDarkRPVar("agenda") and ply:getDarkRPVar("agenda") != "" end
	},
	{
		Name = function() return RayHUD.GetPhrase("lockdown") end,
		Icon = FlatUI.Icons.House,
		Text = function() return RayHUD.GetPhrase("lockdown_init") end,
		Show = function() return GetGlobalBool("DarkRP_LockDown") end
	},
	{
		Name = function() return RayHUD.GetPhrase("laws") end,
		Icon = FlatUI.Icons.Law,
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
			return (DarkRP.getLaws() and DarkRP.getLaws() != "") and (RayHUD.LawsPanel == 1 or (RayHUD.LawsPanel == 2 and ply:KeyDown( IN_SCORE )))
		end
	},
	{
		Name = function() return "Wanted List" end,
		Icon = FlatUI.Icons.Handcuffs,
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
					return (RayHUD.WantedList == 1 or (RayHUD.WantedList == 2 and ply:KeyDown( IN_SCORE )))
				end
			end
		end
	},
}

local function UpdatePos(SetSize)
	timer.Simple(0, function()
		for k, v in ipairs(PanelsTbl) do

			if !SetSize then v:SizeTo(width, 55 * RayHUD.Scale + v:GetChild(0):GetTall(), 0.25) end

			if HeightTbl[k] then table.remove( HeightTbl, k ) end

			if !v:IsVisible() then
				if !HeightTbl[k - 1] then
					table.insert( HeightTbl, k, 0 )
				else
					table.insert( HeightTbl, k, HeightTbl[k - 1] )
				end
			else
				if !HeightTbl[k - 1] then
					table.insert( HeightTbl, k, 55 * RayHUD.Scale + v:GetChild(0):GetTall() + y )
				else
					table.insert( HeightTbl, k, (55 * RayHUD.Scale + v:GetChild(0):GetTall()) +  HeightTbl[k - 1] + y )
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
		FlatUI.DrawMaterialBox(ActivePanel.Name(), 0, 0, w, h, ActivePanel.Icon)
	end

	local TextPanel = vgui.Create("DLabel", Panel)
	TextPanel:SetFont("RayHUD:TopRight")
	TextPanel:SetText(DarkRP.deLocalise(ActivePanel.Text()))
	TextPanel:SetPos(10 * RayHUD.Scale, 48 * RayHUD.Scale)
	TextPanel:SetWide(width - 20 * RayHUD.Scale)
	TextPanel:SetAutoStretchVertical( true )
	TextPanel:SetWrap(true)

	timer.Simple(0, function() if !Panel:IsValid() then return end; Panel:SetSize( width, 55 * RayHUD.Scale + TextPanel:GetTall() ) end)
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
			Panel:SizeTo(-1, Panel:GetChildren()[1]:GetTall() + 55 * RayHUD.Scale, 0.25, 0, -1)
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
end