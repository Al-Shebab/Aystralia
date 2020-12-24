if CLIENT then

	concommand.Add("doorlink_editor",function(ply,cmd,args)
		if DoorLink_EditorP and DoorLink_EditorP:IsValid() then
			DoorLink_Editor_Close()
		else
			DoorLink_Editor_Open()
		end
	end)
	
	function DoorLink_Editor_Close()
		if DoorLink_EditorP and DoorLink_EditorP:IsValid() then
			DoorLink_EditorP:Remove()
			DoorLink_EditorP = nil
		end
	end
	function DoorLink_Editor_Open()
		if DoorLink_EditorP and DoorLink_EditorP:IsValid() then
			DoorLink_EditorP:Remove()
			DoorLink_EditorP = nil
		end
			DoorLink_EditorP = vgui.Create("DoorLink_Editor")
			DoorLink_EditorP:SetPos(0,0)
			DoorLink_EditorP:SetSize(300,ScrH())
			DoorLink_EditorP:Install()
			
			return DoorLink_EditorP
		
		
	end

end


if CLIENT then
DoorLink_FlipData = {}
function InitCategoryData()
	local Data = {}
	Data.PrintName = "Category"
	
	local function GenUniqueID()
		local Gen = math.random(100000,999999) -- 6 num
		for k,v in pairs(DoorLink.Category) do
			if v.UniqueID == Gen then
				return GenUniqueID()
			end
		end
		return Gen
	end
	
	Data.UniqueID = GenUniqueID()
	Data.Items = {}
	Data.ShowPrintNameInHUD = true -- 문 조준시 이름 표시?
	
	return table.Copy(Data)
end


local PANEL = {}
function PANEL:EditorSetting()
	local CategoryMain = vgui.Create("DoorLink_EditorSetting")
	CategoryMain:SetCategoryID(UniqueID)
	CategoryMain:SetSize(ScrW(),ScrH())
	CategoryMain:Center()
	CategoryMain:MakePopup()
	CategoryMain:Install()
	CategoryMain.Mother = self
end

function PANEL:RemoveDoor(doorent)
	for k,v in pairs(DoorLink.Category) do
		for a,b in pairs(v.Items) do
			if b == doorent:EntIndex() then
				DoorLink.Category[k].Items[a] = nil
			end
		end
	end
	
	self:RefreshList()
	UpdateLinkData_C2S()
end
function PANEL:AddDoor(doorent)
	if !self.SelectedUniqueID then return end
	local TargetTable = nil
	for k,v in pairs(DoorLink.Category or {}) do
		if v.UniqueID == self.SelectedUniqueID then
			TargetTable = DoorLink.Category[k]
		end
	end
	if !TargetTable then return end
	for k,v in pairs(DoorLink.Category) do
		for a,b in pairs(v.Items) do
			if b == doorent:EntIndex() then
				return
			end
		end
	end
	table.insert(TargetTable.Items,doorent:EntIndex())
	
	self:RefreshList()
	UpdateLinkData_C2S()
end
function PANEL:AddCategory()
	local NewData = InitCategoryData()
	table.insert(DoorLink.Category,NewData)
	self:RefreshList()
	UpdateLinkData_C2S()
end
function PANEL:RemoveCategory(UniqueID)
	for k,v in pairs(DoorLink.Category) do
		if v.UniqueID == UniqueID then
			DoorLink.Category[k] = nil
			continue
		end
	end
	self:RefreshList()
	UpdateLinkData_C2S()
end
function PANEL:EditCategory(UniqueID)
	local CategoryMain = vgui.Create("DoorLink_CategoryEditor")
	CategoryMain:SetCategoryID(UniqueID)
	CategoryMain:SetSize(ScrW(),ScrH())
	CategoryMain:Center()
	CategoryMain:MakePopup()
	CategoryMain:Install()
	CategoryMain.Mother = self
end
function PANEL:RefreshList()
	self.CategoryList:Clear()
	
	for k,v in pairs(DoorLink.Category) do
		local CategoryMain = vgui.Create("DoorLink_CategoryButton")
		CategoryMain:SetData(v)
		CategoryMain:SetSize(self.CategoryList,20)
		CategoryMain:SetTexts(v.PrintName)
		CategoryMain.Mother = self
		CategoryMain.LeftClick = function(slf)
			self.SelectedUniqueID = v.UniqueID
			self:RefreshList()
		end
		self.CategoryList:AddItem(CategoryMain)
		
			for a,b in pairs(v.Items) do
				local CategoryMain = vgui.Create("DoorLink_DoorItemButton")
				CategoryMain:SetIndex(b)
				CategoryMain:SetSize(self.CategoryList,20)
				CategoryMain.Mother = self
				self.CategoryList:AddItem(CategoryMain)
			end
	end
	
	
