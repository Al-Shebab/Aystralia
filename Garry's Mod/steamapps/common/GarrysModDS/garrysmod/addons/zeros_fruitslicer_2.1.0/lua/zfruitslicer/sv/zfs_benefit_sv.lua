if not SERVER then return end
zfs = zfs or {}
zfs.f = zfs.f or {}
zfs.Benefits = zfs.Benefits or {}

util.AddNetworkString("zfs_benefit_FX")
util.AddNetworkString("zfs_screeneffect")
util.AddNetworkString("zfs_screeneffect_stop")

function zfs.f.Benefit_Effect(effect,ply,duration)
	net.Start("zfs_benefit_FX")
	net.WriteString(effect)
	net.WriteEntity(ply)
	net.WriteFloat(duration)
	net.Broadcast()
end

function zfs.f.Benefit_ScreenEffect(ScreenEffectName,ply,duration)
	net.Start("zfs_screeneffect")
	net.WriteString(ScreenEffectName)
	net.WriteFloat(duration)
	net.Send(ply)
end

function zfs.f.Benefit_ScreenEffect_Stop(ply)
	net.Start("zfs_screeneffect_stop")
	net.Send(ply)
end

function zfs.f.Benefit_Inform(ply, time, abilityname)
	local BenefitInfo_start = string.Replace(zfs.language.Benefit.Start, "$benefitime", time)
	BenefitInfo_start = string.Replace(BenefitInfo_start, "$benefit", abilityname)
	zfs.f.Notify(ply, BenefitInfo_start, 3)

	timer.Simple(time, function()
		if IsValid(ply) then
			local BenefitInfo_end = string.Replace(zfs.language.Benefit.End, "$benefit", abilityname)
			zfs.f.Notify(ply, BenefitInfo_end, 3)
		end
	end)
end

function zfs.f.Benefit_StopAll(ply)

	if not IsValid(ply) then return end

	// Stops SpeedBoost
	if ply.zfs_HasSpeedBoost then

		if ply.zfs_speedboost_trail and IsValid(ply.zfs_speedboost_trail) then
			ply.zfs_speedboost_trail:Remove()
		end

		ply.zfs_HasSpeedBoost = false

		zfs.f.Timer_Remove("zfs_player_benefit_speedboost_" .. ply:EntIndex())
	end

	// Stops AntiGravity
	if ply.zfs_HasAntiGravity then
		ply:SetGravity(1)
		ply:SetJumpPower(ply.zfs_old_JumpPower)
		ply.zfs_HasAntiGravity = false
		zfs.f.Timer_Remove("zfs_player_benefit_antigravity_" .. ply:EntIndex())
	end

	// Stops Ghost
	if ply.zfs_HasGhost then
		ply.zfs_HasGhost = false
		ply:SetRenderMode(RENDERMODE_NORMAL)
		ply:SetColor(ply.zfs_BaseColor or Color(255,255,255,255))
		ply:SetRenderFX(kRenderFxNone)
		zfs.f.Timer_Remove("zfs_player_benefit_ghost_" .. ply:EntIndex())
	end

	// Stop Drugs
	if ply.zfs_HasScreeneffect then
		ply.zfs_HasScreeneffect = false
		zfs.f.Timer_Remove("zfs_player_benefit_drugs_" .. ply:EntIndex())
	end
end

hook.Add( "Move", "a_zfs_Move_PlayerSpeedModify", function( ply, mv, usrcmd )
    if ply.zfs_HasSpeedBoost then
        local speed = mv:GetMaxSpeed() * ply.zfs_SpeedBoostMul
        mv:SetMaxSpeed( speed )
        mv:SetMaxClientSpeed( speed )
    end
end )

