resource.AddWorkshop("793766115")

local p = FindMetaTable("Player")

util.AddNetworkString("StartLSDPurchase")
util.AddNetworkString("RemoveLSDEffects")

function p:SetLSD(am)
     self:SetNW2Float("LSD",am)
end

hook.Add("PlayerTick","LSDTick",function(ply)
  if(ply:GetLSD() > 0) then
    if((ply.NextLSD or 0) < CurTime()) then
      ply.NextLSD = CurTime() + LSD.Config.DurationMultiplier
      ply:SetLSD(ply:GetLSD()-1)
      if(ply:GetLSD() <= 0) then
        ply:ScreenFade( SCREENFADE.IN, color_white, 0.8, 0.5 )
      end
    end
  end
end)

hook.Add("PlayerDeath","HealLSD",function(ply)
  ply:SetLSD(0)
  net.Start("RemoveLSDEffects")
  net.Send(ply)
end)


net.Receive("StartLSDPurchase",function(l,ply)
  if(ply:HasWeapon("swep_lsd_cellphone") || ply:IsAdmin()) then
    local i = net.ReadInt(8)
    local price = math.Round(LSD_STORE.Items[i].price*(LSD.Config.PriceRankMultiplier[ply:GetUserGroup()] or 1))
    if(price <= ply:getDarkRPVar("money")) then
      if(!ply.LSDObjects) then
        ply.LSDObjects = {}
      end
      if(!ply.LSDObjects[LSD_STORE.Items[i].ent]) then
        ply.LSDObjects[LSD_STORE.Items[i].ent] = 0
      end
      if((ply.LSDObjects[LSD_STORE.Items[i].ent] or 0) < LSD_STORE.Items[i].maxamount) then
        ply.LSDObjects[LSD_STORE.Items[i].ent] = (ply.LSDObjects[LSD_STORE.Items[i].ent] or 0) + 1
        DarkRP.notify(ply,2,5,"You bought "..LSD_STORE.Items[i].name.." ("..ply.LSDObjects[LSD_STORE.Items[i].ent].."/"..math.ceil(LSD_STORE.Items[i].maxamount)..")")
      else
        DarkRP.notify(ply,1,5,"You've reached the limit!")
        return
      end
      ply:addMoney(-price)
      local tr = util.TraceLine({start=ply:EyePos(),endpos=ply:EyePos() + ply:GetAimVector()*96,filter=ply})
      local ent = ents.Create(LSD_STORE.Items[i].ent)
      ent:SetPos(tr.HitPos)
      ent:Spawn()
      ent:CPPISetOwner(ply)
      ent.LSD_Owner = ply
    end
  else
    return
  end
end)

concommand.Add("lsd_spawn_dealers",function()
  local tbl = {}
	if(file.Exists(game.GetMap().."_lsd.txt","DATA")) then
		tbl = util.JSONToTable(file.Read(game.GetMap().."_lsd.txt","DATA"))
	end
	for k,v in pairs(tbl) do
		local ent = ents.Create("npc_lsd_dealer")
		ent:SetPos(v[1])
		ent:SetAngles(Angle(0,v[2],0))
		ent:Spawn()
	end
end)
