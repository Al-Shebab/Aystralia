--[[
    MGangs 2 - (SH) THEMES
    Developed by Zephruz
]]

mg2.vgui.themes = (mg2.vgui.themes or {})
mg2.vgui._currentTheme = (mg2.vgui._currentTheme or false)

function mg2.vgui:SetCurrentTheme(name)
    local theme = self:GetTheme(name)

    if !(theme) then return end

    self._currentTheme = theme
end

function mg2.vgui:GetCurrentTheme()
    return self._currentTheme
end

function mg2.vgui:GetTheme(name)
    return self.themes[name]
end

function mg2.vgui:RegisterTheme(name, data)
    local themeTbl = {}

    zlib.object:SetMetatable("mg2.Theme", themeTbl)

    themeTbl:SetName(name)

    if (data) then
        for k,v in pairs(data) do
            themeTbl:setData(k,v)
        end
    end

    self.themes[name] = themeTbl

    return self.themes[name]
end

--[[
    Theme Metastructure
]]
local themeMeta = zlib.object:Create("mg2.Theme", {})

themeMeta:setData("Name", "THEME.NAME", {})
themeMeta:setData("Colors", {}, {})

function themeMeta:AddColor(id, color)
    local colors = self:GetColors()

    colors[id] = color

    self:SetColors(colors)
end

function themeMeta:GetColor(id)
    local colors = self:GetColors()

    return colors[id]
end

--[[
    Includes
]]

-- Themes
local files, dirs = file.Find("mg2/vgui/themes/mg2_theme_*", "LUA")

for k,v in pairs(files) do
    zlib.util:IncludeByPath(v, "themes/")
end