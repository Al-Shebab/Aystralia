local cfg = USEPICKUP.Config

USEPICKUP.FUNCS = {}
--

function USEPICKUP.FUNCS:ValidateUse( p, ent )
    if ent:GetPos():Distance( p:GetShootPos() ) > cfg.Range then return false end

    return true
end

function USEPICKUP.FUNCS:GetLookAtWeapon( p, return_entity )
    --if !USEPICKUP.COMP:CanInteract( p ) then return false end

    local t = p:GetEyeTrace(MASK_SHOT)
    local darkrp = engine.ActiveGamemode() == "darkrp"
    local ent

    --if IsValid( t.Entity ) and !t.Entity:IsScripted() then return false end -- hl2 support later

    if darkrp then
        ent = IsValid(t.Entity) and t.Entity.IsSpawnedWeapon and t.Entity
        if ent and ent:GetWeaponClass() then
            if !ent.USEPICKUP_ToReturn then
                for k, v in pairs( weapons.GetList() ) do
                    if v.ClassName and v.ClassName == ent:GetWeaponClass() then
                        ent.USEPICKUP_ToReturn = v
                    end
                end
            end
            
            return self:ValidateUse( p, ent ) and !return_entity and ent.USEPICKUP_ToReturn or return_entity and ent or false
        end
    end

    return IsValid( t.Entity ) and t.Entity:IsWeapon() and self:ValidateUse( p, t.Entity ) and t.Entity or false
end

function USEPICKUP.FUNCS:GenerateColorFromString( s )
    local sum = 0

    for i=1,#s do
        sum = sum + utf8.codepoint( s[i] )
    end

    local r, g, b
    local mr = math.Round
    local ss = string.sub
    local tn = tonumber

    r = mr( tn( "0." .. string.sub( math.sin( sum + 1 ), 6 ) ) * 256, 0 )
    g = mr( tn( "0." .. string.sub( math.sin( sum + 2 ), 6 ) ) * 256, 0 )
    b = mr( tn( "0." .. string.sub( math.sin( sum + 3 ), 6 ) ) * 256, 0 )

    -- MsgC( Color( r, g, b ), s )

    return Color( r, g, b )
end

if CLIENT then

    local blur = Material("pp/blurscreen")
    function USEPICKUP.FUNCS:BlurPanel( panel, amount, heavyness ) -- https://forum.facepunch.com/f/gmodgd/iymn/Blurring-a-Panel/1/#postcacot
        
        local x, y = panel:LocalToScreen( 0, 0 )

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(blur)

        for i = 1, heavyness do
            blur:SetFloat("$blur", (i / 3) * (amount or 6))
            blur:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end

    end

end