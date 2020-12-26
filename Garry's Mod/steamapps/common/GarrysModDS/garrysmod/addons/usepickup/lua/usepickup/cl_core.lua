CreateClientConVar( "usepickup_autoswitch", 0, true, true, "Switch to weapon on pickup.")
CreateClientConVar( "usepickup_statskey", 81, true, true, "Switch to weapon on pickup.")

USEPICKUP.UI = USEPICKUP.UI or {} -- refresh                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                76561198167491948
--USEPICKUP.UI.TextAlpha = 0

local cfg = USEPICKUP.Config
--

function USEPICKUP.UI:GetUseKey() -- MOVE TO sh_funcs LATER (maybe a clientside version)
    local k = input.LookupBinding( "use" )

    return (k and string.upper(k)) or "err"
end

function USEPICKUP.UI:GetStatsKey()
    return GetConVar( "usepickup_statskey" ):GetInt() or input.GetKeyCode( "lalt" )
end

function USEPICKUP.UI:KeepAlive()
    if cfg.Enable == false and self.Panel and IsValid( self.Panel ) then
        self:Disable()
        hook.Remove( "PreDrawHalos", "USEPICKUP.PreDrawHalos" )
        hook.Remove( "HUDPaint", "USEPICKUP.HUDPaint" )
        return
    end

    if !self.Panel or !IsValid( self.Panel ) then
        self.Panel = vgui.Create( "DUsePickup")
    end
end

function USEPICKUP.UI:Recreate()
    if self.Panel and IsValid( self.Panel ) then
        self.Panel:Remove()
        self:KeepAlive()
    end
end

function USEPICKUP.UI:Disable()
    if self.Panel and IsValid( self.Panel ) then
        self.Panel:Remove()
        self.Panel = nil
    end
end

--

