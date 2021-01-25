-- ╔═══╗───╔╗──────╔╗─╔╗────╔╗--
-- ║╔═╗║───║║──────║║─║║────║║--
-- ║║─╚╬╗─╔╣╚═╦══╦═╣╚═╝╠╗╔╦═╝║--
-- ║║─╔╣║─║║╔╗║║═╣╔╣╔═╗║║║║╔╗║--
-- ║╚═╝║╚═╝║╚╝║║═╣║║║─║║╚╝║╚╝║--
-- ╚═══╩═╗╔╩══╩══╩╝╚╝─╚╩══╩══╝--
-- ────╔═╝║──── By Mactavish ─--
-- ────╚══╝───── Hud Main ────--

local pp_tab = { 
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

local damage = 0
local surface, draw, math, Lerp = surface, draw, math, Lerp
local ply = LocalPlayer()

function CyberHud.VitalSigns()

	local health = ply:Health()	
	local maxhp = ply:GetMaxHealth()
	local glitchStart = false
	local glitchType = false
	
	if !Sndd then
		Sndd = CreateSound(ply, Sound("player/heartbeat1.wav"))
		Sndd:Play()
		Sndd:ChangeVolume(0, 0)
		Sndd:ChangePitch(100, 0)
	end
	
	if (health < maxhp * .3 and health > 0) then
		if CyberHud.Config.HeartBeat then
			Sndd:ChangePitch(120, 0)
			Sndd:ChangeVolume(0.7-(health/maxhp), 0)
		end
		glitchStart = true
		glitchType = (health/(maxhp * .3))
	else
		Sndd:ChangeVolume(0, 0)
		Sndd:ChangePitch(100, 0)
	end
	
	if health <= maxhp * .6 then
		
		if CyberHud.Config.ColorCor then
			pp_tab[ "$pp_colour_colour" ] =  math.Clamp(health/(maxhp * .6),0,1)
			DrawColorModify( pp_tab )
		end
		
		if CyberHud.Config.BloodStains then
			surface.SetDrawColor(255,255,255,200-(health/(maxhp * .6)*200))
			surface.SetMaterial(Material("cyberhud/blood.png"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
		end
		
		if damage > 1 and health > maxhp * .2 then
			damage = Lerp(3 * FrameTime(),damage,0)
			glitchStart = true
		end
		
	end
	
	return glitchStart, glitchType
end

local a_hp, b_hp, a_arm, a_hng, a_wallet = 0, 0, 0, 0, 0
local ahp, bhp = 0, 0
local flicker, hunger, old_money, c_money = 255, 0, 0, 0

function CyberHud.TopBar(x, y)
	
	local hp = ply:Health()
	local arm = ply:Armor()
	local maxhp = ply:GetMaxHealth()
	local hng = ply:getDarkRPVar( "Energy" )
	local money = ply:getDarkRPVar( "money" )
	
	if CyberHud.Config.HiddenWallet then
	
		if old_money != money then
			old_money = money
			a_wallet = 255
			c_money = CurTime() + 3
		end
		
		if a_wallet > 0 and c_money < CurTime() then
			a_wallet = Lerp(5 * FrameTime(),a_wallet, 0)
		end
		
	else
		if a_wallet < 255 then a_wallet = 255 end
	end
	
	if hng then
		hunger = 10
		a_hng = Lerp(5 * FrameTime(),a_hng, hng)
		a_hng = math.Clamp(a_hng,0,100)
		hng = a_hng/100 * 340
	else
		hunger = 0
	end
	
	flicker = math.random(100,150)
	
	if arm > 1 then
		a_arm = Lerp(5 * FrameTime(),a_arm, arm)
		a_arm = math.Clamp(a_arm,0,100)
		arm = a_arm/100 * 340
	end
	
	a_hp = Lerp(3 * FrameTime(),a_hp, hp)
	ahp = math.Clamp(a_hp,0,maxhp)
	ahp =  ahp / maxhp * 350
	
	if ahp > hp then
		b_hp = Lerp(2 * FrameTime(),b_hp, hp)
	else
		b_hp = Lerp(15 * FrameTime(),b_hp, hp)
	end
	
	bhp = math.Clamp(b_hp,0,maxhp)
	bhp =  bhp / maxhp * 350
	
	CyberHud.DrawBloomLines(x - 15, y - 8, 400, 30, CyberHud.Alpha(CyberHud.Patern["main_l"], 255 - flicker), "gr")
	CyberHud.DrawBloomLines(x+355,y-5, 50, 25, CyberHud.Alpha(CyberHud.Patern["sub_l"], 255 - flicker), "gr")
	CyberHud.DrawPoly(x,y,20,Color(120,55,55,200),350)
	
	CyberHud.DrawPolyMoving(x,y,20,CyberHud.Patern["main_d"],bhp,350)
	CyberHud.DrawPolyMoving(x,y,20,CyberHud.Patern["main_l"],ahp,350)
	CyberHud.DrawBloomLines(x, y, ahp, 25, Color(0,0,0, 200 - flicker), "rd")

	draw.RoundedBox(0, x, 20+y, 340, 6, CyberHud.Patern["bgr"])
	draw.RoundedBox(0, x, 20+y, arm, 5, CyberHud.Patern["sub_l"])
	
	if hunger > 0 then
		draw.RoundedBox(0, x, 30+y, 340, 6, CyberHud.Patern["bgr"])
		draw.RoundedBox(0, x, 30+y, hng, 5, CyberHud.Patern["hunger"])
	end
	
	if math.Round(ahp/3.5) != hp and math.Round(ahp/3.5) > hp then
		damage = 10
	end
	
	draw.SimpleTextOutlined(math.Round(ahp/3.5).."%", "CyberHud.Sub24", x+355,y+7, CyberHud.Patern["sub_l"], TEXT_ALIGN_LEFT, 1, 1, CyberHud.Patern["shadow"] )
	draw.SimpleTextOutlined(DarkRP.getPhrase("job", ply:getDarkRPVar( "job" )), "CyberHud.Main16", x,y-10, CyberHud.Patern["main_l"], TEXT_ALIGN_LEFT, 1, 1, CyberHud.Patern["shadow"] )
	
	draw.SimpleTextOutlined(DarkRP.getPhrase("wallet", DarkRP.formatMoney( money or 0 ).. " +".. DarkRP.formatMoney( ply:getDarkRPVar( "salary" ) or 0 ), ""), "CyberHud.Main16", x,y+45+hunger, CyberHud.Alpha(CyberHud.Patern["hunger"], a_wallet), TEXT_ALIGN_LEFT, 1, 1, CyberHud.Alpha(CyberHud.Patern["shadow"], a_wallet) )
	
	draw.NoTexture()
	
	for i = 0,10 do
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect( 20+x+(i*30), 28+y+hunger, 2, 5 )
		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect( 20+x+(i*30), 28+y+hunger, 1, 5 )
	end
	
	CyberHud.DrawStat(x+410, y-7, CyberHud.Patern["sub_l"], ply:getDarkRPVar("HasGunlicense"), "cyberhud/license.png")
	
	if ply:getDarkRPVar("wanted") then
		CyberHud.TextBox(x+24, y+65+hunger, 100, DarkRP.getPhrase("Wanted_text"), "align_left", "cyberhud/warning.png", 255 - math.sin( CurTime() * 5 ) * 200, CyberHud.Patern["red"])
	end
	
	if ply:getDarkRPVar("Arrested") then
		if ply.CyberHudInfo then
			CyberHud.TextBox(x+24, y+65+hunger, 100, DarkRP.getPhrase("youre_arrested", math.Clamp((ply.CyberHudInfo[1]+ply.CyberHudInfo[2])-CurTime(), 0, 99999)), "align_left", "cyberhud/warning.png", 255 - math.sin( CurTime() * 5 ) * 200, CyberHud.Patern["red"])
		else
			CyberHud.TextBox(x+24, y+65+hunger, 100, "You are arrested!", "align_left", "cyberhud/warning.png", 255 - math.sin( CurTime() * 5 ) * 200, CyberHud.Patern["red"])
		
		end
	end
	
end

local low_ammo = 0

function CyberHud.DrawWeaponSelection( x, y, alf)
	
	if alf < 1 then return end

	surface.SetDrawColor( CyberHud.Alpha(CyberHud.Patern["main_l"], alf) )
	surface.SetMaterial( Material("cyberhud/ui/line_10.png") )
	surface.DrawTexturedRectRotated( x+9, y-30, 160, 10, 90 )
	surface.SetMaterial( Material("cyberhud/ui/corner_50f.png") )
	surface.DrawTexturedRect( x, y-160, 50, 50 )
	
	for i = 0, 5 do
		local py = (32 * i)
		if i+1 == CyberHud.WPS.Slot then
			CyberHud.TextLineCustom(x+5, y-py, tostring(i+1), TEXT_ALIGN_LEFT, "CyberHud.Main36", alf)
		else
			CyberHud.TextLineCustom(x+5, y-py, tostring(i+1), TEXT_ALIGN_LEFT, "CyberHud.Main36", alf-200)
		end
	end
	
	if CyberHud.WPS.Slot > 0 and CurTime() > CyberHud.WPS.TimeOpen + 2 then return end
	
	local weps = CyberHud.WPS.Cashe[CyberHud.WPS.Slot]
	
	for i = 1, CyberHud.WPS.CasheLength[CyberHud.WPS.Slot] or 1 do
		
		if !IsValid(weps and weps[i]) then return end
		
		local name = weps[i]:GetPrintName()
		
		local py = (32 * i) + (32 * CyberHud.WPS.Slot) - 64
		
		if i == CyberHud.WPS.Pos then
			CyberHud.TextLineCustom(x+65, y-py+5, name, TEXT_ALIGN_LEFT, "CyberHud.Main16", alf)
		else
			CyberHud.TextLineCustom(x+65, y-py+5, name, TEXT_ALIGN_LEFT, "CyberHud.Main16", alf-200)
		end
		
	end
	
end

function CyberHud.DrawAmmoInfo(x, y, wep)
	
	if !CyberHud.Config.WeaponInfo then return end
	
	local clip = wep:Clip1() or 0
	local mag = wep:GetMaxClip1() or 1
	local maxammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
	
	if (wep:GetClass() == "weapon_physcannon") then return false end
	if not clip or clip < 0 then return false end
	
	if clip <= mag/100*30 then 
		low_ammo = math.sin( CurTime() * 7 ) * 200
	else
		low_ammo = 0
	end
	
	local w = CyberHud.TextLineCustom(x, y, clip, TEXT_ALIGN_LEFT, "CyberHud.Main36", 255-low_ammo)
	
	draw.SimpleTextOutlined(maxammo, "CyberHud.Main16", x + w + 25, y + 12, CyberHud.Alpha(CyberHud.Patern["main_l"], 100), TEXT_ALIGN_LEFT, 0, 1, CyberHud.Alpha(CyberHud.Patern["shadow"], 100) )
	
	return true
	
end

local show_wi, sel_show = false, false
local oldwep
local a_wep, a_sel = 0, 0

function CyberHud.DrawWeaponInfo(x, y)
	
	if !IsValid(ply:GetActiveWeapon()) then return end
	
	local wep = ply:GetActiveWeapon()
	
	if (!oldwep or wep != oldwep) and CyberHud.Config.WeaponInfo then
		a_wep = 500
		oldwep = wep
		show_wi = true
	end
	
	local name = wep.GetPrintName and wep:GetPrintName() or wep:GetClass() or "Unknown Weapon Name"
	
	if CyberHud.WPS.Slot > 0 then show_wi = true sel_show = true end
	
	if show_wi then 
		a_wep = Lerp(5 * FrameTime(),a_wep, 255)
	else
		a_wep = Lerp(5 * FrameTime(),a_wep, 0)
	end
	
	if sel_show then 
		a_sel = Lerp(5 * FrameTime(),a_sel, 255)
	else
		a_sel = Lerp(5 * FrameTime(),a_sel, 0)
	end
	
	if a_wep < a_sel then a_sel = a_wep end
	
	if a_wep < 1 and  a_sel < 1 then return end
	
	local w = CyberHud.TextBox(x+10, y+15, 0, name, "align_left", nil, a_wep)
	
	show_wi = CyberHud.DrawAmmoInfo(x+20+w, y, wep)
	
	surface.SetDrawColor( CyberHud.Alpha(CyberHud.Patern["main_l"], a_wep) )
	surface.SetMaterial( Material("cyberhud/ui/corner_50.png") )
	surface.DrawTexturedRect( x, y, 50, 50 )
	
	if w > 40 then
		surface.SetMaterial( Material("cyberhud/ui/line_10.png") )
		surface.DrawTexturedRect( x+50, y+38, w-40, 10 )
	end
	
	if (not ply:InVehicle() or ply:GetAllowWeaponsInVehicle()) and CurTime() < CyberHud.WPS.TimeOpen + 2 then
		sel_show = true
	else
		CyberHud.WPS.Slot = 0
		sel_show = false
	end
	
	CyberHud.DrawWeaponSelection(15, ScrH() - 115, a_sel)
end

function CyberHud.PlayerSwitchWeapon()
	show_wi = true
end

local as, ls = 0, 0

function CyberHud.DrawAmmo()
	CyberHud.DrawWeaponInfo(15, ScrH() - 65 )
end

local function DrawPlayerInfo(p)

	if !CyberHud.Config.EnablePlayerInfo then return end
	
	if p.FAdmin_GetGlobal and p:FAdmin_GetGlobal("FAdmin_cloaked") then return end
	
	local pos = p:EyePos()
	local sp = ply:GetShootPos()
	local hitp = p:GetPos()
	local tpp = hitp:Distance(sp)
	
	pos.z = pos.z + 10
	pos = pos:ToScreen()
	pos.y = pos.y - 55
	surface.SetFont("CyberHud.Main24")
	plynick = surface.GetTextSize( p:Nick() )
	local teamcl = CyberHud.Config.UseTeamColors and team.GetColor( p:Team() ) or false
	local eh = 0

	if tpp < 130 then 
		
		if CyberHud.Config.ShowPlayerJob then
			eh = 20
			draw.SimpleTextOutlined(p:getDarkRPVar( "job" ), "CyberHud.Main18", pos.x+10, pos.y-15, teamcl or CyberHud.Patern["main_l"],TEXT_ALIGN_CENTER, 0, 1, CyberHud.Patern["shadow"])
		end

		local w, h = CyberHud.TextLineCustom(pos.x, pos.y, p:Nick(), TEXT_ALIGN_CENTER, "CyberHud.Main24", 255, true, teamcl or CyberHud.Patern["main_l"])
		
		if p:getDarkRPVar("wanted") then
			CyberHud.TextBox(pos.x-20, pos.y-eh-20, 100, DarkRP.getPhrase("Wanted_text"), "align_left", "cyberhud/warning.png", 255 - math.sin( CurTime() * 5 ) * 200, CyberHud.Patern["red"])
		end
		
		draw.RoundedBox(0, pos.x-w/2+5, pos.y+h*2, w+15, 6, CyberHud.Patern["bgr"])
		draw.RoundedBox(0, pos.x-w/2+5, pos.y+h*2, math.Clamp(p:Health()/p:GetMaxHealth()*w+15,0,w+15), 5, CyberHud.Patern["red"])
		
		local ar = CyberHud.DrawStat(pos.x+w/2+30, pos.y+8, CyberHud.Patern["main_l"], p:getDarkRPVar("Arrested"), "cyberhud/cuffs.png")
		
		if !ar then
			CyberHud.DrawStat(pos.x+w/2+30, pos.y+8, CyberHud.Patern["main_l"], p:getDarkRPVar("HasGunlicense"), "cyberhud/license.png")
		end
		
		CyberHud.DrawStat(pos.x-w/2-30, pos.y+8, CyberHud.Patern["main_l"], p:IsSpeaking(), "cyberhud/speaker.png")
		CyberHud.DrawStat(pos.x-w/2-30, pos.y+8, CyberHud.Patern["main_l"], p:IsTyping(), "cyberhud/chat.png")
		
		if CyberHud.Config.DrawPlayerHalo then
			
			local dal = math.Clamp(550-(tpp*3.8+60),0,255)
		
			halo.Add( {p}, CyberHud.Alpha(CyberHud.Patern["main_l"],dal), 2, 2, 2, true, false )
			
		end
		
	end
	
end

function CyberHud.PlayerInfo()

	local sp = ply:GetShootPos()

	for k, p in pairs(player.GetAll()) do
	
		if !IsValid(p) or !p:Alive() or p == ply then continue end
		
		local hp = p:GetShootPos()

		if hp:Distance(sp) < 550 then
			local pos = hp - sp
			local trace = util.QuickTrace(sp, pos, ply)
			if trace.Hit and trace.Entity ~= p then return end
			DrawPlayerInfo(p)
		end
	end

end

function CyberHud.EntInfoFunction(door, x, y, nofade)

	local door_info = door:getDoorData()
	local title = door_info.title or ""
	local owner = door_info.owner and Player(door_info.owner)
	local coowners = door_info.extraOwners
	local allowed = door_info.allowedToOwn
	local groups = door_info.groupOwn or door_info.teamOwn
	local alpha = 0
	
	if nofade then 
		alpha = 255
	else
		alpha = math.Clamp( 255-ply:GetPos():Distance(door:GetPos())/200*255 , 0, 255)
	end

	if !groups or #groups <= 0 then
		
		draw.SimpleTextOutlined( title, "CyberHud.Main36", x, y-20, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )

		if owner then
		
			draw.SimpleTextOutlined( DarkRP.getPhrase("keys_owned_by"), "CyberHud.Main24", x, y+15, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )
			draw.SimpleTextOutlined( owner:Nick(), "CyberHud.Main24", x, y+45, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )
			
			local spc = 0
			local spc2 = 27
			
			if coowners then
				for ply, _ in pairs( coowners ) do
					draw.SimpleTextOutlined( Player(ply):Nick(), "CyberHud.Main24", x, y+70+spc, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2,CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )

					spc = spc+27
				end
			end
			
			if allowed then
				draw.SimpleTextOutlined( "Allowed to coown:", "CyberHud.Main24", x, y+70+spc, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )
			
				for ply, _ in pairs( allowed ) do
					draw.SimpleTextOutlined( Player(ply):Nick(), "CyberHud.Main24", x, y+70+spc+spc2, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2,CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )

					spc2 = spc2+27
				end
			end
			
			
			
		elseif !owner and !door:getKeysNonOwnable() then
		
			local title = string.Explode( "\n", DarkRP.getPhrase("keys_unowned"))
			
			draw.SimpleTextOutlined( title[1] and title[1] or "Unowned", "CyberHud.Main36", x, y+15, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )
			draw.SimpleTextOutlined( title[2] and title[2] or "", "CyberHud.Main16", x, y+55, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )
		
		end
		
	else
	
		if istable(groups) then
			
			local spc = 0
			
			for group, _ in pairs( groups ) do
				
				draw.SimpleTextOutlined( team.GetName(group), "CyberHud.Main24", x, y+50+spc, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )
				spc = spc+25
				
			end
			
		else
			draw.SimpleTextOutlined( groups, "CyberHud.Main24", x, y+50, CyberHud.Alpha(CyberHud.Patern["main_l"], alpha), TEXT_ALIGN_CENTER, 0, 2, CyberHud.Alpha(CyberHud.Patern["shadow"], alpha)  )
		end
		
	end 
	
	if CyberHud.Config.DrawDoorHalo then
		halo.Add( {door}, CyberHud.Alpha(CyberHud.Patern["main_l"],255), 2, 2, 2, true, false )
	end
	
end

function CyberHud.DrawEntInfo()
	
	local ent = ply:GetEyeTrace() and ply:GetEyeTrace().Entity
	
	if !ent or !IsValid( ent ) then CyberHud.DrawDoorInfoEnt = nil return end
	
	if ply:InVehicle() then return end
	
	if ply:GetPos():Distance( ent:GetPos() ) > 200 then return end
	
	
	if ent:IsVehicle() then
		CyberHud.EntInfoFunction(ent, ScrW()/2, ScrH()/2+ScrH()/4, true)
	elseif ent:GetClass() != "prop_vehicle_airboat" then
		CyberHud.DrawDoorInfoEnt = ent
	end
	
end

function CyberHud.DrawInfo()
	
	CyberHud.TopBar(15, 25)
	
	if GetGlobalBool("DarkRP_LockDown") then
		CyberHud.TitleBox(ScrW()-10, 15, 200, DarkRP.getPhrase("lockdown_started"), "align_right", "cyberhud/warning.png")
		ls = 36
	else
		ls = 0
	end
	
	if ply:getDarkRPVar("agenda") and ply:getDarkRPVar("agenda") != "" then
		local w = CyberHud.TextBox(ScrW()-10, 40+ls, 200, ply:getDarkRPVar("agenda"), "align_right")
		CyberHud.TitleBox(ScrW()-10, 15+ls, w, "agenda", "align_right")
		as = 58
	else
		as = 0
	end
	
	CyberHud.Spacing = as + ls
	
end