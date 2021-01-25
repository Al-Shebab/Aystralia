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

    /*
    *	parent
    */

    self.par                        = vgui.Create( 'DPanel', self           )
    self.par:Dock                   ( FILL                                  )
    self.par:SetVisible             ( true                                  )

                                    self.par.Paint = function( s, w, h ) end

    /*
    *	sub
    */

    self.sub                        = vgui.Create( 'DIconLayout', self.par  )
    self.sub:Dock                   ( FILL                                  )
    self.sub:DockMargin             ( 0, 50, 0, 0                           )
    self.sub:SetPos                 ( 0, 0                                  )
    self.sub:SetSpaceY              ( 5                                     )
    self.sub:SetSpaceX              ( 5                                     )

    /*
    *	loop > commands
    */

    for k, v in pairs( cfg.commands ) do

        if ( v.mayorOnly and not LocalPlayer( ):isMayor( ) ) then continue end
        if ( v.civilProtectionOnly and not LocalPlayer( ):isCP( ) ) then continue end

        /*
        *	separator
        */

        if v.name == 'Separator' then

            local sep               = self.sub:Add( 'DPanel'                )
            sep:SetSize             ( 2, 2                                  )
            sep:Dock                ( TOP                                   )

                                    sep.Paint = function( s, w, h ) end
            continue

        end

        local b_cmd                 = self.sub:Add( 'DButton'               )
        b_cmd:SetSize               ( self.sub:GetWide( ) / 2 - 47, 30      )
        b_cmd:SetText               ( ''                                    )
        b_cmd:SetSize               ( 120, 50                               )

                                    b_cmd.Paint = function( s, w, h )
                                        local clr_box_ol    = v.buttonOutline or Color(255, 255, 255, 50)
                                        local clr_box       = v.buttonNormal or Color(72, 112, 58, 190)
                                        local clr_txt       = v.textNormal or Color(72, 112, 58, 190)

                                        if s:IsHovered( ) or s:IsDown( ) then
                                            clr_box         = v.buttonHover or Color( 255, 255, 255, 255 )
                                            clr_txt         = v.textHover or Color( 255, 255, 255, 255 )
                                        end

                                        design.box_ol( 0, 0, w, h, clr_box, clr_box_ol )

                                        draw.SimpleText( string.upper( v.name or '' ), 'AriviaFontButtonItem', s:GetWide( ) / 2, s:GetTall( ) / 2, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

                                    end

                                    b_cmd.DoClick = function( )

                                        if v.argCount == 0 then
                                            RunConsoleCommand( 'say', v.command )
                                            mod.pnl.root:Hide( )

                                            return
                                        end

                                        local cdiag = vgui.Create( 'DFrame' )
                                        cdiag:SetSize( 300, 125 )
                                        cdiag:SetTitle( v.name )
                                        cdiag:SetVisible( true )
                                        cdiag:ShowCloseButton( true )
                                        cdiag:Center( )
                                        cdiag:MakePopup( )
                                        cdiag.Think = function( )
                                            if not b_cmd:IsVisible( ) then
                                                cdiag:Close( )
                                            end
                                        end
                                        cdiag.Paint = function( s, w, h )
                                            mod.design.blur( s )
                                            draw.RoundedBox( 4, 0, 0, w, h, Color( 10, 10, 10, 230 ) )
                                        end

                                        local lb_a1 = vgui.Create( 'DLabel', cdiag )
                                        lb_a1:SetSize( cdiag:GetWide( ) - 20, 25 )
                                        lb_a1:Dock(TOP)
                                        lb_a1:SetText( v.arg1 )

                                        local dt_a1 = vgui.Create( 'DTextEntry', cdiag )
                                        dt_a1:SetSize( cdiag:GetWide( ) - 20, 25 )
                                        dt_a1:Dock(TOP)
                                        dt_a1:SetText( '' )

                                        local lb_a2 = vgui.Create( 'DLabel', cdiag )
                                        lb_a2:SetSize( cdiag:GetWide( ) - 20, 25 )
                                        lb_a2:Dock(TOP)
                                        lb_a2:SetVisible(false)
                                        lb_a2:SetText( v.arg2 )

                                        local dt_a2 = vgui.Create( 'DTextEntry', cdiag )
                                        dt_a2:SetSize( cdiag:GetWide( ) - 20, 25 )
                                        dt_a2:Dock(TOP)
                                        dt_a2:SetVisible(false)
                                        dt_a2:SetText( '' )

                                        if v.argCount == 2 then
                                            cdiag:SetSize( 300, 180 )
                                            lb_a2:SetVisible(true)
                                            dt_a2:SetVisible(true)
                                        end

                                        local b_ok = vgui.Create( 'DButton', cdiag )
                                        b_ok:SetSize( cdiag:GetWide( ) - 20, 25 )
                                        b_ok:Dock(BOTTOM)
                                        b_ok:SetText( 'OK' )
                                        b_ok:SetFont('AriviaFontButtonItem')
                                        b_ok:SetTextColor( Color( 255, 255, 255 ) )
                                        b_ok.Paint = function( self, w, h )
                                            local clr_box = Color( 64, 105, 126, 190 )
                                            if self:IsHovered( ) or self:IsDown( ) then
                                                clr_box = Color(64, 105, 126, 220)
                                            end
                                            draw.RoundedBox( 4, 0, 0, w, h, clr_box )
                                        end

                                        b_ok.DoClick = function( )
                                            if v.argCount == 1 then
                                                RunConsoleCommand( 'say', v.command .. ' ' .. dt_a1:GetValue( ) )
                                            else
                                                RunConsoleCommand( 'say', v.command .. ' ' .. dt_a1:GetValue( ) .. ' ' .. dt_a2:GetValue( ) )
                                            end

                                            mod.pnl.root:Hide( )
                                            cdiag:Close( )
                                        end

                                    end

    end

end

/*
*	register
*/

vgui.Register( 'AriviaCommand', PANEL, 'EditablePanel' )