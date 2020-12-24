@echo off
cls
echo Starting server
title srcds.com Garry's Mod Console
:srcds
start /wait srcds.exe -console -game garrysmod -secure -ip 134.255.252.243 -port 27021 +clientport 27003 +map gm_flatgrass +host_workshop_collection 2332062788 +maxplayers 10 +gamemode sandbox +r_hunkalloclightmaps 0
echo (%time%) WARNING: srcds closed or crashed, restarting.
goto srcds