
local l = {}

l["HINT"] = {
    ["pickup"]      = '%key% to pickup %weapon%.',
    ["exchange"]    = '%key% to exchange %old_weapon% with %new_weapon%.',
    ["alt"]         = "Hold %key% to view stats."
}

l["STATS"] = {
    ["damage"]      = "Damage",
    ["rpm"]         = "RPM",
    ["clipsize"]    = "Clip-Size",
    ["spread"]      = "Spread",
    ["recoil"]      = "Recoil"
}

USEPICKUP.LANG:Register( "english", l )