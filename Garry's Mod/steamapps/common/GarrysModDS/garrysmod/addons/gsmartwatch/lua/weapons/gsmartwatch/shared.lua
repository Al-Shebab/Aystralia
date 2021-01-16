SWEP.Base                           = "weapon_base"
SWEP.PrintName                      = "Smart Watch"
SWEP.ViewModel                      = "models/sterling/gsmart_c_watch.mdl"
SWEP.WorldModel                     = ""

SWEP.Spawnable                      = false
SWEP.AdminSpawnable                 = false
SWEP.UseHands                       = false

SWEP.Primary.ClipSize               = -1
SWEP.Primary.DefaultClip            = -1
SWEP.Primary.Automatic              = true
SWEP.Primary.Ammo                   = "none"

SWEP.Secondary.ClipSize             = -1
SWEP.Secondary.DefaultClip          = -1
SWEP.Secondary.Automatic            = false
SWEP.Secondary.Ammo                 = "none"

--[[

    SWEP:Initialize

]]--

function SWEP:Initialize()
    if CLIENT then
        if self.Owner and ( self.Owner ~= LocalPlayer() ) then
            return
        end

        -- if GSmartWatch.ClientSettings.LeftHanded then
        --     self.ViewModelFlip = true
        -- end


        self:SetBandColor( GSmartWatch.ClientSettings.BandColor or GSmartWatch.Cfg.Bands[ 1 ] )

        timer.Simple( .6, function()
            if IsValid( self ) then
                GSmartWatch:DrawScreen( self )

                if GSmartWatch.Cfg.ViewModelLight then
                    hook.Add( "Think", "GSmartWatch_SWEPLightEmitter", function()
            	        local tLight = DynamicLight( self:EntIndex(), true )
	                    if tLight then
                            local eViewModel = LocalPlayer():GetViewModel()
                            local eAttach = eViewModel:GetAttachment( 1 )
                            if not eAttach then
                                hook.Remove( "Think", "GSmartWatch_SWEPLightEmitter" )
                                return 
                            end

	    	                tLight.pos = eAttach.Pos + ( eAttach.Ang:Up() * 16 )
		                    tLight.r, tLight.g, tLight.b = 150, 200, 255

		                    tLight.brightness = 1.5
		                    tLight.Decay = 100
        		            tLight.Size = 32
		                    tLight.DieTime = ( CurTime() + .1 )
    	                end
                    end )
                end
            end
        end )

        hook.Run( "GSmartWatch_OnDeploy", self )
    end
end

--[[

    SWEP:Deploy

]]--

function SWEP:Deploy()
    self:SendWeaponAnim( ACT_VM_DRAW )
end

--[[

    SWEP:TranslateActivity

]]--

function SWEP:Holster( eWeapon )
    self:SendWeaponAnim( ACT_VM_HOLSTER )

    if SERVER then
        if IsValid( self.Owner ) then
            net.Start( "GSmartWatchNW" )
                net.WriteUInt( 1, 3 )
            net.Send( self.Owner )
        end

        timer.Simple( .5, function()
            if IsValid( self ) and IsValid( self.Owner ) then
                self.Owner:StripWeapon( "gsmartwatch" )

                hook.Run( "GSmartWatch_OnHolster", self.Owner )
            end
        end )
    end

    return true
end

--[[

    SWEP:OnRemove

]]--

function SWEP:OnRemove()
    if CLIENT then
        if self.BaseUI and IsValid( self.BaseUI ) then
            self.BaseUI:Remove()

            if GSmartWatch.CurrentApp then
                hook.Run( "GSmartWatch_PostAppShutdown", GSmartWatch.CurrentApp )
            end

            if GSmartWatch.Cfg.ViewModelLight then
                hook.Remove( "Think", "GSmartWatch_SWEPLightEmitter" )
            end

            hook.Remove( "PreDrawHalos", "GSmartWatch_PreDrawHalos" )
        end
    end

    if SERVER then
        if IsValid( self.Owner ) then
            net.Start( "GSmartWatchNW" )
                net.WriteUInt( 1, 3 )
            net.Send( self.Owner )
        end
    end
end

if CLIENT then
    SWEP.Category = "GSmartWatch"
    SWEP.UseHands = true

    SWEP.Author = "Timmy & Sterling"
    SWEP.BobScale = .4
    SWEP.SwayScale = .25
    SWEP.ViewModelFOV = 72
    SWEP.BounceWeaponIcon = false
    SWEP.DrawWeaponInfoBox = false
    SWEP.DrawAmmo = false

    --[[

        SWEP:SetBandColor

    ]]--

    local bandSubMaterial = CreateMaterial( "GSmartWatch_SubMaterial", "VertexLitGeneric", {
	    [ "$basetexture" ] = "sterling/gsmart_watch_band_main",
        [ "$bumpmap" ] = "sterling/gsmart_watch_band_norm",
	    [ "$envmap" ] = "env_cubemap",
	    [ "$normalmapalphaenvmapmask" ] = "1",
	    [ "$envmaptint" ] = "[.01 .01 .01]",
	    [ "$phong" ] = "1",
        [ "$phongboost" ] = "1",
	    [ "$phongexponent" ] = "20",
	    [ "$phongfresnelranges" ] = "[0.1 0.1 0.1]"
    })

    function SWEP:SetBandColor( tColor )
        bandSubMaterial:SetVector( "$color2", Vector( ( tColor.r / 255 ), ( tColor.g / 255 ), ( tColor.b / 255 ) ) )

        timer.Simple( .25, function()
            if self and IsValid( self ) then
                LocalPlayer():GetViewModel():SetSubMaterial( 1, "!GSmartWatch_SubMaterial" )
            end
        end )
    end

    --[[
    
        SWEP:DoDrawCrosshair

    ]]--

    function SWEP:DoDrawCrosshair( iX, iY )
    	return true
    end

    --[[
    
        SWEP:PostDrawViewModel

    ]]--

    function SWEP:PostDrawViewModel( eViewModel, eWeapon, pPlayer )
        if not eViewModel or not IsValid( eViewModel ) then
            return
        end

        if not self.BaseUI or not IsValid( self.BaseUI ) then
            return
        end
    
        local eAttach = eViewModel:GetAttachment( 1 )
        if not eAttach then
            return
        end

        local tPos = eViewModel:LocalToWorld( Vector( 0, 0, 0 ) )
	    local tAng = eAttach.Ang

        tPos = tPos - ( tAng:Right() * 2.51 ) + ( tAng:Forward() * 1.81 ) - ( tAng:Up() * 15.15 )

	    cam.Start3D2D( tPos, tAng, .0045 )
		    self.BaseUI:PaintManual()
        cam.End3D2D()
    end
end                                                                                                                                                                                                                                                                             -- 76561198166995690