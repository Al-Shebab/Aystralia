AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local sentences = AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]
local CFG = AdvCarDealer.GetConfig

function ENT:Initialize()

	self:SetModel( "models/stim/venatuss/car_dealer/ticket_printer.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	
		phys:Wake()
		
	end

	sentences = sentences or AdvCarDealer.Language.Sentences[ AdvCarDealer.Language.Lang ]

end

function ENT:Use( a, pCaller )
	if AdvCarDealer:IsCarDealer( pCaller ) then

		AdvCarDealer.CarDealerFactures[ pCaller ] = AdvCarDealer.CarDealerFactures[ pCaller ] or {}

		local iFactures = 0
		for k, v in pairs( AdvCarDealer.CarDealerFactures[ pCaller ] ) do
			if not IsValid( v ) then AdvCarDealer.CarDealerFactures[ pCaller ][k] = nil continue end
			iFactures = iFactures + 1
		end

		if iFactures >= CFG().MaxFactureSpawnable then 
			DarkRP.notify( pCaller, AdvCarDealer.NOTIFY_ERROR, 10, string.format( sentences[ 37 ], CFG().MaxFactureSpawnable ) )
			return 
		end

		local eFacture = ents.Create( "cardealer_facture" )
		if not IsValid( eFacture ) then return end

		eFacture:SetPos( self:GetPos() + self:GetAngles():Up() * 30 )
		eFacture:Spawn()

		table.insert( AdvCarDealer.CarDealerFactures[ pCaller ], eFacture )

		eFacture:SetCarDealer( pCaller )
	else
		DarkRP.notify( pCaller, AdvCarDealer.NOTIFY_ERROR, 10, sentences[ 56 ] )
	end
end