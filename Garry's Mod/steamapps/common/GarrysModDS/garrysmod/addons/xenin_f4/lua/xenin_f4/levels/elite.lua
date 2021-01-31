--[[
Generated using LAUX.
Author: Patrick Ratzow (sleeppyy)

Compile ID: 76561198174514595

This is not the source code, this is a LAUX -> Lua transpiled version.

Licensed to 76561198166995690
Under no circumstances are you allowed to share this script.
Doing so will get you banned from GmodStore.
]]

F4Menu.Levels:register("Elite", {
  isInstalled = function(self)
    return istable(EliteXP)
  end,
  getLevel = function(self, ply)
    if ply == nil then ply = LocalPlayer()
    end
    return EliteXP.GetLevel(ply) or 0
  end
})
