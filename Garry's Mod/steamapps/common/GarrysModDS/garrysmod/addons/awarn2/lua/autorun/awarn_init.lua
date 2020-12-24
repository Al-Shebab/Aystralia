AddCSLuaFile()
--[[------------------------------
  AWarn 2
----------------------------------]]

MsgC( Color(255,255,0), "AWarn2: Welcome to AWarn 2!\n" )

if SERVER then include( 'includes/sv_awarn2.lua' ) end
if CLIENT then include( 'includes/cl_awarn2.lua' ) end