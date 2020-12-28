fx_version'bodacious'
game'gta5'

server_scripts{ 
  "weathersync-server.lua",
  "handsup-server.lua",
  "sv_carry.lua",
  "sv_piggyback.lua",
  "sv_takehostage.lua",
  "sv_tackle.lua",
  "dispatch-server.lua"
}

-- client scripts
client_scripts{
  "cfg/config.lua",
  "main.lua",
  "hud.lua",
  "cl_afk.lua",
  "cl_antivdm.lua",
  "cl_carry.lua",
  "cl_commands.lua",
  "cl_tackle.lua",
  "cl_idsabovehead.lua",
  "cl_pointfinger.lua",
  "antinpc.lua",
  "cl_takehostage.lua",
  "dv.lua",
  "vehiclecontrol.lua",
  "pvp.lua",
  "windows.lua",
  "pointfinger-client.lua",
  "handsup-client.lua",
  "stopwanted-client.lua", 
  "gameui-client.lua",
  "weathersync-client.lua",
  "missiontext-client.lua",
  "Nopeds/client.lua",
  "noweapondrops-client.lua"
 }
 
  exports {
    'getSurrenderStatus',
}