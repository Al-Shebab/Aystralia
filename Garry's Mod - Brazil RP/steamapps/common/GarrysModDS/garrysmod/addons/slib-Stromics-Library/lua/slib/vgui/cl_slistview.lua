local PANEL = {}

local font = slib.createFont("Roboto", 15)
local textcolor, maincolor_7, linecol, neutralcolor = slib.getTheme("textcolor"), slib.getTheme("maincolor", 7), Color(0,0,0,160), slib.getTheme("neutralcolor")

function PANEL:Init()
    self.Columns = self.Columns or {}
    self.Lines = self.Lines or {}

    self.columniteration = 0
    self.lineiteration = 0
    
    self.assortment = self.assortment or {}

    slib.wrapFunction(self, "Dock", nil, function() return self end, true)
    slib.wrapFunction(self, "SetSize", nil, function() return self end, true)
	slib.wrapFunction(self, "Center", nil, function() return self end, true)
	slib.wrapFunction(self, "SetPos", nil, function() return self end, true)
	slib.wrapFunction(self, "MakePopup", nil, function() return self end, true)
end

function PANEL:getColumnPos(col)
    local result = self.Columns[col]:GetPos()
    return select(1, result)
end

function PANEL:getColumnWide(col)
    return self.Columns[col]:GetWide()
end

local function differenciate(a, b)
    if !(isstring(a) == isstring(b)) or isbool(a) or isbool(b) then
        return tostring(a), tostring(b)
    end

    return a, b
end

