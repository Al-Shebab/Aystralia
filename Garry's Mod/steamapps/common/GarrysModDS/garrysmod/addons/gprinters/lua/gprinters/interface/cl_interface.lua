local Fonts = {}
Fonts[ "font" ] = "bfhud"

function gPrinters.moneyFormat( number )
    number = tonumber( number )
    local output = number
    if number < 1000000 then
        output = string.gsub( number, "^(-?%d+)(%d%d%d)", "%1,%2" )
    else
        output = string.gsub( number, "^(-?%d+)(%d%d%d)(%d%d%d)", "%1,%2,%3" )
    end
    return output
end

function gPrinters.rotatedBox( x, y, w, h, ang, color )
    draw.NoTexture()
    surface.SetDrawColor( color or color_white )
    surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

for a,b in pairs( Fonts ) do
    for k = 0, 100 do
        surface.CreateFont( a .. k, { font = b, size = k, weight = 750 } )
    end
end

function gPrinters.drawBox( radius, x, y, w, h, color )
    draw.RoundedBox( radius, x, y, w, h, color )
end

function gPrinters.drawPicture( x, y, w, h, icon, r, g, b, alpha )
    surface.SetMaterial( Material( icon, "smooth" ) )
    surface.SetDrawColor( r, g, b, alpha )
    surface.DrawTexturedRect( x, y, w, h )
end

function gPrinters.blackPicture( x, y, w, h, icon )
    surface.SetMaterial( Material( icon, "smooth" ) )
    surface.SetDrawColor( 0, 0, 0, 75 )
    surface.DrawTexturedRect( x, y, w, h )
end

function gPrinters.drawText( upper, text, size, x, y, color, align )
    if ( upper == 1 ) then
        draw.SimpleText( string.upper( text ), "font" .. size, x, y, color, align, 1 )
    else
        draw.SimpleText( text, "font" .. size, x, y, color, align, 1 )
    end
end

local P0 = {}
function P0:Init()
    self:GetVBar():SetSize( 10 )
    self:GetVBar().Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar():GetWide(), self:GetVBar():GetTall(), Color( 255, 255, 255, 10 ) ) end
    self:GetVBar().btnGrip.Paint = function() draw.RoundedBox( 0, 0, 1, self:GetVBar().btnGrip:GetWide(), self:GetVBar().btnGrip:GetTall() - 2, Color( 255, 255, 255, 10 ) ) end
    self:GetVBar().btnUp.Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar().btnUp:GetWide(), self:GetVBar().btnUp:GetTall(), Color( 255, 255, 255, 10 ) ) end
    self:GetVBar().btnDown.Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar().btnDown:GetWide(), self:GetVBar().btnDown:GetTall(), Color( 255, 255, 255, 10 ) ) end
end
vgui.Register( "gPrinters.Parent", P0, "DScrollPanel" )

local P1 = {}
function P1:Init()
    self:SetSize( 225, 20 )
    self.enabled = false
end

function P1:Paint( w, h )
    local x = w - 43
    local y = 3
    gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
    gPrinters.drawBox( 0, x, y, 40, 15, Color( 5, 5, 5, 100 ) )

    if self.enabled then
        gPrinters.drawBox( 0, 2 + x, 2 + y, 18, 11, Color( 50, 150, 50, 100 ) )
    else
        gPrinters.drawBox( 0, 20 + x, 2 + y, 18, 11, Color( 150, 50, 50, 100 ) )
    end
end

function P1:OnMousePressed()
    self.enabled = !self.enabled
    self:onOptionChanged()
end

function P1:onOptionChanged()
end
vgui.Register( "gprinters_switch", P1, "EditablePanel" )

local P2 = {}
function P2:Init()
    self:SetSize( 40, 15 )
    self.enabled = false
end

