local PANEL = {}
PANEL.Start = 0
PANEL.State = 0
PANEL.DrawText = ""

local percent = 0
local states = {"How can I help you Mr?","Touch me with LSD and I'll buy it"}
local nextState = 0
local doState = 1
local nDraw = 0

function PANEL:Init()

    percent = 0

    self.Start = SysTime()
    self:SetSize(ScrW(),ScrH())
    self:Center()

    self.State = 0
    self.DrawText = ""
    doState = 1
    nDraw = CurTime() + 0.5

    timer.Simple(0.5,function()
        if(IsValid(self)) then
            self.State = 1
            self.DrawText = ""
            doState = 1
            nDraw = CurTime() + 0.5
        end
    end)

    self.Model = vgui.Create("DModelPanel",self)
    self.Model:SetModel("models/player/magnusson.mdl")
    self.Model:SetSize(ScrW()*0.3,ScrH())
    self.Model.LayoutEntity = function(s,ent)
        ent.GetPlayerColor = function() return Vector(1,1,1) end
        ent:SetFlexWeight(42,1)
        return
    end


    local eyepos = self.Model.Entity:GetBonePosition( self.Model.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
    eyepos:Add( Vector( 0, 0, 2 ) )	-- Move up slightly
    self.Model:SetLookAt( eyepos )
    self.Model.Entity:SetEyeTarget(Vector(0,- 10,75))
    self.Model:SetCamPos( eyepos-Vector( -12, 4, 0 ) )	-- Move cam in front of eyes

    self.Exit = vgui.Create("DButton",self)
    self.Exit:SetSize(128,48)
    self.Exit:SetPos(ScrW()-128-24,ScrH()-48-24)
    self.Exit:SetText("")
    self.Exit.DoClick = function() self:Remove() end
    self.Exit.Paint = function(s,w,h)
        surface.SetDrawColor(Color(96, 0, 150))
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(Color(64, 0, 128))
        surface.DrawRect(8,8,w-16,h-16)

        draw.SimpleText("EXIT","LSDDealerText",w/2+1,h/2+1,Color(35,35,35),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText("EXIT","LSDDealerText",w/2,h/2,Color(235,235,235),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        if(s:IsHovered()) then
            surface.SetDrawColor(Color(255, 255,255, 2))
            surface.DrawRect(0,0,w,h)
        end
    end

    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self:SetTitle("")

end

local rope = surface.GetTextureID("ggui/lsd/lines")
local boddy = surface.GetTextureID("ggui/lsd/menu_degree")


function PANEL:Paint(w,h)

    Derma_DrawBackgroundBlur( self, self.Start )

    percent = Lerp(FrameTime()*3,percent,w-w*0.1+48)

    surface.SetDrawColor(Color(235,235,235,255))
    surface.SetTexture(boddy)
    surface.DrawTexturedRect(w*0.1,h-256,percent-52,256)

    surface.SetDrawColor(Color(128, 64, 196))
    surface.DrawRect(percent+104,h-256,16,256)

    self.Exit:SetPos(percent-64,ScrH()-48-24)

    surface.SetTexture(rope)
    surface.SetDrawColor(235,235,235,255)
    surface.DrawTexturedRectUV(w*0.1,h-286,percent-42,64,0,0,w/128,1)

    if(true) then
        if(states[doState] != self.DrawText && nDraw <= CurTime()) then
            nDraw = CurTime() + 0.01
            self.DrawText = self.DrawText..states[doState][#self.DrawText+1]
        end
        if(states[1] == self.DrawText && self.State != 2) then
            self.State = 2
            self:CreateButtons()
        end
        if(nextState == 0) then
          self.DrawText = ""
          nextState = CurTime() + 3
          doState = 1
        end
        if(nextState < CurTime()) then
          self.DrawText = ""
          doState = doState == 1 and 2 or 1
          nDraw = CurTime() + 0.01
          nextState = CurTime() + 3
        end
    end

    draw.SimpleText(self.DrawText,"LSDDealerText",w*0.3+32+1,h-210+1,Color(35,35,35))
    draw.SimpleText(self.DrawText,"LSDDealerText",w*0.3+32,h-210,Color(235,100,235))
end

function PANEL:CreateButtons()
    local w,h = ScrW(),ScrH()
    self.Purchase = {}

    if(true) then
        self.Purchase[1] = vgui.Create("DButton",self)
        self.Purchase[1]:SetSize(w-w*0.3-64,44)
        self.Purchase[1]:SetPos(w*0.3+32,h-216+48)
        self.Purchase[1]:SetText("")
        self.Purchase[1].Text = "Purchase a cellphone ($"..LSD.Config.PhonePrice..")"
        self.Purchase[1].Paint = self.PaintButton
        self.Purchase[1].Price = LSD.Config.PhonePrice
        self.Purchase[1].DoClick = function()
            if(LocalPlayer():getDarkRPVar("money",0)>=LSD.Config.PhonePrice) then
                net.Start("DoLSDDealerDeliver")
                net.WriteBool(false)
                net.SendToServer()
                self:Remove()
            end
        end
    end

    if(true) then
        self.Purchase[2] = vgui.Create("DButton",self)
        self.Purchase[2]:SetSize(w-w*0.3-64,44)
        self.Purchase[2]:SetPos(w*0.3+32,h-216+48+48)
        self.Purchase[2]:SetText("")
        self.Purchase[2].Text = "Purchase LSD x4 ($"..LSD.Config.Price..")"
        self.Purchase[2].Paint = self.PaintButton
        self.Purchase[2].Disabled = !LSD.Config.AllowPurchase
        //76561198166995690
        self.Purchase[2].Price = LSD.Config.Price
        self.Purchase[2].DoClick = function()
            if(LSD.Config.AllowPurchase && LocalPlayer():getDarkRPVar("money",0)>=LSD.Config.Price) then
                net.Start("DoLSDDealerDeliver")
                net.WriteBool(true)
                net.SendToServer()
                self:Remove()
            end
        end
    end

    self.Purchase[3] = vgui.Create("DButton",self)
    self.Purchase[3]:SetSize(w*0.54,44)
    self.Purchase[3]:SetPos(w*0.3+32,h-216+48+96)
    self.Purchase[3]:SetText("")
    self.Purchase[3].Text = "Watch Tutorial"
    self.Purchase[3].Price = 50
    self.Purchase[3].Paint = self.PaintButton
    self.Purchase[3].DoClick = function()
        self:Remove()
        notification.AddLegacy( "Touch the dealer with your LSD", NOTIFY_HINT, 5 )
        gui.OpenURL("https://www.youtube.com/watch?v=wHqhwNFY4BQ")
    end
end

function PANEL:PaintButton(w,h)
  if(self:IsHovered()) then
      surface.SetDrawColor(Color(255, 255,255, 25))
      surface.DrawRect(0,0,w,h)
  end
    draw.SimpleText(self.Text,"LSDDealerText",9,h/2+1,Color(35,35,35),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    if(!(self.Disabled or false)) then
      draw.SimpleText(self.Text,"LSDDealerText",8,h/2,LocalPlayer():getDarkRPVar("money",0)>=self.Price && Color(235,235,235) || Color(235,75,75),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    else
      draw.SimpleText(self.Text,"LSDDealerText",8,h/2,Color(75,75,75),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end
end

derma.DefineControl("gLSDDealer","gLSDDealer",PANEL,"DFrame")
