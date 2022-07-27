function Decals.Update()
    local ent = net.ReadEntity()

    ent:SetDecal( Material "icon16/error.png" )
    ent:SetLoaded( false )
end
net.Receive( "Decals.Update", Decals.Update )

function Decals.Open( len, ent )
    if Decals.Menu then return end

    if !ent then
        ent = net.ReadEntity()
    end

	local pos
	
	cam.Start3D( EyePos(), LocalPlayer():EyeAngles() ) -- bad game = bad rendering = broken positioning
		pos = ent:GetPos():ToScreen()
	cam.End3D()

    local x = pos.x + pos.x / 4

    if x > ScrW() then
        x = x - pos.x / 2
    end

    local frame = vgui.Create "Decals.Menu"
    frame:SetSize( 320, 475 )
    frame:SetPos( x, 0 )
    frame:CenterVertical()
    frame:SetEnt( ent )
    frame:Setup()
    frame:MakePopup()

    Decals.Menu = frame
end
net.Receive( "Decals.Edit", Decals.Open )

function Decals.Render()
    for _, decal in ipairs( ents.FindByClass "decal" ) do
        decal:Render()
    end
end

function Decals.CheckRender()
    if GetConVar "decals_enabled" :GetBool() then
        hook.Add( "PostDrawTranslucentRenderables", "Decals.Render", Decals.Render )
    end
end
hook.Add( "InitPostEntity", "Decals.CheckRender", Decals.CheckRender )

function Decals.RenderCallback( name, old, new )
    local hookCall = hook[ tobool( new ) and "Add" or "Remove" ]

    hookCall( "PostDrawTranslucentRenderables", "Decals.Render", Decals.Render )
end
cvars.AddChangeCallback( "decals_enabled", Decals.RenderCallback )