end
function PANEL:Paint()
		surface.SetDrawColor( Color(50,50,50,255) )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())
		
		surface.SetDrawColor( Color(70,70,70,255) )
		surface.DrawRect( 2, 2, self:GetWide()-4, self:GetTall()-4)
		
		
end

function PANEL:Init()
end

function PANEL:Install()
	self.CategoryList = vgui.Create("DPanelList",self)
	self.CategoryList:SetSize(self:GetWide()-14,self:GetTall()-140)
	self.CategoryList:SetPos(7,10)
	self.CategoryList:EnableHorizontal( false )
	self.CategoryList:EnableVerticalScrollbar( true )
	self.CategoryList.Paint = function(slf)
		surface.SetDrawColor( Color(40,40,40,255) )
		surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
	end

	local NewCategory = vgui.Create("DButton",self)
	NewCategory:SetSize(self:GetWide()-20,30)
	NewCategory:SetPos(10,self:GetTall()-120)
	NewCategory:SetText("New Category")
	NewCategory.DoClick = function(slf)
		self:AddCategory()
	end
	
	local NewCategory = vgui.Create("DButton",self)
	NewCategory:SetSize(self:GetWide()-20,30)
	NewCategory:SetPos(10,self:GetTall()-80)
	NewCategory:SetText("Setting")
	NewCategory.DoClick = function(slf)
		self:EditorSetting()
	end
	
	local CloseButton = vgui.Create("DButton",self)
	CloseButton:SetSize(self:GetWide()-20,30)
	CloseButton:SetPos(10,self:GetTall()-40)
	CloseButton:SetText("Close")
	CloseButton.DoClick = function(slf)
		self:Remove()
	end
	
	self:RefreshList()
end

function PANEL:Think()
end

vgui.Register("DoorLink_Editor",PANEL,"DPanel")




















local PANEL = {}
function PANEL:Init()
	self:ShowCloseButton(false)
	self:SetTitle(" ")
	self:SetDraggable(false)
end
function PANEL:SetCategoryID(ID)
	self.UniqueID = ID
	
	for k,v in pairs(DoorLink.Category) do
		if v.UniqueID == ID then
			self.LinkData = v
			return
		end
	end
end
function PANEL:Paint()
		surface.SetDrawColor( Color(0,0,0,200) )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
end
CreateClientConVar("doorlink_rendermode", 0, false, false)
function PANEL:Install()
	self.BG = vgui.Create("DPanel",self)
	self.BG:SetSize(400,250)
	self.BG:Center()
	self.BG.Paint = function(slf)
		surface.SetDrawColor( Color(150,150,150,255) )
		surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
		surface.SetDrawColor( Color(50,50,50,255) )
		surface.DrawRect( 2, 2, slf:GetWide()-4, slf:GetTall()-4)
		draw.SimpleText("Editor Setting", "TargetID", 10, 2, Color(200, 200, 200, 255))
	end
		local CheckBoxThing = vgui.Create( "DCheckBoxLabel", self.BG )
			CheckBoxThing:SetPos( 20,30 )
			CheckBoxThing:SetText( "LinkWep RenderMode" )
			CheckBoxThing:SetValue( 0 )
			CheckBoxThing:SizeToContents() -- Make its size to the contents. Duh?
			CheckBoxThing:SetConVar( "doorlink_rendermode" ) -- ConCommand must be a 1 or 0 value
			
			
		local CloseButton = vgui.Create( "DButton",self.BG )
		CloseButton:SetPos(2,228)
		CloseButton:SetSize(396,20)
		CloseButton:SetText("Save and Exit")
		CloseButton.DoClick = function(slf)
			self:Remove()
		end
end

function PANEL:Think()
end

vgui.Register("DoorLink_EditorSetting",PANEL,"DFrame")





local PANEL = {}
function PANEL:Init()
	self:ShowCloseButton(false)
	self:SetTitle(" ")
	self:SetDraggable(false)
end
function PANEL:SetCategoryID(ID)
	self.UniqueID = ID
	
	for k,v in pairs(DoorLink.Category) do
		if v.UniqueID == ID then
			self.LinkData = v
			return
		end
	end
end
function PANEL:Paint()
		surface.SetDrawColor( Color(0,0,0,200) )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
end

