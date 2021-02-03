gProtect = gProtect or {}
gProtect.config = gProtect.config or {}

gProtect.config.Prefix = "[gProtect] "

gProtect.config.FrameSize = {x = 620, y = 450}

gProtect.config.SelectedLanguage = "en"

gProtect.config.StorageType = "file" --- (file, sql_local, mysql)

gProtect.config.EnableOwnershipHUD = true

gProtect.config.ConfigPermission = { 
	["owner"] = true,
	["superadmin"] = true
}

gProtect.config.NotifyStaffPermission = {
	["owner"] = true,
	["superadmin"] = true
}