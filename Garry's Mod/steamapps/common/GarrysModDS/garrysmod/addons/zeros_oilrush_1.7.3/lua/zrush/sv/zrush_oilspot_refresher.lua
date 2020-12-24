if not SERVER then return end

local function zrush_OilSpotChecker()
	for k, v in pairs(zrush.OilSpots) do
		if (IsValid(v) and v.NoOil_TimeStamp > 0 and zrush.f.Oilspot_ReadyForRefresh(v) and v.NoOil_TimeStamp < CurTime()) then
			zrush.f.Oilspot_Reset(v)
		end
	end
end

local function zrush_OilSpotChecker_TimerExist()
	if (zrush.config.OilSpot.Cooldown > 0 and zrush.config.Drill_Mode == 1) then

		local timerid = "zrush_OilSpotChecker_id"
	    zrush.f.Timer_Remove(timerid)
	    zrush.f.Timer_Create(timerid, zrush.config.OilSpot.Cooldown, 0, zrush_OilSpotChecker)
	end
end
//hook.Add("InitPostEntity", "a.zrush.InitPostEntity.OilSpotChecker.OnMapLoad", zrush_OilSpotChecker_TimerExist)
zrush_OilSpotChecker_TimerExist()