function USEPICKUP.UI:OpenSettings()
    -- keyname = string.upper( input.LookupBinding( bind ) )
    self.DFrame = vgui.Create( "EditablePanel" ) -- ik DPanel nor DFrame, too lazy to change, doesnt matter anyway
    self.DFrame:SetSize( 220, 300 )
    self.DFrame:SetAlpha( 0 )
    self.DFrame:Center()
    self.DFrame:MakePopup()
    self.DFrame.Paint = function( s, w, h )
        USEPICKUP.FUNCS:BlurPanel( s, 3, 3 )
        draw.RoundedBox( 0, 0, 0, w, h, cfg["Colors"]["SettingsBG"] )
    end

    self.DFrame.TitleBox = vgui.Create( "DPanel", self.DFrame )
    self.DFrame.TitleBox:Dock( TOP )
    self.DFrame.TitleBox:DockMargin( 5, 5, 5, 0 )
    self.DFrame.TitleBox:SetTall( 30 )
    self.DFrame.TitleBox.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 125 ) )
        draw.SimpleText( "USEPICKUP - Settings", "DermaDefault", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    self.DFrame.CloseButton = vgui.Create( "DButton", self.DFrame )
    self.DFrame.CloseButton:SetText( "" )
    self.DFrame.CloseButton:Dock( BOTTOM )
    self.DFrame.CloseButton:DockMargin( 5, 0, 5, 5 )
    self.DFrame.CloseButton:SetTall( 35 )
    self.DFrame.CloseButton.Paint = function( s, w, h )
        s.LerpVal = s.LerpVal and Lerp( FrameTime() * 5, s.LerpVal, s:IsHovered() and 1 or 0 ) or 0
        draw.RoundedBox( 0, 0, 0, w, w, ColorAlpha( cfg["Colors"]["SettingsCloseButton"], Lerp( s.LerpVal, 25, 255 )) )
        draw.SimpleText( "E X I T", "DermaDefault", w/2, h/2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    self.DFrame.CloseButton.DoClick = function( s )
        local parent = s:GetParent()
        
        parent:SetMouseInputEnabled( false )
        parent:SetKeyboardInputEnabled( false )

        for k, v in pairs( parent:GetChildren() ) do
            v:SetMouseInputEnabled( false )
            v:SetKeyboardInputEnabled( false )
        end

        parent:AlphaTo( 0, .5, 0, function() parent:Remove() end )
    end

    self.DFrame.Container = vgui.Create( "EditablePanel", self.DFrame )
    self.DFrame.Container:Dock(FILL)
    self.DFrame.Container:DockMargin( 5, 5, 5, 5 )
    self.DFrame.Container.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 125 ) )
    end

    self.DFrame.Container.Setting_AutoSwitch = vgui.Create( "DCheckBoxLabel", self.DFrame.Container )
    self.DFrame.Container.Setting_AutoSwitch:Dock( TOP )
    self.DFrame.Container.Setting_AutoSwitch:DockMargin( 5, 5, 5, 0 )
    self.DFrame.Container.Setting_AutoSwitch:SetConVar( "usepickup_autoswitch" )
    self.DFrame.Container.Setting_AutoSwitch:SetText( "Switch to new weapon on pickup" )

    self.DFrame.Container.Setting_StatsBind = vgui.Create( "DButton", self.DFrame.Container )
    self.DFrame.Container.Setting_StatsBind:Dock( TOP )
    self.DFrame.Container.Setting_StatsBind:DockMargin( 5, 5, 5, 0 )
    self.DFrame.Container.Setting_StatsBind:SetTall( 40 )
    self.DFrame.Container.Setting_StatsBind:SetText( "" )
    self.DFrame.Container.Setting_StatsBind:SetKeyboardInputEnabled( true )
    self.DFrame.Container.Setting_StatsBind.State = 1 -- 0 = wait for button, 1 = show button
    self.DFrame.Container.Setting_StatsBind.Paint = function( s, w, h )
        local key
        key = USEPICKUP.UI:GetStatsKey()
        key = input.GetKeyName( key )
        key = language.GetPhrase( key )
        
        draw.SimpleText( "View stats key:", "DermaDefault", w/2, h/2 - 9, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        if s.State == 1 then
            draw.SimpleText( key, "DermaDefault", w/2, h/2 + 7, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            draw.SimpleText( "Please press a button", "DermaDefault", w/2, h/2 + 7, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    
        draw.RoundedBox( 0, 0, 0, w, h, s.State == 1 and Color( 255, 255, 255, 10 ) or Color( 255, 255, 255, 50 ) )
    end
    self.DFrame.Container.Setting_StatsBind.DoClick = function( s )
        s.State = 0
        s:RequestFocus() -- needed
    end
    self.DFrame.Container.Setting_StatsBind.OnKeyCodePressed = function( s, key )
        GetConVar( "usepickup_statskey" ):SetInt( key )
        s.State = 1
    end

    self.DFrame:AlphaTo( 255, .5 )
end

--

hook.Add( "HUDPaint", "USEPICKUP.HUDPaint", function()
    local b = USEPICKUP.COMP:CanInteract( LocalPlayer() ) and USEPICKUP.FUNCS:GetLookAtWeapon( LocalPlayer() ) or false -- performance improvement
    if b then
        USEPICKUP.UI.CurWeapon = b
        USEPICKUP.UI:KeepAlive()
    else
        USEPICKUP.UI:Disable() -- no animation :(
    end
end )

if cfg.Halos then
    hook.Add( "PreDrawHalos", "USEPICKUP.PreDrawHalos", function()
        if !USEPICKUP.COMP:CanInteract( LocalPlayer() ) or !USEPICKUP.Config.Enable then return end

        local wep = USEPICKUP.FUNCS:GetLookAtWeapon( LocalPlayer(), false )
        local wep_e = USEPICKUP.FUNCS:GetLookAtWeapon( LocalPlayer(), true ) -- get the actual entity

        if !wep or !IsValid( wep_e ) then return end

        halo.Add( {wep_e}, USEPICKUP.COMP:GetWeaponColor( wep ), 1, .5, 5, true, true )
    end )
end

-- GM:OnPlayerChat( Player ply, string text, boolean teamChat, boolean isDead )
hook.Add( "OnPlayerChat", "USEPICKUP.OnPlayerChat", function( p, text )
    if p != LocalPlayer() or !table.HasValue( cfg.ChatCommands, text ) then return end
    USEPICKUP.UI:OpenSettings()
    return true
end )