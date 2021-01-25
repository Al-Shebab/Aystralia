module('mina', package.seeall)
local panelMeta = FindMetaTable('Panel')

function Linear(n)
	return n
end

function EaseIn(n)
	return math.pow(n, .48)
end

function EaseInOut(n)
	if n == 1 then return 1 end
	if n == 0 then return 0 end

	local  q = .48 - n / 1.04
	local Q = math.sqrt(.1734 + q * q)
	local x = Q - q
	local X = math.pow(math.abs(x), 1 / 3) * (x < 0 and -1 or 1)
	local y = -Q - q
	local Y = math.pow(math.abs(y), 1 / 3) * (y < 0 and -1 or 1)
	local t = X + Y + .5
	return (1 - t) * 3 * t * t + t * t * t
end

function BackIn(n)
	if n == 1 then return 1 end
	n = n - 1
	local  s = 1.70158
	return n * n * ((s + 1) * n + s) + 1
end

function BackOut(n)
	if n == 0 then return 0 end
	n = n - 1
	local  s = 1.70158
	return n * n * ((s + 1) * n + s) + 1
end

function Elastic(n)
	if n == 0 then return n end
	return math.pow(2, -10 * n) * math.sin((n - .075) *
			(2 * math.pi) / .3) + 1
end

function StepEnd(n)
	if n == 1 then return 1 end
	return 0
end

function Step2End(n)
	if n == 1 then return 1 end
	if n >= 0.5 then return 0.5 end

	return 0
end

function StepStart(n)
	if n == 0 then return 0 end
	return 1
end

function panelMeta:AnimationThinkInternal()
	local systime = SysTime()

	if self.Term and self.Term <= systime then self:Remove() return end
	if not self.m_AnimList then return end

	for k, anim in pairs(self.m_AnimList) do
		if systime >= anim.StartTime then	
			local Fraction = math.TimeFraction(anim.StartTime, anim.EndTime, systime)
			Fraction = math.Clamp(Fraction, 0, 1)
			
			if anim.Think then
				
				local Frac = 0
				if isnumber(anim.Ease) then
					if anim.Ease < 0 then
						Frac = Fraction ^ (1.0 - ((Fraction - 0.5)))
					else
						Frac = Fraction ^ anim.Ease
					end
				else
					Frac = anim.Ease(Fraction)
				end
			
				anim:Think(self, Frac)
			end
			
			if Fraction == 1 then
				if anim.OnEnd then anim:OnEnd(self) end	
				self.m_AnimList[k] = nil				
			end			
		end
	end	
end