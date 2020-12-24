//ADMIN FILE

grptb = {}

gPrinters.adminModes[ "SAM System" ] = {
    displayName = "SAM System",
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

        for _, v in pairs( sam.get_global("Ranks") ) do
            if v == "operator" or v == "noaccess" then continue end
            local grp = vgui.Create( "DButton", panel )
            grp:SetSize( 160, 30 )
            grp:SetText( "" )
            grp.Paint = function( slf, w, h )
                gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 100 ) )
                gPrinters.drawText( 0, _, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )
            end

            local grpcheck = vgui.Create( "DCheckBox", grp )
            grpcheck:SetSize( 16, 16 )
            grpcheck:SetPos( 8, 8 )


            grp.DoClick = function()
                if !grpcheck:GetChecked() then
                    table.insert( grptb, _ )
                    grpcheck:SetChecked( true )
                else
                    table.RemoveByValue( grptb, _ )
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
                    table.insert( grptb, _ )
                    grpcheck:SetChecked( true )
                else
                    table.RemoveByValue( grptb, _ )
                    grpcheck:SetChecked( false )
                end
            end

            group:AddItem( grp )
        end
    end,
    rankTable = function() return grptb end,
    enableFunction = function()
        if SAM_LOADED then
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

        for _, v in pairs( sam.get_global("Ranks") ) do
            local grp = vgui.Create( "DButton", panel )
            grp:SetSize( 160, 25 )
            grp:SetText( "" )
            grp.Paint = function( slf, w, x )
                gPrinters.drawBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 0, 0, 0, 100 ) )
                gPrinters.drawText( 0, _, 16, slf:GetWide() / 2, slf:GetTall() / 2, Color( 163, 163, 163, 175 ), 1 )
            end

            local grpcheck = vgui.Create( "DCheckBox", grp )
            grpcheck:SetSize( 16, 16 )
            grpcheck:SetPos( 8, 5 )

            if table.HasValue( ranks, _ ) then
                table.insert( grptb, _ )
                grpcheck:SetChecked( true )
            end

            grp.DoClick = function()
                if !grpcheck:GetChecked() then
                    table.insert( grptb, _ )
                    grpcheck:SetChecked( true )
                else
                    table.RemoveByValue( grptb, _ )
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
                    table.insert( grptb, _ )
                    grpcheck:SetChecked( true )
                else
                    table.RemoveByValue( grptb, _ )
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