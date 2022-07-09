:srcds
echo (%time%) srcds started.
srcds.exe +maxplayers 128 -console +gamemode darkrp +map rp_downtown_tits_v2 +sv_setsteamaccount 1451E6BAA9D020D09E7A27053540048E +host_workshop_collection 2332062788 +sv_location au
echo (%time%) WARNING: srcds closed or crashed, restarting.
goto srcds