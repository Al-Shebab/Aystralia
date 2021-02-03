-- FlatHUD Owner: 76561198166995690
-- FlatHUD Version: 1.1.1

FlatHUD.Lang = {}

function FlatHUD.GetPhrase(phrase)
	local lang = FlatHUD.Cfg.Language

	if !FlatHUD.Lang[lang] then
		lang = "english"
	end

	return FlatHUD.Lang[lang][phrase] or "Missing: " .. (phrase)
end