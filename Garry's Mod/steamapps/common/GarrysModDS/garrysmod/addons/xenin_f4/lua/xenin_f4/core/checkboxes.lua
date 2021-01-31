--[[
Generated using LAUX.
Author: Patrick Ratzow (sleeppyy)

Compile ID: 76561198174514595

This is not the source code, this is a LAUX -> Lua transpiled version.

Licensed to 76561198166995690
Under no circumstances are you allowed to share this script.
Doing so will get you banned from GmodStore.
]]

function F4Menu:GetCheckboxState(id)
  if (!F4Menu.Config.SaveCheckboxStates) then
    return F4Menu.Config.CheckboxStates[id]
  end

  return tobool(LocalPlayer():GetPData("xenin.f4menu.checkbox." .. id, F4Menu.Config.CheckboxStates[id]))
end

function F4Menu:SetCheckboxState(id, state)
  if (!F4Menu.Config.SaveCheckboxStates) then return end

  LocalPlayer():SetPData("xenin.f4menu.checkbox." .. id, tostring(state))
end
