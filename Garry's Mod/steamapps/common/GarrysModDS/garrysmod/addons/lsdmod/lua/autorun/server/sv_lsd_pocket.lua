
tfanpw = TFA_PocketBlock

local cantPocket = {}
cantPocket["sent_lsd_freezer"] = true

hook.Add("canPocket","LSDPocketing",function(ply,item)
  if(item:GetClass() == "sent_lsd_flank_support") then
    if(item:GetPower()) then
      ply:Ignite(3)
      DarkRP.notify(ply,1,5,"This is on fire!")
      return false
    end
    if(item.Flask) then
      DarkRP.notify(ply,1,5,"There's a flask on it.")
      return false
    end
  end
  if(cantPocket[item:GetClass()]) then
    DarkRP.notify(ply,1,5,"You can't pocket a "..item.PrintName)
    return false
  end
  if(item.LSDItem && IsValid(item.LSD_Owner)) then
    item.LSD_Owner.LSDObjects[item:GetClass()] =  math.max(0,(item.LSD_Owner.LSDObjects[item:GetClass()] or 0)+1)
  end
end)

util.AddNetworkString("DoLSDDealerDeliver")
util.AddNetworkString("CallLSDDialerMenu")

net.Receive("DoLSDDealerDeliver",function(l,ply)
  local b = net.ReadBool()
  if(!b && !ply:HasWeapon("swep_lsd_cellphone")) then
    if(ply:getDarkRPVar("money") >= LSD.Config.PhonePrice) then
      ply:addMoney(-LSD.Config.PhonePrice)
      ply:Give("swep_lsd_cellphone")
      DarkRP.notify(ply,2,5,"You have my number now, contact me for supply")
    else
      DarkRP.notify(ply,1,5,"Come back once you have money")
    end
  elseif(!b) then
    DarkRP.notify(ply,1,5,"You already have my number")
  end
  if(b) then
    if(ply:getDarkRPVar("money") >= LSD.Config.Price) then
      local ent = ents.Create("sent_lsd")
      ent:SetPos(ply:GetPos() + ply:GetAimVector()*16)
      ent:Spawn()
      ply:addPocketItem(ent)
      DarkRP.notify(ply,2,5,"Check your pockets partner")
    else
      DarkRP.notify(ply,1,5,"You don't have enough cash")
    end
  end
end)

hook.Add("OnPlayerChangedTeam","LSD_removeWeapons",function(ply)
  ply:StripWeapon("swep_lsd_cellphone")
  for k,v in pairs(ents.GetAll()) do
    if(v.LSD_Owner == ply) then
      v:Remove()
    end
  end
end)

hook.Add("PlayerDisconnected","LSD_RemoveWeaponsAgain",function(ply)
  for k,v in pairs(ents.GetAll()) do
    if(v.LSD_Owner == ply) then
      v:Remove()
    end
  end
end)
