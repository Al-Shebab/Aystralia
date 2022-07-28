--[[
    MGangs 2 - (SH) VGUI ELEMENT - Circle image & HTTP Image
    Developed by Zephruz
]]

--[[------------------
	Circular Image
---------------------]]
local CIRCLEIMG = {}

function CIRCLEIMG:Init()
	self.Image = vgui.Create("DImage", self)
	self.Image:SetPaintedManually(true)
	self.material = Material( "effects/flashlight001" )
	
	self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function CIRCLEIMG:PerformLayout(w,h)
	self:OnSizeChanged(w,h)
end

function CIRCLEIMG:SetImage(...)
	self.Image:SetImage(...)
end

function CIRCLEIMG:SetMaterial(...)
	self.Image:SetMaterial(..., "noclamp smooth")
end

function CIRCLEIMG:OnSizeChanged(w,h)
	self.Image:SetSize(self:GetWide(), self:GetTall())
	self.points = math.Max((self:GetWide()/4), 96)
	self.poly = draw.CirclePoly(self:GetWide()/2, self:GetTall()/2, self:GetWide()/2, self.points)
end

function CIRCLEIMG:DrawMask(w,h)
	draw.NoTexture()
	surface.SetMaterial(self.material)
	surface.SetDrawColor(color_white)
	surface.DrawPoly(self.poly)
end

function CIRCLEIMG:Paint(w,h)
	draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )

	self:DrawMask(w, h)

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	self.Image:SetPaintedManually(false)
	self.Image:PaintManual()
	self.Image:SetPaintedManually(true)

	render.SetStencilEnable(false)
	render.ClearStencil()
end

vgui.Register("mg2.CircularImage", CIRCLEIMG, "DImage")

--[[-----------------------
	HTTP/URL Material Image
--------------------------]]
local function validateHTTPURL(url)
	-- Check if it's a secure connection (we can't use this)
	if (url:StartWith("https")) then
		url = url:Replace("https", "http")
	end
	
	return url
end

local HTTPIMG = {}

function HTTPIMG:Init()
	local DHTMLImg = vgui.Create("DHTML", self)
	DHTMLImg:SetSize(self:GetSize())
	DHTMLImg:SetAlpha(0)
	DHTMLImg:SetMouseInputEnabled(false)
	DHTMLImg.LoadImageMat = function(s)
		return self:LoadMaterial()
	end

	DHTMLImg.Think = function(s)
		if (s:GetHTMLMaterial() && !s.ImageMatLoaded) then
			s.ImageMatLoaded = s:LoadImageMat()
		end
	end

	self.DHTMLImg = DHTMLImg
end

function HTTPIMG:GetMaterialPrefix() 
	return self._materialPrefix 
end

function HTTPIMG:SetMaterialPrefix(pfx)
	self._materialPrefix = string.gsub(pfx, "[^0-9a-zA-Z]+", "")
	self:LoadMaterial()
end

function HTTPIMG:LoadMaterial()
	local matData
	local matPfx = self:GetMaterialPrefix()
	local htmlMat = self.DHTMLImg:GetHTMLMaterial()

	matPfx = (matPfx || (htmlMat && htmlMat:GetName()))

	if !(matPfx) then return end
	if (htmlMat) then
		local sX, sY = math.Round(self:GetWide() / htmlMat:Width(), 3), math.Round(self:GetTall() / htmlMat:Height(), 3)

		matData = {
			["$basetexture"] = htmlMat:GetName(),
			["$basetexturetransform"] = "center 0 0 scale " .. sX .. " " .. sY .. " rotate 0 translate 0 0",
			["$model"] = 1,
			["$alphatest"] = 1,
			["$nocull"] = 1,
			["$noclamp"] = 1,
			["$smooth"] = 1
		}
	end

	-- Current mat
	local matName = "mg2_material_" .. matPfx
	
	local mat = Material("!" .. matName)

	if (mat:IsError()) then
		if !(matData) then return end

		mat = CreateMaterial(matName, "UnlitGeneric", matData)
	else
		if (matData) then
			mat:SetTexture("$basetexture", matData["$basetexture"])
		end
	end

	self:SetMaterial(mat)

	return true
end

function HTTPIMG:SetURL(url)
	self.url = validateHTTPURL(url)

	local sW, sH = self:GetSize()

	self.DHTMLImg:SetHTML([[
		<body style="overflow: hidden; margin: 0;">
			<img src="]] .. self.url .. [[" width=]] .. sW .. [[px height=]] .. sH .. [[px />
		</body>]])
	self.DHTMLImg.ImageMatLoaded = false
end

vgui.Register("mg2.HTMLImage", HTTPIMG, "mg2.CircularImage")


-- [[Draw Circle]]
function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )

	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	surface.DisableClipping( false )
	surface.DrawPoly( cir )
end

-- [[Draw Circle Poly func (for avatar)]]
function draw.CirclePoly( pos_x, pos_y, radius, ang_pts )
    local _u = ( pos_x + radius * 320 ) - pos_x
    local _v = ( pos_y + radius * 320 ) - pos_y

    local _slices = ( 2 * math.pi ) / ang_pts
    local _poly = { }

    for i = 0, ang_pts - 1 do
        local _angle = ( _slices * i ) % ang_pts
        local x = pos_x + radius * math.cos( _angle )
        local y = pos_y + radius * math.sin( _angle )
        table.insert( _poly, { x = x, y = y, u = _u, v = _v } )
    end

    return _poly
end