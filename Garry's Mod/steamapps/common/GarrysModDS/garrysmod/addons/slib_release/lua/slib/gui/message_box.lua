--[[
	SLib - Szymekk's Library 
	
	A library that does everything for me (Don't repeat yourself).
	
	message_box.luaa
	17.04.2016 10:18:10
	Compiled using LuaAdvanced
	This file should not be modified.
	
	Copyright © 2016 Szymon (Szymekk) Jankowski
	All Rights Reserved
	Steam: https://steamcommunity.com/id/szymski
]]

surface.CreateFont("slib_msg_btn_font", { ["font"] = "Arial", ["size"] = 17, ["weight"] = 500, })

-- SLib_MessageBoxButton class metatable
CSLib_MessageBoxButton = { }
CSLib_MessageBoxButton.__index = CSLib_MessageBoxButton
CSLib_MessageBoxButton.__type = "SLib_MessageBoxButton"
CSLib_MessageBoxButton.__baseclasses = { }
CSLib_MessageBoxButton.__initializers = { }
luaa.Inherit(CSLib_MessageBoxButton, CLUAA_Object)

function CSLib_MessageBoxButton:Init()
	self:__new()
	self:SetText("")
end
function CSLib_MessageBoxButton:Setup(text)
	self.Text = text
end
function CSLib_MessageBoxButton:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
	if(self:IsHovered()) then
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 20))
	end
	
	surface.SetDrawColor(255, 255, 255, 30)
	surface.DrawOutlinedRect(0, 0, w, h)
	draw.SimpleText(self.Text, "slib_msg_btn_font", w / 2, h / 2, Color(255, 255, 255), 1, 1)
end

CSLib_MessageBoxButton.__initializers[#CSLib_MessageBoxButton.__initializers + 1] = function(self)
    	self.Text = ""

end

function CSLib_MessageBoxButton:__new(...)
    for k, v in pairs(self.__initializers) do
        v(self)
    end
    
end
function SLib_MessageBoxButton(...)
    local tbl = { }
    setmetatable(tbl, CSLib_MessageBoxButton)
    tbl:__new(...);
    return tbl
end

CSLib_MessageBoxButton.__index = nil
derma.DefineControl("SLib_MessageBoxButton", "SLib Message Box", CSLib_MessageBoxButton, "DButton")

-- SLib_MessageBox class metatable
CSLib_MessageBox = { }
CSLib_MessageBox.__index = CSLib_MessageBox
CSLib_MessageBox.__type = "SLib_MessageBox"
CSLib_MessageBox.__baseclasses = { }
CSLib_MessageBox.__initializers = { }
luaa.Inherit(CSLib_MessageBox, CLUAA_Object)

function CSLib_MessageBox:Init()
	self:__new()
	self:SetTitle("")
	self.ButtonPanel:Dock(BOTTOM)
	self.ButtonPanel:SetHeight(24)
	self.Label:SetColor(Color(255, 255, 255))
	self.Label:SetFont("slib_msg_btn_font")
	self.Label:SetContentAlignment(7)
	self.Label:SetWrap(true)
	self.Label:Dock(FILL)
end
function CSLib_MessageBox:Setup(title, text)
	self.Title = title
	self.Label:SetText(text)
	print(text)
	self:ShowCloseButton(false)
	self:SetSize(500, 400)
	local closeButton = self:AddButton("Ok", RIGHT, 100)
	closeButton.DoClick = function()
			self:Remove()
	
	end
	self:MakePopup()
	self:Center()
end
function CSLib_MessageBox:AddButton(text, dockPos, width)
	local btn = self.ButtonPanel:Add("SLib_MessageBoxButton")
	btn:Setup(text)
	btn:Dock(dockPos)
	btn:SetWidth(width)
	return btn
end
function CSLib_MessageBox:Paint(w, h)
	local x, y = self:LocalToScreen(0, 0)
	SLib.Gui.DrawBlurRect(x, y, w, h, 3, 5, 255)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawOutlinedRect(0, 0, w, h)
	draw.SimpleText(self.Title, "slib_msg_btn_font", 4, 4, Color(255, 255, 255), 0, 0)
end

CSLib_MessageBox.__initializers[#CSLib_MessageBox.__initializers + 1] = function(self)
    	self.Title = ""
	self.ButtonPanel = self:Add("EditablePanel")
	self.Label = self:Add("DLabel")

end

function CSLib_MessageBox:__new(...)
    for k, v in pairs(self.__initializers) do
        v(self)
    end
    
end
function SLib_MessageBox(...)
    local tbl = { }
    setmetatable(tbl, CSLib_MessageBox)
    tbl:__new(...);
    return tbl
end

CSLib_MessageBox.__index = nil
derma.DefineControl("SLib_MessageBox", "SLib Message Box", CSLib_MessageBox, "DFrame")
function SLib.Gui.ShowMessageBox(title, text)
	local msg = vgui.Create("SLib_MessageBox")
	msg:Setup(title, text)
	return msg

end
function SLib.Gui.ShowErrorMessageBox(title, text, error)
	local msg = vgui.Create("SLib_MessageBox")
	msg:Setup(title, text .. error)
	local copy = msg:AddButton("Copy to clipboard", LEFT, 200)
	function copy:DoClick()
			surface.PlaySound("buttons/button14.wav")
			SetClipboardText(error)
	
	end
	return msg

end

