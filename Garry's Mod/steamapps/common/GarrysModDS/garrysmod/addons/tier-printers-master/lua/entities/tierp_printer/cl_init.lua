include("shared.lua")
include("sh_tierprinters_config.lua")

-- Used to print chat notifications from the server
net.Receive( "opr_notification", function()
	chat.AddText( TierPrinters.Config.ChatPrefixColor, TierPrinters.Config.ChatPrefix..": ", Color( 255, 255, 255 ), net.ReadString() )
end )

-- All the fonts used
surface.CreateFont( "printer50", {
	font = "Calibri",
	size = 50,
	weight = 100
})
surface.CreateFont( "printer40", {
	font = "Calibri",
	size = 40,
	weight = 100
})
surface.CreateFont( "printer30", {
	font = "Calibri",
	size = 30,
	weight = 100
})
surface.CreateFont( "printer25", {
	font = "Calibri",
	size = 25,
	weight = 100
})
surface.CreateFont( "printer20", {
	font = "Calibri",
	size = 20,
	weight = 100
})
surface.CreateFont( "printer15", {
	font = "Calibri",
	size = 15,
	weight = 100
})


-- The function for blur panels
local blur = Material("pp/blurscreen")
local function blurPanel(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 6 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

-- The function to format money with ,
local function formatMoney(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

-- Caled for later used
local curtiercol

-- Draws all the 3D2D
function ENT:Draw()
	self:DrawModel()
	if LocalPlayer():GetPos():Distance( self:GetPos() ) > 500 then return end	
	-- Basic setups
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or "Disconnected"
	

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)

	cam.Start3D2D(Pos + Ang:Up()*30.1, Ang, 0.11)
		-- This is so that the interface has the same color theme as the current tier it is in. To keep things neat and looking clean/good.
		for k, v in pairs(TierPrinters.Config.Tiers) do
			if k == self:GetTier() then
				curtiercol = v.color
			end
		end


		-- Setting up the interactive 3D2D
		local tr = LocalPlayer():GetEyeTrace().HitPos
		local pos = self:WorldToLocal(tr)
		local backcolor = Color(0, 100, 160)
		local invisback = Color(0, 0, 0, 0)
		local pos = self:WorldToLocal(tr)

		-- This is the interactive 3D2D
		if pos.x < 30.662 and pos.x > 30.6031 and pos.y < 15.58 and pos.y > -0.63 and pos.z < 44.26 and pos.z > 41.03 then
			backcolor = curtiercol
			invisback = Color(0, 0, 0, 100)
		end

		-- The bac panel
		draw.RoundedBox(0, -15, -470, 170, 110, Color(70, 70, 70))

		-- The printers owner info
		draw.RoundedBox(0, -15, -470, 170, 30, curtiercol)
		draw.RoundedBox(0, -15, -470, 170, 30, Color(0, 0, 0, 100))
		draw.SimpleText(string.format(TierPrinters.Config.Language.Identity1, owner), "printer15", 68, -460, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.format(TierPrinters.Config.Language.Identity2), "printer15", 68, -450, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- Text to display the current holding mount of the printer
		draw.SimpleText(string.format(TierPrinters.Config.Language.CurrentHold1), "printer20", 68, -432, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.format(TierPrinters.Config.Language.CurrentHold2, formatMoney(self:GetMoney())), "printer20", 68, -417, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- The 3D2D button visuals
		draw.RoundedBox(4, -5, -402, 147, 30, backcolor)
		draw.RoundedBox(4, -5, -402, 147, 30, invisback)
		draw.SimpleText(TierPrinters.Config.Language.Access, "printer30", 68, -388, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

	-- This is for the battery life display
	-- Checks if the battery system is enabled
	if TierPrinters.Config.BatterySystem then
		local batterylife
		cam.Start3D2D(Pos + Ang:Up()*23.7, Ang, 0.11)
			-- Making the bar increase/decrease depending on the amount of battery left.
			batterylife = self:GetBattery() or 0
			draw.RoundedBox(0, -300, -220, 220, 20, Color(70, 70, 70))
			if batterylife != 0 then
				draw.RoundedBox(0, -295, -215, 210*batterylife/100, 10, Color(200, 0, 0))
			end
		cam.End3D2D()
	end
end

-- Changed the animation to start/stop printing
function ENT:Think()
	if self:GetBattery() == 0 then
		self:SetSkin(1)
	else
		self:SetSkin(0)
	end
end

-- The UI
net.Receive("opr_openui", function()
	-- Used for scaling text so that it all looks clean on every screen size
	local dermafont
	if ScrH() > 700 then
		dermafont = "printer50"
	elseif ScrH() > 600 then
		dermafont = "printer40"
	else
		dermafont = "printer25"
	end

	-- Used to rescale the box to allow for more panels depending on what is/isnt enabled in config. (Adding space for batter ect..)
	local frameheight
	local frameblocks
	if TierPrinters.Config.BatterySystem then
		frameheight = 0.75
		frameblocks = 5
	else
		frameheight = 0.5
		frameblocks = 4
	end

	-- Used to call live info about printer (Battery life, amount holding ect....)
	local printer = net.ReadEntity()

	-- the core frame of the UI
	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW()*0.5, ScrH()*frameheight)
	frame:Center()
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame:SetTitle("")
	-- Basic blur design
	frame.Paint = function( self, w, h )
		blurPanel(frame, 3)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
		draw.RoundedBox(0, 0, 0, w, 25, Color(40, 40, 40))
	end

	-- Custom close button
	local close = vgui.Create("DButton", frame)
	close:SetSize(25,25)
	close:SetPos(frame:GetWide()-25,0)
	close:SetText("")
	close.DoClick = function() frame:Close() end
	close.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(100,0,0))
		draw.SimpleText("X", "printer30", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- Because of both the grey bar and the gap of 5, it's easier to work with this as the master panel for content.
	local shell = vgui.Create("DPanel", frame)
	shell:SetSize(frame:GetWide()-10, frame:GetTall()-35)
	shell:SetPos(5, 30)
	shell.Paint = function() end

	-- The area for tiers
	local tiersshell = vgui.Create("DPanel", shell)
	tiersshell:SetSize(shell:GetWide()/4, shell:GetTall())
	tiersshell:SetPos(0, 0)
	tiersshell.Paint = function() end

	-- Creating a list panel for tiers
	local tiers = vgui.Create("DPanelList", tiersshell)
	tiers:SetSize(tiersshell:GetWide()+15, tiersshell:GetTall())
	tiers:SetPos(0, 0)
	tiers:SetSpacing(0)
	tiers:EnableHorizontal(false)
	tiers:EnableVerticalScrollbar(false)
	tiers.Paint = function() end

	-- Adding all the tiers
	for k, v in ipairs(TierPrinters.Config.Tiers) do
		-- Core tier frame
		local tierbut = vgui.Create("DButton", tiers)
		tiers:AddItem(tierbut)
		tierbut:SetSize(tiers:GetWide(), 70)
		tierbut:SetText("")

		-- Send an upgrade tier request. All checks are done server side to prevent exploits
		tierbut.DoClick = function()
			net.Start("opr_upgrade")
				net.WriteInt(k, 32)
				net.WriteEntity(printer)
			net.SendToServer()
		end

		-- Used for slide animation
		local tablerp = 0
		-- Painting the tiers
		tierbut.Paint = function(self, w, h)
			if not IsValid(printer) then frame:Close() return end

			-- The logics behind the animation
			if tierbut:IsHovered() then
				tablerp = Lerp(0.02, tablerp, w)
			else
				tablerp = Lerp(0.02, tablerp, 0)
			end
			if printer:GetTier() >= k then
				draw.RoundedBox(0, 0, 0, w, h, Color(v.color.r, v.color.g, v.color.b, 150))
			else 
				draw.RoundedBox(0, 0, 0, tablerp, h, Color(v.color.r, v.color.g, v.color.b, 150))
			end 

			-- Basic design stuff
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.SimpleText(string.format(TierPrinters.Config.Language.Tiers1, k), "printer30", w/2-5, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

			-- This is the math to present how much the grand total it to jump straigh to a specific tier. That way when chooses a tier, they know the gand total rather than just that tiers price.
			local charge = 0
			for n, m in ipairs(TierPrinters.Config.Tiers) do
				if not IsValid(printer) then frame:Close() end
				if !(n <= printer:GetTier()) then
					if !(n > k )then
						charge = charge + m.price
					end
				end
			end
			if charge == 0 then
				charge = TierPrinters.Config.Language.Tiers3
			else
				charge = string.format(TierPrinters.Config.Language.Tiers2, formatMoney(charge))
			end
			draw.SimpleText(charge, "printer30", w/2-5, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	end

	-- The shell for all the infomation
	local info = vgui.Create("DPanel", shell)
	info:SetSize(shell:GetWide()/4*3-5, shell:GetTall())
	info:SetPos(shell:GetWide()/4+5, 0)
	info.Paint = function() end

	-- Printer owners info
	local playerstat = vgui.Create("DPanel", info)
	playerstat:SetSize(info:GetWide(), shell:GetTall()/frameblocks-5)
	playerstat:SetPos(0, 0)
	local owner = printer:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or "Disconnected"
	playerstat.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		draw.SimpleText(string.format(TierPrinters.Config.Language.Identity1, owner), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(string.format(TierPrinters.Config.Language.Identity2), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	-- Current money being held
	local moneystat = vgui.Create("DPanel", info)
	moneystat:SetSize(info:GetWide(), shell:GetTall()/frameblocks-5)
	moneystat:SetPos(0, shell:GetTall()/frameblocks)
	moneystat.Paint = function(self, w, h)
		if not IsValid(printer) then frame:Close() return end
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		draw.SimpleText(string.format(TierPrinters.Config.Language.CurrentHold1), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(string.format(TierPrinters.Config.Language.CurrentHold2, formatMoney(printer:GetMoney()))..((TierPrinters.Config.Tiers[printer:GetTier()].limit and "/$"..formatMoney(TierPrinters.Config.Tiers[printer:GetTier()].limit)) or ""), dermafont, w/2, h/2, Color(100, 200, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	if TierPrinters.Config.ShowHealth then
		-- Current tier and income
		local tierstat = vgui.Create("DPanel", info)
		tierstat:SetSize(info:GetWide()/2-5, shell:GetTall()/frameblocks-5)
		tierstat:SetPos(0, shell:GetTall()/frameblocks*2)
		tierstat.Paint = function(self, w, h)
			if not IsValid(printer) then frame:Close() return end
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.SimpleText(string.format(TierPrinters.Config.Language.Tiers1, printer:GetTier()), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(string.format(TierPrinters.Config.Language.Tiers2, TierPrinters.Config.Tiers[printer:GetTier()].amount), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	
		-- Current health
		local tierhealth = vgui.Create("DPanel", info)
		tierhealth:SetSize(info:GetWide()/2, shell:GetTall()/frameblocks-5)
		tierhealth:SetPos(info:GetWide()/2, shell:GetTall()/frameblocks*2)
		tierhealth.Paint = function(self, w, h)
			if not IsValid(printer) then frame:Close() return end
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.SimpleText(string.format(TierPrinters.Config.Language.Health1), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(string.format(TierPrinters.Config.Language.Health2, printer:GetCHealth()), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	else
		-- Current tier and income
		local tierstat = vgui.Create("DPanel", info)
		tierstat:SetSize(info:GetWide(), shell:GetTall()/frameblocks-5)
		tierstat:SetPos(0, shell:GetTall()/frameblocks*2)
		tierstat.Paint = function(self, w, h)
			if not IsValid(printer) then frame:Close() return end
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.SimpleText(string.format(TierPrinters.Config.Language.Tiers1, printer:GetTier()), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(string.format(TierPrinters.Config.Language.Tiers2, TierPrinters.Config.Tiers[printer:GetTier()].amount), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	end

	-- Battery panel
	-- Checks to see if battery system is enabled
	if TierPrinters.Config.BatterySystem then
		-- Reajusting panels and text depending on configs settings
		local batterytextaign
		if TierPrinters.Config.BatteryUI then
			batterytextaign = 4
		else
			batterytextaign = 2
		end

		-- current battery life
		local batterystat = vgui.Create("DPanel", info)
		batterystat:SetSize(info:GetWide(), shell:GetTall()/frameblocks-5)
		batterystat:SetPos(0, shell:GetTall()/frameblocks*3)
		batterystat.Paint = function(self, w, h)
			if not IsValid(printer) then frame:Close() return end
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.SimpleText(string.format(TierPrinters.Config.Language.Battery1), dermafont, w/batterytextaign, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(string.format(TierPrinters.Config.Language.Battery2, printer:GetBattery()), dermafont, w/batterytextaign, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		-- Checks if UI recharge is enabled
		if TierPrinters.Config.BatteryUI then
			-- The recharge button
			local batterybut = vgui.Create("DButton", batterystat)
			batterybut:SetSize(batterystat:GetWide()/2, batterystat:GetTall())
			batterybut:SetPos(batterystat:GetWide()/2,0)
			batterybut:SetText("")
			batterybut.DoClick = function() net.Start("opr_recharge") net.WriteEntity(printer) net.SendToServer() end
			batterybut.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 150, 150))
				draw.SimpleText(string.format(TierPrinters.Config.Language.Recharge1), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(string.format(TierPrinters.Config.Language.Recharge2, formatMoney(TierPrinters.Config.BatteryPrice)), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end
	end

	-- Withdraw button shell
	local withdrawpanel = vgui.Create("DPanel", info)
	withdrawpanel:SetSize(info:GetWide(), shell:GetTall()/frameblocks-5)
	withdrawpanel:SetPos(0, shell:GetTall()/frameblocks*(frameblocks-1))
	withdrawpanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end

	-- Withdraw button
	local withdraw = vgui.Create("DButton", withdrawpanel)
	withdraw:SetSize(withdrawpanel:GetWide(), withdrawpanel:GetTall())
	withdraw:SetPos(0,0)
	withdraw:SetText("")
	withdraw.DoClick = function()
		net.Start("opr_withdraw")
			net.WriteEntity(printer)
		net.SendToServer()
	end
	withdraw.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 100, 0))
		draw.SimpleText(string.format(TierPrinters.Config.Language.Withdraw), dermafont, w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

-- Notes are primarily for myself, secondary for other. Helps me keep stuff neat, and allows others to follow along. Spelling/typo errors may be present within the notes 