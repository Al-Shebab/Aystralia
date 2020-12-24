
local puffs = {"001","067","133","199","265","331"}

function EFFECT:Init(data)
	self.ent = data:GetEntity()
	if(IsValid(self.ent)) then
		self.Emitter = ParticleEmitter( self.ent:GetPos() )
	end
end

EFFECT.nFlash = 0

function EFFECT:Think()


	if(IsValid(self.ent) && !self.ent.DispatchEffect ) then

		if(self.nFlash < CurTime()) then
			self.nFlash = CurTime() + 0.5 - (self.ent:GetProgress()/100)*0.4
			for k=0, (self.ent:GetProgress()/100)*16 do
				local beat = self.Emitter:Add(string.format("particle/smokesprites_00%02d",math.random(7,16)), self.ent:GetPos() + Vector(0,0,24))
				if (beat) then
					beat:SetLifeTime(0)
					beat:SetDieTime(1)
					beat:SetStartAlpha(50)
					beat:SetEndAlpha(0)
					beat:SetStartSize(2)
					beat:SetEndSize(16*(self.ent:GetProgress()/100))
					beat:SetGravity(Vector(0,0,46))
					beat:SetColor(255,255,255)

					local a = math.rad( ( k / 16 ) * -360 )
					beat:SetVelocity(VectorRand()*16 + Vector(0,0,50))
					beat:SetAngles(Angle(math.random(360),math.random(360),0))
				end
			end
		end
		return true
	end

	return false
end

function EFFECT:Render()
end
