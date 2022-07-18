AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	--self:SetAngles( self:Getowning_ent():GetAngles() - Angle( 76561198166995690 ) )
	self:GetPhysicsObject():Wake()
	
	self:SetHealth( CH_SupplyCrate.Config.MoneyBag_Health )
	self.SomeoneStealing = false
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self:SetHealth( self:Health() - dmg:GetDamage() )
		
		self.m_bApplyingDamage = true
		
		if self:Health() <= 0 then
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetMagnitude( 2 )
			effectdata:SetScale( 2 )
			effectdata:SetRadius( 3 )
			util.Effect( "Sparks", effectdata )
			self:Remove()
		end
		
		self.m_bApplyingDamage = false
	end
end

function ENT:Use( activator, caller )
	if caller:IsPlayer() and IsValid( caller ) then
		if ( self.LastUsed or CurTime() ) <= CurTime() then
			self.LastUsed = CurTime() + 1.5
			
			if self:GetBagMoney() > 0 then
				if not table.HasValue( CH_SupplyCrate.Config.AllowedTeams, team.GetName( caller:Team() ) ) then
					DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["You are not allowed to pick up looted money stacks as a"][CH_SupplyCrate.Config.Language] .." ".. team.GetName( caller:Team() ).."!" )
					DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["You can destroy it with any weapon."][CH_SupplyCrate.Config.Language] )
					return
				end
	
				if caller.StealingMoney then
					DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["You are already taking the money!"][CH_SupplyCrate.Config.Language] )
					return
				end
				
				if self.SomeoneStealing then
					DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["Someone is already taking the money!"][CH_SupplyCrate.Config.Language] )
					return
				end
				
				local crate = CH_SupplyCrate.CrateEntity
				if caller:GetPos():DistToSqr( crate:GetPos() ) < CH_SupplyCrate.Config.DistanceToCrateToPickup then
					DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["You must bring the money further away from the supply crate to take it!"][CH_SupplyCrate.Config.Language] )
					return
				end
				
				if not caller.StealingMoney then
					caller.StealingMoney = true
					self.SomeoneStealing = true
					
					DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["You are taking the money!"][CH_SupplyCrate.Config.Language] )
					DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["Keep starring at the money stack for"][CH_SupplyCrate.Config.Language] .." ".. CH_SupplyCrate.Config.MoneyBag_StealTime .." ".. CH_SupplyCrate.Config.Lang["seconds!"][CH_SupplyCrate.Config.Language] )
					
					timer.Simple( CH_SupplyCrate.Config.MoneyBag_StealTime, function()
						if not IsValid( self ) then
							return
						end
						
						if not IsValid( caller ) then
							return
						end
						
						local tr = caller:GetEyeTrace()
						local bagtrace = tr.Entity
						
						if bagtrace:GetClass() == "police_money_bag" then
							if caller:GetPos():DistToSqr( self:GetPos() ) < 10000 then
								caller:addMoney( self:GetBagMoney() )
								DarkRP.notify( caller, 1, 5, DarkRP.formatMoney( self:GetBagMoney() ) .." "..CH_SupplyCrate.Config.Lang["has been taken from the money stack!"][CH_SupplyCrate.Config.Language] )
							
								self:Remove()
							else
								DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["You are too far away and failed to take the money!"][CH_SupplyCrate.Config.Language] )
							end
						else
							DarkRP.notify( caller, 1, 5, CH_SupplyCrate.Config.Lang["You looked away and failed to take the money!"][CH_SupplyCrate.Config.Language] )
						end
						
						caller.StealingMoney = false
						self.SomeoneStealing = false
					end )
				end
			end
		end
	end
end

function MONEYBAG_Disconnect( ply )
	for _, ent in pairs( ents.GetAll() ) do
		if ent:GetModel() == "models/props_c17/SuitCase001a.mdl" then
			if ent:Getowning_ent() == 76561198166995690 then
				ent:Remove()
			end
		end
	end
end
hook.Add("Disconect", "MONEYBAG_Disconnect", MONEYBAG_Disconnect)