function P2:Paint( w, h )
    gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
    if self.enabled then
        gPrinters.drawBox( 0, 2, 2, 18, 11, Color( 50, 150, 50, 100 ) )
    else
        gPrinters.drawBox( 0, 20, 2, 18, 11, Color( 150, 50, 50, 100 ) )
    end
end

function P2:OnMousePressed()
    self.enabled = !self.enabled
    self:onOptionChanged()
end

function P2:onOptionChanged()
end
vgui.Register( "gprinters_switch_original", P2, "EditablePanel" )

local metaPanel = FindMetaTable( "Panel" )
function metaPanel:scrollPanel()
    self.VBar.btnDown.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 100 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.btnUp.Paint = function(slf)
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 100 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.btnGrip.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 100 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.Paint = function( slf )
    end
end

function metaPanel:hideBar()
    self.VBar.btnDown.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.btnUp.Paint = function(slf)
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.btnGrip.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.Paint = function( slf )
    end
end

local P3 = {}
function P3:Init()
    self:SetSize( 340, 20 )
    self:SetCursor( "beam" )
    self:SetFont( "font17" )
    self:SetCursorColor( Color( 163, 163, 163, 150 ) )
end

function P3:Paint( w, h )
    surface.SetDrawColor( Color( 5, 5, 5, 100 ) )
    surface.DrawRect( 0, 0, w, h )
    self:DrawTextEntryText( Color( 171, 171, 171 ), Color( 163, 163, 163, 150 ), Color( 163, 163, 163, 150 ) )

    if ( self:HasFocus() ) then
        surface.SetDrawColor( Color( 163, 163, 163, 50 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
end

function P3:OnEnter()
end
vgui.Register( "gprinters_textinput", P3, "DTextEntry" )

local P4 = {}
function P4:Init()
    self:SetSize( 140, 20 )
    self:SetText( "" )
    self.valor = Vector( 0, 0, 0 )
    self.plugins = ""
end

function P4:DoClick()
    local colorpicker = vgui.Create( "DFrame" )
    colorpicker:SetSize( 267, 230 )
    colorpicker:Center()
    colorpicker:SetTitle( "" )
    colorpicker:MakePopup()
    colorpicker:SetDraggable( false )
    colorpicker:ShowCloseButton( false )

    colorpicker.Paint = function( slf, w, h )
        gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 255 ) )
        gPrinters.drawBox( 0, 1, 1, slf:GetWide() - 2, slf:GetTall() - 2, Color( 57, 64, 77, 255 ) )
        gPrinters.drawBox( 0, 2, 2, slf:GetWide() - 4, slf:GetTall() - 4, Color( 29, 33, 44, 255 ) )
        gPrinters.drawBox( 0, 1, 25, slf:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )
        gPrinters.drawText( 0, "Color Selection Menu", 14, 10, 10, Color( 163, 163, 163, 175 ), 0 )
    end

    local Mixer = vgui.Create( "DColorMixer", colorpicker )
    Mixer:SetSize( 255, 150 )
    Mixer:SetPos( 5, 30 )
    Mixer:SetPalette( false )
    Mixer:SetAlphaBar( false )
    Mixer:SetWangs( true )

    local cbtn = vgui.Create( "DButton", colorpicker )
    cbtn:SetSize( 257, 32 )
    cbtn:SetPos( 5, colorpicker:GetTall() - 35 )
    cbtn:SetText ( "" )
    cbtn.Paint = function( slf, w, h )
        if slf:IsHovered() then
            gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 150 ) )
        else
            gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
        end
        gPrinters.drawText( 0, "Choose Color", 14, w / 2, h / 2, Color( 163, 163, 163, 175 ), 1 )
    end

    cbtn.DoClick = function()
        if self && self:IsValid() then
            self.valor = Vector( Mixer:GetColor().r, Mixer:GetColor().g, Mixer:GetColor().b )
            colorpicker:Remove()
        else
            colorpicker:Remove()
        end
    end
end

