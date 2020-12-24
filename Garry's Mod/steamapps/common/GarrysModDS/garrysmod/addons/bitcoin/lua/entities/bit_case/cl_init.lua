include("shared.lua")

function ENT:Initialize()
end

surface.CreateFont( "BitCoinFont", {
	font = "TargetID", 
	size = 15,
	weight = 500,
	antialias = true
} )

surface.CreateFont( "BitCoinFont2", {
	font = "TargetID", 
	size = 8,
	weight = 499,
	antialias = false
} )

local load1 = Material("materials/bit/load1.png")	
local load2 = Material("materials/bit/load2.png")	
local load3 = Material("materials/bit/load3.png")
local load4 = Material("materials/bit/load4.png")
local load5 = Material("materials/bit/load5.png")
local load6 = Material("materials/bit/window1.png")
local load7 = Material("materials/bit/window2.png")
local load8 = Material("materials/bit/window3.png")

function ENT:Draw()

	self:DrawModel()
	
	if self:GetPos():Distance(EyePos()) > 400 then return end
	
	local ang = self:GetAngles()
	local pos = self:GetPos()
	local spin = CurTime() * 180
	
	ang:RotateAroundAxis(self:GetAngles():Up(), 450)
	ang:RotateAroundAxis(self:GetAngles():Right(), 274)
	ang:RotateAroundAxis(self:GetAngles():Up(), 360)
	
	cam.Start3D2D(pos + ang:Up() * 12.65, ang, 0.11)	
	
		
	if (self:GetCornet()) then
	
		if (self:GetLoad() == 1) then
		
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load1 )
			surface.DrawTexturedRect( -88,-100,177,145 )	
		
		elseif (self:GetLoad() == 2) then
	
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load2 )
			surface.DrawTexturedRect( -88,-100,177,145 )	
		
		elseif (self:GetLoad() == 3) then		
		
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load3 )
			surface.DrawTexturedRect( -88,-100,177,145 )	
		
		elseif (self:GetLoad() == 4) then	
		
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load4 )
			surface.DrawTexturedRect( -88,-100,177,145 )		
		
		elseif (self:GetLoad() == 5) then	
		
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load5 )
			surface.DrawTexturedRect( -88,-100,177,145 )	
		
			draw.SimpleText("Bitcoins collected: "..self:GetBitCoin(), "BitCoinFont", -70,-90, Color(255,255,255),0,1) 
			draw.SimpleText("GB Used: "..self:GetGBused().."/"..self:GetHarddisk(), "BitCoinFont", -70,-70, Color(255,255,255),0,1) 
			draw.SimpleText("Power Output: "..self:GetPowerSupply().."W", "BitCoinFont", -70,-50, Color(255,255,255),0,1) 	
			draw.SimpleText("Power Usage: "..self:GetReqPowerSupply().."W", "BitCoinFont", -70,-30, Color(255,255,255),0,1) 
			draw.SimpleText("Ram: "..self:GetRam().."GB", "BitCoinFont", -70,-10, Color(255,255,255),0,1)		
			draw.SimpleText("GPU: "..self:GetGraphiccard().."* Amd 240x", "BitCoinFont", -70,10, Color(255,255,255),0,1)	
			draw.SimpleText("CPU: Intel Celeron 2.4GHz", "BitCoinFont", -70,30, Color(255,255,255),0,1)
		
		else	
			local whitecolor, whiteleft = Color(255,255,255), -67
			
			draw.RoundedBox(0,-88,-100,177,145,Color(0,0,0))
			draw.SimpleText("Insert parts & press E.: ", "BitCoinFont", whiteleft,-86, whitecolor,0,1) 
			
			if (self:GetGraphiccard() == 0) then
				draw.SimpleText("Insert GPU: ", "BitCoinFont", whiteleft,-66, whitecolor,0,1)
			end
			
			if !(self:GetCPU()) then
				draw.SimpleText("Insert CPU: ", "BitCoinFont", whiteleft,-56, whitecolor,0,1)	
			end
			
			if (self:GetRam() == 0) then			
				draw.SimpleText("Insert RAM: ", "BitCoinFont", whiteleft,-46, whitecolor,0,1)
			end
			
			if (self:GetPowerSupply() == 0) then
				draw.SimpleText("Insert PSU: ", "BitCoinFont", whiteleft,-36, whitecolor,0,1)		
			end
			
			if !(self:GetMotherboard()) then
				draw.SimpleText("Insert MOBO: ", "BitCoinFont", whiteleft,-26, whitecolor,0,1)
			end
			
			if (self:GetHarddisk() == 0) then
				draw.SimpleText("Insert HARDDISK: ", "BitCoinFont", whiteleft,-16, whitecolor,0,1)	
			end
			
		end
		
	elseif (self:GetWindow()) then
	
		if (self:GetLoad() > 0 and self:GetLoad() <= 3) then
		
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load6 )
			surface.DrawTexturedRect( -88,-100,177,145 )
			
		elseif (self:GetLoad() == 4) then
		
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load7 )
			surface.DrawTexturedRect( -88,-100,177,145 )
			
		elseif (self:GetLoad() == 5) then
		
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( load8 )
			surface.DrawTexturedRect( -88,-100,177,145 )
			
			draw.SimpleText("Bitcoins collected: "..self:GetBitCoin(), "BitCoinFont2", -6,-73, Color(0,0,0),0,1) 
			draw.SimpleText("GB Used: "..self:GetGBused().."/"..self:GetHarddisk(), "BitCoinFont2", -6,-63, Color(0,0,0),0,1) 
			draw.SimpleText("Power Output: "..self:GetPowerSupply().."W", "BitCoinFont2", -6,-53, Color(0,0,0),0,1) 	
			draw.SimpleText("Power Usage: "..self:GetReqPowerSupply().."W", "BitCoinFont2", -6,-43, Color(0,0,0),0,1) 
			draw.SimpleText("Ram: "..self:GetRam().."GB", "BitCoinFont2", -6,-33, Color(0,0,0),0,1)		
			draw.SimpleText("GPU: "..self:GetGraphiccard().."* Amd 240x", "BitCoinFont2", -6,-23, Color(0,0,0),0,1)	
			draw.SimpleText("CPU: Celeron 2.4GHz", "BitCoinFont2", -6,-13, Color(0,0,0),0,1)
			
		else
		
			local whitecolor, whiteleft = Color(255,255,255), -67
			
			draw.RoundedBox(0,-88,-100,177,145,Color(0,0,0))
			draw.SimpleText("Insert parts & press E.: ", "BitCoinFont", whiteleft,-86, whitecolor,0,1) 
			
			if (self:GetGraphiccard() == 0) then
				draw.SimpleText("Insert GPU: ", "BitCoinFont", whiteleft,-66, whitecolor,0,1)
			end
			
			if !(self:GetCPU()) then
				draw.SimpleText("Insert CPU: ", "BitCoinFont", whiteleft,-56, whitecolor,0,1)	
			end
			
			if (self:GetRam() == 0) then			
				draw.SimpleText("Insert RAM: ", "BitCoinFont", whiteleft,-46, whitecolor,0,1)
			end
			
			if (self:GetPowerSupply() == 0) then
				draw.SimpleText("Insert PSU: ", "BitCoinFont", whiteleft,-36, whitecolor,0,1)		
			end
			
			if !(self:GetMotherboard()) then
				draw.SimpleText("Insert MOBO: ", "BitCoinFont", whiteleft,-26, whitecolor,0,1)
			end
			
			if (self:GetHarddisk() == 0) then
				draw.SimpleText("Insert HARDDISK: ", "BitCoinFont", whiteleft,-16, whitecolor,0,1)	
			end 
			
		end		
	end
		
	cam.End3D2D()	
end		

