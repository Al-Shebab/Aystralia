--[[
Generated using LAUX.
Author: Patrick Ratzow (sleeppyy)

Compile ID: 76561198174514595

This is not the source code, this is a LAUX -> Lua transpiled version.

Licensed to 76561198166995690
Under no circumstances are you allowed to share this script.
Doing so will get you banned from GmodStore.
]]

local PANEL = {}

function PANEL:Init()
  self:DockMargin(0, 4, 0, 0)
  self.Hover = XeninUI.Theme.Primary
  self.NonHover = XeninUI.Theme.Navbar
end

function PANEL:OnSwitchedTo()
  self:CreateCommands()
end

vgui.Register("F4Menu.Commands.Standalone", PANEL, "F4Menu.Commands")
