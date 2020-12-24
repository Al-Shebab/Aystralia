TOOL.Category = "#tool.crash.category"
TOOL.Name = "#tool.casinocrash.name"
TOOL.ClientConVar["scale"] = 1
TOOL.nextUse = CurTime()

function TOOL:LeftClick(trace)
	--check rank and shit
	if not self:GetOwner():IsValid() then return end
	if self.nextUse > CurTime() then return end

	if not self:GetOwner():IsSuperAdmin() then
		if CLIENT then
			chat.AddText("Only super administrators can access this tool!")
			self.nextUse = CurTime() + 0.5
		end

		return
	end

	if SERVER then
		file.CreateDir'crash_casino'

		if not file.Exists('crash_casino/' .. string.lower(game.GetMap()) .. '.txt', 'DATA') then
			local __vector = trace.HitPos
			local __angle = trace.HitNormal:Angle()
			local __scale = self:GetClientNumber("scale", 1)

			local __table = {
				[0] = {
					["vector"] = __vector,
					["angle"] = __angle,
					["scale"] = __scale
				}
			}

			file.Write("crash_casino/" .. string.lower(game.GetMap()) .. ".txt", util.TableToJSON(__table))
		else
			local __locations = file.Read("crash_casino/" .. string.lower(game.GetMap()) .. ".txt", "DATA")
			local __table = util.JSONToTable(__locations)
			local __vector = trace.HitPos
			local __angle = trace.HitNormal:Angle()
			local __scale = self:GetClientNumber("scale", 1)

			__table[table.Count(__table)] = {
				["vector"] = __vector,
				["angle"] = __angle,
				["scale"] = __scale
			}

			file.Write("crash_casino/" .. string.lower(game.GetMap()) .. ".txt", util.TableToJSON(__table))
		end

		Casino_Crash.FetchRenderingTable(self:GetOwner())

		net.Start('Casino_Crash.Notify')
		net.WriteString('Location successfully added!')
		net.Send(self:GetOwner())
		self.nextUse = CurTime() + 0.5
	end
end

function TOOL:RightClick(trace)

	if self.nextUse > CurTime() then return end
	if not trace.Entity:IsValid() or not trace.Entity:GetClass() == "sent_crash" then return end

	self.nextUse = CurTime( ) + 0.5


	if not SERVER then return end

	function temp_rem( tab )
		if not tab.Entities[1] or not tab.Entities[1]:IsValid() then return end		

		Casino_Crash.RemoveScreen( tab.Entities[1]:GetPos(), true )
	end

	--what the fuck :@
	local tab = {}
	tab.Owner = self:GetOwner( )
	tab.Name = "prop"
	tab.Entities = { trace.Entity }
	temp_rem( tab )

	undo.Do_Undo( tab )

	return
end

function TOOL:Reload(trace)
	if self.nextUse > CurTime() then return end

	if SERVER and self:GetOwner():IsSuperAdmin() then
		file.Write("crash_casino/" .. string.lower(game.GetMap()) .. ".txt", "[]")
		Casino_Crash.FetchRenderingTable()
	end

	self.nextUse = CurTime() + 0.5

	return true
end

hook.Add("PostDrawOpaqueRenderables", "KappaJ.PostDrawOpaqueRenderables.CasinoCrash.MAIN", function()
	if LocalPlayer():IsValid() and LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() then
		local _PlayerTool = LocalPlayer():GetTool()

		if LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" and _PlayerTool ~= nil and _PlayerTool["Mode"] == "casinocrash" then
			local scale = _PlayerTool:GetClientNumber("scale")
			local pos = LocalPlayer():GetShootPos()
			local ang = LocalPlayer():GetAimVector()
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos + (ang * 1024)
			tracedata.filter = LocalPlayer()
			local __trace = util.TraceLine(tracedata)
			cam.Start3D2D(__trace.HitPos + Vector(0, 0, 0), __trace.HitNormal:Angle() + Angle(90, 0, 0), 1) --add 1 to prevent flickering and such
			draw.RoundedBox(0, scaleX(-140 * scale / 2), scaleH(-260 * scale / 2), scaleX(140 * scale), scaleH(260 * scale), Color(255, 255, 255))
			cam.End3D2D()
		end
	end
end)

if (SERVER) then return end

TOOL.Information = {
	{
		name = "info",
		stage = 1
	},
	{
		name = "left"
	},
	{
		name = "right"
	},
	{
		name = "reload"
	}
}

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {
		Text = "#tool.casinocrash.desc",
		Description = "#tool.casinocrash.desc"
	})

	CPanel:AddControl("Slider", {
		Label = "#tool.crash.slider",
		Type = "Float",
		Min = 0.2,
		Max = 1,
		Command = "casinocrash_scale",
	})
end