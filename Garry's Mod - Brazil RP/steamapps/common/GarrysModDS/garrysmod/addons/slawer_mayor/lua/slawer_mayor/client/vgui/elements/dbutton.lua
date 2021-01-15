local PANEL = {}

AccessorFunc(PANEL, "m_colBackground", "BackgroundColor")
AccessorFunc(PANEL, "m_bNoDelay", "NoDelay", FORCE_BOOL)

function PANEL:Init()
	self:SetText("")

	self:SetBackgroundColor(Slawer.Mayor.Colors.Blue)
	self:SetFont("Slawer.Mayor:R20")

	self.intLerp = 0
	self.strText = ""

	self:SetNoDelay(false)

	self.Image = nil
	self.ImageColor = color_white
	self.ImageSize = 24

	function self:SetText(strText) self.strText = strText end
end

function PANEL:SetImageButton(mat, col, size)
	self.Image = mat or self.Image
	self.ImageColor = col or self.ImageColor
	self.ImageSize = size or self.ImageSize
end

function PANEL:OnMousePressed()
	if (self.intNextClick && self.intNextClick > CurTime()) && !self:GetNoDelay() then return end

	self.intNextClick = CurTime() + 0.5

	self:DoClick()
  surface.PlaySound( "buttons/button15.wav" )
end


function PANEL:Paint(intW, intH)
	self.intLerp = Lerp(RealFrameTime() * 5, self.intLerp, self.Hovered && 125 || 0)

	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(0, 0, intW, intH)
	
	surface.SetDrawColor(ColorAlpha(color_black, self.intLerp))
	surface.DrawRect(0, 0, intW, intH)

	if self.Image then
		surface.SetMaterial(self.Image)
		surface.SetDrawColor(self.ImageColor)
		surface.DrawTexturedRect(intW * 0.5 - self.ImageSize * 0.5, intH * 0.5 - self.ImageSize * 0.5, self.ImageSize, self.ImageSize)
	else
		draw.SimpleText(self.strText, self:GetFont(), intW * 0.5, intH * 0.5, self:GetTextColor(), 1, 1)
	end
end

vgui.Register("Slawer.Mayor:DButton", PANEL, "DButton")