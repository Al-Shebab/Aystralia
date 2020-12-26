
function sKore.updateScalingConvar()
	if sKore.scalingConvar != nil then
		sKore.scalingConvar:SetFloat(sKore.scalingConvar:GetFloat())
		return
	end

	sKore.scalingConvar = CreateClientConVar(
		sKore.config["scaleConvar"], 1, false, false,
		"sKore's scale ajustment console variable. You might want to " ..
		"decrease this if you're standing close to a big monitor, or " ..
		"increase it if you're standing far from a small monitor."
	)

	cvars.RemoveChangeCallback(sKore.config["scaleConvar"], "sKoreScaleCallback")
	cvars.AddChangeCallback(sKore.config["scaleConvar"], function(convar, oldValue, newValue)
		if !sKore.config["allowScaleAjustment"] then
			sKore.scalingFactor = sKore.scalingFactorRaw
			hook.Run("sKoreScaleUpdated")
			return
		end
		newValue = tonumber(newValue) or newValue
		if !isnumber(newValue) or newValue < sKore.config["minimumScale"]
		or newValue > sKore.config["maximumScale"] then
			oldValue = tonumber(oldValue) or oldValue
			sKore.scalingConvar:SetFloat(
				isnumber(oldValue) and oldValue >= sKore.config["minimumScale"]
				and oldValue <= sKore.config["maximumScale"] and oldValue
				or 1
			)
		else
			sKore.scalingFactor = sKore.scalingFactorRaw * newValue
			sKore.fileTable["scale"] = newValue
			file.Write(sKore.filePath, util.TableToJSON(sKore.fileTable))
			hook.Run("sKoreScaleUpdated")
		end
	end, "sKoreScaleCallback")

	sKore.scalingConvar:SetFloat(sKore.fileTable["scale"] or 1)
end

function sKore.testScalingConfig()
	local fileName = "skore/config/scaling.lua"

	assert(isbool(sKore.config["allowScaleAjustment"]), Format("The '%s' setting on '%s' is not a boolean!", "allowScaleAjustment", fileName))

	assert(isstring(sKore.config["scaleConvar"]), Format("The '%s' setting on '%s' is not a string!", "scaleConvar", fileName))
	assert(string.Trim(sKore.config["scaleConvar"]) != "", Format("The '%s' setting on '%s' is either an empty string or just whitespace!", "scaleConvar", fileName))

	assert(istable(sKore.config["scaleAjustmentMenuChat"]), Format("The '%s' setting on '%s' is not a table!", "scaleAjustmentMenuChat", fileName))
	assert(table.IsSequential(sKore.config["scaleAjustmentMenuChat"]), Format("The '%s' setting on '%s' is not a sequential table!", "scaleAjustmentMenuChat", fileName))
	local optimizedTable = {}
	for key, value in pairs(sKore.config["scaleAjustmentMenuChat"]) do
		assert(isstring(value), Format("The key #%s of the '%s' setting on '%s' is not a string!", key, "scaleAjustmentMenuChat", fileName))
		assert(string.Trim(value) != "", Format("The key #%s of the '%s' setting on '%s' is either an empty string or just whitespace!", key, "scaleAjustmentMenuChat", fileName))
		optimizedTable[value:lower()] = true
	end
	sKore.config["scaleAjustmentMenuChat"] = optimizedTable

	assert(istable(sKore.config["scaleAjustmentMenuConsole"]), Format("The '%s' setting on '%s' is not a table!", "scaleAjustmentMenuConsole", fileName))
	assert(table.IsSequential(sKore.config["scaleAjustmentMenuConsole"]), Format("The '%s' setting on '%s' is not a sequential table!", "scaleAjustmentMenuConsole", fileName))
	for key, value in pairs(sKore.config["scaleAjustmentMenuConsole"]) do
		assert(isstring(value), Format("The key #%s of the '%s' setting on '%s' is not a string!", key, "scaleAjustmentMenuConsole", fileName))
		assert(string.Trim(value) != "", Format("The key #%s of the '%s' setting on '%s' is either an empty string or just whitespace!", key, "scaleAjustmentMenuConsole", fileName))
	end

	assert(isnumber(sKore.config["minimumScale"]), Format("The '%s' setting on '%s' is not a number!", "minimumScale", fileName))
	assert(sKore.config["minimumScale"] > 0, Format("The '%s' setting on '%s' is not a number greater than 0!", "minimumScale", fileName))
	assert(sKore.config["minimumScale"] <= 1, Format("The '%s' setting on '%s' is not a number less than or equal to 1!", "minimumScale", fileName))

	assert(isnumber(sKore.config["maximumScale"]), Format("The '%s' setting on '%s' is not a number!", "maximumScale", fileName))
	assert(sKore.config["maximumScale"] >= 1, Format("The '%s' setting on '%s' is not a number greater than or equal to 1!", "maximumScale", fileName))
end

function sKore.loadScaling()
	if sKore.loadingScaling then return end
	sKore.loadingScaling = true
	include("skore/config/scaling.lua")
	sKore.testScalingConfig()
	sKore.scalingFactor = ScrH() / 1080
	sKore.scalingFactorRaw = sKore.scalingFactor
	sKore.updateScalingConvar()
	sKore.loadingScaling = nil
end

function sKore.reloadScaling()
	if sKore.loadingScaling then return end
	sKore.loadScaling()
	hook.Run("sKoreScalingReloaded")
end

function sKore.getScalingFactorRaw()
	return sKore.scalingFactorRaw
end

function sKore.getScalingFactor()
	return sKore.scalingFactor
end

function sKore.scale(value)
	return value * sKore.scalingFactor
end

function sKore.scaleClamp(value, min, max)
	local scaledValue = value * sKore.scalingFactor
	return math.Clamp(scaledValue, min or scaledValue, max or scaledValue)
end
sKore.scaleC = sKore.scaleClamp

function sKore.scaleRound(value, decimals)
	return math.Round(value * sKore.scalingFactor, decimals or 0)
end
sKore.scaleR = sKore.scaleRound

function sKore.scaleRoundClamp(value, min, max, decimals)
	local scaledValue = value * sKore.scalingFactor
	return math.Round(math.Clamp(scaledValue, min or scaledValue, max or scaledValue), decimals or 0)
end
sKore.scaleRC = sKore.scaleRoundClamp

sKore.loadScaling()
