--------------
/// COLORS ///
--------------
emenu.colors.jobs[emenu.text["favorite"]] = Color(255,107,129)
emenu.colors.jobs[emenu.text["recent"]]   = Color(138,43,226)

------------------
/// HL2 MODELS ///
------------------
local halflife2 = {
	["weapon_bugbait"] = { PrintName = "Bugbait", WorldModel = "models/weapons/w_bugbait.mdl" },
	["weapon_357"] = { PrintName = ".357 Magnum", WorldModel = "models/weapons/w_357.mdl" },
	["weapon_pistol"] = { PrintName = "Pistol", WorldModel = "models/weapons/w_pistol.mdl" },
	["weapon_crossbow"] = { PrintName = "Crossbow", WorldModel = "models/weapons/w_crossbow.mdl" },
	["weapon_crowbar"] = { PrintName = "Crowbar", WorldModel = "models/weapons/w_crowbar.mdl" },
	["weapon_frag"] = { PrintName = "Grenade", WorldModel = "models/weapons/w_grenade.mdl" },
	["weapon_physcannon"] = { PrintName = "Gravity Gun", WorldModel = "models/weapons/w_Physics.mdl" },
	["weapon_ar2"] = { PrintName = "Pulse-Rifle", WorldModel = "models/weapons/w_irifle.mdl" },
	["weapon_rpg"] = { PrintName = "RPG", WorldModel = "models/weapons/w_rocket_launcher.mdl" },
	["weapon_slam"] = { PrintName = "S.L.A.M", WorldModel = "	models/weapons/w_slam.mdl" },
	["weapon_shotgun"] = { PrintName = "Shotgun", WorldModel = "models/weapons/w_shotgun.mdl" },
	["weapon_smg1"] = { PrintName = "SMG", WorldModel = "models/weapons/w_smg1.mdl"},
	["weapon_stunstick"] = { PrintName = "Stunstick", WorldModel = "models/weapons/w_stunbaton.mdl" }
}


-----------------
/// FUNCTIONS ///
-----------------
emenu.jobs = emenu.jobs or {}
emenu.jobs.needupdate = false
emenu.jobs.list = {}


----------------
/// FAVORITE ///
----------------
emenu.jobs.favorite = emenu.jobs.favorite or {}
emenu.jobs.favorite.list = emenu.jobs.favorite.list or {}
local filename = "favorite_jobs"

function emenu.jobs.favorite:Exists()
	return file.Exists("emenu/"..filename..".txt", "DATA")
end

function emenu.jobs.favorite:Save()
	file.Write("emenu/"..filename..".txt", util.TableToJSON(self.list))
end

function emenu.jobs.favorite:Get()
	if self:Exists() then
		return util.JSONToTable(file.Read("emenu/"..filename..".txt","DATA")) or {}
	else
		return {}
	end
end
emenu.jobs.favorite.list = emenu.jobs.favorite:Get()

function emenu.jobs.favorite:Add(jobid)
	if istable(self.list) then
		self.list[jobid] = true
		if istable(RPExtraTeams) then
			RPExtraTeams[jobid].favorite = true
		end
		self:Save()
	end
end

function emenu.jobs.favorite:Remove(jobid)
	if istable(self.list) then
		self.list[jobid] = nil
		if istable(RPExtraTeams) then
			RPExtraTeams[jobid].favorite = nil
		end
		self:Save()
	end
end



