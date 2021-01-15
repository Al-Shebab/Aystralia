OnePrint.Tabs = OnePrint.Tabs or {}
OnePrint.b3DWaiting = true

OnePrint.UIW = 600
OnePrint.UIH = 600
OnePrint.iMargin = 12
OnePrint.iRoundness = 6

surface.CreateFont( "OnePrint.1", { font = "Rajdhani Bold", size = ( OnePrint.UIH * .1 ), weight = 600, antialias = true } )
surface.CreateFont( "OnePrint.2", { font = "Rajdhani Bold", size = ( OnePrint.UIH * .07 ), weight = 600, antialias = true } )
surface.CreateFont( "OnePrint.3", { font = "Rajdhani Bold", size = ( OnePrint.UIH * .06 ), weight = 600, antialias = true } )
surface.CreateFont( "OnePrint.4", { font = "Rajdhani Bold", size = ( OnePrint.UIH * .05 ), weight = 600, antialias = true } )
surface.CreateFont( "OnePrint.5", { font = "Rajdhani Bold", size = ( OnePrint.UIH * .038 ), weight = 600, antialias = true } )
surface.CreateFont( "OnePrint.6", { font = "Rajdhani Regular", size = ( OnePrint.UIH * .035 ), weight = 550, antialias = true } )

--[[

    OnePrint:RegisterTab

]]--

function OnePrint:RegisterTab( tTab )
    if not tTab or not tTab.ID or not isnumber( tTab.ID ) then
        return
    end

    OnePrint.Tabs[ tTab.ID ] = tTab
end

--[[

    OnePrint:TabExists

]]--

function OnePrint:IsValidTab( sTabID )
    if not sTabID or not OnePrint.Tabs[ sTabID ] then
        return false
    end

    return true
end

--[[

    OnePrint:DrawPrinterScreen

]]--

function OnePrint:Create3DUI( eEntity )
    if not eEntity or not IsValid( eEntity ) or ( eEntity:GetClass() ~= "oneprint" ) then
        return
    end

    if OnePrint.b3DWaiting then
        include( "oneprint/client/vgui/3d2dvgui.lua" )        
        OnePrint.b3DWaiting = nil
    end

    local dBase = vgui.Create( "DPanel" )
    dBase:SetSize( OnePrint.UIW, OnePrint.UIH )

    dBase.bIsOnePrint = true
    dBase.eEntity = eEntity

    function dBase:Think()
        if not IsValid( self.eEntity ) then
            return
        end
    end

    function dBase:Paint( iW, iH )
        surface.SetDrawColor( OnePrint:C( 0 ) )
        surface.DrawRect( 0, 0, iW, iH )
    end

    OnePrint:SetTab( dBase, ( eEntity:GetCurrentTab() or 1 ) )

    return dBase
end

--[[

    OnePrint:SetTab

]]--

local matCursor = Material( "materials/oneprint/wb_cursor.png", "smooth" )

function OnePrint:SetTab( dBase, iTab, bSync )
    if not dBase or not IsValid( dBase ) or not dBase.bIsOnePrint then
        return
    end

    if not OnePrint:IsValidTab( iTab ) then
        return
    end

    if dBase.ActiveTab and IsValid( dBase.ActiveTab ) then
        dBase.ActiveTab:Remove()
        dBase.ActiveTab = nil
    end

    if not bSync then
        OnePrint.Tabs[ iTab ].Run( dBase )
    end

    local fLerpX, fLerpY = false, false

    if dBase.ActiveTab and IsValid( dBase.ActiveTab ) then
        function dBase.ActiveTab:PaintOver( iW, iH )
            local iX, iY = OnePrint:GetCursorPos()
            if not fLerpX then
                fLerpX, fLerpY = iX, iY
            end

            fLerpX = Lerp( RealFrameTime() * 10, fLerpX, iX )
            fLerpY = Lerp( RealFrameTime() * 10, fLerpY, iY )

            if ( fLerpX < -32 ) or ( fLerpX > ( iW + 16 ) ) then
                return
            end

            if ( fLerpY < -32 ) or ( fLerpY > ( iH + 16 ) ) then
                return
            end

            surface.SetDrawColor( color_white )
            surface.SetMaterial( matCursor )
            surface.DrawTexturedRect( fLerpX, fLerpY, ( iH * .03 ), ( iH * .03 ) )
        end
    end

    if bSync then
        self:SyncTab( dBase.eEntity, iTab )
    end
end

--[[

    OnePrint:SyncTab

]]--

function OnePrint:SyncTab( ePrinter, iTab )
    if not ePrinter or not IsValid( ePrinter ) or ( ePrinter:GetClass() ~= "oneprint" ) then
        return false
    end

    if ( ePrinter:GetCurrentTab() == iTab ) then
        return false
    end

    net.Start( "OnePrintNW" )
        net.WriteUInt( 0, 4 )
        net.WriteUInt( iTab, 3 )
        net.WriteEntity( ePrinter )
    net.SendToServer()
end

--[[

    OnePrint:Play2DSound

]]--

local CSoundSource = false

function OnePrint:Play2DSound( sFileName )
    if CSoundSource then
        CSoundSource:Stop()
        CSoundSource = false
    end

    CSoundSource = CreateSound( LocalPlayer(), sFileName )
    CSoundSource:PlayEx( 50, 100 )
end

--[[

    Packet reception

]]--

local tPacket = {
    -- GSmartWatch : Data update
    [ 0 ] = function()
        if not GSmartWatch then
            return
        end

        OnePrint.GSmartWatch = {}

        local iOwnedPrinters = net.ReadUInt( 8 )
		if ( iOwnedPrinters > 0 ) then
			for i = 1, iOwnedPrinters do
				local iMoney = net.ReadUInt( 24 )
				local iHealth = net.ReadUInt( 16 )
				local iTemperature = net.ReadUInt( 9 )

                OnePrint.GSmartWatch[ i ] = { money = iMoney, health = iHealth, temperature = iTemperature }
			end
		end
    end
}

net.Receive( "OnePrintNW", function()
    local i = net.ReadUInt( 4 )
    if i and tPacket[ i ] then
        tPacket[ i ]()
    end
end )