local CURRENT = "1.1.5"

timer.Simple( 10, function()
    http.Fetch( "https://pastebin.com/raw/NZ4FRwfk",
        function( body, len, headers, code )
            if CURRENT != body then
                USEPICKUP:Debug( "An update is available!" )
            else
                USEPICKUP:Debug( "You are using the latest version." )
            end
        end,
        function( error )
            USEPICKUP:Debug( "Unable to check for a new version!" )
        end
    )
end )