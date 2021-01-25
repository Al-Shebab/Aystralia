/*
*   @module         : arivia
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (c) 2016 - 2020
*   @docs           : https://arivia.rlib.io
*
*   LICENSOR HEREBY GRANTS LICENSEE PERMISSION TO MODIFY AND/OR CREATE DERIVATIVE WORKS BASED AROUND THE
*   SOFTWARE HEREIN, ALSO, AGREES AND UNDERSTANDS THAT THE LICENSEE DOES NOT HAVE PERMISSION TO SHARE,
*   DISTRIBUTE, PUBLISH, AND/OR SELL THE ORIGINAL SOFTWARE OR ANY DERIVATIVE WORKS. LICENSEE MUST ONLY
*   INSTALL AND USE THE SOFTWARE HEREIN AND/OR ANY DERIVATIVE WORKS ON PLATFORMS THAT ARE OWNED/OPERATED
*   BY ONLY THE LICENSEE.
*
*   YOU MAY REVIEW THE COMPLETE LICENSE FILE PROVIDED AND MARKED AS LICENSE.TXT
*
*   BY MODIFYING THIS FILE -- YOU UNDERSTAND THAT THE ABOVE MENTIONED AUTHORS CANNOT BE HELD RESPONSIBLE
*   FOR ANY ISSUES THAT ARISE FROM MAKING ANY ADJUSTMENTS TO THIS SCRIPT. YOU UNDERSTAND THAT THE ABOVE
*   MENTIONED AUTHOR CAN ALSO NOT BE HELD RESPONSIBLE FOR ANY DAMAGES THAT MAY OCCUR TO YOUR SERVER AS A
*   RESULT OF THIS SCRIPT AND ANY OTHER SCRIPT NOT BEING COMPATIBLE WITH ONE ANOTHER.
*/

/*
*	declare > module
*/

local mod                   = arivia
local helper                = mod.helper
local design                = mod.design

/*
*	declare > cfg
*/

local cfg                   = mod.cfg
local lng                   = mod.lng

/*
*	declare > vals
*/

local PANEL                 = { }
local AriviaTickers         = { }
local tabs                  = { }

/*
*	mats
*/

local btn_close             = Material( 'arivia/arivia_button_close.png', 'noclamp smooth' )
local btn_steam             = Material( 'arivia/arivia_button_steam.png', 'noclamp smooth' )

/*
*	ticker
*/

function arivia:ticker( str, clr )
    AriviaTickers.clr       = clr
    AriviaTickers.msg       = str
end

/*
*	ticker > net
*/

net.Receive( 'AriviaSendTickerData', function( len )
    local vcol = net.ReadVector( )
    arivia:ticker( net.ReadString( ), Color( vcol.x, vcol.y, vcol.z ) )
end )

/*
*	meta > pnl > scrollbar
*/

local META = FindMetaTable('Panel')

function META:ConstructScrollbarGUI( )

    self.Paint = function( s, w, h )
        surface.SetDrawColor(5, 5, 5, 200)
        surface.DrawRect(0, 0, w, h)
    end

    self.btnUp.Paint = function( s, w, h )
        surface.SetDrawColor(64, 105, 126, 190)
        surface.DrawRect(0, 0, w, h)
    end

    self.btnDown.Paint = function( s, w, h )
        surface.SetDrawColor(64, 105, 126, 190)
        surface.DrawRect(0, 0, w, h)
    end

    self.btnGrip.Paint = function( s, w, h )
        surface.SetDrawColor(52, 87, 104, 190)
        surface.DrawRect(0, 0, w, h)
    end
end

/*
*	canjoin > job
*/

function mod:bCanJob(job, maxTeamCheck)
    local pl = LocalPlayer( )
    if maxTeamCheck and table.Count(team.GetPlayers(job.team)) >= (job.Max or 1337) then return false end
    if job.customCheck and not job.customCheck(pl) then return false end
    if job.admin == 1 and not (LocalPlayer( ):IsAdmin( ) or LocalPlayer( ):IsSuperAdmin( )) then return false end

    return true
end

/*
*	canbuy > gun
*/

function mod:bCanBuyGun( ship )
    local pl = LocalPlayer( )
    local pl_job = 1

    if IsValid(mod.pnl.root) then pl_job = mod.pnl.root.CurJob else pl_job = pl:Team( ) end

    if GAMEMODE.Config.restrictbuypistol and not table.HasValue(ship.allowed, pl_job) then return false, true end
    if ship.customCheck and not ship.customCheck(pl) then return false, true end
    local canbuy, suppress, message, price = hook.Call('canBuyPistol', nil, pl, ship)
    local cost = price or ship.getPrice and ship.getPrice(pl, ship.pricesep) or ship.pricesep
    --if not pl:canAfford(cost) then return false, false, cost end
    if canbuy == false then return false, suppress, cost end

    return true, nil, cost
end

/*
*	canbuy > ent
*/

function mod:bCanBuyEnt( item )
    local pl = LocalPlayer( )
    local pl_job = 1

    if IsValid(mod.pnl.root) then pl_job = mod.pnl.root.CurJob else pl_job = pl:Team( ) end

    if istable(item.allowed) and not table.HasValue(item.allowed, pl_job) then return false, true end
    if item.customCheck and not item.customCheck(pl) then return false, true end
    local canbuy, suppress, message, price = hook.Call('canBuyCustomEntity', nil, pl, item)
    local cost = price or item.getPrice and item.getPrice(pl, item.price) or item.price
    --if not pl:canAfford(cost) then return false, false, cost end
    if canbuy == false then return false, suppress, cost end

    return true, nil, cost
end

/*
*	canbuy > ammo
*/

