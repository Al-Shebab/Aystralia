--[[
    MGangs 2 - (SH) VGUI ELEMENT - Slider
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.NUMSLIDER.SMALL", {
	font = "Abel",
	size = 18,
})

end

local PANEL = {}

function PANEL:Init() 
    self.theme = mg2.vgui:GetCurrentTheme()
end

function PANEL:PerformLayout()
	local lbl, slider, scratch, txtEntry = self.Label, self.Slider, self.Scratch, self.TextArea

	-- [[Text Area Layout]]
	txtEntry:SetTextColor(Color(255,255,255))

	-- [[Label Layout]]
	lbl:SetTextColor(Color(255,255,255))
	lbl:SetFont("mg2.NUMSLIDER.SMALL")
	lbl:SetContentAlignment(5)

	-- [[Slider Layout]]
	slider.Knob.Paint = function(s,w,h)
		local aCol, iCol = self.theme:GetColor("numSlider.Knob.Active"), self.theme:GetColor("numSlider.Knob.Inactive")

		draw.RoundedBoxEx(2, 0, 0, w, h, (s:IsHovered() && aCol || iCol))
	end
end

vgui.Register("mg2.NumSlider", PANEL, "DNumSlider")