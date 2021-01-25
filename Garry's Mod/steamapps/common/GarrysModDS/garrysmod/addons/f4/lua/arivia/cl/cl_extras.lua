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

/*
*	declare > pnl
*/

local PANEL                 = { }

/*
*	Init
*/

function PANEL:Init( )

    self.Offset                     = 0
    self.Scroll                     = 0
    self.CanvasSize                 = 1
    self.BarSize                    = 1

    self.btnUp                      = vgui.Create( 'DButton', self )
    self.btnUp:SetText              ( '' )

                                    self.btnUp.DoClick = function ( s )
                                        s:GetParent( ):AddScroll( -1 )
                                    end

                                    self.btnUp.Paint = function( s, w, h )
                                        derma.SkinHook( 'Paint', 'ButtonUp', s, w, h )
                                    end

    self.btnDown                    = vgui.Create( 'DButton', self )
    self.btnDown:SetText            ( '' )

                                    self.btnDown.DoClick = function ( s )
                                        s:GetParent( ):AddScroll( 1 )
                                    end

                                    self.btnDown.Paint = function( s, w, h )
                                        derma.SkinHook( 'Paint', 'ButtonDown', s, w, h )
                                    end

    self.btnGrip                    = vgui.Create( 'DScrollBarGrip', self )
    self:SetSize                    ( 15, 15 )

end

/*
*	SetEnabled
*
*   @param  : bool b
*/

function PANEL:SetEnabled( b )
    if not b then
        self.Offset                 = 0
        self:SetScroll              ( 0 )
        self.HasChanged             = true
    end

    self:SetMouseInputEnabled       ( b )
    self:SetVisible                 ( b )

    if ( self.Enabled ~= b ) then
        self.Content:InvalidateLayout( )

        if ( self.Content.OnScrollbarAppear ) then
            self.Content:OnScrollbarAppear( )
        end
    end

    self.Enabled = b
end

/*
*	Value
*/

function PANEL:Value( )
    return self.Pos
end

/*
*	BarScale
*/

function PANEL:BarScale( )
    if ( self.BarSize == 0 ) then return 1 end
    return self.BarSize / ( self.CanvasSize + self.BarSize )
end

/*
*	SetUp
*/

function PANEL:SetUp( _barsize_, _canvassize_ )
    self.BarSize                    = _barsize_
    self.CanvasSize                 = math.max( _canvassize_ - _barsize_, 1 )

    self:SetEnabled                 ( _canvassize_ > _barsize_ )
    self:InvalidateLayout           ( )
end

/*
*	OnMouseWheeled
*/

function PANEL:OnMouseWheeled( dlta )
    if not self:IsVisible( ) then return false end
    return self:AddScroll( dlta * -2 )
end

/*
*	AddScroll
*/

function PANEL:AddScroll( dlta )
    local OldScroll                 = self:GetScroll( )
    dlta                            = dlta * 25

    self:SetScroll( self:GetScroll( ) + dlta )

    return OldScroll ~= self:GetScroll( )
end

/*
*	SetScroll
*/

function PANEL:SetScroll( scrll )
    if not self.Enabled then self.Scroll = 0 return end

    self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )

    self:InvalidateLayout( )

    local func = self.Content.OnVScroll
    if ( func ) then
        func( self.Content, self:GetOffset( ) )
    else
        self.Content:InvalidateLayout( )
    end
end

/*
*	AnimateTo
*/

function PANEL:AnimateTo( scrll, length, delay, ease )
    local anim                      = self:NewAnimation( length, delay, ease )
    anim.StartPos                   = self.Scroll
    anim.TargetPos                  = scrll

    anim.Think = function( anim, pnl, fraction )
        pnl:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )
    end
end

/*
*	GetScroll
*/

function PANEL:GetScroll( )
    if not self.Enabled then self.Scroll = 0 end
    return self.Scroll
end

/*
*	GetOffset
*/

function PANEL:GetOffset( )
    if not self.Enabled then return 0 end
    return self.Scroll * -1
end

/*
*	Think
*/

function PANEL:Think( )

end

/*
*	Paint
*/

function PANEL:Paint( w, h )
    derma.SkinHook( 'Paint', 'VScrollBar', self, w, h )
    return true
end

/*
*	OnMousePressed
*/

function PANEL:OnMousePressed( )

    local x, y                      = self:CursorPos( )
    local page_sz                   = self.BarSize

    if ( y > self.btnGrip.y ) then
        self:SetScroll( self:GetScroll( ) + page_sz )
    else
        self:SetScroll( self:GetScroll( ) - page_sz )
    end

end

/*
*	OnMouseReleased
*/

function PANEL:OnMouseReleased( )
    self.Dragging                   = false
    self.DraggingCanvas             = nil
    self:MouseCapture               ( false )

    self.btnGrip.Depressed          = false
end

/*
*	OnCursorMoved
*/

