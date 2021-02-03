include( "shared.lua" )

function ENT:Initialize()
end

net.Receive( "CRATE_UpdateMoneyBagAmt", function( length, ply )
	local moneybag_ent = net.ReadEntity()
	local moneybag_amount = net.ReadDouble()
	
	moneybag_ent.BagMoney = moneybag_amount
end )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_SupplyCrate.Design.DistanceTo3D2D then
		return
	end
	
	-- Draw text above bag of money
	local pos = self:GetPos() + ( Vector( 0, 0, 1 ) * math.sin(CurTime() * 2) * 2 )
	local PlayersAngle = LocalPlayer():GetAngles()
	local ang = Angle( 0, PlayersAngle.y - 180, 0 )
	
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	if not self.BagMoney then
		return
	end
	
	cam.Start3D2D( pos + Vector( 0, 0, 15 ), ang, 0.07 )
		draw.SimpleTextOutlined( DarkRP.formatMoney( self.BagMoney ), "CRATE_OverheadTitleSmall", 0, 0, CH_SupplyCrate.Design.TheMoneyColor, 1, 1, 2, CH_SupplyCrate.Design.TheMoneyBoarder )
	cam.End3D2D()
end

function ENT:Think()
end