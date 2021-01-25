-- ╔═══╗───╔╗──────╔╗─╔╗────╔╗--
-- ║╔═╗║───║║──────║║─║║────║║--
-- ║║─╚╬╗─╔╣╚═╦══╦═╣╚═╝╠╗╔╦═╝║--
-- ║║─╔╣║─║║╔╗║║═╣╔╣╔═╗║║║║╔╗║--
-- ║╚═╝║╚═╝║╚╝║║═╣║║║─║║╚╝║╚╝║--
-- ╚═══╩═╗╔╩══╩══╩╝╚╝─╚╩══╩══╝--
-- ────╔═╝║──── By Mactavish ─--
-- ────╚══╝───────────────────--
-- ─────── Server Core ───────--

function CyberHud.Alert(text, ply)
	net.Start("CyberHud.Alert")
		net.WriteString(text)
	net.Send(ply)
end

net.Receive( "CyberHud.Alert", function()

	local text = net.ReadString()
	
	CyberHud.Alert(text)
	
end)

RunConsoleCommand("mp_show_voice_icons",0)

-- ────── Hooks for RP ───────--

hook.Add("playerArrested","CyberHud.playerArrested",function( s, t, w )

	if !IsValid(s) then return end
	
	net.Start("CyberHud.playerArrested")
		net.WriteFloat(t)
	net.Send(s)
	
end)

hook.Add("playerWanted","CyberHud.playerWanted", function( s, w, r )
	
	if !IsValid(s) then return end
	
	r = r or ""
	
	CyberHud.Alert( DarkRP.getPhrase("wanted_by_police", s:Name(), r, w:Name() ), player.GetAll() )
	
	return true
	
end)

hook.Add("playerUnWanted","CyberHud.playerUnWanted",function( s )

	if !IsValid(s) then return end
	
	CyberHud.Alert( DarkRP.getPhrase("wanted_expired", s:Name() ), player.GetAll() )
	
	return true

end)

hook.Add("playerWarranted","CyberHud.playerWarranted", function( s, w, r )

	if !IsValid(s) then return end
	
	r = r or ""

	CyberHud.Alert( DarkRP.getPhrase("warrant_approved", s:Name(), r, w:Name() ), w )
	CyberHud.Alert( DarkRP.getPhrase("warrant_approved", s:Name(), r, w:Name() ), s )
	
	return true

end)

local plm = FindMetaTable("Player")

local pmeta = FindMetaTable("Player")

pmeta.PrintMessageOld = pmeta.PrintMessageOld or pmeta.PrintMessage

function pmeta:PrintMessage(type, message)
	if type == HUD_PRINTCENTER then
		CyberHud.Alert( message, self )
	else
		self:PrintMessageOld(type, message)
	end
end