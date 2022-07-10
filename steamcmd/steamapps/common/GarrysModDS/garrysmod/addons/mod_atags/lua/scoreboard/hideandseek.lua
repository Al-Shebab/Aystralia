function ScoBShow()
	local specs = {}
	ScoBIsShowing = true
	ScoBBase = vgui.Create("DFrame")
	ScoBBase:SetPos(0,0)
	ScoBBase:SetSize(ScrW(),ScrH())
	ScoBBase:SetTitle("")
	ScoBBase:ShowCloseButton(false)
	ScoBBase:SetDraggable(false)
	if ScoBFocus then
		ScoBBase:MakePopup()
		ScoBBase:SetKeyBoardInputEnabled(false)
	end
	ScoBBase.Paint = function()
		draw.RoundedBox(0,0,0,ScoBBase:GetWide(),ScoBBase:GetTall(),Color(0,0,0,0))
	end
	ScoBHead = vgui.Create("DFrame",ScoBBase)
	ScoBHead:SetPos(ScrW()/2-400,80)
	ScoBHead:SetSize(800,40)
	ScoBHead:SetTitle("")
	ScoBHead:ShowCloseButton(false)
	ScoBHead:SetDraggable(false)
	ScoBHead.Paint = function()
		draw.RoundedBox(16,0,0,ScoBHead:GetWide(),ScoBHead:GetTall(),Color(0,0,0,200))
	end
	ScoBHeader1 = vgui.Create("DLabel",ScoBHead)
	ScoBHeader1:SetPos(612,6)
	ScoBHeader1:SetColor(Color(255,255,255,255))
	ScoBHeader1:SetFont("DermaLarge")
	ScoBHeader1:SetText("Hide and Seek")
	ScoBHeader1:SizeToContents()
	ScoBHeader2_1 = vgui.Create("DLabel",ScoBHead)
	ScoBHeader2_1:SetPos(12,5)
	ScoBHeader2_1:SetColor(Color(255,255,255,255))
	ScoBHeader2_1:SetFont("DermaDefault")
	ScoBHeader2_1:SetText(GetHostName())
	ScoBHeader2_1:SizeToContents()
	ScoBHeader2_2 = vgui.Create("DLabel",ScoBHead)
	ScoBHeader2_2:SetPos(12,20)
	ScoBHeader2_2:SetColor(Color(255,255,255,255))
	ScoBHeader2_2:SetFont("DermaDefault")
	ScoBHeader2_2:SetText(game.GetMap())
	ScoBHeader2_2:SizeToContents()
	ScoBHeader2_3 = vgui.Create("DLabel",ScoBHead)
	ScoBHeader2_3:SetPos(575,20)
	ScoBHeader2_3:SetColor(Color(255,255,255,255))
	ScoBHeader2_3:SetFont("DermaDefault")
	ScoBHeader2_3:SetText(has_ver)
	ScoBHeader2_3:SizeToContents()
	ScoBHeader2_4 = vgui.Create("DLabel",ScoBHead)
	ScoBHeader2_4:SetPos(495,20)
	ScoBHeader2_4:SetColor(Color(255,255,255,255))
	ScoBHeader2_4:SetFont("DermaDefault")
	ScoBHeader2_4:SetText(#player.GetAll().." / "..game.MaxPlayers())
	ScoBHeader2_4:SizeToContents()
	ScoBHeaderP_1 = vgui.Create("DImage",ScoBHead)
	ScoBHeaderP_1:SetPos(555,19)
	ScoBHeaderP_1:SetImage("icon16/server_uncompressed.png")
	ScoBHeaderP_1:SizeToContents()
	ScoBHeaderP_2 = vgui.Create("DImage",ScoBHead)
	ScoBHeaderP_2:SetPos(475,19)
	ScoBHeaderP_2:SetImage("icon16/status_offline.png")
	ScoBHeaderP_2:SizeToContents()
	ScoBHeaderSc = vgui.Create("DButton",ScoBHead)
	ScoBHeaderSc:SetSize(173,26)
	ScoBHeaderSc:SetPos(612,6)
	ScoBHeaderSc:SetText("")
	ScoBHeaderSc.Paint = function()
		draw.RoundedBox(0,0,0,ScoBHeaderSc:GetWide(),ScoBHeaderSc:GetTall(),Color(0,0,0,0))
	end
	ScoBHeaderSc.DoClick = function(DermaButton)
		RunConsoleCommand("has_help")
		surface.PlaySound("garrysmod/content_downloaded.wav")
		timer.Simple(0.1,function() ScoBHide() end)
	end
	ScoBHeaderSc.DoRightClick = function(DermaButton)
		timer.Destroy("ScoBRefresh")
		local ScoBHeadMenu = vgui.Create("DMenu",ScoBHead)
		ScoBHeadMenu:AddOption("Open Help",function()
			RunConsoleCommand("has_help")
			surface.PlaySound("garrysmod/content_downloaded.wav")
			timer.Simple(0.1,function() ScoBHide() end)
		end):SetImage("icon16/information.png")
		ScoBHeadMenu:AddOption("Open Options",function()
			RunConsoleCommand("has_options")
			surface.PlaySound("garrysmod/content_downloaded.wav")
			timer.Simple(0.1,function() ScoBHide() end)
		end):SetImage("icon16/cog_edit.png")
		ScoBHeadMenu:AddOption("Open Achievements",function()
			RunConsoleCommand("has_achievements")
			surface.PlaySound("garrysmod/content_downloaded.wav")
			timer.Simple(0.1,function() ScoBHide() end)
		end):SetImage("icon16/table.png")
		ScoBHeadMenu:AddSpacer()
		local sb,mb = ScoBHeadMenu:AddSubMenu("Sort")
			sb:AddOption("By EntityID",function()
				file.Write("hideandseek/scobsort.txt","0")
				timer.Create("ScoBRefresh",0.8,0,ScoBRefreshIt)
				surface.PlaySound("garrysmod/ui_return.wav")
			end):SetImage("icon16/brick.png")
			mb:SetImage("icon16/image_link.png")
			sb:AddOption("By Alphabetical",function()
				file.Write("hideandseek/scobsort.txt","1")
				timer.Create("ScoBRefresh",0.8,0,ScoBRefreshIt)
				surface.PlaySound("garrysmod/ui_return.wav")
			end):SetImage("icon16/font.png")
			sb:AddOption("By Score",function()
				file.Write("hideandseek/scobsort.txt","2")
				timer.Create("ScoBRefresh",0.8,0,ScoBRefreshIt)
				surface.PlaySound("garrysmod/ui_return.wav")
			end):SetImage("icon16/medal_gold_1.png")
		ScoBHeadMenu:Open()
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	
	local sorttab = player.GetAll()
	if file.Read("hideandseek/scobsort.txt","DATA") == "1" then
		table.sort(sorttab,function(a,b) return a:Name() < b:Name() end)
	elseif file.Read("hideandseek/scobsort.txt","DATA") == "2" then
		table.sort(sorttab,function(a,b) return a:Frags() > b:Frags() end)
	end
	local n = 0
	for k,v in pairs(sorttab) do
		if v:Team() != 3 then
			n = n+1
			local size = (team.NumPlayers(3) > 0 and n < 5) and 550 or 724
			local ScoBPly = vgui.Create("DFrame",ScoBBase)
			ScoBPly:SetPos(ScrW()/2-365,84+(38*n))
			ScoBPly:SetSize(size,36)
			ScoBPly:SetTitle("")
			ScoBPly:ShowCloseButton(false)
			ScoBPly:SetDraggable(false)
			ScoBPly.Think = function()
				local achflash = (math.sin(CurTime()*2.5)*12)+55
				local acol = (v.IsAchMaster == true) and Color(achflash,achflash*0.8,0,200) or Color(0,0,0,200)
				ScoBPly.Paint = function()
					draw.RoundedBox(4,0,0,ScoBPly:GetWide(),ScoBPly:GetTall(),acol)
				end
			end
			if v.IsAchMaster == true then
				for i=0,2 do
					local q = (i == 1) and 113 or 111
					local ScoBPlyAchh = vgui.Create("DImage",ScoBBase)
					ScoBPlyAchh:SetPos(ScrW()/2-352+(i*15),q+(38*n))
					ScoBPlyAchh:SetSize(9,9)
					ScoBPlyAchh:SetImage("icon16/star.png")
				end
			end
			local ScoBPlyA = vgui.Create("AvatarImage",ScoBPly)
			ScoBPlyA:SetSize(32,32)
			ScoBPlyA:SetPos(2,2)
			ScoBPlyA:SetPlayer(v,32)
			local ScoBPlyAB = vgui.Create("DButton",ScoBPly)
			ScoBPlyAB:SetSize(32,32)
			ScoBPlyAB:SetPos(2,2)
			ScoBPlyAB:SetText("")
			ScoBPlyAB.Paint = function()
				draw.RoundedBox(0,0,0,ScoBPlyAB:GetWide(),ScoBPlyAB:GetTall(),Color(0,0,0,0))
			end
			ScoBPlyAB.DoClick = function(DermaButton)
				v:ShowProfile()
				surface.PlaySound("garrysmod/content_downloaded.wav")
				timer.Simple(0.1,function() ScoBHide() end)
			end
			ScoBPlyAB.DoRightClick = function(DermaButton)
				timer.Destroy("ScoBRefresh")
				local ScoBPlyABMenu = vgui.Create("DMenu",ScoBPly)
				ScoBPlyABMenu:AddOption("Show Profile",function()
					v:ShowProfile()
					surface.PlaySound("garrysmod/content_downloaded.wav")
					timer.Simple(0.1,function() ScoBHide() end)
				end):SetImage("icon16/report_go.png")
				ScoBPlyABMenu:AddSpacer()
				if v:IsMuted() then
					ScoBPlyABMenu:AddOption("Unmute",function()
					v:SetMuted(false)
					timer.Create("ScoBRefresh",0.8,0,ScoBRefreshIt)
					surface.PlaySound("garrysmod/ui_return.wav")
					end):SetImage("icon16/sound.png")
				else
					ScoBPlyABMenu:AddOption("Mute",function()
					v:SetMuted(true)
					timer.Create("ScoBRefresh",0.8,0,ScoBRefreshIt)
					surface.PlaySound("garrysmod/ui_hover.wav")
					end):SetImage("icon16/sound_mute.png")
				end
				ScoBPlyABMenu:Open()
				surface.PlaySound("garrysmod/ui_click.wav")
			end
			local ScoBPlyN_1 = vgui.Create("DLabel",ScoBPly)
			ScoBPlyN_1:SetPos(40,4)
			if v:SteamID() == "STEAM_0:0:33106902" then ScoBPlyN_1:SetColor(Color(245,210,125,255)) else ScoBPlyN_1:SetColor(Color(255,255,255,255)) end
			ScoBPlyN_1:SetFont("DermaDefaultBold")
			ScoBPlyN_1:SetText(v:Name())
			ScoBPlyN_1:SizeToContents()
			local ScoBPlyN_2 = vgui.Create("DLabel",ScoBPly)
			ScoBPlyN_2:SetPos(40,18)
			ScoBPlyN_2:SetColor(Color(255,255,255,255))
			ScoBPlyN_2:SetFont("DermaDefault")
			ScoBPlyN_2:SetText("Score: "..v:Frags())
			ScoBPlyN_2:SizeToContents()
			local ScoBPlyN_3 = vgui.Create("DLabel",ScoBPly)
			ScoBPlyN_3:SetPos(ScoBPly:GetWide()-24,11)
			ScoBPlyN_3:SetColor(Color(255,255,255,255))
			ScoBPlyN_3:SetFont("DermaDefault")
			ScoBPlyN_3:SetText(v:Ping())
			ScoBPlyN_3:SizeToContents()
			local ScoBPlyP = vgui.Create("DImage",ScoBPly)
			ScoBPlyP:SetPos(ScoBPly:GetWide()-44,10)
			if v:Ping() > 5 then ScoBPlyP:SetImage("icon16/transmit_blue.png") else ScoBPlyP:SetImage("icon16/server_connect.png") end
			ScoBPlyP:SizeToContents()
			if v:GetFriendStatus() != "none" then
				local ScoBPlyPF = vgui.Create("DImage",ScoBPly)
				ScoBPlyPF:SetPos(ScoBPly:GetWide()-72,10)
				if v:GetFriendStatus() == "blocked" then ScoBPlyPF:SetImage("icon16/exclamation.png") else ScoBPlyPF:SetImage("icon16/user_add.png") end
				ScoBPlyPF:SizeToContents()
			end
			if v == LocalPlayer() then
				local ScoBPlyY = vgui.Create("DImage",ScoBPly)
				ScoBPlyY:SetPos(ScoBPly:GetWide()-72,10)
				ScoBPlyY:SetImage("icon16/asterisk_orange.png")
				ScoBPlyY:SizeToContents()
			end
			if v:IsMuted() then
				local ScoBPlyPM = vgui.Create("DImage",ScoBPly)
				ScoBPlyPM:SetPos(ScoBPly:GetWide()-100,10)
				ScoBPlyPM:SetImage("icon16/sound_mute.png")
				ScoBPlyPM:SizeToContents()
			end
			if LocalPlayer():Team() != 1 then
				local ScoBPlyPT = vgui.Create("DImage",ScoBPly)
				ScoBPlyPT:SetPos(255,10)
				if v:Team() == 1 then ScoBPlyPT:SetImage("icon16/flag_blue.png") end
				if v:Team() == 2 then ScoBPlyPT:SetImage("icon16/flag_red.png") end
				if v:Team() == 4 and LocalPlayer():Team() != 2 then ScoBPlyPT:SetImage("icon16/camera_delete.png") end
				ScoBPlyPT:SizeToContents()
			end
			
			-- a whole scoreboard in a single function :O
			local name, color = hook.Call( "aTag_GetScoreboardTag", nil, v )
			
			local sb_aTags = vgui.Create( "DLabel", ScoBPly )
			sb_aTags:SetColor( color or Color( 255, 255, 255, 255 ) )
			sb_aTags:SetText( name or "" )
			sb_aTags:SetFont( "DermaDefault" )
			sb_aTags:SizeToContents()
			sb_aTags:SetPos( ( ScoBPly:GetWide() * 0.70 ) - ( sb_aTags:GetWide() / 2 ), 11 )
			
		else
			table.insert(specs,v)
		end
	end
	if team.NumPlayers(3) > 0 then
		local ScoBSpec = vgui.Create("DFrame",ScoBBase)
		ScoBSpec:SetPos(ScrW()/2+187,122)
		ScoBSpec:SetSize(172,150)
		ScoBSpec:SetTitle("")
		ScoBSpec:ShowCloseButton(false)
		ScoBSpec:SetDraggable(false)
		ScoBSpec.Paint = function()
			draw.RoundedBox(4,0,0,ScoBSpec:GetWide(),ScoBSpec:GetTall(),Color(0,0,0,200))
		end
		local ScoBSpecP = vgui.Create("DImage",ScoBSpec)
		ScoBSpecP:SetPos(8,4)
		ScoBSpecP:SetImage("icon16/camera_go.png")
		ScoBSpecP:SizeToContents()
		local ScoBSpecT = vgui.Create("DLabel",ScoBSpec)
		ScoBSpecT:SetPos(30,4)
		ScoBSpecT:SetColor(Color(255,255,255,255))
		ScoBSpecT:SetFont("DermaDefaultBold")
		ScoBSpecT:SetText("Spectators:")
		ScoBSpecT:SizeToContents()
		for k,v in pairs(specs) do
			local y = 6+(k*16)
			local ScoBSpecPlyA = vgui.Create("AvatarImage",ScoBSpec)
			ScoBSpecPlyA:SetSize(14,14)
			ScoBSpecPlyA:SetPos(8,y)
			ScoBSpecPlyA:SetPlayer(v,16)
			local ScoBSpecPlyAB = vgui.Create("DButton",ScoBSpec)
			ScoBSpecPlyAB:SetSize(14,14)
			ScoBSpecPlyAB:SetPos(8,y)
			ScoBSpecPlyAB:SetText("")
			ScoBSpecPlyAB.Paint = function()
				draw.RoundedBox(0,0,0,ScoBSpecPlyAB:GetWide(),ScoBSpecPlyAB:GetTall(),Color(0,0,0,0))
			end
			ScoBSpecPlyAB.DoClick = function(DermaButton)
				v:ShowProfile()
				surface.PlaySound("garrysmod/content_downloaded.wav")
				timer.Simple(0.1,function() ScoBHide() end)
			end
			ScoBSpecPlyAB.DoRightClick = function(DermaButton)
				timer.Destroy("ScoBRefresh")
				local ScoBSpecPlyABMenu = vgui.Create("DMenu",ScoBPly)
				ScoBSpecPlyABMenu:AddOption("Show Profile",function()
					v:ShowProfile()
					surface.PlaySound("garrysmod/content_downloaded.wav")
					timer.Simple(0.1,function() ScoBHide() end)
				end):SetImage("icon16/report_go.png")
				ScoBSpecPlyABMenu:AddSpacer()
				if v:IsMuted() then
					ScoBSpecPlyABMenu:AddOption("Unmute",function()
					v:SetMuted(false)
					timer.Create("ScoBRefresh",0.8,0,ScoBRefreshIt)
					surface.PlaySound("garrysmod/ui_return.wav")
					end):SetImage("icon16/sound.png")
				else
					ScoBSpecPlyABMenu:AddOption("Mute",function()
					v:SetMuted(true)
					timer.Create("ScoBRefresh",0.8,0,ScoBRefreshIt)
					surface.PlaySound("garrysmod/ui_hover.wav")
					end):SetImage("icon16/sound_mute.png")
				end
				ScoBSpecPlyABMenu:Open()
				surface.PlaySound("garrysmod/ui_click.wav")
			end
			local ScoBSpecN = vgui.Create("DLabel",ScoBSpec)
			ScoBSpecN:SetPos(26,y)
			ScoBSpecN:SetColor(Color(255,255,255,255))
			ScoBSpecN:SetFont("DermaDefault")
			ScoBSpecN:SetText(v:Name())
			ScoBSpecN:SizeToContents()
		end
	end
end