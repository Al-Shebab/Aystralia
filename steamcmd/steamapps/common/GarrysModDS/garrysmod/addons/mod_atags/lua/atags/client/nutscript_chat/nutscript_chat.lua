-- Override default chat types
local function initialize()
	
	do
		local chatType = 'ic'
		local data = nut.chat.classes[chatType]
		data.onChatAdd = function(speaker, text, anonymous)
			
			local color = data.onGetColor and data.onGetColor(speaker, text) or data.color
			local name = anonymous and L"someone" or hook.Run("GetDisplayedName", speaker, chatType) or (IsValid(speaker) and speaker:Name() or "Console")

			local tagPieces, textColor, nameColor = speaker:getChatTag()
			
			local packedParams = {}
			
			for k, v in pairs(tagPieces) do
				packedParams[#packedParams + 1] = v.color
				packedParams[#packedParams + 1] = v.name
			end
			
			if nameColor and nameColor != "" then
				packedParams[#packedParams + 1] = nameColor
			elseif ATAG.Gamemode_TeamColor then
				packedParams[#packedParams + 1] = GAMEMODE:GetTeamColor(ply)
			end
			packedParams[#packedParams + 1] = name
			
			local splitText = (L2(chatType.."Format", "\n", text) or string.format(data.format, "\n", text)):Split("\n")
			packedParams[#packedParams + 1] = splitText[1]
			packedParams[#packedParams + 1] = (textColor and textColor != "") and textColor or color
			packedParams[#packedParams + 1] = splitText[2]
			
			chat.AddText(unpack(packedParams))
		end
	end
	
	do
		local chatType = 'w'
		local data = nut.chat.classes[chatType]
		data.onChatAdd = function(speaker, text, anonymous)
			
			local color = data.onGetColor and data.onGetColor(speaker, text) or data.color
			local name = anonymous and L"someone" or hook.Run("GetDisplayedName", speaker, chatType) or (IsValid(speaker) and speaker:Name() or "Console")

			local tagPieces, textColor, nameColor = speaker:getChatTag()
			
			local packedParams = {}
			
			for k, v in pairs(tagPieces) do
				packedParams[#packedParams + 1] = v.color
				packedParams[#packedParams + 1] = v.name
			end
			
			if nameColor and nameColor != "" then
				packedParams[#packedParams + 1] = nameColor
			elseif ATAG.Gamemode_TeamColor then
				packedParams[#packedParams + 1] = GAMEMODE:GetTeamColor(ply)
			end
			packedParams[#packedParams + 1] = name
			
			local splitText = (L2(chatType.."Format", "\n", text) or string.format(data.format, "\n", text)):Split("\n")
			packedParams[#packedParams + 1] = splitText[1]
			packedParams[#packedParams + 1] = (textColor and textColor != "") and textColor or color
			packedParams[#packedParams + 1] = splitText[2]
			
			chat.AddText(unpack(packedParams))
		end
	end
	
	do
		local chatType = 'y'
		local data = nut.chat.classes[chatType]
		data.onChatAdd = function(speaker, text, anonymous)
			
			local color = data.onGetColor and data.onGetColor(speaker, text) or data.color
			local name = anonymous and L"someone" or hook.Run("GetDisplayedName", speaker, chatType) or (IsValid(speaker) and speaker:Name() or "Console")

			local tagPieces, textColor, nameColor = speaker:getChatTag()
			
			local packedParams = {}
			
			for k, v in pairs(tagPieces) do
				packedParams[#packedParams + 1] = v.color
				packedParams[#packedParams + 1] = v.name
			end
			
			if nameColor and nameColor != "" then
				packedParams[#packedParams + 1] = nameColor
			elseif ATAG.Gamemode_TeamColor then
				packedParams[#packedParams + 1] = GAMEMODE:GetTeamColor(ply)
			end
			packedParams[#packedParams + 1] = name
			
			local splitText = (L2(chatType.."Format", "\n", text) or string.format(data.format, "\n", text)):Split("\n")
			packedParams[#packedParams + 1] = splitText[1]
			packedParams[#packedParams + 1] = (textColor and textColor != "") and textColor or color
			packedParams[#packedParams + 1] = splitText[2]
			
			chat.AddText(unpack(packedParams))
		end
	end
	
	do
		local chatType = 'ooc'
		local data = nut.chat.classes[chatType]
		data.onChatAdd = function(speaker, text)
			
			local icon = "icon16/user.png"

			if (speaker:SteamID() == "STEAM_0:1:34930764") then
				icon = "icon16/script_gear.png"
			elseif (speaker:SteamID() == "STEAM_0:0:19814083") then
				icon = "icon16/gun.png"
			elseif (speaker:IsSuperAdmin()) then
				icon = "icon16/shield.png"
			elseif (speaker:IsAdmin()) then
				icon = "icon16/star.png"
			elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
				icon = "icon16/wrench.png"
			elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
				icon = "icon16/heart.png"
			end

			icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

			local tagPieces, textColor, nameColor = speaker:getChatTag()
			
			local packedParams = {}
			
			packedParams[#packedParams + 1] = icon
			packedParams[#packedParams + 1] = Color(255, 50, 50)
			packedParams[#packedParams + 1] = " [OOC] "
			
			for k, v in pairs(tagPieces) do
				packedParams[#packedParams + 1] = v.color
				packedParams[#packedParams + 1] = v.name
			end
			
			if nameColor and nameColor != "" then
				packedParams[#packedParams + 1] = nameColor
			elseif ATAG.Gamemode_TeamColor then
				packedParams[#packedParams + 1] = Color(255, 50, 50)
			end
			packedParams[#packedParams + 1] = speaker:Nick()
			
			packedParams[#packedParams + 1] = color_white
			packedParams[#packedParams + 1] = ": "..text
			
			chat.AddText(unpack(packedParams))
		end
	end
	
	do
		local chatType = 'looc'
		local data = nut.chat.classes[chatType]
		data.onChatAdd = function(speaker, text)
			
			local tagPieces, textColor, nameColor = speaker:getChatTag()
			
			local packedParams = {}
			
			packedParams[#packedParams + 1] = Color(255, 50, 50)
			packedParams[#packedParams + 1] = "[LOOC] "
			
			for k, v in pairs(tagPieces) do
				packedParams[#packedParams + 1] = v.color
				packedParams[#packedParams + 1] = v.name
			end
			
			if nameColor and nameColor != "" then
				packedParams[#packedParams + 1] = nameColor
			elseif ATAG.Gamemode_TeamColor then
				packedParams[#packedParams + 1] = nut.config.get("chatColor")
			end
			packedParams[#packedParams + 1] = speaker:Nick()
			
			packedParams[#packedParams + 1] = nut.config.get("chatColor")
			packedParams[#packedParams + 1] = ": "..text
			
			chat.AddText(unpack(packedParams))
		end
	end
	
end

hook.Add("InitializedConfig", "aTags nutChatTypes", function()
	
	-- Add a small delay to it, to ensure NutScript initializes first
	timer.Simple(.1, initialize)
	
end)