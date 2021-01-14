local L = VoidCases.Lang.GetPhrase
local sc = VoidUI.Scale

--

local function createFrame(self, _name, _color, pnl)
    local frame = vgui.Create("VoidUI.Frame")
    frame:SSetSize(380, 450)
    frame:MakePopup()
    frame:Center()
    frame:SetParent(self:GetParent())
    frame:StayOnTop()

    frame:SetTitle(_name or L"add_rarity")

    local container = frame:Add("Panel")
    container:Dock(FILL)
    container:SDockMargin(30, 20, 30, 0)

    local grid = container:Add("VoidUI.ElementGrid")
    grid:Dock(FILL)
    grid:MarginBottom(5)
    grid:SetColumns(1)

    local name = grid:AddElement(L"name", "VoidUI.TextInput")
    local color = grid:AddElement(L"color", "VoidUI.ColorMixer", sc(145))

    if (_name and _color) then
        name:SetValue(_name)
        color.colorMixer:SetColor(_color)
    end

    local buttonContainer = frame:Add("Panel")
    buttonContainer:Dock(BOTTOM)
    buttonContainer:SSetTall(100)
    buttonContainer:SDockPadding(35,30,35,30)
    
    local saveButton = buttonContainer:Add("VoidUI.Button")
    saveButton:Dock(LEFT)
    saveButton:SSetWide(140)
    saveButton:SetText(_name and L"edit" or L"create")
    saveButton:SetColor(VoidUI.Colors.Green, VoidUI.Colors.Background)

    saveButton.DoClick = function ()

        local c = color.colorMixer:GetColor()

        net.Start("VoidCases_CreateRarity")
            net.WriteString(name:GetValue())
            net.WriteBool(_name and true or false)
            if (_name) then
                net.WriteString(_name)
            end
            net.WriteBool(false)
            net.WriteColor(Color(c.r, c.g, c.b, 255))
        net.SendToServer()

        self.tbl[name:GetValue()] = {c, nil}
        if (_name and _name != name:GetValue()) then
            self.tbl[_name] = nil
        end

        self.refreshRarities(self.tbl)

        frame:Remove()
    end

    local deleteButton = buttonContainer:Add("VoidUI.Button")
    deleteButton:Dock(RIGHT)
    deleteButton:SSetWide(140)
    deleteButton:SetText(L"delete")
    deleteButton:SetColor(VoidUI.Colors.Red, VoidUI.Colors.Background)
    deleteButton:SetVisible(_name and true or false)

    if (_name) then
        local canDelete = true
        for k, v in pairs(VoidCases.Config.Items) do
            if (!VoidCases.IsItemValid(v)) then continue end

            if (v.info.rarity == VoidCases.Rarities[_name]) then
                canDelete = false
            end
        end

        deleteButton:SetEnabled(canDelete)
    end

    deleteButton.DoClick = function ()
        net.Start("VoidCases_CreateRarity")
            net.WriteString(_name)
            net.WriteBool(false)
            net.WriteBool(true)
        net.SendToServer()

        self.tbl[name:GetValue()] = nil

        self.refreshRarities(self.tbl)
        frame:Remove()
    end
end

--

local PANEL = {}

function PANEL:Init()
    local grid = self:Add("VoidUI.Grid")
    grid:Dock(FILL)
    grid:MarginTop(40)

    grid:InvalidateParent(true)

    grid:SetColumns(3)
    grid:SetHorizontalMargin(sc(20))
    grid:SetVerticalMargin(sc(15))

    local tbl = table.Copy(VoidCases.Config.CustomRarities)
    self.tbl = tbl

    self.refreshRarities = function ()
        grid:Clear()

        for name, tbl in pairs(tbl) do
            local panel = vgui.Create("DButton")
            panel:SSetTall(45)
            panel:SetText("")
            panel.Paint = function (self, w, h)
                draw.RoundedBox(8, 0, 0, w, h, tbl[1])

                draw.SimpleText(name, "VoidUI.R24", sc(15), h/2, VoidUI.Colors.Gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                local icoSize = sc(18)
                local margin = sc(20)

                surface.SetDrawColor(VoidUI.Colors.Gray)
                surface.SetMaterial(VoidUI.Icons.Rename)
                surface.DrawTexturedRect(w - sc(icoSize) - margin, h/2 - icoSize / 2, icoSize, icoSize)
            end

            panel.DoClick = function ()
                createFrame(self, name, tbl[1], panel)
            end

            grid:AddCell(panel)
        end
    end
    self.refreshRarities()

    local buttonContainer = self:Add("Panel")
    buttonContainer:Dock(BOTTOM)
    buttonContainer:SSetTall(50)
    buttonContainer:MarginSides(320)
    buttonContainer:MarginTops(10)

    local addRarity = buttonContainer:Add("VoidUI.Button")
    addRarity:Dock(FILL)
    addRarity:SetColor(VoidUI.Colors.Green, VoidUI.Colors.Primary)
    addRarity:SetText(L"add_rarity")

    addRarity.DoClick = function ()
        createFrame(self)
    end

end

function PANEL:Paint(w, h)
    draw.SimpleText(table.Count(VoidCases.Config.CustomRarities) .. " " .. L"rarities", "VoidUI.R26", 0, 0, VoidUI.Colors.Gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

vgui.Register("VoidCases.Rarities", PANEL, "Panel")