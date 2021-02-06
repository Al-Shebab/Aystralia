	-- 130.6.19 DevNote {{ script_version_name }

	
	if party == nil then party = {} end					-- Don't Touch (allows for reloading config without restarting)

	
	party.buttoncolor = Color(100,100,100,200)			-- Invite/join request button color 
	party.buttonhovercolor = Color(255,0,0,200)			-- Invite/join request button color when hovered
	party.backgroundcolor = Color( 50, 50, 50, 255 )	-- Invite/join request background color  
	party.partymenubutton = KEY_F5						-- Key to assign the party menu to (nil  to disable)																
	party.fadediconsfadeamount = 50 					-- Recommend under 50 (reduce to make unused icons fadded out more then they are)
	party.halos = true         							-- Shows a halo around fellow party members
	party.hudverticalpos = 175							-- Up/down position of the hud (175 is a good spot for most agendas) (only first join setting, Does not change for all players when changed as players can set their own hud position)
	party.hudhorizontalpos = 10							-- Left/Right position of the hud from the left side(only first join setting, Does not change for all players when changed as players can set their own hud position)
	party.partychatcolr = Color(255,0,0,255) 			-- The color of [Party] in party chat									
	party.partychatmsgcolr = Color(0,255,255,255)		-- Color of the party message text										
	party.partychatnamecolr = Color(0,255,0,255)		-- Color of player name who sent party message							
	party.chatcommand = "!party"						-- Chat command to open party menu
	party.maxplayers = 4 								-- Maximum number of players per party, if you dont want to use this set really high
	party.joinrequestcooldown = 60 						-- Time between requests to join your party per players								
	party.invitecooldown	= 30						-- Time between invites from the party leader per player invited					
	party.partychatcommand = "/p"						-- Chat command used to chat with your party		
	party.defaultlowend		= false						-- If you would like to use circles at players feet instead of halos set to true (clients can choose this option but this will be the default value)	
	party.kickondisconnect = false						-- Kick a player from their party if they disconnect? 
	party.DarkrpGamemode = true							-- Is your gamemode derived from darkrp?
	party.ForceJobParty	= false							-- If this is set to false and the party.AutoGroupedJobs has teams then the players will recieve invites to those parties when they join the team instead of being placed in that party
	party.PartyDamage = true							-- Should party members be able to damage eachother
	party.KickBlacklistJobs = false						-- Kick players from their party if they join a job that is blacklisted from joining parties

	
    timer.Simple(0, function() --DO NOT TOUCH! This gives darkrp time to load before trying to add teams
		party.BlacklistJobs = {TEAM_HOBO32, TEAM_UGLYDUCK} -- Jobs that can NOT join parties
	end)

  
  
  
	-- PARTY GROUPS!
	
	party.AutoGroupedJobs = {}-- DONT TOUCH!
	timer.Simple(0, function()	--DO NOT TOUCH! This gives darkrp time to load before trying to add teams 
	--VVVVVVV Edit here VVVVVVVVV
	
		--party.AutoGroupedJobs[1] = {
		--Jobs = {"TEAM_HOBO, TEAM_MAYOR},
		--}																			-- Teams that will be given their own party seperated by groups
		
		--party.AutoGroupedJobs[2] = {Name = "Cops",                                -- Party name will automatically become the first team in each list or you can set it with the name option
		--Jobs = {TEAM_POLICE, TEAM_CHIEF},
		--}			
												
		--party.AutoGroupedJobs[4] = {nil}		-- ADD AS MANY GROUPS AS YOU WANT!
		
	end)
	
 
	
-- Language Stuff default is english
	party.language = {
	
	--Do not edit this side					-- Edit this side!
	-- Party Chat
	["[Party]"]								= "[Party] ",		--Chat Tag	
	--Menu
	["Invited to join a party"] 			= "Invited to join a party",
	["Has invited you to their party."] 	= "Has invited you to their party.",
	["Accept?"] 							= "Accept?",
	["YES"] 								= "YES",
	["NO"] 									= "NO",
	["Request To Join Your Party"] 			= "Request To Join Your Party",
	["Would like to join your party"] 		= "Would like to join your party",
	["Party Menu"] 							= "Party Menu",
	["Welcome to the party menu!"] 			= "Welcome to the party menu!",
	["An easy way for you to"] 				= "An easy way for you to",
	["team up with your friends!"] 			= "team up with your friends!",
	["Start Party"] 						= "Start Party",
	["WARNING!"] 							= "WARNING!",
	["By starting a new party"] 			= "By starting a new party",
	["you will be removed from"] 			= "you will be removed from",
	["your current party."]	 				= "your current party.",
	["Start A New Party"] 					= "Start A New Party",
	["Party Name"] 							= "Party Name",
	["Join Party"] 							= "Join Party",
	["Members"] 							= "Members",
	["Request Join"] 						= "Request Join",
	["Leave Party"] 						= "Leave Party",
	["By leaving your party"] 				= "By leaving your party",
	["you will no longer be protected"] 	= "you will no longer be protected",
	["from damage from"] 					= "from damage from",
	["your former party members."] 			= "your former party members.",
	["Leave Current Party"] 				= "Leave Current Party",
	["Manage Party"] 						= "Manage Party",
	["Kick From Party"] 					= "Kick From Party",
	["offline"] 							= "Offline",					--Also on hud
	["Invite To Party"] 					= "Invite To Party",
	["Players"] 							= "Players",
	["Settings"] 							= "Settings",
	["Color of party halo"] 				= "Color of party halo",
	["Lowend Halo"]							= "Disable Halos (FPS HOG)",
	["Admin"] 								= "Admin",
	["Disband Party"] 						= "Disband Party",
	["Parties"] 							= "Parties",
	
	--HUD
	["Party Name"] 							= "Party Name",
	["Alive"] 								= "Alive",
	["Dead"] 								= "Dead",
	["Disable Hud?"]						= "Disable Hud?",
	["Kick"]								= "Kick",
	-- Messages sent to clients from the server(in chatbox)	 
	["Maximum number of players in this party."]			= "Maximum number of players in this party.",
	["Please wait"]											= "Please wait",
	["seconds between party requests."]						= "seconds between party requests.",
	["seconds between party invites."]						= "seconds between party invites.",
	["accepted your party request."]						= "accepted your party request.",
	["declined your party request."]						= "declined your party request.",
	["accepted your party invite."]							= "accepted your party invite.",
	["declined your party invite."]							= "declined your party invite.",
	["kicked you from the party."]							= "kicked you from the party.",
	["disbanded your party."]								= "disbanded your party.",
	["You must be the same team!"]							= "You must be the same team!",
	["You are not allowed to join this party."]				= "You are not allowed to join this party.",
	["You are currently in a forced party, change jobs."] 	= "You are currently in a forced party, change jobs.",
	["You joined a job that is not allowed to be in a party. Kicking you from party"] = "You joined a job that is not allowed to be in a party. Kicking you from party"
}

-- French
--[[


--  Replace  bottom of config to translate to french
party.language = {
   
    --Do not edit this side                 -- Edit this side!
    -- Party Chat
    ["[Party]"]                             = "[Groupe] ",      --Chat Tag 
    --Menu
    ["Invited to join a party"]             = "Invité à rejoindre un groupe.",
    ["Has invited you to their party."]     = "vous a invité à rejoindre leur groupe.",
    ["Accept?"]                             = "Accepter?",
    ["YES"]                                 = "OUI",
    ["NO"]                                  = "NON",
    ["Request To Join Your Party"]          = "Demander à rejoindre un Groupe",
    ["Would like to join your party"]       = "Souhaiterait rejoindre votre Groupe",
    ["Party Menu"]                          = "Menu du Groupe",
    ["Welcome to the party menu!"]          = "Bienvenue sur le menu des Groupes!",
    ["An easy way for you to"]              = "Un moyen plus facile pour vous",
    ["team up with your friends!"]          = "de faire équipe avec vos amis!",
    ["Start Party"]                         = "Créer un Groupe",
    ["WARNING!"]                            = "ATTENTION!",
    ["By starting a new party"]             = "En créant un nouveau Groupe",
    ["you will be removed from"]            = "vous serez retiré de votre",
    ["your current party."]                 = "Groupe actuel.",
    ["Start A New Party"]                   = "Créer un nouveau Groupe",
    ["Party Name"]                          = "Nom du Groupe",
    ["Join Party"]                          = "Rejoindre ce Groupe",
    ["Members"]                             = "Membres",
    ["Request Join"]                        = "Demander à rejoindre",
    ["Leave Party"]                         = "Quitter ce Groupe",
    ["By leaving your party"]               = "En quittant ce groupe,",
    ["you will no longer be protected"]     = "vous ne serez plus à l'abri",
    ["from damage from"]                    = "des dégâts causés par",
    ["your former party members."]          = "les anciens membres de votre Groupe",
    ["Leave Current Party"]                 = "Quitter le Groupe actuel",
    ["Manage Party"]                        = "Gérer le Groupe",
    ["Kick From Party"]                     = "Ejecter du Groupe",
    ["offline"]                             = "Hors-Ligne",                 --Also on hud
    ["Invite To Party"]                     = "Inviter dans le Groupe",
    ["Players"]                             = "Joueurs",
    ["Settings"]                            = "Réglages",
    ["Color of party halo"]                 = "Couleur du Halo du Groupe",
    ["Lowend Halo"]                         = "Désactiver Halos (+IPS)",
    ["Admin"]                               = "Admin",
    ["Disband Party"]                       = "Dissoudre le Groupe",
    ["Parties"]                             = "Groupes",
   
    --HUD
    ["Party Name"]                          = "Nom du Groupe",
    ["Alive"]                               = "Vivant",
    ["Dead"]                                = "Mort",
    ["Disable Hud?"]                        = "Désactiver HUD?",
    ["Kick"]                                = "Exclure",
    -- Messages sent to clients from the server(in chatbox)  
    ["Maximum number of players in this party."]            = "Nombre maximum de joueurs dans ce Groupe.",
    ["Please wait"]                                         = "Veuillez patienter...",
    ["seconds between party requests."]                     = "secondes entre demandes de Groupe.",
    ["seconds between party invites."]                      = "secondes entre les invitations de Groupe.",
    ["accepted your party request."]                        = "a accepté votre demande de rejoindre le Groupe.",
    ["declined your party request."]                        = "a refusé votre demande de rejoindre le Groupe.",
    ["accepted your party invite."]                         = "a accepté l’invitation de rejoindre le Groupe.",
    ["declined your party invite."]                         = "a refusé l’invitation de rejoindre le Groupe.",
    ["kicked you from the party."]                          = "vous a éjecté du Groupe.",
    ["disbanded your party."]                               = "a dissous votre Groupe.",
    ["You must be the same team!"]                          = "Vous devez être dans la même équipe!",
    ["You are not allowed to join this party."]             = "Vous n'êtes pas autorisé a rejoindre ce Groupe.",
    ["You are currently in a forced party, change jobs."]   = "Vous êtes dans un Groupe forcé, changez de métier.",
}


]]

-- DO NOT TOUCH THIS OR YOU WILL BREAK THINGS

