/*---------------------------------------------------------------------------
	Metatable
---------------------------------------------------------------------------*/
local webhookMeta = {}
webhookMeta.__index = webhookMeta


/*---------------------------------------------------------------------------
	Setting data of the webhook
---------------------------------------------------------------------------*/
function webhookMeta.SetName(self, name)
	self.username = name
end

function webhookMeta.SetAvatar(self, avatar)
	self.avatarUrl = avatar
end


/*---------------------------------------------------------------------------
	Resetting data to Discord hook defaults
---------------------------------------------------------------------------*/
function webhookMeta.ResetName(self)
	self.username = nil
end

function webhookMeta.ResetAvatar(self)
	self.avatarUrl = nil
end

function webhookMeta.ResetProfile(self)
	self:ResetName()
	self:ResetAvatar()
end


/*---------------------------------------------------------------------------
	Sends a raw message to discord's webhook API.
---------------------------------------------------------------------------*/
function webhookMeta.Send(self, content)
	content.username = self.username
	content.avatar_url = self.avatarUrl
	content.sendURL = self.URL

	HTTP({
		url = "https://licensing.threebow.com/tdw/proxy",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json"
		},
		body = util.TableToJSON(content),
		success = function(code, body, headers)
			if(code == 400) then
				MsgC(Color(255, 0, 0, 255), "TDW: Sending Error: ", util.JSONToTable(body).message, "\n")
			elseif(TDW.Config.NotifySuccess && (code == 200 || code == 204)) then
				MsgC(Color(0, 255, 0, 255), "TDW: Sent Data to Discord\n")
			end
		end,
		failed = function(reason)
			MsgC(Color(255, 0, 0, 255), "TDW: HTTP Failed, this shouldn't happen - contact Threebow via support ticket.\n")
		end,
		type = "application/json"
	})
end


/*---------------------------------------------------------------------------
	Helper functions for easily sending various things
---------------------------------------------------------------------------*/
function webhookMeta.SendMessage(self, message)
	self:Send({content = message})
end

function webhookMeta.SendEmbed(self, embed)
	self:Send({embeds = {embed}})
end

function webhookMeta.SendAttachment(self, attachment)
	self:Send({files = {attachment}})
end


/*---------------------------------------------------------------------------
	Constructor
---------------------------------------------------------------------------*/
function TDW.CreateWebhook(url)
	return setmetatable({URL = url || TDW.Config.WebhookURL}, webhookMeta)
end