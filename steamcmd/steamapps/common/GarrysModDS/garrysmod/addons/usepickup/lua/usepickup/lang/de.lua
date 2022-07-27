
local l = {}

l["HINT"] = {
    ["pickup"]      = "%key% um %weapon% aufzuheben.",
    ["exchange"]    = '%key% um %old_weapon% gegen %new_weapon% zu tauschen.',
    ["alt"]         = "Halte %key% zum vergleichen."
}

l["STATS"] = {
    ["damage"]      = "Schaden",
    ["rpm"]         = "RPM",
    ["clipsize"]    = "Magazingröße",
    ["spread"]      = "Genauigkeit",
    ["recoil"]      = "Rückstoß"
}

USEPICKUP.LANG:Register( "german", l )