include('shared.lua')

function ENT:Draw()
	if _PArmory then
		if _PArmory.ENTDraw then
			return _PArmory.ENTDraw(self)
		end
	end
end