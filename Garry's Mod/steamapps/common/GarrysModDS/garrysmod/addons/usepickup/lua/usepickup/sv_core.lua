local cfg = USEPICKUP.Config

hook.Add( "KeyPress", "USEPICKUP.KeyPress", function( p, k )
	if k == IN_USE and cfg.Enable then
        local ent = USEPICKUP.FUNCS:GetLookAtWeapon( p, true )
        local cd = p.USEPICKUP_Last or 0

        if ent and IsValid( ent ) and (ent:IsWeapon() or ent:GetClass() == "spawned_weapon") and (cd + .25 < CurTime()) and USEPICKUP.FUNCS:ValidateUse( p, ent ) then

            --if p.USEPICKUP then return end -- prevent spamming [only one process at the time -> times out anyway]

            p.USEPICKUP_Last = CurTime()

            -- darkrp                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       76561198122210646
            if ent:GetClass() == "spawned_weapon" then
                ent:Use( p, p, USE_TOGGLE, 1 ) -- darkrp thingy
                p.USEPICKUP = {
                    w   = ent:GetWeaponClass(),
                    t   = CurTime()
                }
                return
            end

            p.USEPICKUP = {
                w   = ent,
                t   = CurTime()
            }

            ent:SetPos( p:GetShootPos() )
        end
	end
end )

hook.Add( "WeaponEquip", "USEPICKUP.WeaponEquip", function( wep, p )
    timer.Simple( 0, function() -- next frame cuz gmod is gay
        if !IsValid(p) then return end

        if p.USEPICKUP and (p.USEPICKUP.w and !isstring(p.USEPICKUP.w) and IsValid( p.USEPICKUP.w ) or isstring(p.USEPICKUP.w)) and tobool( p:GetInfo("usepickup_autoswitch") ) then
            p:SelectWeapon( isstring(p.USEPICKUP.w) and p.USEPICKUP.w or p.USEPICKUP.w:GetClass() )
        end

        --jb stuff
        if p.USEPICKUP and p.USEPICKUP.bypass then
            p:SelectWeapon( p.USEPICKUP.bypass )
        end

        p.USEPICKUP = nil -- clear
        p.USEPICKUP_Last = 0 -- removes the cooldown, unclean but works, not used anyway xdddddddddddd
    end )
end )