function mod:bCanBuyAmmo( item )
    local pl = LocalPlayer( )
    local pl_job = 1

    if IsValid(mod.pnl.root) then pl_job = mod.pnl.root.CurJob else pl_job = pl:Team( ) end

    if item.customCheck and not item.customCheck(pl) then return false, true end
    local canbuy, suppress, message, price = hook.Call('canBuyAmmo', nil, pl, item)
    local cost = price or item.getPrice and item.getPrice(pl, item.price) or item.price
    --if not pl:canAfford(cost) then return false, false, cost end
    if canbuy == false then return false, suppress, price end

    return true, nil, price
end

/*
*	canbuy > ship
*/

function mod:bCanBuyShip(ship)
    local pl = LocalPlayer( )
    local pl_job = 1

    if IsValid(mod.pnl.root) then pl_job = mod.pnl.root.CurJob else pl_job = pl:Team( ) end

    if not table.HasValue(ship.allowed, pl_job) then return false, true end
    if ship.customCheck and not ship.customCheck(pl) then return false, true end
    local canbuy, suppress, message, price = hook.Call('canBuyShipment', nil, pl, ship)
    local cost = price or ship.getPrice and ship.getPrice(pl, ship.price) or ship.price
    --if not pl:canAfford(cost) then return false, false, cost end
    if canbuy == false then return false, suppress, cost end
    if ship.noship then return false end

    return true, nil, cost
end

/*
*	canbuy > vehicle
*/

function mod:bCanBuyVeh( item )
    local pl = LocalPlayer( )
    local pl_job = 1

    if IsValid( mod.pnl.root ) then pl_job = mod.pnl.root.CurJob else pl_job = pl:Team( ) end

    local cost = item.getPrice and item.getPrice(pl, item.price) or item.price
    if istable( item.allowed ) and not table.HasValue( item.allowed, pl_job ) then return false, true end
    if item.customCheck and not item.customCheck(pl) then return false, true end

    local canbuy, suppress, message, price = hook.Call('canBuyVehicle', nil, pl, item)
    cost = price or cost
    --if not pl:canAfford(cost) then return false, false, cost end
    if canbuy == false then return false, suppress, cost end

    return true, nil, cost
end

/*
*	canbuy > food
*/

function mod:bCanBuyFood( item )
    local pl = LocalPlayer( )

    if (item.requiresCook == nil or item.requiresCook == true) and not pl:isCook( ) then return false, true end
    if item.customCheck and not item.customCheck(LocalPlayer( )) then return false, false end

    if arivia.tab.item.hideCannotBuy then
        if not pl:canAfford(item.price) then return false, false end
    end

    return true
end

/*
*	clear panels
*/

function PANEL:ClearPanels( )
    if IsValid( mod.pnl.tabs ) then mod.pnl.tabs:SetVisible( false ) end
    if IsValid( mod.pnl.staff ) then mod.pnl.staff:SetVisible( false ) end
    if IsValid( mod.pnl.ibws ) then mod.pnl.ibws:SetVisible( false ) end
    if IsValid( mod.pnl.cmds ) then mod.pnl.cmds:SetVisible( false ) end
end

/*
*	parent
*/

