emenu.util = emenu.util or {}

--coefficient
emenu.xcoef = 1920 / ScrW()
emenu.ycoef = 1080 / ScrH()
emenu.ixcoef = ScrW() / 1920
emenu.iycoef = ScrH() / 1080



-------------------------
/// TEXT AND LANGUAGE ///
-------------------------
emenu.text = emenu.text or {}
local lang = emenu.config.language
local langs = emenu.langs


--Integrity check.
for st,phrase in pairs(langs["english"]) do
	for k,v in pairs(langs) do
		if k ~= "english" then
			if not v[st] then v[st] = phrase end
		end
	end
end

emenu.text = langs[lang] or langs["english"]

-- TEXT FUNCTIONS
emenu.text.capitalize = function(str)
	return str:gsub("^%l", string.upper)
end
emenu.text.capitalizeall = function(str)
	function titleCase( first, rest ) return first:upper()..rest:lower() end
	return string.gsub(str, "(%a)([%w_']*)", titleCase)
end
emenu.text.spacecase = function(str)
	local newstr = ""
	for _,v in ipairs(string.ToTable( str )) do
		newstr = newstr..v.." "
	end
	return newstr
end



-------------
/// UTILS ///
-------------
function emenu.util:CreateSequencedTable(tab,order)
	local tab = table.Copy(tab)
	local newtab = {}
	
	if istable(order) then
		for k,v in ipairs(order) do
			if tab[v] ~= nil then
				table.insert(newtab,#newtab+1,v)
				tab[v] = nil
			end
		end

		for k,v in pairs(tab) do
			table.insert(newtab,k)
		end
	else
		newtab = table.GetKeys(tab)
	end

	return newtab
end

function emenu.util.sortAssoc(tbl, sort)
    local keys = table.GetKeys(tbl)

    table.sort(keys, function(a, b)
        return sort(tbl[a], tbl[b], a, b)
    end)

    return keys
end


local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        if totalWidth >= remainingWidth then
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

-- https://github.com/FPtje/DarkRP/blob/8c0035710adefa47c1dbffc9ae65461f66ae73f4/gamemode/modules/base/cl_util.lua
function emenu.util.TextWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", 
    	function(word)
	        local char = string.sub(word, 1, 1)
	        if char == "\n" or char == "\t" then
	            totalWidth = 0
	        end

	        local wordlen = surface.GetTextSize(word)
	        totalWidth = totalWidth + wordlen

	        if wordlen >= maxWidth then
	            local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
	            totalWidth = splitPoint
	            return splitWord
	        elseif totalWidth < maxWidth then
	            return word
	        end

	        if char == ' ' then
	            totalWidth = wordlen - spaceWidth
	            return '\n' .. string.sub(word, 2)
	        end

	        totalWidth = wordlen
	        return '\n' .. word
	    end)

    return text
end

function emenu.util.GetTextSize(txt,font)
	surface.SetFont(font)
	local x, y = surface.GetTextSize(txt)
	return {w = x, h = y}
end

function emenu.util.TextColMustDark(bgCol)
	return ((bgCol.r + bgCol.g + bgCol.b) / 3 >= 127)
end

