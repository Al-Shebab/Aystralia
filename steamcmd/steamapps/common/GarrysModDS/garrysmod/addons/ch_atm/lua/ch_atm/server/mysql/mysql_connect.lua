local sql_isconnected

CH_ATM.Config.SQL_HOST = ""
CH_ATM.Config.SQL_USERNAME = ""
CH_ATM.Config.SQL_PASSWORD = ""
CH_ATM.Config.SQL_DATABASE = ""

--[[
	Connect to the SQL database of their choice when the gamemode is loaded.
--]]
function CH_ATM.ConnectDatabase()
	if not CH_ATM.Config.EnableSQL then
		return
	end
	
	if sql_isconnected then
		return
	end
	
	mysql:SetModule( "mysqloo" )
	mysql:Connect( CH_ATM.Config.SQL_HOST , CH_ATM.Config.SQL_USERNAME, CH_ATM.Config.SQL_PASSWORD, CH_ATM.Config.SQL_DATABASE, 3306 )
	
	sql_isconnected = true
end
hook.Add( "PostGamemodeLoaded", "CH_ATM.ConnectDatabase", CH_ATM.ConnectDatabase ) 

--[[
	Reconnect to the SQL when the gamemode is reloaded by auto refresh in case something happens
--]]
function CH_ATM.OnReloaded()
	if not CH_ATM.Config.EnableSQL then
		return
	end
	
	if sql_isconnected then
		return
	end

	CH_ATM.ConnectDatabase()
end
hook.Add( "OnReloaded", "CH_ATM.OnReloaded", CH_ATM.OnReloaded )

--[[
	Create database table if it does not exist already
--]]
function CH_ATM.CreateDatabases()
	if not CH_ATM.Config.EnableSQL then
		return
	end
	
	local queryObj = mysql:Create( "ch_atm_accounts" )
		queryObj:Create( "amount", "float(11) NOT NULL" )
		queryObj:Create( "level", "int(11) NOT NULL" )
		queryObj:Create( "steamid", "varchar(45) NOT NULL" )
		queryObj:PrimaryKey( "steamid" )
	queryObj:Execute()
	
	local queryObj = mysql:Create( "ch_atm_transactions" )
		queryObj:Create( "action", "varchar(10) NOT NULL" )
		queryObj:Create( "amount", "float(11) NOT NULL" )
		queryObj:Create( "timestamp", "timestamp NOT NULL" )
		queryObj:Create( "steamid", "varchar(45) NOT NULL" )
	queryObj:Execute()
end
hook.Add( "DatabaseConnected", "CH_ATM.CreateDatabases", CH_ATM.CreateDatabases )