zfs.Benefits = {
	//Getting Health
	["Health"] = function(ply, ID)
		// This is the only ability that can be from a Smoothie or Topping
		local extraHealth = zfs.config.Toppings[ID].ToppingBenefits["Health"]
		local newHealth = ply:Health() + extraHealth

		if zfs.config.Health.HealthCap and newHealth > ply:GetMaxHealth() then
			newHealth = ply:GetMaxHealth()
			zfs.f.Notify(ply, zfs.language.Benefit.CantAdd_ExtraHealth, 1)

			return
		end

		ply:SetHealth(newHealth)
		// This make a nice health effect
		zfs.f.Benefit_Effect("zfs_health_effect",ply,3)
	end,
	//Creating a ParticleEffect
	["ParticleEffect"] = function(ply, ID)
		local EffectName = zfs.config.Toppings[ID].ToppingBenefits["ParticleEffect"]
		local EffectDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		zfs.f.Benefit_Effect(EffectName,ply,EffectDuration)
	end,
	//Gives the Player a SpeedBoost
	["SpeedBoost"] = function(ply, ID)
		local SpeedBoost = zfs.config.Toppings[ID].ToppingBenefits["SpeedBoost"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		if (ply.zfs_HasSpeedBoost) then
			zfs.f.Notify(ply, zfs.language.Benefit.CantAdd_Speedboost, 1)

			return
		end

		ply.zfs_SpeedBoostMul = SpeedBoost or 1
		ply.zfs_HasSpeedBoost = true

		zfs.f.Benefit_Inform(ply, BenefitDuration, "SpeedBoost")

		ply.zfs_speedboost_trail = util.SpriteTrail(ply, ply:LookupAttachment("chest"), zfs.default_colors["cyan02"], true, 100, 1, 4, 1 / (15 + 1) * 0.5, "trails/laser.vmt")


		local timerid = "zfs_player_benefit_speedboost_" .. ply:EntIndex()
		zfs.f.Timer_Create(timerid,BenefitDuration,1,function()
			if not IsValid(ply) then return end

			if (ply.zfs_speedboost_trail and IsValid(ply.zfs_speedboost_trail)) then
				ply.zfs_speedboost_trail:Remove()
			end

			ply.zfs_HasSpeedBoost = false

			zfs.f.Timer_Remove("zfs_player_benefit_speedboost_" .. ply:EntIndex())
		end)
	end,
	// Makes the Player feel very light
	["AntiGravity"] = function(ply, ID)
		local JumpBoost = zfs.config.Toppings[ID].ToppingBenefits["AntiGravity"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		if (ply.zfs_HasAntiGravity) then
			zfs.f.Notify(ply, zfs.language.Benefit.CantAdd_AntiGravity, 1)

			return
		end

		ply.zfs_HasAntiGravity = true
		ply.zfs_old_JumpPower = ply:GetJumpPower()
		ply:SetGravity(0.5)
		ply:SetJumpPower(ply:GetJumpPower() + JumpBoost)
		zfs.f.Benefit_Inform(ply, BenefitDuration, "AntiGravity")

		local timerid = "zfs_player_benefit_antigravity_" .. ply:EntIndex()
		zfs.f.Timer_Create(timerid,BenefitDuration,1,function()
			if not IsValid(ply) then return end

			ply:SetGravity(1)
			ply:SetJumpPower(ply.zfs_old_JumpPower)
			zfs.f.Timer_Remove("zfs_player_benefit_antigravity_" .. ply:EntIndex())

			// Lets make sure the Player dont gets hurt so we add 3 seconds before he can recive fall damage again
			timer.Simple(BenefitDuration + 3, function()
				if IsValid(ply) then
					ply.zfs_HasAntiGravity = false
				end
			end)
		end)
	end,
	// Makes the Player nearly invisible
	["Ghost"] = function(ply, ID)
		local PlayerAlpha = zfs.config.Toppings[ID].ToppingBenefits["Ghost"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		if (ply.zfs_HasGhost) then
			zfs.f.Notify(ply, zfs.language.Benefit.CantAdd_Ghost, 1)

			return
		end

		ply.zfs_HasGhost = true
		ply.zfs_BaseColor = ply:GetColor()
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetRenderFX(kRenderFxPulseFast)
		ply:SetColor(Color(0, 255, 0, PlayerAlpha))
		zfs.f.Benefit_Inform(ply, BenefitDuration, "Ghost")

		local timerid = "zfs_player_benefit_ghost_" .. ply:EntIndex()
		zfs.f.Timer_Create(timerid,BenefitDuration,1,function()
			if not IsValid(ply) then return end

			ply.zfs_HasGhost = false
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor(ply.zfs_BaseColor or Color(255,255,255,255))
			ply:SetRenderFX(kRenderFxNone)

			zfs.f.Timer_Remove("zfs_player_benefit_ghost_" .. ply:EntIndex())
		end)
	end,
	// Gives the Player a trippy ScreenEffect
	["Drugs"] = function(ply, ID)
		local ScreenEffectName = zfs.config.Toppings[ID].ToppingBenefits["Drugs"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		if (ply.zfs_HasScreeneffect) then
			zfs.f.Notify(ply, zfs.language.Benefit.CantAdd_Drugs, 1)

			return
		end

		ply.zfs_HasScreeneffect = true

		zfs.f.Benefit_ScreenEffect(ScreenEffectName,ply,BenefitDuration)

		zfs.f.Benefit_Inform(ply, BenefitDuration, "Drugs")

		local timerid = "zfs_player_benefit_drugs_" .. ply:EntIndex()
		zfs.f.Timer_Create(timerid,BenefitDuration,1,function()
			if not IsValid(ply) then return end

			ply.zfs_HasScreeneffect = false
			zfs.f.Timer_Remove("zfs_player_benefit_drugs_" .. ply:EntIndex())
		end)
	end
}

hook.Add("GetFallDamage", "a_zfs_AnitGravity_GetFallDamage", function(ply, speed)
	if IsValid(ply) and ply:IsPlayer() and ply.zfs_HasAntiGravity then
		ply:EmitSound("zfs_sfx_bounce")

		return 0
	end
end)

hook.Add("PlayerDeath", "a_zfs_Benefits_OnPlayerDeath", function(victim, inflictor, attacker)
	zfs.f.Benefit_StopAll(victim)
	zfs.f.Benefit_ScreenEffect_Stop(victim)
end)

hook.Add("PlayerDisconnected", "a_zfs_Benefits_OnDisconnnect", function(ply)
	zfs.f.Benefit_StopAll(ply)
end)
