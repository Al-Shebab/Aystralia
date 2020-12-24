ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = false

ENT.PrintName		= "LSD Dealer"
ENT.Author		= "Gonzo"
ENT.Category		= "LSD Drugs"
ENT.Spawnable 		= true
ENT.AdminOnly 		= true

AddCSLuaFile()

function ENT:Initialize( )

	self:SetModel( "models/player/magnusson.mdl" )

	if SERVER then
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal( )
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid(  SOLID_BBOX )
		self:CapabilitiesAdd( CAP_ANIMATEDFACE )
		self:CapabilitiesAdd( CAP_TURN_HEAD )
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()

		self:SetMaxYawSpeed( 90 )

		local sequence = self:LookupSequence("menu_combine")
		self:ResetSequence(sequence)
	end

end

function ENT:Think()

	if SERVER then
		self:ResetSequence("menu_combine")
		for k,v in pairs(ents.FindInSphere(self:GetPos() + Vector(0,0,30),64)) do
			if(v:GetClass() == "sent_lsd") then
				v:TakeIt()
			end
		end
		self:NextThink(CurTime() + 1)
		return true
	end
end

local a

if SERVER then
  util.AddNetworkString("CreateLSDDealer")
  util.AddNetworkString("SendLSDDealerInfo")
  util.AddNetworkString("CallLSDDealer")
  util.AddNetworkString("DoLSDDealerDeliver")
end


function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" and Caller:IsPlayer() then
		net.Start("CallLSDDealer")
		net.Send(Caller)
	end
end

ENT.Notified = false

local lns = {"You're ready for the party?",
"Do you need more energy?",
"Don't you wish to see the truth?",
"Come here and enjoy my intelligence",
"Do you wanna fly high?"}
//76561198166995702
function ENT:GetPlayerColor()
  if(!self.Notified) then
    if(LocalPlayer():GetPos():Distance(self:GetPos()) < 1024)  then
      self.TR = util.TraceLine( {
	      start = self:EyePos(),
      endpos = LocalPlayer():EyePos() + (self:EyePos()-LocalPlayer():EyePos())*-0.4,
	     filter = self
     } )
      if(self.TR.Entity == LocalPlayer()) then
        chat.AddText(Color(200, 89, 220),"[LSD] ",Color(235,235,235),lns[math.random(1,#lns)])
        self.Notified = true
        self.TR = nil
      end
    end
  end
	return Vector(1,1,1)
end

concommand.Add("create_lsd_dealer",function(ply)
	if(ply:IsAdmin()) then
		chat.AddText(Color(100,235,50),"[LSD]",Color(235,235,235)," Dealer created!")
		net.Start("CreateLSDDealer")
		net.SendToServer()
	else
		chat.AddText(Color(235,100,50),"[LSD]",Color(235,235,235)," You can't create a dealer")
	end
end)

net.Receive("CreateLSDDealer",function(l,ply)
	if(ply:IsAdmin()) then
		local tbl = {}
		if(file.Exists(game.GetMap().."_lsd.txt","DATA")) then
			tbl = util.JSONToTable(file.Read(game.GetMap().."_lsd.txt","DATA"))
		end
		table.insert(tbl,{ply:GetPos(),ply:GetAngles().y})
		file.Write(game.GetMap().."_lsd.txt",util.TableToJSON(tbl,true))
    	//DarkRP.notify(ply, 3, 3, "Dealer created, check console for instructions!")
    	net.Start("SendDealerInfo")
    	net.Send(ply)
	end
end)

net.Receive("SendDealerInfo",function()
  MsgN("Copy data/"..(game.GetMap().."_lsd.txt").." file into your server once you placed all dealers!")
end)

hook.Add("InitPostEntity","CreateLSDDealers",function()

	if CLIENT then return end

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

if CLIENT then

local pnl

local rpl = {"I have no time for this!",
"Can you stay away?",
"Get away dude",
"Take it easy, i'm not doing nothing bad",
"Move the FUCK UP!"}

net.Receive("CallLSDDealer",function(l,ply)
	local a,b = table.Random(rpl)
  	if(!LSD:CanPurchase(LocalPlayer())) then
    	chat.AddText(Color(155, 89, 182),"[LSD] ",Color(235,235,235),a)
    	return
  	end

	if(pnl != nil) then
		pnl:Remove()
		pnl = nil
	end
	pnl = vgui.Create("gLSDDealer")
	pnl:MakePopup()

end)

end