function PANEL:OnCursorMoved( x, y )

    if ( !self.Enabled ) then return end
    if ( !self.Dragging ) then return end

    local x                         = 0
    local y                         = gui.MouseY( )
    local x, y                      = self:ScreenToLocal( x, y )
    y                               = y - self.btnUp:GetTall( )
    y                               = y - self.HoldPos

    local TrackSize                 = self:GetTall( ) - self:GetWide( ) * 2 - self.btnGrip:GetTall( )
    y                               = y / TrackSize

    self:SetScroll( y * self.CanvasSize )

end

/*
*	Grip
*/

function PANEL:Grip( )

    if not self.Enabled  then return end
    if self.BarSize == 0 then return end

    self:MouseCapture               ( true )
    self.Dragging                   = true

    local x, y                      = 0, gui.MouseY( )
    local x, y                      = self.btnGrip:ScreenToLocal( x, y )
    self.HoldPos                    = y

    self.btnGrip.Depressed          = true

end

/*
*	PerformLayout
*/

function PANEL:PerformLayout( )

    local w                         = self:GetWide( )
    local scr                       = self:GetScroll( ) / self.CanvasSize
    local bar_sz                    = math.max( self:BarScale( ) * (self:GetTall( ) - (w * 2)), 10 )
    local track                     = self:GetTall( ) - ( w * 2 ) - bar_sz
    track                           = track + 1
    scr                             = scr * track

    self.btnGrip:SetPos             ( 0, w + scr )
    self.btnGrip:SetSize            ( w, bar_sz )

    self.btnUp:SetPos               ( 0, 0, w, w )
    self.btnUp:SetSize              ( w, w )

    self.btnDown:SetPos             ( 0, self:GetTall( ) - w, w, w )
    self.btnDown:SetSize            ( w, w )

end

/*
*	register
*/

derma.DefineControl( 'AriviaDVScrollBar', 'A Scrollbar', PANEL, 'Panel' )

/*
*	declare > category > pnl
*/

local PANEL = { }

/*
*	category > Init
*/

function PANEL:Init( )

    self.Children                   = { }
    self.bToggled                   = true
    self:SetTall                    ( 20 )

    self.btn                        = vgui.Create( 'DButton', self          )
    self.btn:Dock                   ( TOP                                   )
    self.btn:DockMargin             ( 5, 5, 5, 0                            )
    self.btn:SetHeight              ( 25                                    )
    self.btn:SetText                ( ''                                    )

                                    self.btn.DoClick = function( )
                                        self:DoToggle( )
                                    end

                                    self.btn.Paint = function( s, w, h )
                                        draw.RoundedBox( 0, 0, 0, w, h, Color( 5, 5, 5, 200 ) )
                                        draw.SimpleText( self.Title, 'AriviaFontMenuItem', 5, 12, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end

    /*
    *   timer > category expansion states
    */

    timer.Simple( 0.1, function( )
        if not IsValid( self ) then return end

        if self.expanded == 0 then
            self:ToggleClosed( )
        else
            self:ToggleOpened( )
        end

        local cat = self:GetCategoryID( )
        if mod.history.jobs:Registered( cat ) then
            local cat_state = mod.history.jobs:GetState( cat )
            if cat_state == '0' then
                self:ToggleClosed( )
            elseif cat_state == '1' then
                self:ToggleOpened( )
            end
        end

        self.bInitialized = true
    end )

end

/*
*	Paint
*/

function PANEL:Paint( w, h )
    draw.RoundedBox( 0, 1, 0, w - 2, h, Color( 5, 5, 5, 200 ) )
end

/*
*	AddNewChild
*/

function PANEL:AddNewChild( elm )
    if not IsValid( elm ) then return end
    table.insert( self.Children, elm )

    self.List:PerformLayout( )
end

/*
*	SetupChildren
*/

function PANEL:SetupChildren( )
    self:SetTall( 25 + self.List:GetTall( ) + 15 )
end

/*
*	ToggleOpened
*/

function PANEL:ToggleOpened( )
    self.bToggled           = true
    local speed             = not self.bInitialized and 0 or 0.5
    self:SizeTo             ( self:GetWide( ), 25 + self.List:GetTall( ) + 15, speed, 0.1 )
end

/*
*	ToggleClosed
*/

function PANEL:ToggleClosed( )
    self.bToggled           = false
    local speed             = not self.bInitialized and 0 or 0.5
    self:SizeTo             ( self:GetWide( ), 35, speed, 0.1 )
end

/*
*   GetCategoryID
*
*   @return : str
*/

function PANEL:GetCategoryID( )
    local cat               = self.Title
    cat                     = helper.strclean( cat )

    return cat
end

/*
*	DoToggle
*/

function PANEL:DoToggle( )
    local cat = self:GetCategoryID( )

    if self.bToggled then
        self:ToggleClosed( )
        mod.history.jobs:WriteExpanded( cat, self, '0' )
    else
        self:ToggleOpened( )
        mod.history.jobs:WriteExpanded( cat, self, '1' )
    end
end

/*
*	HeaderTitle
*/

function PANEL:HeaderTitle( cat )
    self.Title = cat
end

/*
*   SetExpanded
*
*   @param  : bool b
*/

function PANEL:SetExpanded( b )
    self.expanded = b
end

/*
*   register
*/

vgui.Register( 'AriviaCategory', PANEL, 'DPanel' )