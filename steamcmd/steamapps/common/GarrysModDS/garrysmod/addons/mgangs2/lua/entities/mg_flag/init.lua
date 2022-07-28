AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local function sendNotifByTerritory(terr, msg)
	local claimInfo = terr:GetClaimed()
	local cgid = (claimInfo && claimInfo.gangid)

	if (cgid) then
		mg2:SendNotification(mg2.gang:GetOnlineMembers(cgid), msg)
	end
	
	return cgid != nil
end

function ENT:Initialize()
	self:SetModel("models/zerochain/mgangs2/mgang_flagpost.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:UseClientSideAnimation()

	self:SendClientAnim("idle_closed", 1)
end

function ENT:ClaimTerritory(ply)
	local gang = ply:GetGang()

	if !(gang) then return false, mg2.lang:GetTranslation("territory.YoureNotInAGang") end

	local claimPly = self:GetClaimingPly()

	if (IsValid(claimPly) && claimPly:IsPlayer()) then 
		local cMsg = (claimPly != ply && "territory.SomeoneElseClaiming" || "territory.AlreadyClaiming")

		return false, mg2.lang:GetTranslation(cMsg) 
	end

	local canClaim, hookMsg = hook.Run("mg2.territories.StartClaim", ply, gang)

	if (canClaim == false) then
		return false, hookMsg
	end

	local cConfig = MG2_TERRITORIES.config.claim
	local cTime = cConfig.time

	local sTID = self:GetTerritoryID()
	local terr = MG2_TERRITORIES:Get(sTID)

	if !(terr) then return false end

	local tClaimInfo = terr:GetClaimed()
	local cGangID = (tClaimInfo && tClaimInfo.gangid)

	if (cGangID != ply:GetGangID()) then
		local succ, msg = self:StartClaim(ply, cTime)

		return succ, msg
	else
		return false, mg2.lang:GetTranslation("territory.CantClaimOwn")
	end
end

function ENT:Use(activator, caller)
	local succ, msg = self:ClaimTerritory(caller)

	if (msg) then
		mg2:SendNotification(caller, msg)
	end
end

--[[Claiming]]
function ENT:ClearClaim()
	self:SetClaimingPly(nil)
	self:SetClaimStart(0)

	local tID = self:GetTerritoryID()
	local terr = MG2_TERRITORIES:Get(tID)
	local tcData = terr:GetClaimed()

	if (tcData) then
		self:SendClientAnim("open", 1)
		self:SendClientAnim("idle_open", 1)
	end
end

function ENT:StartClaim(ply, time)
	local sTID = self:GetTerritoryID()
	local claimPly = self:GetClaimingPly()

	local terr = MG2_TERRITORIES:Get(sTID)

	if !(terr) then return end

	local claimInfo = terr:GetClaimed()
	local tName, tDesc = terr:GetName(), terr:GetDescription()

	if (IsValid(claimPly) && claimPly:IsPlayer() && claimPly != ply) then return false end

	if (time <= 0) then 
		self:FinishClaim(ply, true)
		
		return true, mg2.lang:GetTranslation("territory.ClaimedFor", (tName or "NIL"))
	end

	self:SendClientAnim("fold", 1)
	self:SendClientAnim("idle_closed", 1)
	
	self:SetClaimingPly(ply)
	self:SetClaimStart(CurTime() + time)

	-- Warn current owning gang players
	sendNotifByTerritory(terr, mg2.lang:GetTranslation("territory.BeingClaimed", (tName or "NIL")))

	return true, mg2.lang:GetTranslation("territory.MustWait", time)
end

function ENT:FinishClaim(ply, noMsg)
	local sTID = self:GetTerritoryID()
	local terr = MG2_TERRITORIES:Get(sTID)
	
	if !(terr) then return end

	-- Set territory gang
	local gid = ply:GetGangID()
	local gang = mg2.gang:Get(gid)

	if !(gang) then return end

	-- Warn current owning players
	sendNotifByTerritory(terr, mg2.lang:GetTranslation("territory.Stolen", (terr:GetName() or "NIL"), (gang:GetName() or "NIL")))

	-- Set gang
	terr:SetClaimed(true, gid)

	-- Clear the claim (so it inits the new one)
	self:ClearClaim()

	-- Reward gang & message
	MG2_TERRITORIES:RewardGang(gang, "claim")
	
	if !(noMsg) then
		mg2:SendNotification(ply, mg2.lang:GetTranslation("territory.TerritoryClaimedFor", (terr:GetName() or "NIL")))
	end
end

ENT._lastSecThink = os.time() + 1

function ENT:Think()
	--[[Claiming]]
	local cPly = self:GetClaimingPly()

	local cConfig = MG2_TERRITORIES.config.claim
	local cRadius = cConfig.radius

	if (cPly && IsValid(cPly)) then
		local cDist = (cPly:GetPos():DistToSqr(self:GetPos()) > cRadius)
		local cMsg = (!cPly:GetGang() && "territory.NotClaiming.NoGang" || !cPly:Alive() && "territory.NotClaiming.Dead" || cDist && "territory.NotClaiming.TooFar" || false)

		if (cMsg) then
			self:ClearClaim()

			mg2:SendNotification(cPly, mg2.lang:GetTranslation(cMsg))

			return 
		end

		if (self:GetClaimStart() <= CurTime()) then
			self:FinishClaim(cPly)
		end
	end
	
	--[[Controlling/Occupying rewards]]
	if (os.time() < self._lastSecThink) then return end -- Perform every second

	self._lastSecThink = os.time() + 1

	local tid = self:GetTerritoryID()
	local terr = MG2_TERRITORIES:Get(tid)
	local tcData = (terr && terr:GetClaimed())

	if !(tcData) then return end -- Territory isn't claimed (or possibly doesn't exist)

	local gang = mg2.gang:Get(tcData.gangid)

	if !(gang) then return end

	local rewFreq = (MG2_TERRITORIES.config.rewardHoldFrequency or 300)
	local lastHold = (self:GetLastHoldReward() or 0)

	if (lastHold > rewFreq) then
		MG2_TERRITORIES:RewardGang(gang, "hold")

		lastHold = 0
	end

	self:SetLastHoldReward(lastHold + 1)
end

--[[
	Networking

	Anim Types:
		idle_closed (IDLE - CLOSED)
		open  (OPEN)
		idle_open (IDLE - OPENED)
		fold  (CLOSE)
]]
util.AddNetworkString("mg2.flagpost.AnimEvent")

function ENT:SendClientAnim(anim,speed)
	self:ServerAnim(anim, speed)
	
	net.Start("mg2.flagpost.AnimEvent")
		net.WriteTable({
			anim = anim,
			speed = speed,
			parent = self
		})
	net.Broadcast()
end

function ENT:ServerAnim(anim,speed)
	local sequence = self:LookupSequence(anim)
	self:SetCycle(0)
	self:ResetSequence(sequence)
	self:SetPlaybackRate(speed)
	self:SetCycle(0)
end
