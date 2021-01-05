include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()
end

function ENT:SetAnim( strAnim, intSpeed )
	local strSequence, intDuration = self:LookupSequence( strAnim )
	if intDuration > 0 then
		self:SetCycle( 0 )
		self:ResetSequence( strSequence )
		self:SetPlaybackRate( intSpeed )
		self:SetCycle( 0 )
	end
end

Slawer.Mayor:NetReceive("ToggleSafeAnim", function(tbl)
	if tbl.ent && IsValid(tbl.ent) then
		tbl.ent:SetAnim(tbl.open && "open" || "close", 1)
	end
end)