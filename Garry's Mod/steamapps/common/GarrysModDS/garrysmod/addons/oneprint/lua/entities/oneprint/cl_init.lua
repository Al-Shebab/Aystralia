include( "shared.lua" )

ENT.PrintName = "Money printer"
ENT.Category = "OnePrint"
ENT.Author = "Timmy & OGL"
ENT.Contact	= "http://steamcommunity.com/id/alshulgin"
ENT.Instructions = ""

--[[

    ENT:Draw

]]--

function ENT:DrawTranslucent()
	self:DrawModel()

    self.iLastCheck = ( self.iLastCheck or 0 )
	self.iDist = ( self.iDist or 10001 )

    if ( CurTime() > ( self.iLastCheck + 1 ) ) then
		self.iDist = LocalPlayer():GetPos():DistToSqr( self:GetPos() )
		self.iLastCheck = CurTime()
    end

	if ( self.iDist > 10000 ) then
		if IsValid( self.dPrinter ) then
			self.dPrinter:Remove()
			self.dPrinter = nil
		end

		return
	end

	if not IsValid( self.dPrinter ) then
		self.dPrinter = OnePrint:Create3DUI( self )
		return
	end

	local tPos = self:GetPos()
	tPos = tPos + ( self:GetUp() * 61.9 ) + ( self:GetForward() * 21.9 ) + ( self:GetRight() * 11.25 )

	local tAng = self:GetAngles()
	tAng:RotateAroundAxis( tAng:Forward(), 90 )
	tAng:RotateAroundAxis( tAng:Right(), -90 )
	tAng:RotateAroundAxis( tAng:Forward(), -15 )

	vgui.Start3D2D( tPos, tAng, .0384 )
		self.dPrinter:Paint3D2D()
	vgui.End3D2D()
end

--[[

	ENT:OnVarChanged

]]--

function ENT:OnVarChanged( sVar, xOld, xNew )
	if ( sVar == "CurrentTab" ) then
		self:SetTab( xNew )
	end
end

--[[

	ENT:SetTab

]]--

function ENT:SetTab( iTab )
	if IsValid( self.dPrinter ) then
		OnePrint:SetTab( self.dPrinter, iTab )
	end
end

--[[

	ENT:OnRemove

]]--

function ENT:OnRemove()
	if IsValid( self.dPrinter ) then
		self.dPrinter:Remove()
		self.dPrinter = nil
	end
end