USEPICKUP.LANG = {}

function USEPICKUP.LANG:Register( name, tbl )
    self.Languages[name] = tbl
end

function USEPICKUP.LANG:Initialize()

    self.Languages = {}

    local files, directories = file.Find( "usepickup/lang/*.lua", "LUA" )

    for k, v in pairs( files ) do
        USEPICKUP.RESOURCES.AddShared( "lang/" .. string.StripExtension( v ) )
    end

    if self.Languages[USEPICKUP.Config.Language] then
        self.CurrentLanguage = self.Languages[USEPICKUP.Config.Language]
    else
        self.CurrentLanguage = self.Languages["english"] -- fallback                                                                                                                                                                                                                                                                                                                                                                76561207056203045
    end

end

function USEPICKUP.LANG:GetTranslation( sub, n )
    if !n then return "ERROR" end
    return self.CurrentLanguage[sub] and self.CurrentLanguage[sub][n] or "ERROR[T]:" .. n
end
