if not SERVER then return end

local function zrush_DrillholeChecker()
	for k, v in pairs(zrush.DrillHoles) do
		if IsValid(v) then
			zrush.f.DrillHole_RemoverCheck(v)
		end
	end
end

local function zrush_DrillholeChecker_TimerExist()
	if (zrush.config.Drill_Mode == 0 and zrush.config.Machine["DrillHole"].Cooldown > 0) then

		local timerid = "zrush_DrillholeChecker_id"
		zrush.f.Timer_Remove(timerid)
		zrush.f.Timer_Create(timerid, zrush.config.Machine["DrillHole"].Cooldown, 0, zrush_DrillholeChecker)
	end
end

zrush_DrillholeChecker_TimerExist()
//hook.Add("InitPostEntity", "a.zrush.InitPostEntity.DrillholeChecker", zrush_DrillholeChecker_TimerExist)
