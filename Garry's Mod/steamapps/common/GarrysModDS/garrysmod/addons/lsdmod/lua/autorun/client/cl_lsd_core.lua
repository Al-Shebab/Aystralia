
local var = true
local max = 0

local positions = {}
local nextFrame = 0
local maxCrosshair = 100
local fovIncrease = 1
local lsed = 0

net.Receive("RemoveLSDEffects",function()
  timer.Remove("UnderwaterSimulator")
end)

hook.Add("PostDrawTranslucentRenderables","DrawCrazySquare",function(ent)

  lsed = (LocalPlayer():GetLSD()/100)

  if(lsed > 0) then
    if(nextFrame < CurTime()) then
      nextFrame = CurTime() + (0.05)+(0.5-lsed*0.5)
      local tr = util.TraceLine( {
        start = EyePos(),
        endpos = EyePos() + LocalPlayer():GetAimVector()*9000 + LocalPlayer():GetRight()*math.random(-9182,9182) + LocalPlayer():GetUp()*math.random(-9182,9182),
        filter={LocalPlayer()}
      } )
      if(tr.HitWorld) then
        local mdecay = math.random(1,5)
        table.insert(positions,1,{pos=tr.HitPos,normal=tr.HitNormal,size=math.random(5,32),angle=math.random(0,360),decay=mdecay,life=mdecay})
        if(#positions > maxCrosshair) then
          table.remove(positions)
        end
      end
    end

    for k,v in pairs(positions) do
      local ang = v.normal:Angle()
      ang:RotateAroundAxis(ang:Right(),90)
      cam.Start3D2D(v.pos,ang,1)
        local col = HSVToColor((RealTime() * 96+v.angle) % 360, 1, 1)
        local rd = math.abs(math.sin(RealTime()*6)*v.decay)
        v.move = (v.move or 0) + 1
        surface.SetDrawColor(Color(col.r,col.g,col.b,lsed*(v.decay/v.life)*math.random(100,255)))
        surface.DrawTexturedRect(v.move,math.sin(math.rad(v.angle))*v.move,256*v.size,rd*v.size*16)
        v.decay = v.decay - FrameTime()*4*lsed
        if(v.decay < 0) then
          table.remove(positions,k)
        end
      cam.End3D2D()
    end
  end
end)

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.04,
	["$pp_colour_contrast"] = 1.35,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects","DrawLSDShits",function()
  if(lsed > 0) then
    tab["$pp_colour_addr"] = math.cos(RealTime()*2)*0.05*lsed
  	tab["$pp_colour_addg"] = math.sin(RealTime()*2)*0.2*lsed
  	tab["$pp_colour_addb"] = math.tan(RealTime()*2)*0.02*lsed
    DrawBloom( 0.65, 2, math.cos(RealTime()*5)*16*lsed, math.random(1,16)*lsed, 1, 1, tab["$pp_colour_addb"], tab["$pp_colour_addr"], tab["$pp_colour_addg"] )
  	DrawColorModify( tab ) --Draws Color Modify effect
    local amplitude = 1-lsed
  	DrawSobel( (0.95+(math.cos(RealTime()*2)*0.5*math.Clamp(lsed,0,1))+math.Clamp(amplitude*0.05,-0.05,0.05)))
    DrawMotionBlur( 0.1, 0.8, 0.01 )
  end
end)

hook.Add("CalcView","LSDView",function(ply,pos,ang,fov)
  if(lsed > 0) then
    local tbl = {}
    tbl.origin = pos
    tbl.angles = ang + Angle(math.cos(RealTime())*4*lsed,math.sin(RealTime())*3*lsed,0)

    if(ply:KeyDown(IN_FORWARD)) then
      if(ply:KeyDown(IN_MOVELEFT) || ply:KeyDown(IN_MOVERIGHT)) then
        fovIncrease = Lerp(FrameTime(),fovIncrease,1.1)
      else
        fovIncrease = Lerp(FrameTime(),fovIncrease,(ply:GetVelocity():Length()/ply:GetRunSpeed())*1.3)
      end
    else
      fovIncrease = Lerp(FrameTime(),fovIncrease,1)
    end

    tbl.fov = fov*fovIncrease
    return tbl
  end
end)
