
local p = FindMetaTable( "Player" )

USEPICKUP.old_Give = USEPICKUP.old_Give or p.Give
function p:Give( weapon )
	local wep

    p.USEPICKUP_BYPASS = true
    wep = USEPICKUP.old_Give( self, weapon )
    p.USEPICKUP_BYPASS = false

	return wep
end