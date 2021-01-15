AddCSLuaFile()
TOOL.Category = "Zeros OilRush"
TOOL.Name = "#OilSpot Spawner"
TOOL.Command = nil
TOOL.ConfigName = nil
TOOL.ClientConVar["radius"] = 1000

if (CLIENT) then
	language.Add("tool.zrush_oilspot_generator.name", "Zeros OilRush - OilSpot Generator")
	language.Add("tool.zrush_oilspot_generator.desc", "LeftClick: Creates OilSpot Generator. | RightClick: Creates single OilSpot. | Reload: Deletes Oilspot / Oilspot Generator")
	language.Add("tool.zrush_oilspot_generator.0", "LeftClick: Creates OilSpot Generator. | RightClick: Creates single OilSpot. | Reload: Deletes Oilspot / Oilspot Generator")
end

function TOOL:Reload(trace)
	if (trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return end

	if (trace.Entity:GetClass() == "zrush_oilspot_generator" or trace.Entity:GetClass() == "zrush_oilspot") then
		trace.Entity:Remove()
		zrush.f.Notify(self:GetOwner(), trace.Entity.PrintName .. " Removed!", 0)

		return true
	else
		return false
	end
end

function TOOL:LeftClick(trace)
	if (trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return end
	local tool_Radius = self:GetClientNumber("radius", 3)

	if (trace.Entity:GetClass() == "worldspawn") then
		--This prevents the creation of Spawner that are too close to others
		local ahzdistance
		local pos = trace.HitPos

		for a, b in pairs(ents.FindByClass("zrush_oilspot_generator")) do
			if not b:IsValid() then return end

			if pos:Distance(b:GetPos()) <= 100 then
				ahzdistance = true
				zrush.f.Notify(self:GetOwner(), "Too Close to other OilSpot Generator!", 1)
				break
			end
		end

		if ahzdistance then return false end
		local ent = ents.Create("zrush_oilspot_generator")
		if (not ent:IsValid()) then return end
		ent:SetPos(pos + Vector(0, 0, 1))
		ent:Spawn()
		ent:Activate()
		undo.Create("OilspotGenerator")
		undo.AddEntity(ent)
		undo.SetPlayer(self:GetOwner())
		undo.Finish()
		ent:SetSpawnRadius(tool_Radius)
		zrush.f.Notify(self:GetOwner(), "OilSpot Generator Created!", 0)

		return true
	elseif (trace.Entity:GetClass() == "zrush_oilspot_generator") then
		trace.Entity:SetSpawnRadius(tool_Radius)
		zrush.f.Notify(self:GetOwner(), "OilSpot Generator Updated!", 0)

		return true
	else
		return false
	end
end

function TOOL:RightClick(trace)
	if (trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return end

	if (trace.Entity:GetClass() == "worldspawn") then
		--This prevents the creation of Spawner that are too close to others
		local ahzdistance
		local pos = trace.HitPos

		for a, b in pairs(ents.FindByClass("zrush_oilspot")) do
			if not b:IsValid() then return end

			if pos:Distance(b:GetPos()) <= 100 then
				ahzdistance = true
				zrush.f.Notify(self:GetOwner(), "Too Close to other OilSpot!", 1)
				break
			end
		end

		if ahzdistance then return false end
		local ent = ents.Create("zrush_oilspot")
		if (not ent:IsValid()) then return end
		ent:SetPos(pos + Vector(0, 0, 1))
		ent:Spawn()
		ent:Activate()
		undo.Create("Oilspot")
		undo.AddEntity(ent)
		undo.SetPlayer(self:GetOwner())
		undo.Finish()
		zrush.f.Notify(self:GetOwner(), "OilSpot Created!", 0)

		return true
	else
		return false
	end
end


local function zrush_OptionPanel(name, CPanel, cmds)
	local panel = vgui.Create("DPanel")
	panel:SetSize(250 , 40 + (35 * table.Count(cmds)))
	panel.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zrush.default_colors["grey07"])
	end

	local title = vgui.Create("DLabel", panel)
	title:SetPos(10, 2.5)
	title:SetText(name)
	title:SetFont("zrush_settings_font01")
	title:SetSize(panel:GetWide(), 30)
	title:SetTextColor(zrush.default_colors["red05"])

	for k, v in pairs(cmds) do
		if v.class == "DNumSlider" then

			local item = vgui.Create("DNumSlider", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText(v.name)
			item:SetMin(v.min)
			item:SetMax(v.max)
			item:SetDecimals(v.decimal)
			item:SetDefaultValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
			item:ResetToDefaultValue()

			item.OnValueChanged = function(self, val)

				if (not Created) then
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
				end
			end)
		elseif v.class == "DCheckBoxLabel" then

			local item = vgui.Create("DCheckBoxLabel", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( v.name )
			item:SetConVar( v.cmd )
			item:SetValue(0)
			item.OnChange = function(self, val)

				if (not Created) then
					if ((val and 1 or 0) == cvars.Number(v.cmd)) then return end
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(GetConVar(v.cmd):GetInt())
				end
			end)
		elseif v.class == "DButton" then
			local item = vgui.Create("DButton", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( "" )
			item.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zrush.default_colors["grey02"])
				draw.SimpleText(v.name, "zrush_settings_font02", w / 2, h / 2, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if s.Hovered then
					draw.RoundedBox(5, 0, 0, w, h, zrush.default_colors["white05"])
				end
			end
			item.DoClick = function()

				if zrush.f.IsAdmin(LocalPlayer()) == false then return end

				LocalPlayer():EmitSound("zrush_ui_click")

				if v.notify then

					notification.AddLegacy(  v.notify, NOTIFY_GENERIC, 2 )
				end
				LocalPlayer():ConCommand( v.cmd )
			end
		end
	end

	CPanel:AddPanel(panel)
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {
		Text = "#tool.zrush_oilspot_generator.name",
		Description = "#tool.zrush_oilspot_generator.desc"
	})

	zrush_OptionPanel("OilSpots",CPanel,{
		[1] = {name = "Radius",class = "DNumSlider", cmd = "zrush_oilspot_generator_radius",min = 500,max = 3000,decimal = 0},
		[2] = {name = "Save",class = "DButton", cmd = "zrush_publicents_save"},
		[3] = {name = "Restart Oilspot Generators",class = "DButton", cmd = "zrush_restartgog"},
	})
end
