include("shared.lua")

function ENT:Initialize()
	if not KVS then
		return
	end
		
	local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
	KVS:SetNPCName( self, sentences[ 67 ], 0xf494 )
end