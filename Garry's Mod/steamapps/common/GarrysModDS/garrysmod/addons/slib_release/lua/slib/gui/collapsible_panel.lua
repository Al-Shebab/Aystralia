--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	collapsible_panel.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]


-- SLib_CollapsiblePanel class metatable
CSLib_CollapsiblePanel = { }
CSLib_CollapsiblePanel.__index = CSLib_CollapsiblePanel
CSLib_CollapsiblePanel.__type = "SLib_CollapsiblePanel"
CSLib_CollapsiblePanel.__baseclasses = { }
CSLib_CollapsiblePanel.__initializers = { }
luaa.Inherit(CSLib_CollapsiblePanel, CLUAA_Object)

function CSLib_CollapsiblePanel:Init()
	self:__new()
	self.Button = self:Add("DButton")
	self.Button:SetText("")
	self.Button.DoClick = self.DoClickButton
	self.Button.Paint = self.PaintButton
	self.List = self:Add("DScrollPanel")
end
function CSLib_CollapsiblePanel:Setup(paintFunc)
	self.Button.Paint = paintFunc
end
function CSLib_CollapsiblePanel:PerformLayout(w, h)
	self.Button:SetWidth(w)
	self.List:SetPos(0, self.Button:GetTall())
	self.List:SizeToContents()
	self.List:SetWidth(w)
end
function CSLib_CollapsiblePanel:Think()
	local to = (self.Expanded and (self.List:GetTall() + self.Button:GetTall() + 20) or (self.Button:GetTall() - 20))
	self:SetHeight(math.Clamp(Lerp(FrameTime() * 10, self:GetTall(), to), self.Button:GetTall(), self.List:GetTall() + self.Button:GetTall()))
end
function CSLib_CollapsiblePanel:SetExpanded(value)
	self.Expanded = value
end
function CSLib_CollapsiblePanel:SetTitle(value)
	self.Title = value
end
function CSLib_CollapsiblePanel:AddItem(pnl)
	pnl:SetParent(self.List)
end
function CSLib_CollapsiblePanel:DoClickButton()
	self:GetParent():SetExpanded(not (self:GetParent().Expanded))
end
function CSLib_CollapsiblePanel:PaintButton(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 100, 200))
	draw.SimpleText(self:GetParent().Title, "Trebuchet18", 5, h / 2, Color(255, 255, 255), 0, 1)
end

CSLib_CollapsiblePanel.__initializers[#CSLib_CollapsiblePanel.__initializers + 1] = function(self)
    	self.Button = nil
	self.List = nil
	self.Title = "Collapsible Panel"
	self.Expanded = false

end

function CSLib_CollapsiblePanel:__new(...)
    for k, v in pairs(self.__initializers) do
        v(self)
    end
    
end
function SLib_CollapsiblePanel(...)
    local tbl = { }
    setmetatable(tbl, CSLib_CollapsiblePanel)
    tbl:__new(...);
    return tbl
end

CSLib_CollapsiblePanel.__index = nil
derma.DefineControl("SLib_CollapsiblePanel", "SLib Collapsible Panel", CSLib_CollapsiblePanel, "EditablePanel")
function SLib.Gui.CreateCollapsiblePanel(parent)
	local pnl = vgui.Create("SLib_CollapsiblePanel")
	pnl:SetParent(parent)
	return pnl

end
SLib.Gui.AddTestWindow("collapsible_panel", function(wnd)
	local coll = SLib.Gui.CreateCollapsiblePanel(wnd)
	coll:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	coll = SLib.Gui.CreateCollapsiblePanel(wnd)
	coll:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)
	local btn = coll:Add("DButton")
	coll:AddItem(btn)
	btn:Dock(TOP)

end)

