------------------
/// INITIALIZE ///
------------------
emenu.shop = {}

-----------------
/// FUNCTIONS ///
-----------------
--https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/f4menu/cl_entitiestab.lua
function emenu.shop:CanBuyWeapons(ship)
    local ply = LocalPlayer()

    if not table.HasValue(ship.allowed, ply:Team()) then return false, true end
    if ship.customCheck and not ship.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyPistol", nil, ply, ship)
    local cost = price or ship.getPrice and ship.getPrice(ply, ship.pricesep) or ship.pricesep

    if canbuy == false then
        return false
    end

    return true, nil, message, cost
end

function emenu.shop:CanBuyEntity(item)
    local ply = LocalPlayer()

    if istable(item.allowed) and not table.HasValue(item.allowed, ply:Team()) then return false, true end
    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyCustomEntity", nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price
    if not ply:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false
    end

    return true, nil, message, cost
end

function emenu.shop:CanBuyShipments(ship)
    local ply = LocalPlayer()

    if not table.HasValue(ship.allowed, ply:Team()) then return false, true end
    if ship.customCheck and not ship.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyShipment", nil, ply, ship)
    local cost = price or ship.getPrice and ship.getPrice(ply, ship.price) or ship.price

    if canbuy == false then
        return false
    end

    return true, nil, message, cost
end

function emenu.shop:CanBuyVehicles(item)
    local ply = LocalPlayer()
    local cost = item.getPrice and item.getPrice(ply, item.price) or item.price

    if istable(item.allowed) and not table.HasValue(item.allowed, ply:Team()) then return false, true end
    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyVehicle", nil, ply, item)
    cost = price or cost
    
    if canbuy == false then
        return false
    end

    return true, nil, message, cost
end

function emenu.shop:CanBuyAmmo(item)
    local ply = LocalPlayer()

    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyAmmo", nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price

    if canbuy == false then
        return false
    end

    return true, nil, message, price
end

function emenu.shop:CanBuyFood(food)
    local ply = LocalPlayer()

    if (food.requiresCook == nil or food.requiresCook == true) and not ply:isCook() then return false, true end
    if food.customCheck and not food.customCheck(LocalPlayer()) then return false, false end

    return true
end



----------------
/// FAVORITE ///
----------------
emenu.shop.favorite = {}
emenu.shop.favorite.list = emenu.shop.favorite.list or {}
local filename = "favorite_entities"

function emenu.shop.favorite:Exists()
	return file.Exists("emenu/"..filename..".txt", "DATA")
end

function emenu.shop.favorite:Save()
	file.Write("emenu/"..filename..".txt", util.TableToJSON(self.list))
end

function emenu.shop.favorite:Get()
	if self:Exists() then
		return util.JSONToTable(file.Read("emenu/"..filename..".txt","DATA")) or {}
	else
		return {}
	end
end
emenu.shop.favorite.list = emenu.shop.favorite:Get()

function emenu.shop.favorite:Add(tab,cmd)
	if istable(self.list) then
		if self.list[tab] == nil then
			self.list[tab] = {}
		end
		self.list[tab][cmd] = true
		self:Save()
	end
end

function emenu.shop.favorite:Remove(tab,cmd)
	if istable(self.list) then
		if self.list[tab] == nil then
			return
		else
			self.list[tab][cmd] = nil
			self:Save()
		end
	end
end