function PANEL:Init( )

    mod.pnl.root                    = self
    self.CurJob                     = LocalPlayer( ):Team( )
    self.w, self.h                  = ScrW( ) * .8, ScrH( ) * .8
    self:SetSize                    (self.w, self.h)
    self:Center                     ( )
    self:MakePopup                  ( )

                                    self.Paint = function( s, w, h ) end

    -----------------------------------------------------------------
    -- [ BACKGROUND CONTAINER ]
    -----------------------------------------------------------------

    if ( cfg.bg.static.enabled or cfg.bg.live.enabled ) and ( cfg.bg.static.list or cfg.bg.live.list ) then
        local sourceTable = not cfg.bg.live.enabled and cfg.bg.static.list or cfg.bg.live.list

        self.ct_bg = vgui.Create        ( 'DHTML', self )
        self.ct_bg:SetSize              ( ScrW( ), ScrH( ) )
        self.ct_bg:SetScrollbars        ( false )
        self.ct_bg:SetVisible           ( true )
        self.ct_bg:SetHTML(
        [[
            <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'>
                <iframe frameborder='0' width='100%' height='100%' src=']] .. table.Random( sourceTable ) .. [['></iframe>
            </body>
        ]])
        self.ct_bg.Paint = function( s, w, h ) end
    end

    -----------------------------------------------------------------
    -- [ MAIN BACKGROUND FILTER ]
    -----------------------------------------------------------------

    if cfg.bg.static.enabled and cfg.bg.static.list then
        self.ct_bg_filter               = vgui.Create( 'DHTML', self.ct_bg )
        self.ct_bg_filter:SetSize       ( ScrW( ), ScrH( ) )
        self.ct_bg_filter:SetScrollbars ( false )
        self.ct_bg_filter:SetVisible    ( true )

                                        self.ct_bg_filter.Paint = function( s, w, h )
                                            if cfg.bg.static.blur_enabled then
                                                design.blur( s, 3 )
                                            end
                                        end
    end

    -----------------------------------------------------------------
    -- [ LEFT CONTAINER ]
    -----------------------------------------------------------------

    self.ct_l = vgui.Create('DPanel', self)
    self.ct_l:Dock(LEFT)
    self.ct_l:DockMargin(0, 0, 0, 0)
    self.ct_l:SetWide(200)
    self.ct_l.Paint = function( s, w, h ) end

    -----------------------------------------------------------------
    -- [ LEFT TOP CONTAINER ]
    -----------------------------------------------------------------

    self.ct_l_top = vgui.Create('DPanel', self.ct_l)

    if ( cfg.bg.static.enabled or cfg.bg.live.enabled ) and ( cfg.bg.static.list or cfg.bg.live.list ) then
        self.ct_l_top:Dock(FILL)
    else
        self.ct_l_top:Dock(TOP)
    end

    self.ct_l_top:DockMargin(0, 0, 0, 0)
    self.ct_l_top:SetSize(200, 60)
    self.ct_l_top.Paint = function( s, w, h ) end

    self.ct_tabs = vgui.Create('DPanel', self.ct_l)
    self.ct_tabs:Dock(TOP)
    self.ct_tabs:DockMargin(0, 0, 0, 0)
    self.ct_tabs:SetSize(200, 50)
    self.ct_tabs.Paint = function( s, w, h )
        draw.RoundedBox(0, 0, 0, w, h, cfg.pnl_left_top_bg_clr or Color( 128, 0, 0, 250 ))
    end

    -----------------------------------------------------------------
    -- [ LEFT MIDDLE CONTAINER ]
    -----------------------------------------------------------------

    self.ct_l_mid = vgui.Create('DPanel', self.ct_l)
    self.ct_l_mid:Dock(FILL)
    self.ct_l_mid:DockMargin(0, 0, 0, 0)
    self.ct_l_mid:SetWide(200)
    self.ct_l_mid.Paint = function( s, w, h )
        if cfg.bg.static.blur_enabled then
            design.blur( s, 3 )
        end
        draw.RoundedBox(0, 0, 0, w, h, cfg.pnl_left_bg_clr or Color( 0, 0, 0, 250 ))
    end

    -----------------------------------------------------------------
    -- [ HOME TAB CONTAINER ]
    -----------------------------------------------------------------

    self.tab_home = vgui.Create('DPanel', self.ct_l_mid)
    self.tab_home:Dock(LEFT)
    self.tab_home:SetSize(200, 0)
    self.tab_home:DockMargin(0, 0, 0, 0)
    self.tab_home.Paint = function( s, w, h ) end

    -----------------------------------------------------------------
    -- [ INFO TAB CONTAINER ]
    -----------------------------------------------------------------

    self.tab_info = vgui.Create('DPanel', self.ct_l)
    self.tab_info:Dock(FILL)
    self.tab_info:DockMargin(0, 0, 0, 0)
    self.tab_info:SetVisible(false)
    self.tab_info.Paint = function( s, w, h ) end

    -----------------------------------------------------------------
    -- [ INFO BUTTONS ]
    -----------------------------------------------------------------

    local i = 0

    for k, v in pairs( cfg.info ) do

        if not v.enabled then continue end

        local mat = false

        self.b_info = vgui.Create('DButton', self.tab_info)
        self.b_info:SetText('')
        self.b_info:SetSize(190, 50)
        self.b_info:SetPos(5, 5 + i)
        if v.icon and cfg.nav.bIconsEnabled then
            mat = Material( v.icon, 'noclamp smooth' )
            self.b_info:SetSize( self.b_info:GetWide( ), self.b_info:GetTall( ) )
        end
        self.b_info.Paint = function( self, w, h )
            local clr_btn       = v.clr_btn_n
            local clr_txt       = v.clr_txt_n
            local clr_mat       = Color( 255, 255, 255, 255 )

            if self:IsHovered( ) or self:IsDown( ) then
                clr_btn         = v.clr_btn_h
                clr_txt         = v.clr_txt_h
            end

            surface.SetDrawColor    ( clr_btn )
            surface.DrawRect        ( 0, 0, w, h )
            surface.SetDrawColor    ( Color( 255, 255, 255, 255 ) )
            surface.DrawLine        ( 0, 15, 0, 0 )
            surface.DrawLine        ( 15, 0, 0, 0 )
            surface.SetDrawColor    ( Color( 255, 255, 255, 255 ) )
            surface.DrawLine        ( w - 20, h - 1, w, h - 1 )
            surface.DrawLine        ( w - 1, h, w - 1, h - 20 )

            if cfg.nav.bIconsEnabled and mat then
                surface.SetDrawColor        ( clr_mat )
                surface.SetMaterial         ( mat )
                surface.DrawTexturedRect    ( 6, 12, 24, 24 )

                draw.SimpleText( string.upper( v.name ), 'AriviaFontMenuItem', 36, self:GetTall( ) * .35, clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                draw.SimpleText( string.upper( v.desc ), 'AriviaFontMenuSubinfo', 36, self:GetTall( ) * .65, clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( string.upper( v.name ), 'AriviaFontMenuItem', 15, self:GetTall( ) * .35, clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                draw.SimpleText( string.upper( v.desc ), 'AriviaFontMenuSubinfo', 15, self:GetTall( ) * .65, clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end
        end

        self.b_info.DoClick = v.func
        i = i + 55

    end

    -----------------------------------------------------------------
    -- [ BOTTOM CONTAINER ]
    -----------------------------------------------------------------

    self.ct_b = vgui.Create('DPanel', self.ct_l)
    self.ct_b:Dock(BOTTOM)
    self.ct_b:SetSize(200, 60)

    if cfg.clock_enabled then
        self.ct_b:SetVisible(true)
    else
        self.ct_b:SetVisible(false)
    end

    self.ct_b.Paint = function( s, w, h )
        design.blur( s, 3 )
        draw.RoundedBox( 0, 0, 0, w, h, cfg.clock_bg )
        draw.SimpleText( os.date( cfg.clock_format ), 'AriviaFontClock', w / 2, h / 2, cfg.clock_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    -----------------------------------------------------------------
    -- [ RIGHT CONTAINER ]
    -----------------------------------------------------------------

    self.ct_r = vgui.Create('DPanel', self)
    self.ct_r:Dock(FILL)
    self.ct_r.Paint = function( s, w, h )
        if cfg.bg.static.blur_enabled then
            design.blur( s, 3 )
        end

        draw.RoundedBox( 0, 0, 0, w, h, cfg.pnl_mid_bg_clr or Color( 16, 16, 16, 210 ) )

        if cfg.name_enabled then
            draw.SimpleText( cfg.name, 'AriviaFontname', w - 10, 50, cfg.name_clr or Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end
    end

    -----------------------------------------------------------------
    -- [ RIGHT TOP CONTAINER ]
    -----------------------------------------------------------------

    self.ct_r_top = vgui.Create('DPanel', self.ct_r)
    self.ct_r_top:Dock(TOP)
    self.ct_r_top:DockMargin(5, 5, 5, 0)
    self.ct_r_top:SetTall(60)
    self.ct_r_top.Paint = function( s, w, h )
        draw.SimpleText(LocalPlayer( ):getDarkRPVar('job') or '', 'AriviaFontServerInfo', 60, 20, arivia.job_clr or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(DarkRP.formatMoney(LocalPlayer( ):getDarkRPVar('money')), 'AriviaFontPlayerWallet', 60, 40, cfg.money_clr or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.av = vgui.Create('AvatarImage', self.ct_r_top)
    self.av:SetSize(50, 50)
    self.av:SetPos(6, 5)
    self.av:SetPlayer(LocalPlayer( ), 50)

    self.b_close = vgui.Create('DButton', self)
    self.b_close:SetColor(Color( 255, 255, 255, 255 ))
    self.b_close:SetFont('AriviaFontCloseGUI')
    self.b_close:SetText('')
    self.b_close:SetSize(32, 32)
    self.b_close:SetPos(self:GetWide( ) - 25, 0)

    self.b_close.DoClick = function( )
        if IsValid(self) then
            if cfg.regeneration then
                self:Remove( )
            else
                self:Hide( )
            end
        end
    end

    self.b_close.Paint = function( )
        surface.SetDrawColor(cfg.btn_close_clr or Color( 255, 255, 255, 255 ))
        surface.SetMaterial( btn_close )
        surface.DrawTexturedRect(0, 10, 16, 16)
    end

    self.Tab = 1
    self:UpdateTabs( )
    self:UpdateAdmins( )
    self:UpdateCommands( )

    -----------------------------------------------------------------
    -- [ HOME BUTTON ]
    -----------------------------------------------------------------

    self.b_home = vgui.Create('DButton', self.ct_tabs)
    self.b_home:Dock(LEFT)
    self.b_home:DockMargin(2, 0, 0, 0)
    self.b_home:SetSize(60, 40)
    self.b_home:SetText('')
    self.b_home:SetVisible(true)
    self.b_home:SetTooltip(string.upper(lng.TabMain))
    self.b_home.Paint = function(self, w, h)
        local clr_btn_n = Color(60, 0, 0, 0)

        if self:IsHovered( ) or self:IsDown( ) then
            clr_btn_n = Color(100, 0, 0, 240)
        end

        draw.RoundedBox(0, 0, 0, w, h, clr_btn_n)
        draw.SimpleText(string.upper(lng.TabMain), 'AriviaFontButtonItem', self:GetWide( ) / 2, self:GetTall( ) / 2, txtColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.b_home.DoClick = function( )
        self.tab_info:SetVisible(false)
        self.tab_home:SetVisible(true)
    end

    -----------------------------------------------------------------
    -- [ ACTION BUTTON ]
    -----------------------------------------------------------------

    self.b_acts = vgui.Create('DButton', self.ct_tabs)
    self.b_acts:Dock(LEFT)
    self.b_acts:DockMargin(0, 0, 0, 0)
    self.b_acts:SetSize(60, 40)
    self.b_acts:SetText('')
    self.b_acts:SetVisible(true)
    self.b_acts:SetTooltip(string.upper(lng.TabInfo))
    self.b_acts.Paint = function(self, w, h)
        local clr_btn_n = Color(60, 0, 0, 0)

        if self:IsHovered( ) or self:IsDown( ) then
            clr_btn_n = Color(100, 0, 0, 240)
        end

        draw.RoundedBox(0, 0, 0, w, h, clr_btn_n)
        draw.SimpleText(string.upper(lng.TabInfo), 'AriviaFontButtonItem', self:GetWide( ) / 2, self:GetTall( ) / 2, txtColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.b_acts.DoClick = function( )
        self.tab_home:SetVisible(false)
        self.tab_info:SetVisible(true)
    end

    -----------------------------------------------------------------
    -- [ COMMAND BUTTON ]
    -----------------------------------------------------------------

    self.b_cmds = vgui.Create('DButton', self.ct_tabs)
    self.b_cmds:Dock(LEFT)
    self.b_cmds:DockMargin(0, 0, 17, 0)
    self.b_cmds:SetSize(78, 40)
    self.b_cmds:SetText('')
    self.b_cmds:SetVisible(true)
    self.b_cmds:SetTooltip(string.upper(lng.TabCommands))
    self.b_cmds.Paint = function(self, w, h)
        local clr_btn_n = Color(60, 0, 0, 0)

        if self:IsHovered( ) or self:IsDown( ) then
            clr_btn_n = Color(100, 0, 0, 240)
        end

        draw.RoundedBox(0, 0, 0, w, h, clr_btn_n)
        draw.SimpleText(string.upper(lng.TabCommands), 'AriviaFontButtonItem', self:GetWide( ) / 2, self:GetTall( ) / 2, txtColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.b_cmds.DoClick = function( )
        PANEL:ClearPanels( )
        if IsValid(mod.pnl.cmds) then mod.pnl.cmds:SetVisible(true) end
    end

    -----------------------------------------------------------------
    -- [ OPEN EXTERNAL SOURCES ]
    -----------------------------------------------------------------

    function arivia:OpenExternal( title, uri, bIsText )
        mod.pnl.root:ClearPanels( )
        mod.pnl.root:External(title, uri, bIsText)
    end

    -----------------------------------------------------------------
    -- [ OPEN STAFF LIST ]
    -----------------------------------------------------------------

    function arivia:OpenAdmins( )
        mod.pnl.root:UpdateAdmins( )
        mod.pnl.root:ClearPanels( )
        if IsValid(mod.pnl.staff) then mod.pnl.staff:SetVisible(true) end
    end

    -----------------------------------------------------------------
    -- [ TICKER ]
    -----------------------------------------------------------------

    function arivia:TickerLoader( )
        local W, H      = ScrW( ), ScrH( )
                        if not W then timer.Simple( 0.5, Load ) return end

        local PanelTickerConst = vgui.Create('DPanel', panelBarTicker)

        if cfg.ticker_enabled then
            PanelTickerConst:SetVisible(true)
        else
            PanelTickerConst:SetVisible(false)
        end

        PanelTickerConst:SetSize(W, H)
        PanelTickerConst:SetPos(1, 1)

        local LabelTickerData = vgui.Create('DLabel', PanelTickerConst)
        LabelTickerData:SetText('')

        if cfg.ticker_enabled then
            LabelTickerData:SetVisible(true)
        else
            LabelTickerData:SetVisible(false)
        end

        LabelTickerData:SetFont('AriviaFontTicker')
        LabelTickerData:SetTextColor(AriviaTickers.clr)
        PanelTickerConst.Alpha = 0
        PanelTickerConst.Paint = function(self)
            if (FrameTime( ) == 0) then return end
            if (IsValid(LocalPlayer( ):GetActiveWeapon( ))) and (LocalPlayer( ):GetActiveWeapon( ):GetClass( ) == 'gmod_camera') then return end

            if (AriviaTickers.msg) then

                if not LabelTickerData.Setup then
                    LabelTickerData:SetText(AriviaTickers.msg)
                    LabelTickerData:SetTextColor(AriviaTickers.clr)
                    LabelTickerData:SizeToContents( )
                    LabelTickerData:SetPos(PanelTickerConst:GetWide( ) + 50, 2)
                    LabelTickerData.PosX, LabelTickerData.PosY = LabelTickerData:GetPos( )
                    LabelTickerData.Setup = true
                end

                self.Alpha = math.Approach(self.Alpha, 1, FrameTime( ) * 500)
                draw.RoundedBox(4, 0, 0, self:GetWide( ), self:GetTall( ), Color(0, 0, 0, self.Alpha))
                LabelTickerData.PosX = LabelTickerData.PosX - FrameTime( ) * cfg.ticker_speed
                LabelTickerData:SetPos(LabelTickerData.PosX, LabelTickerData.PosY)

                if (LabelTickerData.PosX + LabelTickerData:GetWide( ) < -50) then
                    AriviaTickers.msg = nil
                end

            elseif (self.Alpha > 0) then

                self.Alpha = math.Approach(self.Alpha, 0, FrameTime( ) * 500)
                if (self.Alpha == 0) then
                    LabelTickerData.Setup = false
                end

            end

        end

        AriviaTickers.VGUI = PanelTickerConst

    end

    timer.Simple( 1, arivia.TickerLoader )

end

/*
*	admins > update
*/

function PANEL:UpdateAdmins( )

    if IsValid(mod.pnl.staff) then mod.pnl.staff:Remove( ) end

    mod.pnl.staff = vgui.Create('DPanel', self.ct_r)
    mod.pnl.staff:Dock(FILL)
    mod.pnl.staff:DockMargin(10, 5, 10, 10)
    mod.pnl.staff:SetVisible(false)
    mod.pnl.staff.Paint = function( s, w, h )
        draw.SimpleText( lng.OnlineStaff, 'AriviaFontOnlineStaff', 0, 15, cfg.name_clr or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(Color( 255, 255, 255, 255 ))
        surface.DrawLine(w - 5, 30, 0, 30)
    end

    self.dico_staff = vgui.Create('DIconLayout', mod.pnl.staff)
    self.dico_staff:Dock(FILL)
    self.dico_staff:DockMargin(0, 40, 0, 0)
    self.dico_staff:SetPos(0, 0)
    self.dico_staff:SetSpaceY(5)
    self.dico_staff:SetSpaceX(5)

    local i = 0

    for k, v in ipairs( player.GetAll( ) ) do

        if not table.HasValue( cfg.ugroups_staff, v:GetUserGroup( ) ) then continue end

        self.ct_staff = self.dico_staff:Add('DPanel')
        self.ct_staff:SetSize(275, 72)
        self.ct_staff.Paint = function( s, w, h )
            if cfg.StaffCardBlur then design.blur( s ) end

            if cfg.StaffCardBackgroundUseRankColor then
                draw.RoundedBox( 5, 0, 0, w, h, cfg.ugroup_clrs[v:GetUserGroup( )] and cfg.ugroup_clrs[v:GetUserGroup( )] or cfg.StaffCardBackgroundColor or Color( 0, 0, 0, 230 ) )
            else
                draw.RoundedBox( 5, 0, 0, w, h, cfg.StaffCardBackgroundColor or Color( 0, 0, 0, 230 ) )
            end
        end

        self.av_staff = vgui.Create('AvatarImage', self.ct_staff)
        self.av_staff:SetSize(64, 64)
        self.av_staff:SetPos(4, 4)
        self.av_staff:SetPlayer(v, 64)

        self.lb_nick = vgui.Create('DLabel', self.ct_staff)
        self.lb_nick:SetText(v:Nick( ))
        self.lb_nick:SetPos(75, 5)
        self.lb_nick:SetFont('AriviaFontCardPlayerName')
        self.lb_nick:SetTextColor(cfg.StaffCardNameColor or Color( 255, 255, 255, 255 ))
        self.lb_nick:SizeToContents( )

        self.lb_rank = vgui.Create('DLabel', self.ct_staff)
        self.lb_rank:SetText(cfg.ugroup_titles[v:GetUserGroup( )] and cfg.ugroup_titles[v:GetUserGroup( )] or v:GetUserGroup( ))
        self.lb_rank:SetPos(75, 30)
        self.lb_rank:SetFont('AriviaFontCardRank')
        self.lb_rank:SetTextColor(cfg.StaffCardRankColor or Color( 255, 255, 255, 255 ))
        self.lb_rank:SizeToContents( )

        self.b_steam = vgui.Create('DButton', self.ct_staff)
        self.b_steam:SetText('')
        self.b_steam:SetSize(190, 50)
        self.b_steam:SetPos(self.ct_staff:GetWide( ) - 30, 0)
        self.b_steam:SetTooltip( lng.ViewSteamProfile )
        self.b_steam.Paint = function( s, w, h )
            local clr_btn = ( v:IsPlayer( ) and IsValid( v ) and not v:IsBot( ) and Color(255, 255, 255, 255 ) ) or Color( 255, 255, 255, 25 )

            surface.SetDrawColor        ( clr_btn       )
            surface.SetMaterial         ( btn_steam     )
            surface.DrawTexturedRect    ( 3, 7, 19, 19  )
        end

        self.b_steam.DoClick = function( )
            if IsValid( v ) then v:ShowProfile( ) end
        end

        i = i + 1

    end

end

/*
*	ibws
*/

function PANEL:External( title, uri, bIsText )

    if IsValid( mod.pnl.ibws ) then mod.pnl.ibws:Remove( ) end

    mod.pnl.ibws = vgui.Create( 'DFrame', self.ct_r )
    mod.pnl.ibws:Dock( FILL )
    mod.pnl.ibws:DockMargin(5,5,5,5)
    mod.pnl.ibws:ShowCloseButton(false)
    mod.pnl.ibws:SetTitle( '' )
    mod.pnl.ibws.Paint = function( s, w, h )
        surface.SetDrawColor( 0, 0, 0, 0 )
        draw.RoundedBox( 4, 0, 0, w, h, cfg.BrowserColor or Color( 0, 0, 0, 240 ) )
        draw.DrawText( title, 'AriviaFontBrowserTitle', mod.pnl.ibws:GetWide( ) / 2, 8, cfg.BrowserTitleTextColor or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
    end

    if bIsText then

        self.DTextAnnEntry = vgui.Create( 'DTextEntry', mod.pnl.ibws )
        self.DTextAnnEntry:SetMultiline( true )
        self.DTextAnnEntry:Dock(FILL)
        self.DTextAnnEntry:DockMargin(20, 20, 20, 20)
        self.DTextAnnEntry:SetPaintBackground( false )
        self.DTextAnnEntry:SetEnabled( true )
        self.DTextAnnEntry:SetVerticalScrollbarEnabled( true )
        self.DTextAnnEntry:SetFont( 'AriviaFontStandardText' )
        self.DTextAnnEntry:SetText( uri )
        self.DTextAnnEntry:SetTextColor( cfg.RulesTextColor or Color( 255, 255, 255, 255 ) )

    else

        self.DHTMLWindow = vgui.Create( 'DHTML', mod.pnl.ibws )
        self.DHTMLWindow:SetSize( ScrW( ) - 200, 300 )
        self.DHTMLWindow:DockMargin( 10, 10, 5, 10 )
        self.DHTMLWindow:Dock( FILL )

        if cfg.BrowserControlsEnabled then
            self.DHTMLControlsBar = vgui.Create( 'DHTMLControls', mod.pnl.ibws )
            self.DHTMLControlsBar:Dock( TOP )
            self.DHTMLControlsBar:SetWide( ScrW( ) - 200 )
            self.DHTMLControlsBar:SetPos( 0, 0 )
            self.DHTMLControlsBar:SetHTML( self.DHTMLWindow )
            self.DHTMLControlsBar.AddressBar:SetText( uri or arivia.core.Website )

            self.DHTMLWindow:MoveBelow( self.DHTMLControlsBar )
        end

        self.DHTMLWindow:OpenURL( uri or arivia.core.Website )

    end

end

/*
*	commands > update
*/

function PANEL:UpdateCommands( )

    if IsValid(mod.pnl.cmds) then mod.pnl.cmds:Remove( ) end

    mod.pnl.cmds = vgui.Create('DPanel', self.ct_r)
    mod.pnl.cmds:Dock(FILL)
    mod.pnl.cmds:DockMargin(10, 5, 10, 10)
    mod.pnl.cmds:SetVisible(false)
    mod.pnl.cmds.Paint = function( s, w, h )
        draw.SimpleText( 'Commands', 'AriviaFontOnlineStaff', 0, 15, cfg.name_clr or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(Color( 255, 255, 255, 255 ))
        surface.DrawLine(w - 5, 30, 0, 30)
    end

    self.PanelCmds = vgui.Create( 'AriviaCommand', mod.pnl.cmds )
    self.PanelCmds:Dock( FILL )
    self.PanelCmds:SetVisible( true )

end

/*
*	servers > update
*/

function PANEL:UpdateServers( )

    if table.Count(cfg.servers.list) > 0 and cfg.servers.enabled then

        if IsValid(self.PanelAriviaServers) then self.PanelAriviaServers:Remove( ) end

        self.PanelAriviaServers = vgui.Create('DPanel', self.ct_r)
        self.PanelAriviaServers:Dock(BOTTOM)
        self.PanelAriviaServers:SetTall(60)
        self.PanelAriviaServers.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 240))
            surface.SetDrawColor(Color(5, 5, 5, 255))
        end

        local buttonCount = 0

        for k, v in pairs(cfg.servers.list) do

            self.ButtonCustom = vgui.Create('DButton', self.PanelAriviaServers)
            self.ButtonCustom:SetText('')
            surface.SetFont('AriviaFontButtonItem')

            local sizex, sizey = surface.GetTextSize(string.upper(v.hostname))
            self.ButtonCustom:SetSize(sizex + 20, 60)
            self.ButtonCustom:Dock(LEFT)
            self.ButtonCustom:DockMargin(5, 0, 0, 0)
            local mat = false

            if v.icon and cfg.servers.bIconsText then
                mat = Material(v.icon, 'noclamp smooth')
                self.ButtonCustom:SetSize(self.ButtonCustom:GetWide( ) + 32, self.ButtonCustom:GetTall( ))
            elseif v.icon and cfg.servers.bIconsOnly then
                mat = Material(v.icon, 'noclamp smooth')
                self.ButtonCustom:SetSize(64, self.ButtonCustom:GetTall( ))
            end

            self.ButtonCustom.Paint = function(self, w, h)
                local clr_btn_n = cfg.servers.clr_btn_n
                local txtColor = cfg.servers.clr_txt_n

                if self:IsHovered( ) or self:IsDown( ) then
                    clr_btn_n = cfg.servers.clr_btn_h
                    txtColor = cfg.servers.clr_txt_h
                end

                surface.SetDrawColor(clr_btn_n)
                surface.DrawRect(0, 0, w, h)

                if cfg.servers.bIconsText and mat then
                    surface.SetDrawColor(txtColor)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(5, 14, 32, 32)
                    draw.SimpleText(string.upper(v.hostname), 'AriviaFontButtonItem', self:GetWide( ) / 2 + 16, self:GetTall( ) / 2, txtColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                elseif cfg.servers.bIconsOnly and mat then
                    surface.SetDrawColor(txtColor)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(17, 14, 32, 32)
                else
                    draw.SimpleText(string.upper(v.hostname), 'AriviaFontButtonItem', self:GetWide( ) / 2, self:GetTall( ) / 2, txtColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            self.ButtonCustom.DoClick = function( )
                LocalPlayer( ):ConCommand('connect ' .. v.ip)
            end

            buttonCount = buttonCount + 1
        end
    end

    if IsValid(panelBarTicker) then panelBarTicker:Remove( ) end

    panelBarTicker = vgui.Create('DLabel', self.ct_r)
    panelBarTicker:Dock(BOTTOM)
    panelBarTicker:SetTall(30)
    panelBarTicker:SetText('')

    if cfg.ticker_enabled then
        panelBarTicker:SetVisible(true)
    else
        panelBarTicker:SetVisible(false)
    end

    panelBarTicker.Paint = function( s, w, h )
        design.box( 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        design.box( 0, 0, w, 2, Color( 0, 0, 0, 200 ) )
    end
end

function PANEL:UpdateTabs( )

    tabs = { }

    if IsValid( self.tab_home ) then self.tab_home:Remove( ) end
    if IsValid( self.tab_info ) then self.tab_info:SetVisible( false ) end

    self.tab_home = vgui.Create('DPanel', self.ct_l_mid)
    self.tab_home:SetSize(200, 0)
    self.tab_home:DockMargin(0, 0, 0, 0)
    self.tab_home:Dock(LEFT)
    self.tab_home.Paint = function( s, w, h ) end

    if IsValid( mod.pnl.tabs ) then mod.pnl.tabs:Remove( ) end

    mod.pnl.tabs = vgui.Create('DPanel', self.ct_r)
    mod.pnl.tabs:Dock(FILL)
    mod.pnl.tabs:SetSize(self:GetWide( ) - 215, 0)
    mod.pnl.tabs:DockMargin(5, 5, 5, 5)
    mod.pnl.tabs.Paint = function( s, w, h ) end

    /*
    *	tab > jobs
    */

    if arivia.tab.jobs.enabled then
        self.Jobs = vgui.Create('arivia_tab_jobs', mod.pnl.tabs)
        self:NewCategory( arivia.tab.jobs.name, arivia.tab.jobs.desc, arivia.tab.jobs.icon, arivia.tab.jobs.clr_btn_n, arivia.tab.jobs.clr_btn_h, self.Jobs )
    end

    /*
    *	tab > weapons
    */

    local i = 0

    for k, v in pairs(CustomShipments) do
        if not mod:bCanBuyGun( v ) and not arivia.tab.ship.bShowUnavail then continue end
        if not ( v.separate or v.noship ) then continue end
        i = i + 1
    end

    if arivia.tab.weps.enabled and i ~= 0 then
        self.Weapons = vgui.Create( 'arivia_tab_weps', mod.pnl.tabs )
        self:NewCategory( arivia.tab.weps.name, arivia.tab.weps.desc, arivia.tab.weps.icon, arivia.tab.weps.clr_btn_n, arivia.tab.weps.clr_btn_h, self.Weapons )
    end

    /*
    *	tab > ammo
    */

    if arivia.tab.ammo.enabled and #GAMEMODE.AmmoTypes ~= 0 then
        self.Ammo = vgui.Create( 'arivia_tab_ammo', mod.pnl.tabs )
        self:NewCategory( arivia.tab.ammo.name, arivia.tab.ammo.desc, arivia.tab.ammo.icon, arivia.tab.ammo.clr_btn_n, arivia.tab.ammo.clr_btn_h, self.Ammo )
    end

    /*
    *	tab > food
    */

    local i_food = 0
    if FoodItems then
        for k, v in pairs( FoodItems ) do
            self.Value = v
            if not mod:bCanBuyFood( v ) then continue end
            i_food = i_food + 1
        end
    end

    if arivia.tab.food.enabled and i_food ~= 0 then
        self.Food = vgui.Create( 'arivia_tab_food', mod.pnl.tabs )
        self:NewCategory( arivia.tab.food.name, arivia.tab.food.desc, arivia.tab.food.icon, arivia.tab.food.clr_btn_n, arivia.tab.food.clr_btn_h, self.Food )
    end

    /*
    *	tab > shipments
    */

    i = 0

    for k, v in pairs( CustomShipments ) do
        self.Value = v
        if not mod:bCanBuyShip( v ) then continue end
        i = i + 1
    end

    if arivia.tab.ship.enabled and i ~= 0 then
        self.Ships = vgui.Create( 'arivia_tab_ship', mod.pnl.tabs )
        self:NewCategory( arivia.tab.ship.name, arivia.tab.ship.desc, arivia.tab.ship.icon, arivia.tab.ship.clr_btn_n, arivia.tab.ship.clr_btn_h, self.Ships )
    end

    /*
    *	tab > entities
    */

    i = 0

    for k, v in pairs( DarkRPEntities ) do
        if not mod:bCanBuyEnt( v ) then continue end
        i = i + 1
    end

    if arivia.tab.ents.enabled and i ~= 0 then
        self.Ents = vgui.Create( 'arivia_tab_ents', mod.pnl.tabs )
        self:NewCategory( arivia.tab.ents.name, arivia.tab.ents.desc, arivia.tab.ents.icon, arivia.tab.ents.clr_btn_n, arivia.tab.ents.clr_btn_h, self.Ents )
    end

    /*
    *	tab > vehicles
    */

    local i_veh = 0
    if CustomVehicles then
        for k, v in pairs( CustomVehicles ) do
            self.Value = v
            if not mod:bCanBuyVeh( v ) then continue end
            i_veh = i_veh + 1
        end
    end

    if arivia.tab.vehc.enabled and i_veh ~= 0 then
        self.Vehicles = vgui.Create( 'arivia_tab_veh', mod.pnl.tabs )
        self:NewCategory( arivia.tab.vehc.name, arivia.tab.vehc.desc, arivia.tab.vehc.icon, arivia.tab.vehc.clr_btn_n, arivia.tab.vehc.clr_btn_h, self.Vehicles )
    end

    /*
    *	tab > set all invisible
    */

    for k, v in pairs(tabs) do
        if IsValid( v ) then v:SetVisible( false ) end
    end

    /*
    *	tab > set selected visible
    */

    if IsValid( tabs[ self.Tab ] ) then
        tabs[ self.Tab ]:SetVisible( true )
    end

    /*
    *	update servers
    */

    self:UpdateServers( )

end

/*
*	GetCurrentTab
*/

function PANEL:GetCurrentTab( )
    return self.Tab
end

/*
*	categories > create
*/

function PANEL:NewCategory( name, desc, icon, clr_b_n, clr_b_h, pnl )

    table.insert( tabs, pnl )

    local mat           = Material(icon, 'noclamp smooth')

    self.b_cat = vgui.Create( 'DButton', self.tab_home )
    self.b_cat:SetSize(190, 50)
    self.b_cat:DockMargin(5, 5, 5, 0)
    self.b_cat:Dock(TOP)
    self.b_cat:SetText('')

    self.b_cat.DoClick = function( )
        self.Tab = table.KeyFromValue( tabs, pnl )
        self.ClearPanels( )

        if IsValid( mod.pnl.tabs ) then mod.pnl.tabs:SetVisible( true ) end

        for k, v in pairs( tabs ) do
            if IsValid( v ) then v:SetVisible( false ) end
        end

        if pnl:IsValid( ) then pnl:SetVisible( true ) end
    end

    self.b_cat.Paint = function( this, w, h )
        local buttonHover   = clr_b_h
        local clr_txt       = Color( 255, 255, 255, 255 )
        local clr_btn       = clr_b_n

        if this:IsHovered( ) or this:IsDown( ) then
            clr_btn         = buttonHover
        end

        surface.SetDrawColor        ( clr_btn )
        surface.DrawRect            ( 0, 0, w, h )

        surface.SetDrawColor        ( Color( 255, 255, 255, 255 ) )
        surface.DrawLine            ( 0, 15, 0, 0 )
        surface.DrawLine            ( 15, 0, 0, 0 )

        surface.SetDrawColor        ( Color( 255, 255, 255, 255 ) )
        surface.DrawLine            ( w - 20, h - 1, w, h - 1 )
        surface.DrawLine            ( w - 1, h, w - 1, h - 20 )

        surface.SetDrawColor        ( clr_txt )
        surface.SetMaterial         ( mat )
        surface.DrawTexturedRect    ( 6, 12, 24, 24 )

        draw.SimpleText( string.upper( name ), 'AriviaFontMenuItem', 36, this:GetTall( ) * .35, clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( string.upper( desc ), 'AriviaFontMenuSubinfo', 36, this:GetTall( ) * .65, clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    end

end

-----------------------------------------------------------------
--[ CHECK F4 KEYPRESS ]
-----------------------------------------------------------------

function PANEL:OnKeyCodePressed(keyCode)
    if keyCode == KEY_F4 then
        DarkRP.toggleF4Menu( )
    end
end
vgui.Register( 'arivia_pnl_root', PANEL, 'DPanel' )

-----------------------------------------------------------------
--[ UPDATE ON JOB CHANGE ]
-----------------------------------------------------------------

hook.Add( 'OnPlayerChangedTeam', 'arivia_otc', function( ply, old, new )

    if cfg.regeneration then return end

    if IsValid( mod.pnl.root ) then
        mod.pnl.root.CurJob = new
        mod.pnl.root:UpdateTabs( )
    end

end )

-----------------------------------------------------------------
--[ INITPOST ]
-----------------------------------------------------------------

hook.Add( 'InitPostEntity', 'arivia_ipe', function( )

    mod.pnl.root = nil

    -----------------------------------------------------------------
    --[ OPEN MENU ]
    -----------------------------------------------------------------
    function DarkRP.openF4Menu( )
        if mod.pnl.root and IsValid(mod.pnl.root) then
            if cfg.regeneration then
                mod.pnl.root = vgui.Create( 'arivia_pnl_root' )
            else
                mod.pnl.root:Show( )
            end

            mod.pnl.root:InvalidateLayout( )
        else
            mod.pnl.root = vgui.Create( 'arivia_pnl_root' )
        end
    end

    -----------------------------------------------------------------
    --[ CLOSE MENU ]
    -----------------------------------------------------------------
    function DarkRP.closeF4Menu( )
        if mod.pnl.root then
            if cfg.regeneration then
                mod.pnl.root:Remove( )
            else
                mod.pnl.root:Hide( )
            end
        end
    end

    -----------------------------------------------------------------
    -- [ TOGGLE MENU ]
    -----------------------------------------------------------------
    function DarkRP.toggleF4Menu( )
        if not IsValid(mod.pnl.root) or not mod.pnl.root:IsVisible( ) then
            DarkRP.openF4Menu( )
        else
            DarkRP.closeF4Menu( )
        end
    end

    GAMEMODE.ShowSpare2 = DarkRP.toggleF4Menu

end )