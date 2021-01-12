local PANEL = {}

function PANEL:Setup(vars)
    self.BaseClass.Setup(self, vars)

    local text = self:GetChildren()[1]
    text:SetNumeric(true)
    text.OnValueChange = function(text, new)
        if tonumber(new) then
		    self:ValueChanged(new)
        end
	end
end

derma.DefineControl("DProperty_Number", "", PANEL, "DProperty_Generic")
