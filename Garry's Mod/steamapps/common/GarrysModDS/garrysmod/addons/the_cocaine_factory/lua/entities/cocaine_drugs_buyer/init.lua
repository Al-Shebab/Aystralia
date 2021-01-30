AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString( "TCF_CloseSellMenu" )
util.AddNetworkString( "TCF_SellDrugsMenu" )
util.AddNetworkString( "TCF_SellCocaine" )

function ENT:Initialize()
	self:SetModel( "models/Humans/Group03/Male_01.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )
	self:SetCollisionGroup( 1 )
	self.RandomCocainePayout = math.random( TCF.Config.PayPerPackMin, TCF.Config.PayPerPackMax )
	
	timer.Create( "COCAINE_NPCRandomPayout_".. self:EntIndex(), TCF.Config.RandomPayoutInterval, 0, function() -- Update random payout every 5th minute.
		if IsValid( self ) then
			self.RandomCocainePayout = math.random( TCF.Config.PayPerPackMin, TCF.Config.PayPerPackMax )
		end
	end )
end

function ENT:AcceptInput( string, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 1.5
		
		if IsValid( caller ) then
			if table.HasValue( TCF.Config.CriminalTeams, team.GetName( caller:Team() ) ) then
				for k, v in pairs( ents.FindByClass( "cocaine_box" ) ) do
					local ourcocainebox = v
					
					for k, v in pairs( ents.FindInSphere( self:GetPos(), TCF.Config.SellDistance ) ) do
						if v:GetClass() == "cocaine_box" then
							ourcocainebox = v
						end
					end
					
					local boxowner = ourcocainebox:CPPIGetOwner()
					
					if not IsValid( boxowner ) then
						boxowner = caller
					end
					
					if caller:GetPos():DistToSqr( ourcocainebox:GetPos() ) <= TCF.Config.SellDistance then
						if ourcocainebox.IsClosed then
							if ourcocainebox.BoxCocaineAmount > 0 then
								if boxowner == caller then
									local bonus = boxowner:GetDonatorBonus()
		
									local cocaine_amount = ourcocainebox.BoxCocaineAmount
									
									local payperpack = self.RandomCocainePayout
									local fullpayout = math.Round( ( cocaine_amount * payperpack ) * bonus )
									
									-- Network the information to the client and save it so it cannot be abused.
									caller.DonatorSellBonus = bonus
									caller.SellBoxCocaineAmount = cocaine_amount
									caller.FullPayout = fullpayout
									caller.PayPerPack = payperpack
									
									net.Start( "TCF_SellDrugsMenu" )
										net.WriteDouble( caller.DonatorSellBonus )
										net.WriteDouble( caller.SellBoxCocaineAmount )
										net.WriteDouble( caller.FullPayout )
									net.Send( caller )
									
									self:EmitSound( "vo/npc/male01/hi0".. math.random( 1, 2 ) ..".wav" ) -- finally
									break
								end
							else
								DarkRP.notify( caller, 1, 6,  TCF.Config.Lang["Your box contains no cocaine. Are you trying to scam me?"][TCF.Config.Language] )
								self:EmitSound( "vo/npc/male01/gethellout.wav" )
								break
							end
						else
							DarkRP.notify( caller, 1, 6,  TCF.Config.Lang["Close the box before trying to sell it, rookie."][TCF.Config.Language] )
							self:EmitSound( "vo/npc/male01/uhoh.wav" )
							break
						end
					else
						DarkRP.notify( caller, 1, 6,  TCF.Config.Lang["Please bring the box closer to the druggie."][TCF.Config.Language] )
						self:EmitSound( "vo/npc/male01/answer25.wav" )
						break
					end
				end
			else
				DarkRP.notify( caller, 1, 6,  TCF.Config.Lang["I don't want to speak with you in your current position, go away!"][TCF.Config.Language] )
				self:EmitSound( "vo/npc/male01/sorry01.wav" )
			end
		end
	end
end

net.Receive( "TCF_SellCocaine", function( length, ply )
	for k, v in pairs( ents.FindByClass( "cocaine_box" ) ) do
		local ourcocainebox = v

		for k, v in pairs( ents.FindInSphere( ply:GetPos(), TCF.Config.SellDistance ) ) do
			if v:GetClass() == "cocaine_box" then
				ourcocainebox = v
			end
		end
		
		local boxowner = ourcocainebox:CPPIGetOwner()
		
		if not IsValid( boxowner ) then
			boxowner = ply
		end
		
		if ply:GetPos():DistToSqr( ourcocainebox:GetPos() ) <= TCF.Config.SellDistance then
			if ourcocainebox.IsClosed then
				if ourcocainebox.BoxCocaineAmount > 0 then
					if ( boxowner == ply ) or ( ourcocainebox.ItemStoreOwner == ply ) then
						local bonus = boxowner:GetDonatorBonus()
		
						local cocaine_amount = ourcocainebox.BoxCocaineAmount
						
						local payperpack = ply.PayPerPack
						ply.FullPayout = math.Round( ( cocaine_amount * payperpack ) * bonus )
					
						ply:addMoney( ply.FullPayout )
						DarkRP.notify( ply, 1, 6,   TCF.Config.Lang["You've just sold your cocaine for"][TCF.Config.Language] .." ".. DarkRP.formatMoney( ply.FullPayout ) )
						
						-- XP Support
						local xp_to_give = math.Round( cocaine_amount * TCF.Config.XPPerCocainePack )
						
						-- Give experience support for Vronkadis DarkRP Level System
						if TCF.Config.DarkRPLevelSystemEnabled then
							ply:addXP( xp_to_give, true )
						end
						
						-- Give experience support for Sublime Levels
						if TCF.Config.SublimeLevelSystemEnabled then
							ply:SL_AddExperience( xp_to_give, "for selling cocaine.")
						end
						
						-- Reset all information on the user
						ply.DonatorSellBonus = 0
						ply.SellBoxCocaineAmount = 0
						ply.FullPayout = 0
						ply.PayPerPack = 0
						
						ourcocainebox:Remove()
						
						ply:EmitSound("vo/npc/male01/finally.wav")
						
						if TCF.Config.OnSellGiveXP then
							ply:addXP( TCF.Config.OnSellXPAmount, true )
						end
						break
					end
				else
					DarkRP.notify( ply, 1, 6,  TCF.Config.Lang["Your box contains no cocaine. Are you trying to scam me?"][TCF.Config.Language] )
					break
				end
			else
				DarkRP.notify( ply, 1, 6,  TCF.Config.Lang["Close the box before trying to sell it, rookie."][TCF.Config.Language] )
				break
			end
		else
			DarkRP.notify( ply, 1, 6,  TCF.Config.Lang["Please bring the box closer to the druggie."][TCF.Config.Language] )
			break
		end
	end
end )

function ENT:OnRemove()
	timer.Remove( "COCAINE_NPCRandomPayout_".. self:EntIndex() )
end

function ENT:OnTakeDamage( dmg )
	return 0
end