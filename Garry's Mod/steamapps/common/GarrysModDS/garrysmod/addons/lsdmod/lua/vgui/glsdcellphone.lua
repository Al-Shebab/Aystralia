local PANEL = {}

surface.CreateFont( "LSD_Buttons", {
  font = "Karmatic Arcade",
  size = 42,
  weight = 200
} )

surface.CreateFont( "LSDDealerText", {
  font = "VCR OSD Mono",
  size = 32,
  shadow = true,
  weight = 300
} )

function PANEL:Init()
  self._Start = SysTime()
  self:SetSize(ScrW()*0.75,ScrH())
  self:SetPos(0,0)
  self:MakePopup()
  self.mdl = ClientsideModel("models/gonzo/cellphone.mdl")
  self.mdl:SetIK( false )
  self.mdl:ResetSequence("open")
  self.mdl:SetPlaybackRate(1)
  self.mdl:SetSequence("open")

  self.Store = vgui.Create("DModelPanel",self)
  self.Store:SetModel(LSD_STORE.Items[1].model)
  self.Store:SetPos(0,20)
  self.Store:SetSize(ScrW()*0.75,ScrH()-20)
  self.Store:SetMouseInputEnabled(false)

  self.Next = vgui.Create("DButton",self)
  self.Next:SetSize(148,96)
  self.Next:SetText("Next")
  self.Next:SetTextColor(Color(100,255,100))
  self.Next:SetFont("LSD_Buttons")
  self.Next:SetPos(ScrW()*0.75-196,ScrH()/2-48)
  self.Next.DoClick = function(s) self:ChangePosition(1) surface.PlaySound("garrysmod/ui_click.wav") end
  self.Next.Paint = function() end

  self.Back = vgui.Create("DButton",self)
  self.Back:SetSize(148,96)
  self.Back:SetText("Back")
  self.Back:SetTextColor(Color(255,150,50))
  self.Back:SetFont("LSD_Buttons")
  self.Back:SetPos(48,ScrH()/2-48)
  self.Back.DoClick = function(s) self:ChangePosition(-1) surface.PlaySound("garrysmod/ui_click.wav") end
  self.Back.Paint = function() end

  self.Buy = vgui.Create("DButton",self)
  self.Buy:SetSize(512,96)
  self.Buy:SetText("Buy "..math.Round(LSD_STORE.Items[1].price*(LSD.Config.PriceRankMultiplier[LocalPlayer():GetUserGroup()] or 1)).." coins")
  self.Buy:SetTextColor(Color(255,255,255))
  self.Buy:SetFont("LSD_Buttons")
  self.Buy:SetPos(ScrW()*0.75/2-512/2,ScrH()-124)
  self.Buy.DoClick = function(s)
    surface.PlaySound("garrysmod/save_load"..math.random(1,4)..".wav")
    net.Start("StartLSDPurchase")
    net.WriteInt(self.Selection,8)
    net.SendToServer()
    self:Remove()
  end
  self.Buy.Paint = function() end

  self.Cl = vgui.Create("DButton",self)
  self.Cl:SetSize(96,96)
  self.Cl:SetText("X")
  self.Cl:SetTextColor(Color(255,50,50))
  self.Cl:SetFont("LSD_Buttons")
  self.Cl:SetPos(ScrW()*0.75-96,0)
  self.Cl.DoClick = function(s) self:Remove() surface.PlaySound("garrysmod/ui_return.wav") end
  self.Cl.Paint = function() end

  self:ChangePosition(0)
  self:SetTitle("")
  self:ShowCloseButton(false)
  self:SetDraggable(false)
end

if CELLPHONE then
  CELLPHONE:Remove()
end

function PANEL:OnRemove()
  self.mdl:Remove()
end

PANEL.Selection = 1

function PANEL:ChangePosition(i)
  self.Selection = self.Selection+i
  if(self.Selection < 1) then
    self.Selection = #LSD_STORE.Items
  elseif(self.Selection > #LSD_STORE.Items) then
    self.Selection = 1
  end
  self.Store:SetModel(LSD_STORE.Items[self.Selection].model)
  self.Store.Entity:SetMaterial("models/wireframe")
  self.Store:SetColor(LSD_STORE.Items[self.Selection].color)
  local tab = PositionSpawnIcon(self.Store.Entity,Vector(0,0,0))
	if ( tab ) then
		self.Store:SetCamPos( tab.origin - (LSD_STORE.Items[self.Selection].override or Vector(0,0,0)))
		self.Store:SetFOV( tab.fov + 4 )
		self.Store:SetLookAng( tab.angles )
	end
  self.Buy:SetText("Buy "..math.Round(LSD_STORE.Items[self.Selection].price*(LSD.Config.PriceRankMultiplier[LocalPlayer():GetUserGroup()] or 1)).." coins")
end

surface.CreateFont( "LSD_Header", {
  font = "Karmatic Arcade",
  size = 96,
  weight = 200
} )

local att
local drw = false
function PANEL:Paint(w,h)
  Derma_DrawBackgroundBlur(self,self._Start or SysTime())
  cam.Start3D( Vector(10,-40,7), Angle(0,130,0), 70 )
  	render.SuppressEngineLighting( true )
  	render.SetLightingOrigin( self.mdl:GetPos() )
  	self.mdl:DrawModel()
    self.mdl:FrameAdvance(FrameTime())
	   render.SuppressEngineLighting( false )
	cam.End3D()
  local clr = LSD_STORE.Items[self.Selection].color
  draw.SimpleTextDegree(LSD_STORE.Items[self.Selection].name,"LSD_Header",w/2,64,LSD_STORE.Items[self.Selection].color,Color(clr.r*0.7,clr.g*0.7,clr.b*0.7),0.5,TEXT_ALIGN_CENTER)
end

local drx,dry
local dx,dy

//Example
//draw.SimpleTextDegree("Little buster","MRPHUD_Huge",ScrW()/2,108,Color(235,235,235),Color(150,150,150),0.7,1)
function draw.SimpleTextDegree(text,font,x,y,top,bottom,percent,alignx,aligny)
    aligny = aligny or 3
    drx,dry=draw.SimpleText(text,font,x,y,bottom,alignx,aligny)
    dx = x-(alignx==0 && 0 || alignx==1 && drx/2 || drx)
    dy = y-(aligny==3 && 0 || aligny==1 && dry/2 || dry)
    render.SetScissorRect( dx, dy, dx+drx, dy+dry*percent, true )
        draw.SimpleText(text,font,x,y,top,alignx,aligny)
    render.SetScissorRect( 0,0,0,0, false )
end

derma.DefineControl("DLSDCellphone","DLSDCellphone",PANEL,"DFrame")

net.Receive("CallLSDDialerMenu",function()
  if(CELLPHONE) then
    CELLPHONE:Remove()
  end
  CELLPHONE = vgui.Create("DLSDCellphone")
end)