function P4:Paint( w, h )
    gPrinters.drawBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 100 ) )
    gPrinters.drawText( 0, math.Round( self.valor.r ) .. " " .. math.Round( self.valor.g ) .. " " .. math.Round( self.valor.b ), 14, w / 2, h / 2, Color( self.valor.r, self.valor.g, self.valor.b, 175 ), 1 )
end
vgui.Register( "gprinter_vector", P4, "DButton" )

local P5 = {}
function P5:Init()
    self:SetSize( 140, 20 )
    self:SetText( "Choose your sound" )
    self:AddChoice( "ambient/levels/labs/equipment_printer_loop1.wav" )
end

function P5:Paint( w, h )
    gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
end
vgui.Register( "gprinter_comboinput", P5, "DComboBox" )

local P6 = {}
function P6:Init()
    self:SetSize( 140, 20 )

end

function P6:Paint( w, h )
    gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
end
vgui.Register( "gprinter_editmenu", P6, "DComboBox" )

local P7 = {}
function P7:Init()
    self:SetSize( 140, 20 )
    self:SetText( "Select Category" )
    for k, v in pairs( DarkRP.getCategories()[ "entities" ] ) do
        self:AddChoice( v.name )
    end
end

function P7:Paint( w, h )
    gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
end
vgui.Register( "gprinter_category", P7, "DComboBox" )

local P8 = {}
function P8:Init()
    self:SetSize( 60, 20 )
    self:SetMin( 0 )
    self:SetMax( 100 )
    self:SetDecimals( 0 )
end

