local c = USEPICKUP.Config

--

local PANEL = {}

function PANEL:Init()
    self:Dock( TOP )
    self.Ready = false
end

function PANEL:SetValues( name, a, b, bib )

    local g_min, g_max = USEPICKUP.STATS:GetGlobalMinMaxByKey( name )

    self.Values = {
        name    = USEPICKUP.LANG:GetTranslation( "STATS", name ),
        a       = a,
        b       = b,
        g       = {
            avg = USEPICKUP.STATS:GetAverage( name ),
            min = g_min,
            max = g_max
        },
        bib     = bib
    }

    if !self.Values then
        self:Remove() -- should never be the case anyway
    end

    self:InvalidateLayout( true )

end

function PANEL:PerformLayout( w, h )

    local new_w, new_h = 300, 36

    self:SetSize( new_w, new_h )

    local parent = self:GetParent():GetParent() -- hacky shit - what have i done fml

    if parent:GetWide() < new_w then
        parent:SetWide( new_w )
    else
        self:SetWide( parent:GetWide() )
    end

    self.Ready = true

end

function PANEL:Paint( w, h )
    if !self.Ready or !self.Values then return end

    USEPICKUP.FUNCS:BlurPanel( self, 3, 3 )
    draw.RoundedBox( 0, 0, 0, w, h, c.Colors["Row_BG"] )

    draw.SimpleText( self.Values.name, "USEPICKUP.Stats.Standard.Alt", 5, 11, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- g
    local parent_alpha_p = self:GetParent():GetAlpha()/255

    local gmin, gmax = self.Values.g.min, self.Values.g.max
    local bib = self.Values.bib
    local val_a = self.Values.a
    local val_b = self.Values.b

    local igap = 5
    local bar_height = 10

    local clr
    local bar_a_w, bar_b_w, bar_base_w
    local frac
    local text

    frac = ((self.Values.a or self.Values.b) - gmin) / (gmax - gmin)
    frac = frac * parent_alpha_p

    local b_is_better = (self.Values.a and self.Values.b) and (bib and self.Values.b > self.Values.a or !bib and self.Values.b < self.Values.a)

    -- draw value using markup
    if self.Values.a then
        --local p_val = math.Round( (self.Values.b - self.Values.a) / self.Values.b * 100, 1 )
        local p_val = self.Values.b - self.Values.a
        local p_str = p_val >= 0 and ("+" .. p_val) or p_val
        local p_clr = tostring( b_is_better and Color(0,255,0) or Color(255,0,0) )

        --text = markup.Parse( "<font=USEPICKUP.Stats.Standard.Alt>" .. self.Values.b .. (p_val != 0 and "<color=" .. p_clr .. ">(" .. p_str .. "%)" or "") )
        self.Parse_Text = self.Parse_Text or markup.Parse( "<font=USEPICKUP.Stats.Standard.Alt>" .. self.Values.b .. (p_val != 0 and "<color=" .. p_clr .. "> (" .. p_str .. ")" or "") )
    else
        self.Parse_Text = self.Parse_Text or markup.Parse( "<font=USEPICKUP.Stats.Standard.Alt>" .. self.Values.b ) 
    end

    self.Parse_Text:Draw( w - igap, 11, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

    bar_base_w = w - igap*2

    -- bg bar
    draw.RoundedBox( 0, igap, h - bar_height - igap, bar_base_w, bar_height, Color( 0, 0, 0, 100 ) ) -- just darken it a little bit

    -- first bar (A [current weapon])
    --clr = Color( 150, 150, 150 )
    bar_a_w = bar_base_w * math.Clamp( frac, 0.01, 1 )
    bar_a_w = math.ceil( bar_a_w )

    -- second bar (B [weapon to pickup])
    if !val_b then return end

    frac = (val_b - gmin) / (gmax - gmin)
    frac = frac * parent_alpha_p
    bar_b_w = bar_base_w * math.Clamp( frac, 0.01, 1 )
    bar_b_w = bar_b_w - bar_a_w

    local xpos = math.ceil( igap + bar_a_w + (bar_b_w < 0 and bar_b_w or 0) )

    bar_b_w = bar_b_w < 0 and -bar_b_w or bar_b_w

    clr = b_is_better and c.Colors["Good"] or c.Colors["Bad"]
    clr = ColorAlpha( clr, 200 )
    
    draw.RoundedBox( 0, xpos, h - bar_height - igap, bar_b_w, bar_height, clr )
    draw.RoundedBox( 0, xpos, h - bar_height - igap, bar_b_w, bar_height/2, Color( clr.r-30, clr.g-30, clr.b-30, clr.a ) ) 

    -- VERY SHITTY - fixes overlapping - but works without any problems so far

        clr = c.Colors["Row_Bar"]

        frac = (xpos - igap)/(bar_base_w - igap)
        bar_a_w = math.ceil( bar_base_w * frac )
        bar_a_w = math.Clamp( bar_a_w, 0, bar_base_w )

        draw.RoundedBox( 0, igap, h - bar_height - igap, bar_a_w, bar_height, clr )
        draw.RoundedBox( 0, igap, h - bar_height - igap, bar_a_w, bar_height/2, Color( clr.r-30, clr.g-30, clr.b-30 ) )

    -- "average" marker                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 76561199141829317
    frac = (self.Values.g.avg) / (gmax - gmin)
    frac = frac * parent_alpha_p
    xpos = igap + (bar_base_w*frac) - 1 -- -1 cuz marker width
    xpos = math.ceil( xpos )
    xpos = math.Clamp( xpos, igap, xpos )

    draw.RoundedBox( 0, xpos, h - bar_height - igap, 2, bar_height, c.Colors["Avg"] )
end

vgui.Register( "DUsePickupRow", PANEL, "DPanel" )