function PANEL:addColumn(name)
    if !IsValid(self.topbar) then
        self.topbar = vgui.Create("EditablePanel", self)
        self.topbar:Dock(TOP)
        self.topbar:SetZPos(-32768)
        self.topbar:SetTall(slib.getScaledSize(25, "y"))

        self.topbar.Paint = function(s,w,h)
            surface.SetDrawColor(maincolor_7)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(linecol)
            surface.DrawRect(0, h - 1, w - 1, 1)
        end
    end

    self.columniteration = self.columniteration + 1

    local iteration = self.columniteration

    self.Columns[iteration] = vgui.Create("DButton", self.topbar)
    self.Columns[iteration]:Dock(LEFT)
    self.Columns[iteration]:SetWide(self:GetWide() / #self.Columns)
    self.Columns[iteration].Width = self:GetWide() / #self.Columns
    self.Columns[iteration]:SetText("")
    self.Columns[iteration].name = name
    self.Columns[iteration].iteration = iteration

    self.Columns[iteration].DoClick = function()
        if self.assortment.iteration == iteration then
            self.assortment.ascending = !self.assortment.ascending
        else
            self.assortment.iteration = iteration
            self.assortment.ascending = true
        end
        
        local basictable = {}
        local cleantable = {}

        for i=1,#self.Lines do
            for i, z in pairs(self.Columns[iteration]["lines"][i]) do
                local sortvalue = istable(z) and (z.sortvalue or z.text) or z
                table.insert(basictable, sortvalue)
            end
        end
        
        if self.assortment.ascending then
            table.sort( basictable, function(a, b) a, b = differenciate(a, b) return a > b end )
        else
            table.sort( basictable, function(a, b) a, b = differenciate(a, b) return a < b end )
        end

        for i, z in pairs(basictable) do
            cleantable[z] = i
        end
        
        for i=1,#self.Lines do
            for k, data in pairs(self.Columns[iteration]["lines"][i]) do
                local final = istable(data) and (data.sortvalue or data.text) or data
                self.Lines[i]:SetZPos(cleantable[final])
            end
        end
    end

    self.Columns[iteration].Paint = function(s,w,h)
        draw.SimpleText(name, font, slib.getTheme("margin"), h * .5, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    return self
end

function PANEL:addColumns(...)
    local args = {...}

    for k,v in pairs(args) do
        self:addColumn(v)
    end

    return self
end

function PANEL:addLine(...)
    local args = {...}
    if !IsValid(self.frame) then
        self.frame = vgui.Create("SScrollPanel", self)
        self.frame:Dock(FILL)
        self.frame:SetTall(slib.getScaledSize(25, "y"))
    end

    self.lineiteration = self.lineiteration + 1

    local iteration = self.lineiteration

    for k,v in pairs(args) do
        local display = istable(v) and v[1] or v
        local sortingvalue

        if istable(v) and v[2] then
            sortingvalue = v[2]
        end

        self.Columns[k]["lines"] = self.Columns[k]["lines"] or {}
        self.Columns[k]["lines"][iteration] = self.Columns[k]["lines"][iteration] or {}
        
        self.Columns[k]["lines"][iteration]["text"] = display
        
        if sortingvalue then
            self.Columns[k]["lines"][iteration]["sortvalue"] = sortingvalue
        end

        
    end

    self.Lines[iteration] = vgui.Create("DButton", self)
    self.Lines[iteration]:Dock(TOP)
    self.Lines[iteration]:SetTall(slib.getScaledSize(25, "y"))
    self.Lines[iteration]:SetText("")
    self.Lines[iteration].InitDoClick = self.Lines[iteration].DoClick

    self.Lines[iteration].Think = function()
        self.Lines[iteration]:SetMouseInputEnabled(self.Lines[iteration].DoClick ~= self.Lines[iteration].InitDoClick)
    end

    self.Lines[iteration].Paint = function(s,w,h)
        local wantedcolor = neutralcolor

        if !s:IsHovered() then
            wantedcolor = table.Copy(wantedcolor)
            wantedcolor.a = 0
        end
        
        surface.SetDrawColor(slib.lerpColor(s, wantedcolor))
        surface.DrawRect(0, 0, w, h)
        
        for i = 1,#self.Columns do
            local display = self.Columns[i]["lines"][iteration].text

            if isfunction(display) then
                display = display()
            end

            local x,y = self:getColumnPos(i), h * .5
            local w = self:getColumnWide(i)

            if w < self:getTextWidth(display) then self:resizeColumns() end
            if i == 1 then
                s.name = display
            end

            draw.SimpleText(display, font, x + slib.getTheme("margin"), y, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    return self, self.Lines[iteration]
end

function PANEL:getTextWidth(txt)
    txt = tostring(txt)
    surface.SetFont(font)

    return surface.GetTextSize(txt)
end

function PANEL:resizeColumns()
    local columnsizes = {}
    local fullwidth = self:GetWide()
    local spaceleft = 0

    for k, v in pairs(self.Columns) do
        surface.SetFont(font)

        local longest = self:getTextWidth(self.Columns[k].name)

        if !self.Columns[k]["lines"] then continue end
        for i, z in pairs(self.Columns[k]["lines"]) do
            local compare = isfunction(z.text) and z.text() or z.text
            local width = self:getTextWidth(compare) + (slib.getTheme("margin") * 10)
            if longest < width then longest = width end
        end

        columnsizes[k] = longest
    end

    local occupiedspace = 0
    for k,v in pairs(columnsizes) do
        occupiedspace = occupiedspace + v
    end

    for k,v in pairs(self.Columns) do
        local v = columnsizes[k] or 0

        local gapadd = (fullwidth - occupiedspace) / #self.Columns
        self.Columns[k]:SetWide(v + gapadd)
    end
end

function PANEL:OnSizeChanged()
    self:resizeColumns()
end

function PANEL:PaintOver(w,h)
    for k,v in pairs(self.Columns) do
        if k >= #self.Columns then break end
        local x,y = self:getColumnPos(k), h * .5
        local w = self:getColumnWide(k)
        surface.SetDrawColor(linecol)
        surface.DrawRect(x + w - 1, 0, 1, h)
    end
end

vgui.Register("SListView", PANEL, "SScrollPanel")