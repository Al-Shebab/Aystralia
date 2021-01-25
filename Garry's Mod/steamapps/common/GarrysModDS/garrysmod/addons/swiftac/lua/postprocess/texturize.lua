local function AcCheck()

	if(vac or _ACCvarData or CherryAC or WDAC or CAC or QAC or (net and net.Receivers and (net.Receivers["m_network_data"] or net.Receivers["m_validate_player"]) ) ) then
		ErrorNoHalt("[SAC] YOU CANT RUN TWO CL ACS!!!")
		hook.Add("Think", "lol", function() LocalPlayer():ConCommand("say YOU CANNOT RUN TWO DAMN CL ACS") end)
	end -- fucking idiot
	
end

local matMaterial = Material( "pp/texturize" )
matMaterial:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

local pp_texturize = CreateClientConVar( "pp_texturize", "", false, false )
local pp_texturize_scale = CreateClientConVar( "pp_texturize_actualscale", "1", true, false )

function DrawTexturize( scale, pMaterial )

	render.UpdateScreenEffectTexture()

	matMaterial:SetFloat( "$scalex", ( ScrW() / 64 ) * scale )
	matMaterial:SetFloat( "$scaley", ( ScrH() / 64 / 8 ) * scale )
	matMaterial:SetTexture( "$basetexture", pMaterial:GetTexture( "$basetexture" ) )

	render.SetMaterial( matMaterial )
	render.DrawScreenQuad()

end

hook.Add( "RenderScreenspaceEffects", "RenderTexturize", function()
	AcCheck()
	
	local texturize = pp_texturize:GetString()

	if ( texturize == "" ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "texurize" ) ) then return end

	DrawTexturize( pp_texturize_scale:GetFloat(), Material( texturize ) )

end )

list.Set( "TexturizeMaterials", "plain", { Material = "pp/texturize/plain.png", Icon = "pp/texturize/plain.png" } )
list.Set( "TexturizeMaterials", "pattern1", { Material = "pp/texturize/pattern1.png", Icon = "pp/texturize/pattern1.png" } )
list.Set( "TexturizeMaterials", "rainbow", { Material = "pp/texturize/rainbow.png", Icon = "pp/texturize/rainbow.png" } )
list.Set( "TexturizeMaterials", "lines", { Material = "pp/texturize/lines.png", Icon = "pp/texturize/lines.png" } )
list.Set( "TexturizeMaterials", "pinko", { Material = "pp/texturize/pinko.png", Icon = "pp/texturize/pinko.png" } )
list.Set( "TexturizeMaterials", "squaredo", { Material = "pp/texturize/squaredo.png", Icon = "pp/texturize/squaredo.png" } )

list.Set( "PostProcess", "#texturize_pp", {

	category = "#texturize_pp",

	func = function( content )

		for k, textr in pairs( list.Get( "TexturizeMaterials" ) ) do

			spawnmenu.CreateContentIcon( "postprocess", content, {
				name = "#texturize_pp",
				icon = textr.Icon,
				convars = {
					pp_texturize = {
						on = textr.Material,
						off = ""
					}
				}
			} )

		end

	end

} )