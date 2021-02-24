-- RayHUD Owner: 76561198166995690
-- RayHUD Version: 1.1.3

RayHUD.Lang = {}

function RayHUD.GetPhrase(phrase)
	local lang = RayHUD.Cfg.Language

	if !RayHUD.Lang[lang] then
		lang = "english"
	end

	return RayHUD.Lang[lang][phrase] or "Missing: " .. (phrase)
end