function PANEL:Install()
	self.BG = vgui.Create("DPanel",self)
	self.BG:SetSize(400,250)
	self.BG:Center()
	self.BG.Paint = function(slf)
		surface.SetDrawColor( Color(150,150,150,255) )
		surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
		surface.SetDrawColor( Color(50,50,50,255) )
		surface.DrawRect( 2, 2, slf:GetWide()-4, slf:GetTall()-4)
		draw.SimpleText("Category Editor", "TargetID", 10, 2, Color(200, 200, 200, 255))
		
		draw.SimpleText("Category Name", "TargetID", 20, 25, Color(200, 200, 200, 255))
	end
	
		local Labels = vgui.Create("DTextEntry",self.BG)
			Labels:SetPos(20,40)
			Labels:SetSize(self.BG:GetWide()-40,20)
			Labels:SetAllowNonAsciiCharacters(true)
			if self.LinkData then
				Labels:SetText(self.LinkData.PrintName)
			end
			
			--
		local CheckBoxThing = vgui.Create( "DCheckBoxLabel", self.BG )
			CheckBoxThing:SetPos( 20,70 )
			CheckBoxThing:SetText( "Show Categoryname on HUD" )
			CheckBoxThing:SetValue( 0 )
			CheckBoxThing:SizeToContents() -- Make its size to the contents. Duh?
			if self.LinkData and self.LinkData.ShowPrintNameInHUD then
				CheckBoxThing:SetChecked( true )
			else
				CheckBoxThing:SetChecked( false )
			end
			
			
		local CloseButton = vgui.Create( "DButton",self.BG )
		CloseButton:SetPos(2,228)
		CloseButton:SetSize(396,20)
		CloseButton:SetText("Save and Exit")
		CloseButton.DoClick = function(slf)
			if self.LinkData then
				self.LinkData.PrintName = Labels:GetValue()
				if CheckBoxThing:GetChecked() then
					self.LinkData.ShowPrintNameInHUD = true
				else
					self.LinkData.ShowPrintNameInHUD = false
				end
			end
			UpdateLinkData_C2S()
			self:Remove()
		end
end

function PANEL:Think()
end

vgui.Register("DoorLink_CategoryEditor",PANEL,"DFrame")



local PANEL = {}
function PANEL:Init()
	self:SetText(" ")
end
function PANEL:SetData(data)
	self.Data = data
end
function PANEL:SetTexts(tt)
	self.TXT = tt
end
function PANEL:LeftClick()

end

function PANEL:OnMousePressed(mc)
	if mc == MOUSE_RIGHT then
		local menu = DermaMenu()
		menu:AddOption("Setting",function(slf) self.Mother:EditCategory(self.Data.UniqueID) end)
		menu:AddOption(" ",function(slf) end)
		menu:AddOption(" ",function(slf) end)
		menu:AddOption("Remove",function(slf) self.Mother:RemoveCategory(self.Data.UniqueID) end)
		menu:Open()
	end
	if mc == MOUSE_LEFT then
		self:LeftClick()
	end
end
function PANEL:OnCursorEntered()
	self.Hover = true
end
function PANEL:OnCursorExited()
	self.Hover = false
end

function PANEL:Paint()
	surface.SetDrawColor( Color(20,20,20,255) )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		
	if self.Mother and self.Mother:IsValid() and self.Data and self.Data.UniqueID == self.Mother.SelectedUniqueID then
		surface.SetDrawColor( Color(110,110,110,255) )
	else
		if self.Hover then
			surface.SetDrawColor( Color(50,50,50,255) )
		else
			surface.SetDrawColor( Color(35,35,35,255) )
		end
	end

	
	surface.DrawRect( 2, 2, self:GetWide()-4, self:GetTall()-4 )
	
	if self.Data then
		draw.SimpleText(self.Data.PrintName .. " ( " .. table.Count(self.Data.Items) .. " ) ", "TargetID", 10, 2, Color(200, 200, 200, 255))
	end
end
function PANEL:Think()
end

vgui.Register("DoorLink_CategoryButton",PANEL,"DButton")




local PANEL = {}
function PANEL:Init()
	self:SetText(" ")
end
function PANEL:SetIndex(ind)
	self.DoorIndex = ind
end
function PANEL:SetTexts(tt)
	self.TXT = tt
end
function PANEL:LeftClick()

end

function PANEL:OnMousePressed(mc)
	if mc == MOUSE_RIGHT then

	end
	if mc == MOUSE_LEFT then
		self:LeftClick()
	end
end
function PANEL:OnCursorEntered()
	self.Hover = true
end
function PANEL:OnCursorExited()
	self.Hover = false
end

function PANEL:Paint()

		if self.Hover then
			surface.SetDrawColor( Color(50,50,50,255) )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		end

	
	
	
	if self.DoorIndex then
		draw.SimpleText("Door - " .. (self.DoorIndex or "null"), "TargetID", 20, 2, Color(200, 200, 200, 255))
	end
end
function PANEL:Think()
end

vgui.Register("DoorLink_DoorItemButton",PANEL,"DButton")
end