--------------
/// RECENT ///
--------------
emenu.jobs.recent = emenu.jobs.recent or {}
local function AddRecentJob(job)
	if not DarkRP then return end
	if job == nil then return end
	if istable(RPExtraTeams) then
		if istable(RPExtraTeams[job]) then
			if RPExtraTeams[job].favorite then return end
		end
	end

	if (#emenu.jobs.recent > 3) then
		table.remove(emenu.jobs.recent, 1)
	end

	for id,v in ipairs(emenu.jobs.recent) do
		if job == v then 
			emenu.jobs.recent[id] = nil
			emenu.jobs.recent = table.ClearKeys(emenu.jobs.recent)
		end
	end

	emenu.jobs.needupdate = true
	table.insert(emenu.jobs.recent, job)
end


--------------------
/// JOB LIST GEN ///
--------------------
function emenu.jobs:GenerateJobs()
	self.list.categories = {}
	local ply = LocalPlayer()
	
	self.list.sequence = {}
	local tbl = DarkRP.getCategories()
	if not istable(tbl) then return end
	tbl = tbl["jobs"]

	----------------
	/// FAVORITE ///
	----------------
	if istable(self.favorite.list) then
		for id,bool in pairs(self.favorite.list) do
			if not self.list.categories[emenu.text["favorite"]] then
				self.list.categories[emenu.text["favorite"]] = {}
			end

			local job = RPExtraTeams[id]
			if job then
				job.favorite = bool
				table.insert(self.list.categories[emenu.text["favorite"]],job)
			end
		end

		if self.list.categories[emenu.text["favorite"]] then
			table.insert(self.list.sequence,emenu.text["favorite"])
		end
	end

	--------------
	/// RECENT ///
	--------------
	for _,v in ipairs(self.recent) do
		local job = RPExtraTeams[v]
		if job then
			if job.favorite then continue end
			if not self.list.categories[emenu.text["recent"]] then
				self.list.categories[emenu.text["recent"]] = {}
			end

			table.insert(self.list.categories[emenu.text["recent"]],job)
		end
	end

	if self.list.categories[emenu.text["recent"]] then
		table.insert(self.list.sequence,emenu.text["recent"])
	end

	--------------------
	/// CURRENT JOBS ///
	--------------------
	for id, category in ipairs(tbl) do
		local catname = category.name
		local members = category.members

		self.list.categories[catname] = {}
		for jobid,job in ipairs(members) do
			local show = true
			if job.favorite then show = false end

			if show then
				table.insert(self.list.categories[catname],job)
			end
		end

		if #self.list.categories[catname] < 1 then
			self.list.categories[catname] = nil
		else
			table.insert(self.list.sequence,catname)
		end
	end
end



-------------
/// PANEL ///
-------------
local function func(bg)
	if not IsValid(bg) then return end
	if not DarkRP then return end
	local ply = LocalPlayer()

	local pnl = vgui.Create("emenu.window",bg)
	pnl:SetIcon(emenu.Materials["person"])
	pnl:SetSize(bg:GetWide()*0.6,bg:GetTall()*0.8)
	pnl:SetTitle(emenu.text["jobs"])
	pnl:CenterHorizontal()
	pnl:CenterVertical(0.45)
	local content = pnl:GetContent()

	emenu.jobs:GenerateJobs()

	local scroll = vgui.Create("emenu.scrollpanel",content)
	scroll:SetSize(content:GetWide(),content:GetTall())

	local function CreateList()

		local list = vgui.Create("DIconLayout",scroll)
		list:SetSize(scroll:GetWide(),scroll:GetTall())
		list:SetSpaceX(3)
		list:SetSpaceY(10)

		for _, category in ipairs(emenu.jobs.list.sequence) do
			local jobs = emenu.jobs.list.categories[category]
			local categlist = vgui.Create("DIconLayout",list)
			local jobcolors = {}
			categlist:SetSpaceX(5)
			categlist:SetSpaceY(3)
			categlist:SetBorder(categlist:GetSpaceX())
			categlist:SetSize(list:GetWide(),list:GetTall())

			local catpan = vgui.Create("DPanel",categlist)
			catpan:SetSize(pnl:GetWide()-categlist:GetBorder(),pnl:GetTall()*0.05)

			for _,job in ipairs(jobs) do

				--CUSTOM CHECK
				local customcheck = true
				if isfunction(job.customCheck) then
					customcheck = job.customCheck(ply)
				end

				if job.private and not customcheck then
					continue
				end

				if not IsColor(job.color) then job.color = Color(255,255,255) end
				local jobpan = vgui.Create("DButton",categlist)
				jobpan.job = job
				jobpan:SetText("")
				jobpan:SetSize(categlist:GetWide()*0.5-categlist:GetSpaceX()*2,65)
				table.insert(jobcolors,job.color) --average color

				--RANKCHECK
				local rankcheck = true
				if job.ranks then
					if istable(job.ranks) then
						rankcheck = job.ranks[ply:GetUserGroup()] ~= nil
					else
						rankcheck = ply:GetUserGroup() == job.ranks
					end
				end

				--JOBSLOTS
				local numpl = team.NumPlayers( job.team )
				local maxcheck = false
				if numpl then
					if job.max then

						if job.max > 0 then

							if (job.max <= numpl) then
								maxcheck = true
							end

						end

					end

				end


				--------------
				/// MODELS ///
				--------------
				local models = job.model
				local model = models
				if istable(models) then
					model = models[math.random( #models )]
				elseif isstring(models) then
					model = models
				else
					return
				end

				local jobModel = vgui.Create( "DModelPanel", jobpan )
				local size = jobpan:GetTall()-6
				jobModel:SetModel( model )
				jobModel:SetSize( size, size )
				jobModel:SetPos( 5, 3 )
				jobModel.LayoutEntity = function() return end
				jobModel:SetMouseInputEnabled(false)
				jobModel:SetFOV( 46 )
	            jobModel:SetCamPos( Vector( 25, 0, 66 ) )
	            jobModel:SetLookAt( Vector( 10, 0, 65 ) )
	            jobModel.Color = job.color
	            local modelpaint = baseclass.Get("DModelPanel").Paint

	            local offset = 3
	           	jobModel.Paint = function(self, w, h)
	           		emenu.util:Mask(
			            function()
			            	emenu.util:DrawPolyCircle(h * 0.5, h * 0.5, h * 0.5 - offset, emenu.colors.default.white, 32)
						end,
						function()
							modelpaint(self,w,h)
						end,
						false
					)
	           	end

	           	local wide = jobpan:GetWide()*0.1
	           	local iconx,icony,iconw,iconh = jobModel:GetBounds()
	           	local shadowcolor = emenu.util.color:Adjust(emenu.colors.jobs.bgjob,10)
	           	local bgcola = emenu.util.color:Set(emenu.colors.jobs.bgjob,"a",255)
				function jobpan:Paint(w,h)
					local notcan = false
					local numpl = team.NumPlayers( job.team )
					local hovered = self:IsHovered()

					--bg
					if (ply:Team() == job.team) then
						draw.RoundedBox(0,0,0,w,h,emenu.colors.jobs.bghover)
					else
						draw.RoundedBox(0,0,0,w,h,hovered and emenu.colors.jobs.bghover or emenu.colors.jobs.bgjob)
					end
					surface.SetDrawColor(shadowcolor:Unpack())
					surface.DrawRect(0,h-2,w,2)
					surface.DrawRect(w-2,0,2,h)

					local textcolor = hovered and emenu.colors.jobs.text or emenu.colors.jobs.text2
					if (not customcheck) or (not rankcheck) or (maxcheck) then
						notcan = true
					end

					if notcan then
						textcolor = emenu.colors.default.red
						emenu.util:DrawMaterial(0,0,w,h,emenu.colors.jobs.texturecol,emenu.Materials["tr_texture"])
					end

					local x, y, h2 = iconx+iconw*0.5, icony+iconh*0.5, iconh*0.5 
					if hovered then
						emenu.util:DrawCircle(x,y,h2, jobModel.Color)
					else
						emenu.util:DrawCircle(x,y,h2-2,jobModel.Color)
					end
					emenu.util:DrawCircle(x,y,h2-3,bgcola)

					draw.SimpleText(numpl .. "/" .. ( job.max == 0 and "∞" or job.max ),
						"emenu_18_500",
						w-10,
						h*0.5,
						textcolor,
						TEXT_ALIGN_RIGHT,
						TEXT_ALIGN_CENTER
					)
				end

				if ply:Team() == job.team then
					emenu:AddHelpText(jobpan,job.CustomCheckFailMsg or emenu.text["err_already"] ,nil,5,"bottom")
				end

				if not customcheck then
					emenu:AddHelpText(jobpan,job.CustomCheckFailMsg or emenu.text["err_norights"] ,nil,5,"bottom")
				end

				if not rankcheck then
					emenu:AddHelpText(jobpan,emenu.text["err_norights"] ,nil,5,"bottom")
				end

				if maxcheck then
					emenu:AddHelpText(jobpan,emenu.text["err_noslots"] ,nil,5,"bottom")
				end

				function jobpan:Think()
					if IsValid(self.helptext) then
						if self:IsHovered() then
							local posx,posy = input.GetCursorPos()
							self.helptext:SetPos(posx+5,posy+5)
						else
							self.helptext:Remove()
						end
					end
				end


				-------------------
				/// DESCRIPTION ///
				-------------------
				local descpnl = jobpan:Add("DPanel")
				descpnl:SetSize(jobpan:GetWide()-5,jobModel:GetWide(),jobpan:GetTall())
				descpnl:SetX(5+jobModel:GetX()+jobModel:GetWide())
				descpnl:CenterVertical()
				descpnl:SetMouseInputEnabled(false)
				local textoffset = draw.GetFontHeight("emenu_20_500")
				function descpnl:Paint(w,h)
					local textcolor = emenu.colors.jobs.text
					if jobpan:IsHovered() then
						textcolor = emenu.colors.jobs.texthover
					end
					 
					if not customcheck or not rankcheck or maxcheck then
						textcolor = emenu.colors.default.red
					end

					draw.SimpleText(job.name,"emenu_20_500",5,h*0.5-textoffset,textcolor)
					draw.SimpleText(emenu.text["salary"] .. ": " .. DarkRP.formatMoney(job.salary),"emenu_16_500",5,h*0.5+4,emenu.colors.jobs.text2)
				end

				local favor = jobpan:Add("DButton")
				local size = jobpan:GetTall()*0.3
				favor:SetText("")
				favor:SetSize(size,size)
				favor:CenterVertical()
				favor:SetX(jobpan:GetWide() - favor:GetWide() - 65)
				function favor:Paint(w,h)
					local hovered = self:IsHovered()
					local liked = job.favorite

					local col = hovered and emenu.colors.jobs.favorite or emenu.colors.jobs.text2
					local mat = emenu.Materials["like"]
					if liked then
						col = hovered and emenu.colors.jobs.text2 or emenu.colors.jobs.favorite
						mat = emenu.Materials["like_filled"]
					end
					emenu.util:DrawMaterial(0,0,w,h,col,mat)
				end
				function favor:DoClick()
					if not job.favorite then
						emenu.jobs.favorite:Add(job.team)
						pnl:UpdateList()
					else
						emenu.jobs.favorite:Remove(job.team)
						pnl:UpdateList()
					end
				end

				-----------------
				/// JOB PANEL ///
				-----------------
				function jobpan:DoClick()
					if IsValid(content.slidebg) then
						content.slidebg:Close()
					end

					local job = self.job
					local slidebg = vgui.Create("DButton",pnl)
					slidebg:SetSize(pnl:GetWide(),pnl:GetTall())
					content.slidebg = slidebg
					slidebg:SetPos(0,-slidebg:GetTall())
					slidebg:MoveTo(0,0,emenu.config.animtime,0,-1,function() end)
					slidebg:SetText("")
					local bgcol = Color(13,13,13,200)
					function slidebg:Paint(w,h)
						surface.SetDrawColor(bgcol:Unpack())
						surface.DrawRect(0,0,w,h)
					end

					function slidebg:Close()
						self:MoveTo(self:GetX(),-self:GetTall(),emenu.config.animtime)
					end
					function slidebg:DoClick()
						self:Close()
					end
					function slidebg:DoRightClick()
						self:DoClick()
					end

					local slide = vgui.Create("emenu.window",slidebg)
					local sizex,sizey = slidebg:GetWide()*0.7,slidebg:GetTall()
					content.slidebg.slide = slide
					slide:SetSize(sizex,sizey)
					slide:Center()
					slide:SetRoundSize(0)
					slide:SetDraggable(false)
					slide:EnableMinimizeButton(false)
					slide:SetTitleColor(job.color)
					slide:SetTitle(job.name,emenu.util.TextColMustDark(job.color) and emenu.colors.default.black or emenu.colors.default.white)
					local bgcol = emenu.util.color:Set(job.color,"a",100)
					function slide:PaintBG(w,h)
						surface.SetDrawColor(emenu.colors.jobs.jobselbg:Unpack())
						surface.DrawRect(0,0,w,h)

						local halfw,halfh = w*0.5,h*0.5
						emenu.util:DrawMaterialRotated(w*0.5,h*0.5,h,w,90,bgcol,emenu.Materials["gradient"])
					end
					function slide:Close() slidebg:Close() end


					local model = job.model

					local modelpanel = slide:Add("DModelPanel")
					modelpanel:SetWide(slide:GetWide()*0.5)
					modelpanel:Dock(LEFT)
					modelpanel:InvalidateParent(true)
					modelpanel:SetModel(istable(model) and model[1] or model)
					modelpanel:SetFOV(28)
					if IsValid(modelpanel.Entity) then
						modelpanel.Entity:SetAngles(Angle(0, 60, 0))
						modelpanel.Entity:SetPos(Vector(0, 0, -5))
					end
					local defaultfov = modelpanel:GetFOV()
					function modelpanel:LayoutEntity(ent)
						if not IsValid(ent) then return end
						if self.mouseinput then
							modelpanel:SetCursor("blank")
							local mx,my = input.GetCursorPos()
							local x,y = self:LocalToScreen()
							local w,h = self:GetSize()
							local suspension = self:GetFOV() / defaultfov

							local deltax = self.mousex - mx
							local ang = ent:GetAngles()
							ang.y = ang.y - (deltax*0.2*suspension)
							ent:SetAngles(ang)
							self.mousex = mx

							local deltay = self.mousey - my
							local pos = ent:GetPos()
							pos.z = math.Clamp(pos.z + (deltay*0.05*suspension),-50,50)
							ent:SetPos(pos)
							self.mousey = my

							-- X
							local newx = mx
							if mx > x+w then 
								newx = x
								self.mousex = newx
							elseif mx < x then
								newx = x+w
								self.mousex = newx
							end

							-- Y
							local newy = my
							if my > y+h then
								newy = y
								self.mousey = newy
							elseif my < y then
								newy = y+h
								self.mousey = newy
							end
							input.SetCursorPos(newx,newy)
						else
							modelpanel:SetCursor("cursor")
						end
					end
					function modelpanel:OnMousePressed()
						local posx,posy = input.GetCursorPos()
						self.mouseinput = true
						self.mousex, self.mousey = posx, posy
						self.startx,self.starty = posx,posy
						self:MouseCapture(true)
					end
					function modelpanel:OnMouseReleased()
						self.mouseinput = nil
						self:MouseCapture(false)
						if self.startx and self.starty then
							input.SetCursorPos(self.startx, self.starty)
						end
					end
					function modelpanel:OnMouseWheeled(dlta)
						self:SetFOV(math.Clamp(self:GetFOV()-dlta, 1, 90) )
					end
					
					local desc = modelpanel:Add("DPanel")
					desc:SetHeight(modelpanel:GetTall()*0.1)
					desc:Dock(BOTTOM)
					desc:InvalidateParent(true)
					desc.seq = 1
					function desc:Paint(w,h)
						surface.SetDrawColor(emenu.colors.jobs.jobselbg2:Unpack())
						surface.DrawRect(0,0,w,h)
						draw.SimpleText("Model","emenu_20_500",w*0.5,5,emenu.colors.jobs.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
						if istable(model) then
							draw.SimpleText(self.seq.." / "..#model,"emenu_30_500",w*0.5,30,emenu.colors.jobs.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)

							surface.SetDrawColor(job.color:Unpack())
							surface.DrawRect(0,0,w*(self.seq / #model),3)
						else
							draw.SimpleText("1 / 1","emenu_30_500",w*0.5,30,emenu.colors.jobs.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
						end
					end

					local activebuttons = false
					if istable(model) then
						if #model ~= 1 then
							activebuttons = true
						end
					end

					local next = desc:Add("DButton")
					next:SetWide(desc:GetWide()*0.3)
					next:Dock(RIGHT)
					next:SetText("")
					function next:DoClick()
						if activebuttons then
							if desc.seq + 1 > #model then 
								desc.seq = 1
							else
								desc.seq = desc.seq + 1
							end
							if IsValid(modelpanel.Entity) then
								local oldpos = modelpanel.Entity:GetPos()
								local oldang = modelpanel.Entity:GetAngles()
								modelpanel:SetModel(model[desc.seq])
								if IsValid(modelpanel.Entity) then
									modelpanel.Entity:SetPos(oldpos)
									modelpanel.Entity:SetAngles(oldang)
								end
							else
								modelpanel:SetModel(model[desc.seq])
							end
						end
					end
					function next:Paint(w,h)
						local hovered = self:IsHovered()
						local wide = math.min(28,h*0.5-4)
						emenu.util:DrawMaterialRotated(w*0.5,h*0.5,wide,wide,0,hovered and emenu.colors.jobs.texthover or emenu.colors.jobs.text,emenu.Materials["next"])
					end

					local prev = desc:Add("DButton")
					prev:SetWide(desc:GetWide()*0.3)
					prev:Dock(LEFT)
					prev:SetText("")
					function prev:DoClick()
						if activebuttons then
							if desc.seq - 1 < 1 then 
								desc.seq = #model
							else
								desc.seq = desc.seq - 1
							end
							if IsValid(modelpanel.Entity) then
								local oldpos = modelpanel.Entity:GetPos()
								local oldang = modelpanel.Entity:GetAngles()
								modelpanel:SetModel(model[desc.seq])
								if IsValid(modelpanel.Entity) then
									modelpanel.Entity:SetPos(oldpos)
									modelpanel.Entity:SetAngles(oldang)
								end
							else
								modelpanel:SetModel(model[desc.seq])
							end
						end
					end
					function prev:Paint(w,h)
						local hovered = self:IsHovered()
						local wide = math.min(28,h*0.5-4)
						emenu.util:DrawMaterialRotated(w*0.5,h*0.5,wide,wide,180,hovered and emenu.colors.jobs.texthover or emenu.colors.jobs.text,emenu.Materials["next"])
					end

					local top = slide:Add("DPanel")
					top:SetHeight(slide:GetTall()*0.25)
					top:Dock(TOP)
					top:InvalidateParent(true)
					local font = "emenu_30_500"
					local offset = draw.GetFontHeight(font)+10
					function top:Paint(w,h)
						draw.SimpleText(emenu.text["tags"],font,w*0.5,5,emenu.colors.jobs.text,TEXT_ALIGN_CENTER)
					end
					local ranklist = top:Add("DIconLayout")
					ranklist:SetSize(top:GetWide(),top:GetTall()-offset)
					ranklist:SetPos(0,offset)
					ranklist:SetSpaceX(3)
					ranklist:SetSpaceY(3)
					ranklist:SetBorder(3)
					local font = "emenu_20_500"
					function ranklist:AddTag(tag)
						if not isstring(tag) then return end
						local textsize = emenu.util.GetTextSize(tag,font)
						local rankp = ranklist:Add("DPanel")
						rankp:SetSize(textsize.w+20,textsize.h+6)
						local mustdark = emenu.util.TextColMustDark(job.color)
						function rankp:Paint(w,h)
							draw.RoundedBox(8,0,0,w,h,job.color)
							draw.SimpleText(tag,font,w*0.5,h*0.5,mustdark and emenu.colors.text.dark or emenu.colors.text.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						end
					end

					--ADMIN
					if job.admin then
						if job.admin > 0 then
							ranklist:AddTag(emenu.text["admin"].." "..emenu.text["job"])
						end
					end

					--CATEGORY
					if job.category then
						ranklist:AddTag(job.category)
					end

					--LEVEL
					if job.level then
						ranklist:AddTag(emenu.text["level"]..": "..job.level)
					end

					--SALARY
					if job.salary then
						if job.salary > 0 then
							ranklist:AddTag(emenu.text["salary"]..": "..DarkRP.formatMoney(job.salary))
						end
					end

					if job.vote then
						ranklist:AddTag(emenu.text["need_vote"])
					end

					--RANKS
					if job.ranks then
						if istable(job.ranks) then
							for rank, rank2 in pairs(job.ranks) do
								if isstring(rank2) then
									ranklist:AddTag(rank2)
								else
									ranklist:AddTag(rank)
								end
							end
						else
							ranklist:AddTag(job.ranks)
						end
					end

					local bott = slide:Add("DPanel")
					bott:SetHeight(modelpanel:GetTall()*0.1)
					bott:Dock(BOTTOM)
					bott:InvalidateParent(true)
					function bott:Paint(w,h)
						surface.SetDrawColor(emenu.colors.jobs.jobselbg2:Unpack())
						surface.DrawRect(0,0,w,h)
					end

					local become = bott:Add("DButton")
					become:SetSize(bott:GetWide()*0.5,bott:GetTall()*0.8)
					become:Center()
					become:SetText("")
					local mustdark = emenu.util.TextColMustDark(job.color)
					become.hovercolor = emenu.util.color:Adjust(job.color,-30)
					function become:Paint(w,h)
						local hover = self:IsHovered()
						draw.RoundedBox(h*0.5,0,0,w,h,hover and self.hovercolor or job.color)
						draw.SimpleText(emenu.text["become"],"emenu_24_500",w*0.5,h*0.5,mustdark and emenu.colors.text.dark or emenu.colors.text.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					end
					function become:DoClick()
						local active = true
						local notify = job.CustomCheckFailMsg or emenu.text["err_norights"]

						if (ply:Team() == job.team) or not customcheck or not rankcheck then
							active = false
						end

						if maxcheck then
							active = false
							notify = emenu.text["err_noslots"]
						end

						if ply:Team() == job.team then
							active = false
							notify = emenu.text["err_already"]
						end

						if active then
							if istable(model) then
								DarkRP.setPreferredJobModel(job.team, model[desc.seq])
							end

							timer.Simple(0,function()
								if (job.vote or job.RequiresVote and job.RequiresVote(LocalPlayer(), job.team)) then
									RunConsoleCommand("darkrp", "vote" .. job.command)
								else
									RunConsoleCommand("darkrp", job.command)
								end
								slidebg:Close()
							end)
						else
							emenu:Notify(notify, 3)
						end
					end

					local docks = slide:Add("emenu.combolist")
					docks:SetAccentColor(job.color)
					docks:Dock(FILL)
					docks:InvalidateParent(true)

					docks:AddTab(emenu.text["description"],function(parent)
						local scroll = vgui.Create("emenu.scrollpanel",parent)
						scroll:SetSize(parent:GetWide(),parent:GetTall())

						local lbl = vgui.Create("DLabel",scroll)
						lbl:SetPos(0,10)
						lbl:SetSize(scroll:GetWide(),scroll:GetTall()-10)
						lbl:SetText(job.description)
						lbl:SetTextColor(emenu.colors.jobs.text)
						lbl:SetAutoStretchVertical(true)
						lbl:SetFont("emenu_18_500")
						lbl:SetWrap(true)
						return scroll
					end)

					if job.weapons then
						local show = true
						if istable(job.weapons) then
							if table.IsEmpty(job.weapons) then
								show = false
							end
						else
							job.weapons = {job.weapons}
						end

						if show then
							docks:AddTab(emenu.text["weapons"],function(parent)
								local scroll = vgui.Create("emenu.scrollpanel",parent)
								scroll:SetSize(parent:GetWide(),parent:GetTall())

								local list = vgui.Create("DIconLayout",scroll)
								list:SetSize(parent:GetWide(),parent:GetTall())
								list:SetBorder(3)
								list:SetSpaceY(3)

								local bgcol = emenu.util.color:Set(job.color,"a",100)
								local mustdark = emenu.util.TextColMustDark(bgcol)
								for _,weap in ipairs(job.weapons) do
									local pnl = vgui.Create("DPanel",list)
									pnl:SetSize(list:GetWide()-list:GetBorder()*2-list:GetSpaceX(),list:GetTall()*0.12)

									local swep = weapons.Get(weap)
									if not swep then swep = halflife2[weap] end
									if swep then
										local name = swep.PrintName
										local mdl = swep.WorldModel

										local modelpanel = pnl:Add("DModelPanel")
										modelpanel:SetSize(pnl:GetTall(),pnl:GetTall())
										modelpanel:SetPos(6)
										modelpanel:SetModel(mdl)
										modelpanel:SetMouseInputEnabled(false)
										modelpanel.LayoutEntity = function() end
										if (IsValid(modelpanel.Entity)) then
											local renn, renx = modelpanel.Entity:GetRenderBounds()
											local pos = 0
											pos = math.max(pos, math.abs(renn.x) + math.abs(renx.x))
											modelpanel:SetFOV(42)
											modelpanel:SetCamPos(Vector(pos, pos, pos))
											modelpanel:SetLookAt((renn + renx) * 0.5)
											modelpanel.Entity:SetPos(Vector(0, 0, 0))
										end

										function pnl:Paint(w,h)
											draw.RoundedBox(0,0,0,w,h,bgcol)
											draw.SimpleText(name,"emenu_20_500",6+modelpanel:GetWide()+5,h*0.5,mustdark and emenu.colors.text.dark or emenu.colors.text.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
										end
									else
										function pnl:Paint(w,h)
											draw.RoundedBox(0,0,0,w,h,bgcol)
											draw.SimpleText(emenu.text["unknown"],"emenu_20_500",w*0.5,h*0.5,mustdark and emenu.colors.text.dark or emenu.colors.text.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
										end
									end
								end

								return scroll
							end)
						end
					end

				end

				--------------------
				/// CONTEXT MENU ///
				--------------------
				function jobpan:DoRightClick()
					local context = vgui.Create("emenu.contextmenu",bg)
                	context:SetWide(bg:GetWide()*0.1)
                	context:AddHeader(emenu.text["actions"])
                	context:AddButton(emenu.text["become"],function()
                		if (job.vote or job.RequiresVote and job.RequiresVote(LocalPlayer(), job.team)) then
							RunConsoleCommand("darkrp", "vote" .. job.command)
						else
							RunConsoleCommand("darkrp", job.command)
						end
                	end,emenu.Materials["person"])

                	if job.favorite then
	                	context:AddButton(emenu.text["unfavorite"],function()
	                		emenu.jobs.favorite:Remove(job.team)
							pnl:UpdateList()
	                	end,emenu.Materials["like_filled"])
	                else
	                	context:AddButton(emenu.text["favorite"],function()
	                		emenu.jobs.favorite:Add(job.team)
							pnl:UpdateList()
	                	end,emenu.Materials["like"])
	                end

                	local posx,posy = input.GetCursorPos()
                	context:SetPosClamped(posx+5,posy+5)
				end
			end

			local categorycolor = emenu.util.color:Adjust(emenu.util.color:Average(jobcolors),10)
			if emenu.colors.jobs[category] ~= nil then
				categorycolor = emenu.colors.jobs[category]
			end
			function catpan:Paint(w,h)
				draw.SimpleText(category or "None","emenu_30_500",w*0.5,h*0.5,emenu.colors.jobs.text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end

			local bgcol = emenu.util.color:Set(categorycolor,"a",10)
			local posy = 5
			function categlist:Paint(w,h)

				surface.SetDrawColor(bgcol:Unpack())
				surface.DrawRect(0,posy,w,h)

				surface.SetDrawColor(categorycolor:Unpack())
				surface.DrawRect(0,posy,5,h)
			end
		end
	end
	CreateList()


	------------------------
	/// UPDATE FUNCTIONS ///
	------------------------
	local oldscroll = 0 
	function pnl:UpdateList()
		if not emenu:IsActive() then return end

		oldscroll = scroll:GetVBar():GetScroll()
		scroll:Clear()
		emenu.jobs:GenerateJobs()

		CreateList()

		scroll:Rebuild()
		timer.Simple(0.05, function()
			if IsValid(scroll) then
				scroll:GetVBar():SetScroll(oldscroll)
			end
		end)
		emenu.jobs.needupdate = false
	end

	function pnl:OnMinimize()
		if emenu.jobs.needupdate then
			scroll:SetAlpha(0)
			oldscroll = scroll:GetVBar():GetScroll()
			self:UpdateList()
		end
	end

	function pnl:OnMaximize()
		if emenu.jobs.needupdate then
			scroll:SetAlpha(255)
			self:UpdateList()
		else emenu.jobs.needupdate = false end
	end

	hook.Add("OnEMenuShow","emenu.job.onshow",function()
		hook.Remove("OnEMenuShow","emenu.job.onshow")
		if not IsValid(pnl) then return end
		pnl:OnMaximize()
	end)

	hook.Add("OnEMenuHide","emenu.job.onhide",function()
		hook.Remove("OnEMenuHide","emenu.job.onhide")
		if not IsValid(pnl) then return end
		pnl:OnMinimize()
	end)

	return pnl
end

--CHANGE TEAM
hook.Add("emenu_OnPlayerChangedTeam","emenu.jobs.JobChangeHook",function(ply,old,new)
	if ply == LocalPlayer() then
		AddRecentJob(old)

		local pnl = emenu.windows:GetActive(emenu.text["jobs"])
		timer.Simple(0.1,function()
			if IsValid(pnl) then
				pnl:UpdateList()
				if emenu.config.hide_jobchange then
					emenu:Hide()
				end
			end
		end)
    end
end)


emenu.windows:Register(emenu.text["jobs"], emenu.text["jobs_phrase"],emenu.Materials["person"],func,1)