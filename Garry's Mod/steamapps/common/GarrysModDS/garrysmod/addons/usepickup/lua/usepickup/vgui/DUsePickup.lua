
-- A = CURRENT WEAPON
-- B = PICKUP WEAPON

local PANEL = {}

--
local y_center_offset = 75

local first_gap  = 5
local row_gap    = 1

function PANEL:Init()
    self:SetSize( 5,5 ) -- we do that in performlayout
    self:SetAlpha( 255 )

    self:Center()

    self:PrepareVars()
end

function PANEL:PrepareVars()
    self.Colors = USEPICKUP.Config.Colors

    self.StatsKey = USEPICKUP.UI:GetStatsKey()
    self.AltText = USEPICKUP.LANG:GetTranslation( "HINT", "alt" )
    self.AltText = self.AltText:Replace( "%key%", input.GetKeyName( self.StatsKey ) )

    self.LastPickupText = false
    self.LastPickupTextShadow = false

    self.PickupAlpha = 0
    self.StatsAlpha  = 0
    self.AltAlpha    = 0

    --self.LastWeaponA = nil
    self.LastWeaponB = nil

    self.LastStatsA     = {}
    self.LastStatsB     = {}

    self.CanCompare = false

    self.RowContainer = vgui.Create( "DPanel", self )
    self.RowContainer:Dock(FILL)
    self.RowContainer.Paint = function( s, w, h ) end

    self.Rows = {}
end

function PANEL:UpdateStats( wep )
    self.RowContainer:Clear()
    self.Rows = {}

    if self.CanCompare then

        local copy = {}
        local c = 1
        for k, v in pairs( self.LastStatsB ) do
            v.old_k = k
            copy[c] = v
            c = c + 1
        end

        table.sort( copy, function( a, b ) return a.sort < b.sort end )

        --if self.CanCompare == USEPICKUP_COMPARE_WEAPON then
            for k, v in pairs( copy ) do
                local row = vgui.Create( "DUsePickupRow", self.RowContainer )
                row:Dock( TOP )
                row:DockMargin( 0, 0, 0, row_gap )
                row:SetValues( v.old_k, self.LastStatsA and self.LastStatsA[v.old_k] and self.LastStatsA[v.old_k].val or false, v.val, v.bib )

                table.insert( self.Rows, row )
            end
        --else -- USEPICKUP_COMPARE_GLOBAL
            /*for k, v in pairs( copy ) do
                local row = vgui.Create( "DUsePickupRowAlt", self.RowContainer )
                row:Dock( TOP )
                row:DockMargin( 0, 0, 0, row_gap )
                row:SetValues( v.old_k, v.val, v.bib ) -- fml

                table.insert( self.Rows, row )
            end*/
        --end
    end

    self:InvalidateLayout( true )

end

function PANEL:PerformLayout( w, h ) -- messy as fuck
    local new_h = 1
    for k, v in pairs( self.Rows ) do
        new_h = new_h + v:GetTall() + row_gap
    end

    new_h = new_h - row_gap
    new_h = math.Clamp(new_h, 1, ScrH())

    self:SetTall( new_h )
    self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH()/2 + y_center_offset )

    if self:GetWide() < 50 then
        self:SetWide(50)
    end
end

function PANEL:UpdateWeapons( wep )
    // FIND A WAY TO MAKE USER ABLE TO CHANGE THIS
    self.LastStatsB = USEPICKUP.STATS:GetWeaponStats( wep )

    local drop_weapon = USEPICKUP.COMP.FindWeaponToDrop and USEPICKUP.COMP:FindWeaponToDrop( LocalPlayer(), wep, true )

    local usekey = USEPICKUP.UI:GetUseKey()
    local nw_name = USEPICKUP.COMP:GetWeaponName( wep )
    local nw_color = "<color=" .. tostring( USEPICKUP.COMP:GetWeaponColor( wep ) ) .. ">"

    local f_high = "<font=USEPICKUP.Highlighted>"
    local f_norm = "<font=USEPICKUP.Standard><color=" .. tostring(USEPICKUP.Config.Colors["Base"]) .. ">"

    if drop_weapon then
        local dw_name = USEPICKUP.COMP:GetWeaponName( drop_weapon )
        local dw_color = "<color=" .. tostring( USEPICKUP.COMP:GetWeaponColor( drop_weapon ) ) .. ">"

        local base = f_norm .. USEPICKUP.LANG:GetTranslation( "HINT", "exchange" )
        base = base:Replace( "%key%", f_high .. "<color=" .. tostring(USEPICKUP.Config.Colors["UseKey"]) .. ">" .. "[" .. usekey .. "]" .. f_norm )
        base = base:Replace( "%old_weapon%", f_high .. dw_color .. dw_name .. f_norm )
        base = base:Replace( "%new_weapon%", f_high .. nw_color .. nw_name .. f_norm )

        self.LastPickupText = base
        self.LastStatsA = USEPICKUP.STATS:GetWeaponStats( drop_weapon )
    else
        local base = f_norm .. USEPICKUP.LANG:GetTranslation( "HINT", "pickup" )
        base = base:Replace( "%key%", f_high .. "<color=" .. tostring(USEPICKUP.Config.Colors["UseKey"]) .. ">" .. "[" .. usekey .. "]" .. f_norm )
        base = base:Replace( "%weapon%", f_high .. nw_color .. nw_name .. f_norm )

        self.LastPickupText = base
        self.LastStatsA = nil
    end

    self.LastPickupTextShadow = string.Replace( self.LastPickupText, ">", "><color=" .. tostring(self.Colors["Shadow"]) .. ">" ) -- hacky af
    
    -- messy
    self.Parse_LastPickupTextShadow = markup.Parse( self.LastPickupTextShadow )
    self.Parse_LastPickupText = markup.Parse( self.LastPickupText )

    self.LastWeaponB = wep
    self.CanCompare = USEPICKUP.COMP:CanCompare( drop_weapon, self.LastWeaponB ) or false

    self:UpdateStats( wep )
end

local parse
local parse_shadow
function PANEL:Paint( w, h )
    local wep = USEPICKUP.UI.CurWeapon
    if wep and IsValid(wep) and !self.LastWeaponB or wep and wep != self.LastWeaponB then
        self:UpdateWeapons( wep )
    end

    if !self.LastPickupText then return end

    self.PickupAlpha = Lerp( FrameTime() * 15, self.PickupAlpha, wep and 255 or 0 )

    surface.DisableClipping( true )
        self.Parse_LastPickupTextShadow:Draw( w/2 + 1, -5 + 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, self.PickupAlpha )
        self.Parse_LastPickupText:Draw( w/2, -5, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, self.PickupAlpha )
	surface.DisableClipping( false )

    self.StatsAlpha = Lerp( FrameTime() * 15, self.StatsAlpha, wep and self.CanCompare and input.IsKeyDown( self.StatsKey ) and 255 or 0 )
    self.RowContainer:SetAlpha( self.StatsAlpha )

    if self.CanCompare then -- show alt text bool here (client config)
        self.AltAlpha = math.Clamp( -1 * self.StatsAlpha + 255, 0, math.Clamp( self.PickupAlpha, 0, 255 ) ) -- ffs
        draw.SimpleText( self.AltText, "USEPICKUP.HoldAlt", w/2 + 1, 10 + 1, ColorAlpha( self.Colors["Shadow"], self.AltAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( self.AltText, "USEPICKUP.HoldAlt", w/2, 10, ColorAlpha( self.Colors["Alt"], self.AltAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

vgui.Register( "DUsePickup", PANEL, "DPanel" )