-- RayUI Owner: 76561198166995690
-- RayUI Version: 1.4

local PANEL = {}

function PANEL:Init()

end

function PANEL:SetID(id)
	self.interactElement = nil

	if RayUI.Configuration.ConfigOptions[id].TypeEnum == RAYUI_CONFIG_BOOL then
		self.interactElement = RayUI:MakeCheckbox(self, nil, RayUI.GetPhrase("rayui", RayUI.Configuration.ConfigOptions[id].Title) )
		self.interactElement:SetValue(RayUI.Configuration.GetConfig(id))

		self.interactElement.value = RayUI.Configuration.GetConfig(id)

		self.interactElement.GetValue = function(  )
			return self.interactElement.value
		end

		self.interactElement.DoClick = function(  )
			self.interactElement:Toggle()
			self.interactElement.value = !self.interactElement.value
		end

	elseif RayUI.Configuration.ConfigOptions[id].TypeEnum == RAYUI_CONFIG_NUMBER then

		self.interactElement = RayUI:MakeSlider(self, nil, RayUI.GetPhrase("rayui", RayUI.Configuration.ConfigOptions[id].Title), RayUI.Configuration.ConfigOptions[id].minNum, RayUI.Configuration.ConfigOptions[id].maxNum, 0)
		self.interactElement:SetValue(RayUI.Configuration.GetConfig(id))

		self.interactElement:SetText(RayUI.GetPhrase("rayui", RayUI.Configuration.ConfigOptions[id].Title))

	elseif RayUI.Configuration.ConfigOptions[id].TypeEnum == RAYUI_CONFIG_STRING then
		self.interactElement = RayUI:MakeTextEntry(self, RayUI.GetPhrase("rayui", RayUI.Configuration.ConfigOptions[id].Title) )
		self.interactElement:SetText(RayUI.Configuration.GetConfig(id) and RayUI.Configuration.GetConfig(id) or "")

	elseif RayUI.Configuration.ConfigOptions[id].TypeEnum == RAYUI_CONFIG_TABLE then
		self.interactElement = RayUI:MakeComboBox(self, RayUI.GetPhrase("rayui", RayUI.Configuration.ConfigOptions[id].Title))

		for k,v in pairs(RayUI.Configuration.ConfigOptions[id].Values) do
			if istable(v) then
				self.interactElement:AddChoice(k, k)
			else
				self.interactElement:AddChoice(v, v)
			end
		end

		self.interactElement:SetSortItems(RayUI.Configuration.ConfigOptions[id].SortItems)
		self.interactElement:SetText(RayUI.Configuration.GetConfig(id))

	elseif RayUI.Configuration.ConfigOptions[id].TypeEnum == RAYUI_CONFIG_COLOR then
		self.interactElement = RayUI:MakeColorPanel(self, RayUI.GetPhrase("rayui", RayUI.Configuration.ConfigOptions[id].Title))
		self:SetTall(210 * RayUI.Scale)
		self.interactElement:SetColor( RayUI.Configuration.GetConfig(id) )
		self.interactElement.IsColor = true
	end

	self.interactElement.ID = id
end

vgui.Register( "RayUI:DataPanel", PANEL, "Panel" )