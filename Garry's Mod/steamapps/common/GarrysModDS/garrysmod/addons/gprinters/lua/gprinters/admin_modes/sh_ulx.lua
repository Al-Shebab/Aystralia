--ULX Admin File Creation
--Updated July 1st 2019
--gPrinters Version 4.0 Incoming with new features and events.

grptb = {}

gPrinters.adminModes[ "ULX System" ] = {
    displayName = "ULX System",
    displayColor = Color( 255, 163, 0, 100 ),
    addFunction = function( panel )
    	local group = vgui.Create( "DPanelList", panel )
        group:SetPos( 560, 95 )
        group:SetSize( 330, 185 )
        group:SetSpacing( 1 )
        group:SetPadding( 1 )
        group:EnableVerticalScrollbar( true )
        group:EnableHorizontal( true )
        group:hideBar()

    	if ( gPrinters.plugins[ "Other" ].adminSystem == "ULX System" ) then
            for _, v in ipairs( xgui.data.groups ) do
                if ( v == "operator" or v == "noaccess" ) then continue end
                local grp = vgui.Create( "DButton", panel )
                grp:SetSize( 164, 30 )
                grp:SetText( "" )
                grp.Paint = function( slf, w, h )
                    gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 100 ) )
                    gPrinters.drawText( 0, v, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )
                end

                local grpcheck = vgui.Create( "DCheckBox", grp )
                grpcheck:SetSize( 16, 16 )
                grpcheck:SetPos( 8, 8 )


                grp.DoClick = function()
                    if !grpcheck:GetChecked() then
                        table.insert( grptb, v )
                        grpcheck:SetChecked( true )
                    else
                        table.RemoveByValue( grptb, v )
                        grpcheck:SetChecked( false )
                    end
                end


                grpcheck.Paint = function( slf, w, h )
                    if slf:GetChecked() then
                        gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
                        gPrinters.drawBox( 0, 2, 2, w - 4, h - 4, Color( 50, 150, 50, 100 ) )
                    else
                        gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
                    end
                end

                grpcheck.DoClick = function()
                    if !grpcheck:GetChecked() then
                        table.insert( grptb, v )
                        grpcheck:SetChecked( true )
                    else
                        table.RemoveByValue( grptb, v )
                        grpcheck:SetChecked( false )
                    end
                end

                group:AddItem( grp )
            end
        end
    end,
    rankTable = function() return grptb end,
    enableFunction = function()
        if xgui then
            return true
        end
        return false
    end,
    editFunction = function( panel, ranks )
        local group = vgui.Create( "DPanelList", panel )
        group:SetPos( 560, 155 )
        group:SetSize( 330, 170 )
        group:SetSpacing( 1 )
        group:SetPadding( 1 )
        group:EnableVerticalScrollbar( true )
        group:EnableHorizontal( true )
        group:hideBar()

        for _, h in ipairs( xgui.data.groups ) do
            if ( ( h == "operator" ) or ( h == "noaccess" ) ) then continue end
            local grp = vgui.Create( "DButton", panel )
            grp:SetSize( 160, 25 )
            grp:SetText( "" )
            grp.Paint = function( slf, w, x )
                gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 100 ) )
                gPrinters.drawText( 0, h, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )
            end

            local grpcheck = vgui.Create( "DCheckBox", grp )
            grpcheck:SetSize( 16, 16 )
            grpcheck:SetPos( 8, 5 )

            if table.HasValue( ranks, h ) then
                table.insert( grptb, h )
                grpcheck:SetChecked( true )
            end

            grp.DoClick = function()
                if !grpcheck:GetChecked() then
                    table.insert( grptb, h )
                    grpcheck:SetChecked( true )
                else
                    table.RemoveByValue( grptb, h )
                    grpcheck:SetChecked( false )
                end
            end

            grpcheck.Paint = function( slf, w, h )
                if slf:GetChecked() then
                    gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
                    gPrinters.drawBox( 0, 2, 2, w - 4, h - 4, Color( 50, 150, 50, 100 ) )
                else
                    gPrinters.drawBox( 0, 0, 0, w, h, Color( 5, 5, 5, 100 ) )
                end
            end

            grpcheck.DoClick = function()
                if !grpcheck:GetChecked() then
                    table.insert( grptb, h )
                    grpcheck:SetChecked( true )
                else
                    table.RemoveByValue( grptb, h )
                    grpcheck:SetChecked( false )
                end
            end

            group:AddItem( grp )
        end
    end,
    rankFunction = function( ply )
        return ply:GetUserGroup()
    end
}