function P8:Paint( w, h )
    surface.SetDrawColor( Color( 5, 5, 5, 100 ) )
    surface.DrawRect( 0, 0, w, h )
    surface.SetFont( "font16" )
    self:DrawTextEntryText( Color( 171, 171, 171 ), Color( 163, 163, 163, 150 ), Color( 163, 163, 163, 150 ) )

    if ( self:HasFocus() ) then
        surface.SetDrawColor( Color( 163, 163, 163, 50 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
end

vgui.Register( "gprinters_wang", P8, "DNumberWang" )

local P9 = {}
function P9:Init()
    self:SetSize( 60, 20 )
    self:SetMin( 0 )
    self:SetMax( 100 )
    self:SetDecimals( 0 )
end

function P9:Paint( w, h )
    surface.SetDrawColor( Color( 5, 5, 5, 100 ) )
    surface.DrawRect( 0, 0, w, h )
    self:DrawTextEntryText( Color( 171, 171, 171 ), Color( 163, 163, 163, 150 ), Color( 163, 163, 163, 150 ) )

    if ( self:HasFocus() ) then
        surface.SetDrawColor( Color( 163, 163, 163, 50 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
end

vgui.Register( "gprinters_wang_2", P9, "DNumberWang" )

local P10 = {}
function P10:Init()
    self:SetSize( 380, 40 )
    self:SetText( "" )
    self:Information()
end

function P10:Paint( w, h )
    if !IsValid( self.ent ) then self:GetParent():Remove() return end
    if self:IsHovered() then
        alpha = 150
    else
        alpha = 100
    end

    gPrinters.drawBox( 0, 0, 0, w, h, Color( 57, 64, 77, 255 ) )
    gPrinters.drawBox( 0, 1, 1, w - 2, h - 2, Color( 29, 33, 44, 255 ) )
    gPrinters.drawBox( 4, self:GetWide() - 105, 5, 100, 30, Color( 5, 5, 5, alpha ) )

    if self.ent then
        if ( self.id == 1 ) && self.ent:Getantenna() == 1 then self.status = 1 end
        if ( self.id == 2 ) && self.ent:Getarmour() == 1 then self.status = 1 end
        if ( self.id == 3 ) && self.ent:Getfan() == 1 then self.status = 1 end
        if ( self.id == 4 ) && self.ent:Getmoreprint() == 1 then self.status = 1 end
        if ( self.id == 5 ) && self.ent:Getsilencer() == 1 then self.status = 1 end
        if ( self.id == 6 ) && self.ent:Getpipes() == 1 then self.status = 1 end
        if ( self.id == 7 ) && self.ent:Getscanner() == 1 then self.status = 1 end
    end

    if ( self.status == 0 ) then
        if LocalPlayer():canAfford( self.price ) then
            gPrinters.drawText( 0, "Unlock Now", 15, self:GetWide() - 55, 12, Color( 163, 163, 163, 175 ), 1 )
            gPrinters.drawText( 0, "$" .. gPrinters.moneyFormat( self.price ), 14, self:GetWide() - 55, 25, Color( 163, 163, 163, 175 ), 1 )


             gPrinters.drawPicture( 0, 5, 32, 32, "materials/f1menu/information.png", Color( 25, 150, 255, 100 ) )
            gPrinters.drawText( 0, self.title, 17, 40, 10, Color( 175, 175, 175, 150 ), 0 )
            gPrinters.drawText( 0, self.description, 15, 40, 28, Color( 200, 200, 200, 100 ), 0 )

        else
            gPrinters.drawText( 0, self.title, 15, self:GetWide() - 55, 12, Color( 255, 0, 0, 125 ), 1 )
            gPrinters.drawText( 0, "Not affordable", 14, self:GetWide() - 55, 25, Color( 163, 163, 163, 175 ), 1 )
            gPrinters.drawPicture( 0, 5, 32, 32, "materials/f1menu/alert.png", Color( 255, 163, 0, 200 ) )

            gPrinters.drawText( 0, self.title, 17, 40, 10, Color( 175, 175, 175, 150 ), 0 )
            gPrinters.drawText( 0, self.description, 15, 40, 28, Color( 200, 200, 200, 100 ), 0 )
        end
    else
        gPrinters.drawText( 0, self.title, 15, self:GetWide() - 55, 12, Color( 120, 255, 120, 25 ), 1 )
        gPrinters.drawText( 0, "Installed", 14, self:GetWide() - 55, 25, Color( 163, 163, 163, 175 ), 1 )

        gPrinters.drawPicture( 0, 5, 32, 32, "materials/f1menu/tick.png", Color( 125, 255, 25, 100 ) )
        gPrinters.drawText( 0, self.title, 17, 40, 10, Color( 175, 175, 175, 150 ), 0 )
        gPrinters.drawText( 0, self.description, 15, 40, 28, Color( 200, 200, 200, 100 ), 0 )
    end
end

function P10:Information( title, description, id, ent, status, price )
    self.title = title
    self.description = description
    self.id = id
    self.ent = ent
    self.status = status
    self.price = tonumber( price )
end

function P10:Think()
    if !IsValid( self.ent ) then self:GetParent():Remove() return end
end

function P10:DoClick()
    if !LocalPlayer():canAfford( self.price ) then
        self:GetParent():Remove()
    end

    net.Start( "gPrinters.addUpgrade" )
        net.WriteEntity( self.ent )
        net.WriteUInt( self.id, 8 )
    net.SendToServer()
end
vgui.Register( "gprinter_button", P10, "DButton" )

local P11 = {}
function P11:Init()
    self:SetSize( 140, 20 )
    self:SetText( "" )
    self.jobs = self.jobs or {}
end

function P11:DoClick()
    local colorpicker = vgui.Create( "DFrame" )
    colorpicker:SetSize( 500, 500 )
    colorpicker:Center()
    colorpicker:SetTitle( "" )
    colorpicker:MakePopup()
    colorpicker:SetDraggable( false )
    colorpicker:ShowCloseButton( false )

    colorpicker.Paint = function( slf, w, h )
        gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 255 ) )
        gPrinters.drawBox( 0, 1, 1, slf:GetWide() - 2, slf:GetTall() - 2, Color( 57, 64, 77, 255 ) )
        gPrinters.drawBox( 0, 2, 2, slf:GetWide() - 4, slf:GetTall() - 4, Color( 29, 33, 44, 255 ) )
        gPrinters.drawBox( 0, 1, 25, slf:GetWide() - 2, 1, Color( 57, 64, 77, 255 ) )
        gPrinters.drawText( 0, "Jobs Selection Menu", 16, slf:GetWide() / 2, 13, Color( 163, 163, 163, 175 ), 1 )

        gPrinters.drawBox( 0, 5, 30, slf:GetWide() - 10, 50, Color( 0, 0, 0, 100 ) )
         gPrinters.drawText( 0, "gPrinters", 25, 40, 45, Color( 163, 163, 163, 175 ), 0 )
        gPrinters.drawText( 0, "To view the entire list, please scrolldown.", 16, 40, 65, Color( 163, 163, 163, 150 ), 0 )
        gPrinters.drawPicture( 10, 40, 32, 32, "materials/f1menu/alert.png", Color( 255, 163, 0, 200 ) )
    end

    local results = {}

    self.cat = vgui.Create( "DPanelList", colorpicker )
    self.cat:SetPos( 6, 90 )
    self.cat:SetSize( 500, 370 )
    self.cat:SetSpacing( 1 )
    self.cat:EnableVerticalScrollbar( true )
    self.cat:EnableHorizontal( true )
    self.cat:hideBar()

    for k, v in pairs( RPExtraTeams ) do
        local job = vgui.Create( "DButton", colorpicker )
        job:SetSize( 246, 30 )
        job:SetText( "" )
        job.Paint = function( slf, w, h )
            gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 150 ) )
            gPrinters.drawText( 0, v.name, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )
        end

        local jobcheck = vgui.Create( "DCheckBox", job )
        jobcheck:SetSize( 16, 16 )
        jobcheck:SetPos( 8, 8 )

        jobcheck.Paint = function( slf, w, h )
            if slf:GetChecked() then
                gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
                gPrinters.drawBox( 0, 2, 2, w - 4, h - 4, Color( 50, 150, 50, 100 ) )
            else
                gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
            end
        end

         if table.HasValue( self.jobs, k ) then
            table.insert( results, k )
            jobcheck:SetChecked( true )
        end

        job.DoClick = function()
            if !jobcheck:GetChecked() then
                table.insert( results, k )
                jobcheck:SetChecked( true )
            else
                table.RemoveByValue( results, k )
                jobcheck:SetChecked( false )
            end
        end

        self.cat:AddItem( job )
    end

    local cbtn = vgui.Create( "DButton", colorpicker )
    cbtn:SetSize( colorpicker:GetWide() - 10, 32 )
    cbtn:SetPos( 5, colorpicker:GetTall() - 35 )
    cbtn:SetText ( "" )
    cbtn.Paint = function( slf, w, h )
        if slf:IsHovered() then
            gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 150 ) )
        else
            gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
        end
        gPrinters.drawText( 0, "End Selection", 14, w / 2, h / 2, Color( 163, 163, 163, 175 ), 1 )
    end

    cbtn.DoClick = function()
        if self && self:IsValid() then
            self.jobs = results
            colorpicker:Remove()
        else
            colorpicker:Remove()
        end
    end
end

function P11:Paint( w, h )
    if self:IsHovered() then
        gPrinters.drawBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 150 ) )
        gPrinters.drawText( 0, "Select Jobs ( " .. #self.jobs .. " )", 14, w / 2, h / 2, Color( 163, 163, 163, 200 ), 1 )
    else
        gPrinters.drawBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 100 ) )
        gPrinters.drawText( 0, "Select Jobs ( " .. #self.jobs .. " )", 14, w / 2, h / 2, Color( 163, 163, 163, 175 ), 1 )
    end
end
vgui.Register( "gprinter_jobs", P11, "DButton" )