---------------------
/// MAIN FUNCTION ///
---------------------
function emenu.shop:GenPanel(bg)
	local ply = LocalPlayer()

	local pnl = vgui.Create("emenu.window",bg)
	pnl:SetIcon(emenu.Materials["shop"])
	pnl:SetSize(bg:GetWide()*0.6,bg:GetTall()*0.8)
	pnl:SetTitle(emenu.text["shop"],nil,"emenu_30_500")
	pnl:CenterHorizontal()
	pnl:CenterVertical(0.45)
	self.content = pnl:GetContent()


	function self:ContinueBuild()
		if not IsValid(self.content) then return end
		if IsValid(self.combolist) then
			self.oldactive = self.combolist:GetActive()
			self.combolist:Remove()
		end

		local base = vgui.Create("emenu.combolist",self.content)
		base:Dock(FILL)
		base:InvalidateParent(true)
		base:SetFont("emenu_24_500")
		base:SetPaintBG(true)
		base:SetTextColor(emenu.colors.text.darken)
		self.combolist = base

		local tbl = DarkRP.getCategories()
		if not istable(tbl) then return end



		----------------
		/// ENTITIES ///
		----------------
		local tabname = emenu.text["ents"]
		base:AddTab(tabname,function(parent)
			local scroll = vgui.Create("emenu.scrollpanel",parent)
			scroll:SetSize(parent:GetWide(),parent:GetTall())

			local list = scroll:Add("DIconLayout")
			list:SetSize(scroll:GetWide(),scroll:GetTall())
			list:SetBorder(3)
			list:SetSpaceY(3)

			--GENERATING CATEGORIES
			self.ent_categories = {}
			for id, category in ipairs(tbl["entities"]) do

				for itemid,item in ipairs(category.members) do

					local canbuy, suppress, msg, price = emenu.shop:CanBuyEntity(item)
					if not price then continue end

					if emenu.shop.favorite.list then
						if emenu.shop.favorite.list[tabname] then

							if self.ent_categories[emenu.text["favorite"]] == nil then
								self.ent_categories[emenu.text["favorite"]] = {}
							end

							if emenu.shop.favorite.list[tabname][item.cmd] then
								item.favorite = true
								table.insert(self.ent_categories[emenu.text["favorite"]], item)
							end
						end
					end

					if self.ent_categories[item.category] == nil then
						self.ent_categories[item.category] = {}
					end

					if price and not item.favorite then
						table.insert(self.ent_categories[item.category], item)
					end
				end
			end

			self.ent_sequence = emenu.util:CreateSequencedTable(self.ent_categories,{emenu.text["favorite"]})

			--ITEMS
			for id, category in ipairs(self.ent_sequence) do
				local items = self.ent_categories[category]
				if (#items == 0) then continue end

				local categlist = vgui.Create("DIconLayout",list)
				categlist:SetSpaceX(3)
				categlist:SetSpaceY(3)
				categlist:SetBorder(3)
				categlist:SetSize(list:GetWide()-categlist:GetSpaceX(),list:GetTall())

				local catpan = vgui.Create("DPanel",categlist)
				local font = "emenu_30_500"
				catpan:SetSize(categlist:GetWide()-9,draw.GetFontHeight(font)+6)
				function catpan:Paint(w,h)
					draw.SimpleText(category,font,5,h*0.5,emenu.colors.shop.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				end

				for id, item in ipairs(items) do

					local price = item.price

					if price then
						local canafford = ply:canAfford(price)

						local itempnl = categlist:Add("DButton")
						itempnl:SetSize(categlist:GetWide()*0.5-categlist:GetSpaceX()*2,70)
						itempnl:SetText("")

						local modelpanel = itempnl:Add("DModelPanel")
						modelpanel:SetSize(itempnl:GetTall(),itempnl:GetTall())
						modelpanel:SetX(6)
						modelpanel:SetModel(item.model)
						modelpanel:SetMouseInputEnabled(false)
						modelpanel.LayoutEntity = function() end
						if (IsValid(modelpanel.Entity)) then
							local renn, renx = modelpanel.Entity:GetRenderBounds()
							local pos = 0
							pos = math.max(pos, math.abs(renn.x) + math.abs(renx.x))
							modelpanel:SetFOV(60)
							modelpanel:SetCamPos(Vector(pos, pos, pos))
							modelpanel:SetLookAt((renn + renx) * 0.5)
							modelpanel.Entity:SetPos(Vector(0, 0, 0))
						end

						local maxtext = emenu.text["max"]..": "..(item.max ~= 0 and item.max or "∞")
						local maxfont = "emenu_18_500"
						local maxsize = emenu.util.GetTextSize(maxtext,maxfont)
						local bordercol = emenu.util.color:Adjust(emenu.colors.shop.itembg,10)
						function itempnl:Paint(w,h)
							local hovered = self:IsHovered()
							draw.RoundedBox(0,0,0,w,h,hovered and emenu.colors.shop.itembg_hover or emenu.colors.shop.itembg)

							surface.SetDrawColor(bordercol:Unpack())
							surface.DrawRect(0,h-2,w,2)
							surface.DrawRect(w-2,0,2,h)

							--NAME
							draw.SimpleText(item.name,"emenu_24_500",modelpanel:GetWide()+12,13,emenu.colors.shop.text)

							--PRICE
							draw.SimpleText(DarkRP.formatMoney(item.price),"emenu_20_500",modelpanel:GetWide()+12,h-10,emenu.colors.shop.text2,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

							--MAXIMUM
							if item.max and item.max > 0 then
								draw.SimpleText(maxtext,maxfont,w-12,h*0.5,emenu.colors.shop.text2,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
							end
						end

						function itempnl:DoClick()
							local canafford = ply:canAfford(price)

							if canafford then
								RunConsoleCommand("darkrp",item.cmd)
							else
								emenu:Notify(emenu.text["cantafford"],4)
							end

							-- emenu.shop:ContinueBuild()
						end

						local favor = itempnl:Add("DButton")
						local size = itempnl:GetTall()*0.3
						favor:SetText("")
						favor:SetSize(size,size)
						favor:CenterVertical()
						favor:SetX(itempnl:GetWide() - favor:GetWide() - maxsize["w"] - 25)
						function favor:Paint(w,h)
							local hovered = self:IsHovered()
							local liked = item.favorite

							local col = hovered and emenu.colors.shop.favorite or emenu.colors.shop.text2
							local mat = emenu.Materials["like"]
							if liked then
								col = hovered and emenu.colors.shop.text2 or emenu.colors.shop.favorite
								mat = emenu.Materials["like_filled"]
							end
							emenu.util:DrawMaterial(0,0,w,h,col,mat)
						end
						function favor:DoClick()
							if not item.favorite then
								emenu.shop.favorite:Add(tabname,item.cmd)
								item.favorite = true
								emenu.shop:ContinueBuild()
							else
								emenu.shop.favorite:Remove(tabname,item.cmd)
								item.favorite = nil
								emenu.shop:ContinueBuild()
							end
						end

						function itempnl:DoRightClick()
							local context = vgui.Create("emenu.contextmenu",bg)
		                	context:SetWide(bg:GetWide()*0.1)
		                	context:AddHeader(emenu.text["actions"])
		                	context:AddButton(emenu.text["buy"],function() itempnl:DoClick() end, emenu.Materials["next"])

		                	if item.favorite then
			                	context:AddButton(emenu.text["unfavorite"],function() favor:DoClick() end, emenu.Materials["like_filled"])
			                else
			                	context:AddButton(emenu.text["favorite"],function() favor:DoClick() end, emenu.Materials["like"])
			                end

		                	local posx,posy = input.GetCursorPos()
		                	context:SetPosClamped(posx+5,posy+5)
						end
					end
				end

			end

			return scroll
		end)
		
	
		------------
		/// FOOD ///
		------------

		local contin = true

		if not table.IsEmpty(FoodItems or {}) then contin = false end
		if ply.getJobTable then contin = ply:getJobTable().cook end

		if contin then
		local tabname = emenu.text["food"]
		base:AddTab(tabname,function(parent)
			local scroll = vgui.Create("emenu.scrollpanel",parent)
			scroll:SetSize(parent:GetWide(),parent:GetTall())

			local list = scroll:Add("DIconLayout")
			list:SetSize(scroll:GetWide(),scroll:GetTall())
			list:SetBorder(3)
			list:SetSpaceY(3)

			--GENERATING CATEGORIES
			self.ent_categories = {}
			self.ent_categories[tabname] = {}
			for id, item in ipairs(FoodItems) do

				local canbuy, suppress, msg, price = emenu.shop:CanBuyEntity(item)
				if not price then continue end

				if emenu.shop.favorite.list then
					if emenu.shop.favorite.list[tabname] then

						if self.ent_categories[emenu.text["favorite"]] == nil then
							self.ent_categories[emenu.text["favorite"]] = {}
						end

						if emenu.shop.favorite.list[tabname][item.name] then
							item.favorite = true
							table.insert(self.ent_categories[emenu.text["favorite"]], item)
						end
					end
				end

				if price and not item.favorite then
					table.insert(self.ent_categories[tabname], item)
				end
			end

			self.ent_sequence = emenu.util:CreateSequencedTable(self.ent_categories,{emenu.text["favorite"]})

			--ITEMS
			for id, category in ipairs(self.ent_sequence) do
				local items = self.ent_categories[category]
				if (#items == 0) then continue end

				local categlist = vgui.Create("DIconLayout",list)
				categlist:SetSpaceX(3)
				categlist:SetSpaceY(3)
				categlist:SetBorder(3)
				categlist:SetSize(list:GetWide()-categlist:GetSpaceX(),list:GetTall())

				local catpan = vgui.Create("DPanel",categlist)
				local font = "emenu_30_500"
				catpan:SetSize(categlist:GetWide()-9,draw.GetFontHeight(font)+6)
				function catpan:Paint(w,h)
					draw.SimpleText(category,font,5,h*0.5,emenu.colors.shop.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				end

				for id, item in ipairs(items) do

					local price = item.price

					if price then
						local canafford = ply:canAfford(price)

						local itempnl = categlist:Add("DButton")
						itempnl:SetSize(categlist:GetWide()*0.5-categlist:GetSpaceX()*2,70)
						itempnl:SetText("")

						local modelpanel = itempnl:Add("DModelPanel")
						modelpanel:SetSize(itempnl:GetTall(),itempnl:GetTall())
						modelpanel:SetX(6)
						modelpanel:SetModel(item.model)
						modelpanel:SetMouseInputEnabled(false)
						modelpanel.LayoutEntity = function() end
						if (IsValid(modelpanel.Entity)) then
							local renn, renx = modelpanel.Entity:GetRenderBounds()
							local pos = 0
							pos = math.max(pos, math.abs(renn.x) + math.abs(renx.x))
							modelpanel:SetFOV(60)
							modelpanel:SetCamPos(Vector(pos, pos, pos))
							modelpanel:SetLookAt((renn + renx) * 0.5)
							modelpanel.Entity:SetPos(Vector(0, 0, 0))
						end

						local maxtext = emenu.text["max"]..": "..(item.max ~= 0 and item.max or "∞")
						local maxfont = "emenu_18_500"
						local maxsize = emenu.util.GetTextSize(maxtext,maxfont)
						local bordercol = emenu.util.color:Adjust(emenu.colors.shop.itembg,10)
						function itempnl:Paint(w,h)
							local hovered = self:IsHovered()
							draw.RoundedBox(0,0,0,w,h,hovered and emenu.colors.shop.itembg_hover or emenu.colors.shop.itembg)

							surface.SetDrawColor(bordercol:Unpack())
							surface.DrawRect(0,h-2,w,2)
							surface.DrawRect(w-2,0,2,h)

							--NAME
							draw.SimpleText(item.name,"emenu_24_500",modelpanel:GetWide()+12,13,emenu.colors.shop.text)

							--PRICE
							draw.SimpleText(DarkRP.formatMoney(item.price),"emenu_20_500",modelpanel:GetWide()+12,h-10,emenu.colors.shop.text2,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

							--MAXIMUM
							if item.max and item.max > 0 then
								draw.SimpleText(maxtext,maxfont,w-12,h*0.5,emenu.colors.shop.text2,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
							end
						end

						function itempnl:DoClick()
							local canafford = ply:canAfford(price)

							if canafford then
								RunConsoleCommand("darkrp","buyfood", item.name)
							else
								emenu:Notify(emenu.text["cantafford"],4)
							end

							-- emenu.shop:ContinueBuild()
						end

						local favor = itempnl:Add("DButton")
						local size = itempnl:GetTall()*0.3
						favor:SetText("")
						favor:SetSize(size,size)
						favor:CenterVertical()
						favor:SetX(itempnl:GetWide() - favor:GetWide() - maxsize["w"] - 25)
						function favor:Paint(w,h)
							local hovered = self:IsHovered()
							local liked = item.favorite

							local col = hovered and emenu.colors.shop.favorite or emenu.colors.shop.text2
							local mat = emenu.Materials["like"]
							if liked then
								col = hovered and emenu.colors.shop.text2 or emenu.colors.shop.favorite
								mat = emenu.Materials["like_filled"]
							end
							emenu.util:DrawMaterial(0,0,w,h,col,mat)
						end
						function favor:DoClick()
							if not item.favorite then
								emenu.shop.favorite:Add(tabname,item.name)
								item.favorite = true
								emenu.shop:ContinueBuild()
							else
								emenu.shop.favorite:Remove(tabname,item.name)
								item.favorite = nil
								emenu.shop:ContinueBuild()
							end
						end

						function itempnl:DoRightClick()
							local context = vgui.Create("emenu.contextmenu",bg)
		                	context:SetWide(bg:GetWide()*0.1)
		                	context:AddHeader(emenu.text["actions"])
		                	context:AddButton(emenu.text["buy"],function() itempnl:DoClick() end, emenu.Materials["next"])

		                	if item.favorite then
			                	context:AddButton(emenu.text["unfavorite"],function() favor:DoClick() end, emenu.Materials["like_filled"])
			                else
			                	context:AddButton(emenu.text["favorite"],function() favor:DoClick() end, emenu.Materials["like"])
			                end

		                	local posx,posy = input.GetCursorPos()
		                	context:SetPosClamped(posx+5,posy+5)
						end
					end
				end

			end

			return scroll
		end)
		end


		------------
		/// AMMO ///
		------------
		local tabname = emenu.text["ammo"]
		base:AddTab(tabname,function(parent)
			local scroll = vgui.Create("emenu.scrollpanel",parent)
			scroll:SetSize(parent:GetWide(),parent:GetTall())

			local list = scroll:Add("DIconLayout")
			list:SetSize(scroll:GetWide(),scroll:GetTall())
			list:SetBorder(3)
			list:SetSpaceY(3)

			--GENERATING CATEGORIES
			self.ent_categories = {}
			for id, item in ipairs(GAMEMODE.AmmoTypes or GM.AmmoTypes) do

				if not item.price then continue end

				if emenu.shop.favorite.list then
					if emenu.shop.favorite.list[tabname] then

						if self.ent_categories[emenu.text["favorite"]] == nil then
							self.ent_categories[emenu.text["favorite"]] = {}
						end

						if emenu.shop.favorite.list[tabname][item.id] then
							item.favorite = true
							table.insert(self.ent_categories[emenu.text["favorite"]], item)
						end
					end
				end

				if self.ent_categories[item.category] == nil then
					self.ent_categories[item.category] = {}
				end

				if item.price and not item.favorite then
					table.insert(self.ent_categories[item.category], item)
				end
			end
			self.ent_sequence = emenu.util:CreateSequencedTable(self.ent_categories,{emenu.text["favorite"]})

			--ITEMS
			for id, category in ipairs(self.ent_sequence) do
				local items = self.ent_categories[category]
				if (#items == 0) then continue end

				local categlist = vgui.Create("DIconLayout",list)
				categlist:SetSpaceX(3)
				categlist:SetSpaceY(3)
				categlist:SetBorder(3)
				categlist:SetSize(list:GetWide()-categlist:GetSpaceX(),list:GetTall())

				local catpan = vgui.Create("DPanel",categlist)
				local font = "emenu_30_500"
				catpan:SetSize(categlist:GetWide()-9,draw.GetFontHeight(font)+6)
				function catpan:Paint(w,h)
					draw.SimpleText(category,font,5,h*0.5,emenu.colors.shop.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				end

				for id, item in ipairs(items) do

					local price = item.price

					if price then

						local itempnl = categlist:Add("DButton")
						itempnl:SetSize(categlist:GetWide()*0.5-categlist:GetSpaceX()*2,70)
						itempnl:SetText("")

						local modelpanel = itempnl:Add("DModelPanel")
						modelpanel:SetSize(itempnl:GetTall(),itempnl:GetTall())
						modelpanel:SetX(6)
						modelpanel:SetModel(item.model)
						modelpanel:SetMouseInputEnabled(false)
						modelpanel.LayoutEntity = function() end
						if (IsValid(modelpanel.Entity)) then
							local renn, renx = modelpanel.Entity:GetRenderBounds()
							local pos = 0
							pos = math.max(pos, math.abs(renn.x) + math.abs(renx.x))
							modelpanel:SetFOV(100)
							modelpanel:SetCamPos(Vector(pos, pos, pos))
							modelpanel:SetLookAt((renn + renx) * 0.5)
							modelpanel.Entity:SetPos(Vector(0, 0, 0))
							local ang = modelpanel.Entity:GetAngles()
							ang.y = 45
							modelpanel.Entity:SetAngles(ang)
						end

						local bordercol = emenu.util.color:Adjust(emenu.colors.shop.itembg,10)
						function itempnl:Paint(w,h)
							local hovered = self:IsHovered()
							draw.RoundedBox(0,0,0,w,h,hovered and emenu.colors.shop.itembg_hover or emenu.colors.shop.itembg)

							surface.SetDrawColor(bordercol:Unpack())
							surface.DrawRect(0,h-2,w,2)
							surface.DrawRect(w-2,0,2,h)

							--NAME
							draw.SimpleText(item.name,"emenu_24_500",modelpanel:GetWide()+17,13,emenu.colors.shop.text)

							--PRICE
							draw.SimpleText(DarkRP.formatMoney(item.price).." / "..item.amountGiven,"emenu_20_500",modelpanel:GetWide()+17,h-10,emenu.colors.shop.text2,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

						end

						function itempnl:DoClick()
							local canafford = ply:canAfford(price)

							if canafford then
								RunConsoleCommand("darkrp", "buyammo", item.id)
							else
								emenu:Notify(emenu.text["cantafford"],4)
							end

							-- emenu.shop:ContinueBuild()
						end

						local favor = itempnl:Add("DButton")
						local size = itempnl:GetTall()*0.3
						favor:SetText("")
						favor:SetSize(size,size)
						favor:CenterVertical()
						favor:SetX(itempnl:GetWide() - favor:GetWide() - 25)
						function favor:Paint(w,h)
							local hovered = self:IsHovered()
							local liked = item.favorite

							local col = hovered and emenu.colors.shop.favorite or emenu.colors.shop.text2
							local mat = emenu.Materials["like"]
							if liked then
								col = hovered and emenu.colors.shop.text2 or emenu.colors.shop.favorite
								mat = emenu.Materials["like_filled"]
							end
							emenu.util:DrawMaterial(0,0,w,h,col,mat)
						end
						function favor:DoClick()
							if not item.favorite then
								emenu.shop.favorite:Add(tabname,item.id)
								item.favorite = true
								emenu.shop:ContinueBuild()
							else
								emenu.shop.favorite:Remove(tabname,item.id)
								item.favorite = nil
								emenu.shop:ContinueBuild()
							end
						end

						function itempnl:DoRightClick()
							local context = vgui.Create("emenu.contextmenu",bg)
		                	context:SetWide(bg:GetWide()*0.1)
		                	context:AddHeader(emenu.text["actions"])
		                	context:AddButton(emenu.text["buy"],function() itempnl:DoClick() end, emenu.Materials["next"])

		                	if item.favorite then
			                	context:AddButton(emenu.text["unfavorite"],function() favor:DoClick() end, emenu.Materials["like_filled"])
			                else
			                	context:AddButton(emenu.text["favorite"],function() favor:DoClick() end, emenu.Materials["like"])
			                end

		                	local posx,posy = input.GetCursorPos()
		                	context:SetPosClamped(posx+5,posy+5)
						end
					end
				end

			end

			return scroll
		end)



		---------------
		/// WEAPONS ///
		---------------
		local tabname = emenu.text["weapons"]
		base:AddTab(tabname,function(parent)
			local scroll = vgui.Create("emenu.scrollpanel",parent)
			scroll:SetSize(parent:GetWide(),parent:GetTall())

			local list = scroll:Add("DIconLayout")
			list:SetSize(scroll:GetWide(),scroll:GetTall())
			list:SetBorder(3)
			list:SetSpaceY(3)

			--GENERATING CATEGORIES
			self.ent_categories = {}
			for id, category in ipairs(tbl["weapons"]) do

				for itemid,item in ipairs(category.members) do
					if (not item.separate) then continue end

					local canbuy, suppress, msg, price = emenu.shop:CanBuyWeapons(item)
					if not price then continue end

					if emenu.shop.favorite.list then
						if emenu.shop.favorite.list[tabname] then

							if self.ent_categories[emenu.text["favorite"]] == nil then
								self.ent_categories[emenu.text["favorite"]] = {}
							end

							if emenu.shop.favorite.list[tabname][item.name] then
								item.favorite = true
								table.insert(self.ent_categories[emenu.text["favorite"]], item)
							end
						end
					end

					if self.ent_categories[item.category] == nil then
						self.ent_categories[item.category] = {}
					end

					if price and not item.favorite then
						table.insert(self.ent_categories[item.category], item)
					end
				end
			end
			self.ent_sequence = emenu.util:CreateSequencedTable(self.ent_categories,{emenu.text["favorite"]})

			--ITEMS
			for id, category in ipairs(self.ent_sequence) do
				local items = self.ent_categories[category]
				if (#items == 0) then continue end

				local categlist = vgui.Create("DIconLayout",list)
				categlist:SetSpaceX(3)
				categlist:SetSpaceY(3)
				categlist:SetBorder(3)
				categlist:SetSize(list:GetWide()-categlist:GetSpaceX(),list:GetTall())

				local catpan = vgui.Create("DPanel",categlist)
				local font = "emenu_30_500"
				catpan:SetSize(categlist:GetWide()-9,draw.GetFontHeight(font)+6)
				function catpan:Paint(w,h)
					draw.SimpleText(category,font,5,h*0.5,emenu.colors.shop.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				end

				for id, item in ipairs(items) do

					local price = item.pricesep

					if price then
						local canafford = ply:canAfford(price)

						local itempnl = categlist:Add("DButton")
						itempnl:SetSize(categlist:GetWide()*0.5-categlist:GetSpaceX()*2,70)
						itempnl:SetText("")

						local modelpanel = itempnl:Add("DModelPanel")
						modelpanel:SetSize(itempnl:GetTall(),itempnl:GetTall())
						modelpanel:SetX(6)
						modelpanel:SetModel(item.model)
						modelpanel:SetMouseInputEnabled(false)
						modelpanel.LayoutEntity = function() end
						if (IsValid(modelpanel.Entity)) then
							local renn, renx = modelpanel.Entity:GetRenderBounds()
							local pos = 0
							pos = math.max(pos, math.abs(renn.x) + math.abs(renx.x))
							modelpanel:SetFOV(60)
							modelpanel:SetCamPos(Vector(pos, pos, pos))
							modelpanel:SetLookAt((renn + renx) * 0.5)
							modelpanel.Entity:SetPos(Vector(0, 0, 0))
						end

						local bordercol = emenu.util.color:Adjust(emenu.colors.shop.itembg,10)
						function itempnl:Paint(w,h)
							local hovered = self:IsHovered()
							draw.RoundedBox(0,0,0,w,h,hovered and emenu.colors.shop.itembg_hover or emenu.colors.shop.itembg)

							surface.SetDrawColor(bordercol:Unpack())
							surface.DrawRect(0,h-2,w,2)
							surface.DrawRect(w-2,0,2,h)

							--NAME
							draw.SimpleText(item.name,"emenu_24_500",modelpanel:GetWide()+12,13,emenu.colors.shop.text)

							--PRICE
							draw.SimpleText(DarkRP.formatMoney(price),"emenu_20_500",modelpanel:GetWide()+12,h-10,emenu.colors.shop.text2,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

						end

						function itempnl:DoClick()
							local canafford = ply:canAfford(price)

							if canafford then
								RunConsoleCommand("darkrp", "buy" ,item.name)
							else
								emenu:Notify(emenu.text["cantafford"],4)
							end

							-- emenu.shop:ContinueBuild()
						end

						local favor = itempnl:Add("DButton")
						local size = itempnl:GetTall()*0.3
						favor:SetText("")
						favor:SetSize(size,size)
						favor:CenterVertical()
						favor:SetX(itempnl:GetWide() - favor:GetWide() - 25)
						function favor:Paint(w,h)
							local hovered = self:IsHovered()
							local liked = item.favorite

							local col = hovered and emenu.colors.shop.favorite or emenu.colors.shop.text2
							local mat = emenu.Materials["like"]
							if liked then
								col = hovered and emenu.colors.shop.text2 or emenu.colors.shop.favorite
								mat = emenu.Materials["like_filled"]
							end
							emenu.util:DrawMaterial(0,0,w,h,col,mat)
						end
						function favor:DoClick()
							if not item.favorite then
								emenu.shop.favorite:Add(tabname,item.name)
								item.favorite = true
								emenu.shop:ContinueBuild()
							else
								emenu.shop.favorite:Remove(tabname,item.name)
								item.favorite = nil
								emenu.shop:ContinueBuild()
							end
						end

						function itempnl:DoRightClick()
							local context = vgui.Create("emenu.contextmenu",bg)
		                	context:SetWide(bg:GetWide()*0.1)
		                	context:AddHeader(emenu.text["actions"])
		                	context:AddButton(emenu.text["buy"],function() itempnl:DoClick() end, emenu.Materials["next"])

		                	if item.favorite then
			                	context:AddButton(emenu.text["unfavorite"],function() favor:DoClick() end, emenu.Materials["like_filled"])
			                else
			                	context:AddButton(emenu.text["favorite"],function() favor:DoClick() end, emenu.Materials["like"])
			                end

		                	local posx,posy = input.GetCursorPos()
		                	context:SetPosClamped(posx+5,posy+5)
						end

					end
				end

			end

			return scroll
		end)



		-----------------
		/// SHIPMENTS ///
		-----------------
		local tabname = emenu.text["shipments"]
		base:AddTab(tabname,function(parent)
			local scroll = vgui.Create("emenu.scrollpanel",parent)
			scroll:SetSize(parent:GetWide(),parent:GetTall())

			local list = scroll:Add("DIconLayout")
			list:SetSize(scroll:GetWide(),scroll:GetTall())
			list:SetBorder(3)
			list:SetSpaceY(3)

			--GENERATING CATEGORIES
			self.ent_categories = {}
			for id, category in ipairs(tbl["shipments"]) do

				for itemid,item in ipairs(category.members) do
					if (item.noship) then continue end

					local canbuy, suppress, msg, price = emenu.shop:CanBuyShipments(item)
					if not price then continue end

					if emenu.shop.favorite.list then
						if emenu.shop.favorite.list[tabname] then

							if self.ent_categories[emenu.text["favorite"]] == nil then
								self.ent_categories[emenu.text["favorite"]] = {}
							end

							if emenu.shop.favorite.list[tabname][item.name] then
								item.favorite = true
								table.insert(self.ent_categories[emenu.text["favorite"]], item)
							end
						end
					end

					if self.ent_categories[item.category] == nil then
						self.ent_categories[item.category] = {}
					end


					if price and not item.favorite then
						table.insert(self.ent_categories[item.category], item)
					end
				end
			end
			self.ent_sequence = emenu.util:CreateSequencedTable(self.ent_categories,{emenu.text["favorite"]})

			--ITEMS
			for id, category in ipairs(self.ent_sequence) do
				local items = self.ent_categories[category]
				if (#items == 0) then continue end

				local categlist = vgui.Create("DIconLayout",list)
				categlist:SetSpaceX(3)
				categlist:SetSpaceY(3)
				categlist:SetBorder(3)
				categlist:SetSize(list:GetWide()-categlist:GetSpaceX(),list:GetTall())

				local catpan = vgui.Create("DPanel",categlist)
				local font = "emenu_30_500"
				catpan:SetSize(categlist:GetWide()-9,draw.GetFontHeight(font)+6)
				function catpan:Paint(w,h)
					draw.SimpleText(category,font,5,h*0.5,emenu.colors.shop.text,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				end

				for id, item in ipairs(items) do

					local price = item.price

					if price then

						local itempnl = categlist:Add("DButton")
						itempnl:SetSize(categlist:GetWide()*0.5-categlist:GetSpaceX()*2,70)
						itempnl:SetText("")

						local modelpanel = itempnl:Add("DModelPanel")
						modelpanel:SetSize(itempnl:GetTall(),itempnl:GetTall())
						modelpanel:SetX(6)
						modelpanel:SetModel(item.model)
						modelpanel:SetMouseInputEnabled(false)
						modelpanel.LayoutEntity = function() end
						if (IsValid(modelpanel.Entity)) then
							local renn, renx = modelpanel.Entity:GetRenderBounds()
							local pos = 0
							pos = math.max(pos, math.abs(renn.x) + math.abs(renx.x))
							modelpanel:SetFOV(60)
							modelpanel:SetCamPos(Vector(pos, pos, pos))
							modelpanel:SetLookAt((renn + renx) * 0.5)
							modelpanel.Entity:SetPos(Vector(0, 0, 0))
						end

						local bordercol = emenu.util.color:Adjust(emenu.colors.shop.itembg,10)
						function itempnl:Paint(w,h)
							local hovered = self:IsHovered()
							draw.RoundedBox(0,0,0,w,h,hovered and emenu.colors.shop.itembg_hover or emenu.colors.shop.itembg)

							surface.SetDrawColor(bordercol:Unpack())
							surface.DrawRect(0,h-2,w,2)
							surface.DrawRect(w-2,0,2,h)

							--NAME
							draw.SimpleText(item.name,"emenu_24_500",modelpanel:GetWide()+12,13,emenu.colors.shop.text)

							--PRICE
							draw.SimpleText(DarkRP.formatMoney(item.price),"emenu_20_500",modelpanel:GetWide()+12,h-10,emenu.colors.shop.text2,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

						end

						function itempnl:DoClick()
							local canafford = ply:canAfford(price)

							if canafford then
								RunConsoleCommand("darkrp", "buyshipment" ,item.name)
							else
								emenu:Notify(emenu.text["cantafford"],4)
							end

							-- emenu.shop:ContinueBuild()
						end

						local favor = itempnl:Add("DButton")
						local size = itempnl:GetTall()*0.3
						favor:SetText("")
						favor:SetSize(size,size)
						favor:CenterVertical()
						favor:SetX(itempnl:GetWide() - favor:GetWide() - 25)
						function favor:Paint(w,h)
							local hovered = self:IsHovered()
							local liked = item.favorite

							local col = hovered and emenu.colors.shop.favorite or emenu.colors.shop.text2
							local mat = emenu.Materials["like"]
							if liked then
								col = hovered and emenu.colors.shop.text2 or emenu.colors.shop.favorite
								mat = emenu.Materials["like_filled"]
							end
							emenu.util:DrawMaterial(0,0,w,h,col,mat)
						end
						function favor:DoClick()
							if not item.favorite then
								emenu.shop.favorite:Add(tabname,item.name)
								item.favorite = true
								emenu.shop:ContinueBuild()
							else
								emenu.shop.favorite:Remove(tabname,item.name)
								item.favorite = nil
								emenu.shop:ContinueBuild()
							end
						end

						function itempnl:DoRightClick()
							local context = vgui.Create("emenu.contextmenu",bg)
		                	context:SetWide(bg:GetWide()*0.1)
		                	context:AddHeader(emenu.text["actions"])
		                	context:AddButton(emenu.text["buy"],function() itempnl:DoClick() end, emenu.Materials["next"])

		                	if item.favorite then
			                	context:AddButton(emenu.text["unfavorite"],function() favor:DoClick() end, emenu.Materials["like_filled"])
			                else
			                	context:AddButton(emenu.text["favorite"],function() favor:DoClick() end, emenu.Materials["like"])
			                end

		                	local posx,posy = input.GetCursorPos()
		                	context:SetPosClamped(posx+5,posy+5)
						end
					end
				end

			end

			return scroll
		end)

		if self.oldactive ~= nil then
			base:SetActive(self.oldactive)
			self.oldactive = nil
		end

	end

	self:ContinueBuild()

	return pnl
end

------------------------
/// UPDATE FUNCTIONS ///
------------------------
--CHANGE TEAM
hook.Add("emenu_OnPlayerChangedTeam","emenu.shop.onjobchange",function(ply,old,new)
	if ply == LocalPlayer() then
		timer.Simple(1,function()
			if IsValid(emenu.shop.content) then
				if emenu.shop.ContinueBuild ~= nil then
		    		emenu.shop:ContinueBuild()
		    	end
		    end
		end) 
    end
end)

emenu.windows:Register(emenu.text["shop"], emenu.text["shop_phrase"], emenu.Materials["shop"], function(bg) return emenu.shop:GenPanel(bg) end, 2)