if not SERVER then return end

local function zrush_OilSpotGeneratorChecker()
	for k, v in pairs(zrush.OilSpotGenerators) do
		if IsValid(v) then
			zrush.f.OilspotGenerator_RequestOilSpot(v)
		end
	end
end

local function zrush_OilSpotGeneratorChecker_TimerExist()
	if zrush.config.Drill_Mode == 2 then

		local timerid = "zrush_OilSpotGeneratorChecker_id"
	    zrush.f.Timer_Remove(timerid)
	    zrush.f.Timer_Create(timerid, zrush.config.OilSpot_Generator.Rate, 0, zrush_OilSpotGeneratorChecker)
	end
end
//hook.Add("InitPostEntity", "a.zrush.InitPostEntity.OilSpotGenerator.OnMapLoad", zrush_OilSpotGeneratorChecker_TimerExist)
zrush_OilSpotGeneratorChecker_TimerExist()

concommand.Add("zrush_restartgog", function(ply, cmd, args)
	if zrush.f.IsAdmin(ply) then
		zrush_OilSpotGeneratorChecker_TimerExist()
		zrush.f.Notify(ply, "Global OilSpotGenerator Timer restarted!", 0)
	else
		zrush.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
	end
end)
