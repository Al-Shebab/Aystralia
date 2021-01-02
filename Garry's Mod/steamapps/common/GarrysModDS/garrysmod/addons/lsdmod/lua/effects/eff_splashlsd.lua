
local puffs = {"001","067","133","199","265","331"}

EFFECT.nFlash = 0

function EFFECT:Think()

	for k=0, 32 do
		local beat = self.Emitter:Add("particle/particle_ring_wave_8", self.ent:GetPos() + Vector(0,0,24) + VectorRand()*8)
		if (beat) then
			beat:SetLifeTime(0)
			beat:SetDieTime(5)
			beat:SetStartAlpha(50)
			beat:SetEndAlpha(0)
			beat:SetStartSize(1)
			beat:SetCollide(true)
			beat:SetEndSize(8)
			beat:SetGravity(Vector(0,0,-120))
			beat:SetColor(100,255,255)

			local a = math.rad( ( k / 16 ) * -360 )
			beat:SetVelocity(VectorRand()*96)
			beat:SetAngles(Angle(math.random(360),math.random(360),0))
		end
	end

	return false
end

function EFFECT:Render()
end
