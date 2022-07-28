--[[
    MGangs 2 - (SH) VGUI ELEMENT - Color picker
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.COLORPICKER.SMALL", {
    font = "Abel",
    size = 17,
})

end

local PANEL = {}

local function openColMixer(colPicker)
    local frame = vgui.Create("mg2.Frame")
    frame:SetSize(300,300)
    frame:SetTitle("Select color")
    frame:SetBackgroundBlur(true)
    frame:Center()
    frame:MakePopup()

    local colMixer = vgui.Create("DColorMixer", frame)
    colMixer:Dock(FILL)
    colMixer:DockMargin(3,3,3,3)
    colMixer.ValueChanged = function(s,col)
        colPicker:SetColor(col)
    end
end

function PANEL:Init() 
    self.theme = mg2.vgui:GetCurrentTheme()

    self._color = Color(255,255,255)

    -- Color button
    self.colorBtn = vgui.Create("DColorButton", self)
    self.colorBtn:Dock(RIGHT)
    self.colorBtn:DockMargin(0,3,3,3)
    self.colorBtn:SetWide(50)
    self.colorBtn:SetColor(self:GetColor())
    self.colorBtn.DoClick = function()
        openColMixer(self)
    end
    self.colorBtn.PaintOver = function(s,w,h)
        draw.SimpleText("Click me", "mg2.COLORPICKER.SMALL", w/2 + 2, 5, Color(0,0,0,125), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("Click me", "mg2.COLORPICKER.SMALL", w/2, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    -- Color cube
    self.colorCube = vgui.Create("DColorCube", self)
    self.colorCube:Dock(FILL)
    self.colorCube:DockMargin(0,3,3,3)
    self.colorCube:SetBaseRGB(self:GetColor())
    self.colorCube.OnUserChanged = function(s,col)
        self:SetColor(col)
    end
end

function PANEL:SetColor(color)
    self._color = color
    
    self.colorBtn:SetColor(color)
    self.colorCube:SetColor(color)

    self:OnColorChange(color)
end

function PANEL:GetColor()
    return self._color
end

function PANEL:OnColorChange(col) end

function PANEL:Paint(w,h) end

vgui.Register("mg2.ColorPicker", PANEL, "DPanel")