if not SERVER then return end

local function zrush_ButanGas_DamagePlayers()

    for k, v in pairs(zrush.DrillHoles) do

        local dmgInfo = DamageInfo()
        dmgInfo:SetDamage( zrush.config.Machine["DrillHole"].ButanGas_Damage )
        dmgInfo:SetAttacker( v )
        dmgInfo:SetDamageType( DMG_NERVEGAS )

        if (IsValid(v) and v:GetState() == "NEED_BURNER" and v:GetGas() > 0) then

            for s, w in pairs(zrush_PlayerList) do
                if (IsValid(w) and w:IsPlayer() and w:Alive() and zrush.f.InDistance(w:GetPos(),v:GetPos(),zrush.config.Machine["DrillHole"].ButanGas_DamageRadius)) then
                    w:TakeDamageInfo( dmgInfo )
                end
            end
        end
    end
end

local function Check_ButanGasDamage_TimerExist()

    local timerid = "zrush_butangas_damagetimer_id"
    zrush.f.Timer_Remove(timerid)
    zrush.f.Timer_Create(timerid, zrush.config.Machine["DrillHole"].ButanGas_Speed, 0, zrush_ButanGas_DamagePlayers)
end
//hook.Add("InitPostEntity", "a.zrush.butangas.damagetimer.OnMapLoad", Check_ButanGasDamage_TimerExist)
Check_ButanGasDamage_TimerExist()
