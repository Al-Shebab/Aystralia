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
*	declare > pnl
*/

local PANEL                 = { }

/*
*	Init
*/

function PANEL:Init( )

    local Property = self

    Property:Dock(FILL)
    Property.Paint = function( ) end

    Property.Scroll = vgui.Create('DScrollPanel', Property)
    Property.Scroll:GetVBar( ):Remove( )

    Property.Scroll.VBar = vgui.Create('AriviaDVScrollBar', Property)
    Property.Scroll.VBar.Content = Property.Scroll
    Property.Scroll.VBar:Dock(LEFT)
    Property.Scroll.VBar:DockMargin(0, 7, 0, 5)

    Property.Scroll.PerformLayout = function(self)

        local Wide = self:GetWide( )
        local YPos = 0

        self:Rebuild( )

        self.VBar:SetUp( self:GetTall( ), self.pnlCanvas:GetTall( ) )
        YPos = self.VBar:GetOffset( )

        self.pnlCanvas:SetPos( 0, YPos )
        self.pnlCanvas:SetWide( Wide )

        self:Rebuild( )
    end

    Property.Scroll:Dock(LEFT)
    Property.Scroll:DockMargin(5, 5, 4, 0)
    Property.Scroll:SetWide((Property:GetParent( ):GetWide( ) - Property:GetParent( ):GetWide( ) / 3) + 9)
    Property.Scroll:GetVBar( ):ConstructScrollbarGUI( )

    Property.Categories = { }

    for i = 0, 0 do

        for k, v in ipairs(CustomShipments) do

            if not (v.separate or v.noship) then continue end
            if not mod:bCanBuyGun(v) then continue end

            if !Property.Value then
                Property.Value = v
            end

            local category          = v.category and self:CreateCat( v.category ) or self:CreateCat( lng.CategoryOther )

            local ListItem = vgui.Create('DButton')
            ListItem:SetSize((Property:GetParent( ):GetWide( ) / 3) - 4, 60)
            ListItem:SetText('')
            ListItem.oldpaint = ListItem.Paint
            ListItem.DoClick = function( )
                Property.Value = v
                Property.Value.Key = 1
                if istable(Property.Value.model) then
                    Property.Item.ModelObject:SetModel(Property.Value.model[Property.Value.Key])
                else
                    Property.Item.ModelObject:SetModel(Property.Value.model)
                end
                Property.Item.ModelObject:InvalidateLayout( )
                Property.Item.ButtonAction:InvalidateLayout( )
            end

            ListItem.Paint = function(self, w, h)

                local itemUnavailable = false

                local clr_btn_n = arivia.tab.weps.clr_btn_n
                local txtColor = textNormal
                if ListItem:IsHovered( ) or ListItem:IsDown( ) then
                    clr_btn_n = arivia.tab.weps.clr_btn_h
                    txtColor = textHover
                end

                local objectName = v.name

                if cfg.truncate_enabled then
                    local maxW = cfg.truncate_length or 170
                    surface.SetFont('AriviaFontObjectListName')
                    local fw, fh = surface.GetTextSize(objectName)
                    if fw > maxW then
                        objectName = string.sub(objectName, 1, objectName:len( ) - 3 ) .. '...'
                    end
                end

                -----------------------------------------------------------------
                -- SUPPORT FOR LEVELING SYSTEM
                -----------------------------------------------------------------

                if arivia.tab.weps.bXpEnabled and LevelSystemConfiguration then
                    local itemLevel = v.level or v.lvl
                    if itemLevel == nil or !itemLevel then
                        levelText = lng.NoLevel
                    elseif itemLevel ~= nil then
                        levelText = lng.Level .. ' ' .. itemLevel
                    end
                end

                -----------------------------------------------------------------
                -- SUPPORT FOR PRESTIGE SCRIPT
                -- https://scriptfodder.com/scripts/view/390
                -----------------------------------------------------------------

                if LevelSystemPrestigeConfiguration and arivia.tab.weps.bPrestigeEnabled then
                    local itemPrestige = v.prestige
                    if itemPrestige == nil or !itemPrestige then
                        prestigeText = lng.NoPrestige
                    elseif itemPrestige ~= nil then
                        prestigeText = lng.Prestige .. ' ' .. itemPrestige
                    end
                end

                local itemCount = v.max
                if itemCount == 0 then itemCount = lng.JobMaxUnlimited end

                local originNameX = cfg.ItemnameH or 23
                if (arivia.tab.weps.bXpEnabled and ( LevelSystemConfiguration ) ) or (arivia.tab.weps.bPrestigeEnabled and ( LevelSystemPrestigeConfiguration or v.prestige ) )  then
                    originNameX = 11
                end

                draw.RoundedBox( 0, 0, 0, w, h, clr_btn_n )
                surface.SetDrawColor( 255, 255, 255, 20 )

                draw.NoTexture( )
                design.cir( w - 30, 30, 22, 22 )

                draw.DrawText( objectName, 'AriviaFontObjectListName', 65, originNameX, arivia.tab.weps.clr_txt or Color( 255, 240, 244 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

                if arivia.tab.weps.bXpEnabled then
                    if LevelSystemConfiguration then
                        draw.DrawText( levelText, 'AriviaFontObjectLevel', 65, 35, Color( 255, 240, 244, 100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                        if arivia.tab.weps.bPrestigeEnabled and LevelSystemPrestigeConfiguration then
                            draw.DrawText( prestigeText, 'AriviaFontObjectLevel', 140, 35, Color( 255, 240, 244, 100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                        end
                    end
                elseif arivia.tab.weps.bPrestigeEnabled then
                    if LevelSystemPrestigeConfiguration then
                        draw.DrawText( prestigeText, 'AriviaFontObjectLevel', 65, 35, Color( 255, 240, 244, 100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                    end
                end

                draw.DrawText( GAMEMODE.Config.currency .. ( v.pricesep or v.price ), 'AriviaFontObjectPrice', w - 31, cfg.ItemAmountH or 20, Color( 255, 255, 255, 120 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                -----------------------------------------------------------------
                -- itemUnavailable - CHECK PLAYER LEVEL
                -----------------------------------------------------------------
                if LevelSystemConfiguration and arivia.tab.weps.bXpEnabled then
                    local itemLevel = v.level or v.lvl
                    local PlayerLevel = LocalPlayer( ):getDarkRPVar('level') or 0
                    if itemLevel ~= nil and itemLevel then
                        if itemLevel >  PlayerLevel then
                            itemUnavailable = true
                        end
                    end
                end

                -----------------------------------------------------------------
                -- itemUnavailable - CHECK PLAYER PRESTIGE
                -----------------------------------------------------------------
                if LevelSystemPrestigeConfiguration and v.prestige then
                    local itemPrestige = v.prestige
                    local PlayerPrestigeAmount = LocalPlayer( ):getDarkRPVar('prestige') or 0
                    if itemPrestige ~= nil then
                        if itemPrestige >  PlayerPrestigeAmount then
                            itemUnavailable = true
                        end
                    end
                end

                -----------------------------------------------------------------
                -- itemUnavailable - CHECK PLAYER CAN AFFORD
                -----------------------------------------------------------------
                if ( v.pricesep > LocalPlayer( ):getDarkRPVar('money') ) or ( v.price > LocalPlayer( ):getDarkRPVar('money') ) then
                    itemUnavailable = true
                end

                -----------------------------------------------------------------
                -- itemUnavailable - DARKEN BOX IF TRUE
                -----------------------------------------------------------------
                if arivia.tab.weps.bFadeUnavail and itemUnavailable then
                    draw.RoundedBox( 0, 0, 0, w, h, arivia.tab.weps.clr_unavail )
                end

            end

            local PlayerModel = vgui.Create('DModelPanel', ListItem)
            PlayerModel.LayoutEntity = function( ) return end

            local tmodel
            if istable(v.model) then
                tmodel = v.model[1]
            else
                tmodel = v.model
            end

            if isstring(tmodel) and util.IsValidModel(tmodel) then
                PlayerModel:SetModel(tmodel)
            else
                PlayerModel:SetModel('models/error.mdl')
            end

            if !IsValid(PlayerModel.Entity) then continue end

            local mn, mx    = PlayerModel.Entity:GetRenderBounds( )
            local size      = 0
            size            = math.max(size, math.abs(mn.x) + math.abs(mx.x))
            size            = math.max(size, math.abs(mn.y) + math.abs(mx.y))
            size            = math.max(size, math.abs(mn.z) + math.abs(mx.z))

            PlayerModel:SetFOV(38)
            PlayerModel:SetCamPos(Vector(size, size, size))
            PlayerModel:SetLookAt((mn + mx) * 0.5)

            PlayerModel:SetPos( 0, 0 )
            PlayerModel:SetSize( 60, 60 )

            category.List:Add(ListItem)
            category:AddNewChild(ListItem)

        end

    end

    for k, v in pairs( Property.Categories ) do
        v:SetupChildren( )
    end

    Property.Item = vgui.Create('DPanel', self)
    Property.Item:SetSize(Property:GetParent( ):GetWide( ) * 0.33 - 25, Property.Scroll:GetTall( ))
    Property.Item:Dock(RIGHT)
    Property.Item:DockMargin(2, 7, 0, 0)
    Property.Item.Paint = function( s, w, h )
        draw.RoundedBox( 0, 2.5, 2.5, w - 6.5, h, Color(5, 5, 5, 200 ) )
    end

    Property.Item.Title = vgui.Create('DLabel', Property.Item)
    Property.Item.Title:Dock(TOP)
    Property.Item.Title:SetText('')
    Property.Item.Title:DockMargin(0, 0, 0, 0)
    Property.Item.Title:SetContentAlignment(7)
    Property.Item.Title:SetSize(Property.Item:GetWide( ) - 20, 40)
    Property.Item.Title.Paint = function( s, w, h )
        draw.SimpleText(Property.Value.name, 'AriviaFontCategoryName', w / 2, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if Property.Value.model then
        Property.Item.ModelObject = vgui.Create('DModelPanel', Property.Item)
        Property.Item.ModelObject:SetSize( Property.Item:GetWide( ) / 2, self:GetTall( ) + 160 )
        Property.Item.ModelObject:Dock(TOP)
        Property.Item.ModelObject:DockMargin(3, 0, 3, 0)
        Property.Item.ModelObject:SetCamPos(Vector(110, -10, 70))
        Property.Item.ModelObject:SetLookAt(Vector(0, 0, 5))
        Property.Item.ModelObject:SetFOV(10)
        Property.Item.ModelObject:SetAmbientLight( Color( 255, 255, 255, 255 ) )
        Property.Item.ModelObject:SetModel(Property.Value.model)
    end

    local mn, mx    = Property.Item.ModelObject.Entity:GetRenderBounds( )
    local size      = 0
    size            = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size            = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size            = math.max(size, math.abs(mn.z) + math.abs(mx.z))

    Property.Item.ModelObject:SetFOV(100)
    Property.Item.ModelObject:SetCamPos(Vector(size, size, size))
    Property.Item.ModelObject:SetLookAt((mn + mx) * 0.5)

    Property.Item.ModelObject.LayoutEntity = function( ) end

    Property.Item.Scroll = vgui.Create( 'DScrollPanel', Property.Item )
    Property.Item.Scroll:SetSize( Property.Item:GetWide( ) - 10, 230)
    Property.Item.Scroll.VBar:ConstructScrollbarGUI( )
    Property.Item.Scroll:Dock(FILL)
    Property.Item.Scroll:DockPadding(5, 5, 5, 5)
    Property.Item.Scroll:DockMargin(5, 0, 0, 0)
    Property.Item.Scroll.Paint = function( s, w, h ) end

    if cfg.desc.enabled then
        Property.Item.Description = vgui.Create( 'DLabel', Property.Item.Scroll )
        Property.Item.Description:Dock(FILL)
        Property.Item.Description:DockMargin(20, 20, 20, 10)
        Property.Item.Description:SetFont('AriviaFontItemInformation')
        Property.Item.Description:SetAutoStretchVertical(true)
        Property.Item.Description:SetWrap(true)
        Property.Item.Description:SetSize(40, 200)
        Property.Item.Description.PerformLayout = function( )
            local text = ''
            Property.Item.Description:SetText( cfg.desc.list[Property.Value.entity] and cfg.desc.list[Property.Value.entity] .. '\n\n\n' or text )
        end
    end

    Property.Item.ButtonAction = vgui.Create('DButton', Property.Item)
    Property.Item.ButtonAction:Dock(BOTTOM)
    Property.Item.ButtonAction:DockMargin(10, 5, 10, 5)
    Property.Item.ButtonAction:SetText('')
    Property.Item.ButtonAction.Text = ''
    Property.Item.ButtonAction:SetSize(Property.Item:GetWide( ), 40)
    Property.Item.ButtonAction:SetVisible(true)
    Property.Item.ButtonAction.PerformLayout = function( )
        if mod:bCanBuyGun(Property.Value) then
            Property.Item.ButtonAction.Text = string.upper( lng.MakePurchase .. ': ' .. GAMEMODE.Config.currency .. ( Property.Value.pricesep or Property.Value.price ) )
            Property.Item.ButtonAction.DoClick = function( )
                RunConsoleCommand('darkrp', 'buy', Property.Value.name)
            end
        else
            Property.Item.ButtonAction.Text = string.upper( lng.CannotPurchase )
            Property.Item.ButtonAction.DoClick = function( ) end
        end
    end

    Property.Item.ButtonAction.Paint = function(self, w, h)

        local clr_btn_n
        local WeaponStatus = Property.Item.ButtonAction.Text or ''

        if mod:bCanBuyGun(Property.Value) then
            clr_btn_n = Color( 72, 112, 58, 255 )
        else
            clr_btn_n = Color( 124, 51, 50, 190 )
        end

        -----------------------------------------------------------------
        -- CHECK PLAYER LEVEL
        -----------------------------------------------------------------
        if arivia.tab.weps.bXpEnabled then
            local itemLevel = Property.Value.level
            local PlayerLevel = LocalPlayer( ):getDarkRPVar('level') or 0
            if itemLevel ~= nil and itemLevel then
                if itemLevel >  PlayerLevel then
                    clr_btn_n = arivia.tab.weps.clr_unavail
                    WeaponStatus = string.upper(lng.InsufficientLevel)
                end
            end
        end

        -----------------------------------------------------------------
        -- CHECK PLAYER PRESTIGE
        -----------------------------------------------------------------
        if LevelSystemConfiguration and Property.Value.prestige then
            local PlayerPrestigeAmount = LocalPlayer( ):getDarkRPVar('prestige') or 0
            if Property.Value.prestige ~= nil then
                if Property.Value.prestige >  PlayerPrestigeAmount then
                    clr_btn_n = arivia.tab.weps.clr_unavail
                    WeaponStatus = string.upper(lng.NotEnoughPrestige)
                end
            end
        end

        draw.RoundedBox( 0, 0, 0, w, h, clr_btn_n )
        draw.SimpleText( WeaponStatus, 'arivia_sel_btn_select', w / 2, h / 2, Color(230, 230, 230, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

end

/*
*   Create Category
*
*   @param  : str name
*   @param  : bool bExpanded
*/

function PANEL:CreateCat( name, bExpanded )

    /*
    *	categories :: loop and match names
    */

    for k, v in pairs( self.Categories ) do
        if v.Title == name then return v end
    end

    /*
    *	fetch cats
    *
    *   determine if categories are marked to be expanded or closed
    *   with startExpanded param
    */

    local cats = DarkRP.getCategories( ).weapons

    for k, v in pairs( cats ) do
        if name:lower( ) == v.name:lower( ) then
            bExpanded = v.startExpanded
        end
    end

    /*
    *	cat > parent
    */

    local cat                       = vgui.Create( 'AriviaCategory', self.Scroll )
    cat:Dock                        ( TOP                                   )
    cat:DockMargin                  ( 0, 5, 0, 0                            )
    cat:HeaderTitle                 ( name                                  )
    cat:SetExpanded                 ( bExpanded                             )

                                    table.insert( self.Categories, cat )

    /*
    *	cat > dico
    */

    cat.List                        = vgui.Create( 'DIconLayout', cat       )
    cat.List:Dock                   ( LEFT                                  )
    cat.List:SetLayoutDir           ( TOP                                   )
    cat.List:DockMargin             ( 6, 5, 0, 0                            )
    cat.List:SetSize                ( self:GetParent( ):GetWide( ) - self:GetParent( ):GetWide( ) / 3 + 9, 65 )
    cat.List:SetSpaceY              ( 5                                     )
    cat.List:SetSpaceX              ( 5                                     )

                                    cat.List.Paint = function( pnl, w, h ) end

    return cat
end

/*
*   register
*/

vgui.Register( 'arivia_tab_weps', PANEL, 'DPanel' )