function emenu.util:GenCircle(x,y,r,v)
	local circle = {}
	local v = v or 360 -- poly count
    local angle = -math.rad(0) -- start angle
    local esin, ecos = math.sin(angle), math.cos(angle)
    for i = 0, 360, 360 / v do
        local newang = math.rad(i)
        local newsin, newcos = math.sin(newang), math.cos(newang)

        local oldcos = newcos * r * ecos - newsin * r * esin + x
        newsin = newcos * r * esin + newsin * r * ecos + y
        newcos = oldcos

        circle[#circle + 1] = {x = newcos,y = newsin}
    end
    return circle
end

--DRAW
function emenu.util:DrawPolyCircle( x, y, r, col, v)
	local circle = self:GenCircle(x,y,r, v or 360)

	if circle and #circle > 0 then
		surface.SetDrawColor(col:Unpack())
		draw.NoTexture()
		surface.DrawPoly(circle)
	end
end

function emenu.util:DrawCircle(x,y,r,col)
	x = x - r
	y = y - r
	col = col or emenu.colors.default.white

	surface.SetDrawColor(col:Unpack())
	surface.SetMaterial(emenu.Materials["circle"])
	surface.DrawTexturedRect(x, y, r*2, r*2)
end

function emenu.util:Mask(func, drawfunc, inverse, reference)
	if not reference then reference = 1 end

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(inverse and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(reference)

	func()

	if inverse then reference = reference - 1 end
	render.SetStencilFailOperation(inverse and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(reference)

	drawfunc()

	render.SetStencilEnable(false)
	render.ClearStencil()
end

function emenu.util:DrawShadowText(text,font,posx,posy,color,textax,textay,offset,color2)
	local textax = textax or TEXT_ALIGN_LEFT
	local textay = textay or TEXT_ALIGN_TOP
	local offset = offset or 1
	local color2 = color2 or emenu.colors.text.shadow
	draw.SimpleText(text,font,posx+offset,posy+offset,color2,textax,textay)
	draw.SimpleText(text,font,posx,posy,color,textax,textay)
end

function emenu.util:DrawMaterial(x,y,w,h,col,mat)
	col = col or color_white
	surface.SetDrawColor(col:Unpack())
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x,y,w,h)
end

function emenu.util:DrawMaterialRotated(x,y,w,h,r,col,mat)
	col = col or color_white
	surface.SetDrawColor(col:Unpack())
    surface.SetMaterial(mat)
    surface.DrawTexturedRectRotated(x,y,w,h,r)
end

function emenu.util:DrawMaterialCentered(x,y,r,col,mat)
	self:DrawMaterial(x-r, y-r, r*2, r*2, col, mat)
end

function emenu.util:DrawMaterialCenteredRotated(x,y,r,rot,col,mat)
	self:DrawMaterialRotated(x, y, r*2, r*2, rot, col, mat)
end


--------------
/// COLORS ///
--------------
--nometa
emenu.util.color = {}
local cutil = emenu.util.color

function cutil:Inverse(col)
	return Color(255-col.r,255-col.g,255-col.b,col.a)
end

function cutil:Average(coltable)
	local rsum, gsum, bsum, asum = 0,0,0,0

	local count = #coltable
	for _,col in ipairs(coltable) do
		rsum = rsum + col.r
		gsum = gsum + col.g
		bsum = bsum + col.b
		asum = asum + col.a
	end
	return Color(rsum/count, gsum/count, bsum/count, asum/count)
end

function cutil:Adjust(col,type,a)
	if a == nil then
		a = type
		return Color(col.r+a,col.g+a,col.b+a,col.a)
	else
		if string.find( type:lower(), "r" ) then
			return Color(col.r+a,col.g,col.b,col.a)

		elseif string.find( type:lower(), "g" ) then
			return Color(col.r,col.g+a,col.b,col.a)

		elseif string.find( type:lower(), "b" ) then
			return Color(col.r,col.g,col.b+a,col.a)

		elseif string.find( type:lower(), "a" ) then
			return Color(col.r,col.g,col.b,col.a+a)

		end
	end
end

function cutil:Set(col,type,a)
	if a == nil then
		a = type
		return Color(a, a, a, col.a)
	else
		if string.find( type:lower(), "r" ) then
			return Color(a, col.g, col.b, col.a)

		elseif string.find( type:lower(), "g" ) then
			return Color(col.r, a, col.b, col.a)

		elseif string.find( type:lower(), "b" ) then
			return Color(col.r, col.g, a, col.a)

		elseif string.find( type:lower(), "a" ) then
			return Color(col.r, col.g, col.b, a)

		end
	end
end