@echo off
cls
:StartServer
start /wait java -Xmx3072M -jar paper.jar -o true -nogui
echo (%time%) Server closed/crashed... restarting!
goto StartServer