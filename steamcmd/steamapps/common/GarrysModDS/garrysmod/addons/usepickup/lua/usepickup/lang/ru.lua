local l = {}

l["HINT"] = {
    ["pickup"]      = '%key% Подобрать %weapon%.',
    ["exchange"]    = '%key% Поменять %old_weapon% на %new_weapon%.',
    ["alt"]         = "Удерживайте %key%, чтобы просмотреть характеристики."
}

l["STATS"] = {
    ["damage"]      = "Урон",
    ["rpm"]         = "Выстрелов в минуту",
    ["clipsize"]    = "Размер обоймы",
    ["spread"]      = "Разброс",
    ["recoil"]      = "Отдача"
}

USEPICKUP.LANG:Register( "russian", l )