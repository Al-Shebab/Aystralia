AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


function ENT:Initialize()
	local upgrades = {}
	self:SetModel( "models/gprinter/gprinter_base.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetUseType( SIMPLE_USE )
	self:SetPos( self:GetPos() + Vector( 0, 0, 5 ) )

	self.damage = self.data.health or 100
	self.hasFan = 0
	self.hasArmor = 0
	self.hasPipes = 0
	self.isSecured = false

	if self:Getantenna() == 1 then table.insert( upgrades, 1 ) end
	if self:Getarmour() == 1 then table.insert( upgrades, 2 ) end
	if self:Getfan() == 1 then table.insert( upgrades, 3 ) end
	if self:Getmoreprint() == 1 then table.insert( upgrades, 4 ) end
	if self:Getsilencer() == 1 then table.insert( upgrades, 5 ) end
	if self:Getpipes() == 1 then table.insert( upgrades, 6 ) end
	if self:Getscanner() == 1 then table.insert( upgrades, 7 ) end

	for k, v in pairs( upgrades ) do
		print( v )
		self:AttachModel( v, 1 )
	end


	if ( gPrinters.plugins[ "General" ].Collisions == true ) then
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	end

	timer.Simple( self.data.ptime, function() if self:IsValid() then self:printMoney() end end )
	self.sound = CreateSound( self, Sound( self.data.sound ) )
	self.sound:SetSoundLevel( 52 )
	self.sound:PlayEx( 1, 100 )
end

function ENT:OnTakeDamage( dmg )
	local attacker = dmg:GetAttacker()
	if self.isonFire then return end
	if not IsValid( attacker ) then return end

	if self:Getarmor() > 0 then
		self:Setarmor( self:Getarmor() - dmg:GetDamage() )

		if self:Getarmor() <= 0 && self.hasArmor == 1 then
			if IsValid( armour ) then
				armour:Destroy()
				armour:Remove()
			end
			self:Setarmour( 0 )
			self.hasArmor = 0
		end
		return
	end

	if self:Getarmor() <= 0 then
		if self.hasArmor == 1 && IsValid( armour ) then
			armour:Destroy()
			armour:Remove()
		end
		self:Setarmour( 0 )
		self.hasArmor = 0
	end

	self:Sethealth( self:Gethealth() - dmg:GetDamage() )

	if ( tonumber( self.data.remrew ) >= 1 ) && attacker != self.dt.owning_ent && IsValid( attacker ) && attacker:IsPlayer() && attacker:isCP() && self.damage <= 0 then
		attacker:addMoney( tonumber( self.data.remrew ) )
		if ( gPrinters.plugins[ "General" ].cpNotification == true ) && IsValid( self.dt.owning_ent ) && self.dt.owning_ent:IsPlayer() then
			DarkRP.notify( self.dt.owning_ent, 1, 4, gPrinters.plugins[ "General" ].ownerNote )
		end
	end

	if self:Gethealth() <= 0 then
		local rand = math.random( 1, 10 )
		if rand < 3 then
			self:SetFire()
		else
			self:Destroy()
		end
	end
end

function ENT:Destroy()
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() )
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetScale( 1 )
	util.Effect( "Explosion", effectdata )

	if ( gPrinters.plugins[ "General" ].destroyNotify == true ) && IsValid( self:Getowning_ent() ) then
		DarkRP.notify( self:Getowning_ent(), 1, 4, gPrinters.plugins[ "General" ].destroyMsg )
	end

	if ( gPrinters.plugins[ "General" ].fireSystem == true ) then
		local MPFire = ents.Create("fire")
		MPFire:SetPos( self:GetPos() )
		MPFire:Spawn()
	end
	
	if self.sound then
		self.sound:Stop()
		self:StopSound( self.data.sound )
	end
	self:Remove()
end

function ENT:SetFire()
	if ( gPrinters.plugins[ "General" ].oheatMsg == true ) && IsValid( self:Getowning_ent() ) then
		DarkRP.notify( self:Getowning_ent(), 1, 4, gPrinters.plugins[ "General" ].overheatMsg )
	end

	self.isonFire = true
	local btime = math.random( 5, 10 )
	self:Ignite( btime, 0 )
	timer.Simple( btime, function() if IsValid( self ) then self:Explode() end end )
end

function ENT:Explode()
	if not self:IsOnFire() then
		self.isonFire = false
		return
	end

	local dist = math.random( 10, 300 )
	self:Destroy()

	for k, v in pairs( ents.FindInSphere( self:GetPos(), dist ) ) do
		if not v:IsPlayer() then
			v:Ignite( math.random( 5, 10 ), 0 )
		else
			local distance = v:GetPos():Distance( self:GetPos() )
			v:TakeDamage( distance / dist * 100, self, self )
		end
	end

	if self.sound then
		self.sound:Stop()
		self:StopSound( self.data.sound )
	end
	self:Remove()
end

function ENT:printMoney()
	if not IsValid( self ) then return end
	if self.data.pmaxamount then
		if ( self.data.pmaxamount != 0 ) && ( ( self:Getstoredmoney() + self.data.pamount ) < self.data.pmaxamount ) && ( gPrinters.plugins[ "General" ].showSparks == true ) then
			self.sparking = true
		end
	elseif ( gPrinters.plugins[ "General" ].showSparks == true ) then
		self.sparking = true
	end


	timer.Simple( 1, function()
		if not IsValid( self ) then return end
		self:CreateMoney()
	end )
end

function ENT:CreateMoney()
	if self.IsPocketed then return end
	if not IsValid(self) or self:IsOnFire() then return end
	local overheat = 0

	if ( self.data.poverh == true ) then
		overheat = self.data.ochance

		if ( self:Getfan() != 1 ) then
			local rand = math.random( 100 )
			if ( rand >= 100 - overheat ) then
				self:SetFire()
			end
		end
	end

	local amount = self:Getstoredmoney()
	amount = amount + self.data.pamount

	//Extra Print Upgrade?
	if ( self:Getmoreprint() == 1 ) then
		amount = amount + ( self.data.pamount * ( gPrinters.plugins[ "General" ].morePrint / 100 ) )
	end

	//Check if printer pass the limit?...
	if self.data.pmaxamount && ( self.data.pmaxamount != 0 ) && ( ( amount + self.data.pamount ) >= self.data.pmaxamount ) then
		amount = tonumber( self.data.pmaxamount )
	end

	self:Setstoredmoney( amount )
	self.sparking = false

	if ( self:Getpipes() == 1 ) then
		local percent = self.data.ptime * ( gPrinters.plugins[ "General" ].powerUpgrade / 100 )
		timer.Simple( self.data.ptime - percent, function() if IsValid( self ) then self:printMoney() end end )
	else
		timer.Simple( self.data.ptime, function() if IsValid( self ) then self:printMoney() end end )
	end
end

function ENT:Use( activator, caller )
	if activator:IsPlayer() && activator:IsValid() then

		if not self.selections or not self.selections[ activator] then return end
		if self.lastuse && CurTime() - self.lastuse < 0.75 then return	end

		self.lastuse = CurTime()
		local select = self.selections[ activator ]

		if select == 1 then
			net.Start( "gPrinters.openUpgrades" )
				net.WriteEntity( self )
				net.WriteString( self.data.name )
			net.Send( activator )
			return
		end

		// Scanner Time
		if ( self:Getscanner() == 1 ) && ( self.isSecured == true ) && activator != self.dt.owning_ent then
			gPrinters.sendChat( activator, "gPrinter:", Color( 255, 163, 0 ), gPrinters.plugins[ "General" ].stealerMsg )

			if ( gPrinters.plugins[ "General" ].notifyOwner == true ) then
				gPrinters.sendChat( self.dt.owning_ent, "gPrinter:", Color( 255, 163, 0 ), string.format( gPrinters.plugins[ "General" ].secureMsg, activator:Nick() ) )
			end
			return
		end

		//CPRemove? Reward? Let's go! Let's make a few checks to avoid abuse of this function.
		//Lets avoid users buying printer and after that using "e" on them to retrieve a reward.
		if activator:isCP() && ( self.data.cpremove == true ) then
			if ( tonumber( self.data.remrew ) >= 1 ) && self.dt.owning_ent != activator && IsValid( self.dt.owning_ent ) && self.dt.owning_ent:IsPlayer() then
				activator:addMoney( activator:addMoney( tonumber( self.data.remrew ) ) )
			end

			if ( gPrinters.plugins[ "General" ].cpNotification == true ) && IsValid( self.dt.owning_ent ) && self.dt.owning_ent:IsPlayer() && self.dt.owning_ent != activator then
				DarkRP.notify( self.dt.owning_ent, 1, 4, gPrinters.plugins[ "General" ].ownerNote )
			end
			self:Destroy()
		end

		if gPrinters.plugins[ "General" ].pickupNotification && self:Getstoredmoney() >= 1 then
			DarkRP.notify( activator, 0, 3, string.format( gPrinters.plugins[ "General" ].pickupNote, tonumber( self:Getstoredmoney() ) ) )
		end

		if self:Getstoredmoney() >= 1 then
			if ( gPrinters.plugins[ "General" ].expsystem == true ) then
				activator:addXP( self:Getstoredmoney() * gPrinters.plugins[ "General" ].exppercentage / 100 )
			end

			activator:addMoney( self:Getstoredmoney() )
			self:Setstoredmoney( 0 )
		end
	end
end

function ENT:Think()

	if ( gPrinters.plugins[ "General" ].removeOwner == true ) && not IsValid( self.dt.owning_ent ) then
		self:Remove()
	end

	if ( gPrinters.plugins[ "General" ].waterDestroy == true ) && self:WaterLevel() > 0 then
		self:Destroy()
		return
	end

	//Sparks Here
	if ( self.sparking == true ) then
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 1 )
		util.Effect( "Sparks", effectdata )
	end
end

function ENT:AttachModel( attach, val )
	if ( self.data.attachment == false ) then return end
	//DataTables not required? lets see if we change this to clientside model instead.
	if ( gPrinters.plugins[ "General" ].antenna == true ) && attach == 1 then
		self:Setantenna( val )
		gPrinters.sendChat( self.dt.owning_ent, "[gPrinter]", Color( 0, 127, 127 ), "You can now track & retrieve money from your printers wireless by using the command ( !" .. gPrinters.plugins[ "General" ].printersCommand .. " )" )
		local antenna = ents.Create( "gattachment" )
		antenna:SetPos( self:GetPos() )
		antenna:SetParent( self )
		antenna:SetAngles( self:GetAngles() )
		antenna:setModel( "models/gprinter/gprinter_antenna.mdl" )
		antenna:Spawn()
	end

	if ( gPrinters.plugins[ "General" ].armour == true ) && attach == 2 && self.hasArmor == 0 then
		self.hasArmor = 1
		self:Setarmour( val )
		self.damage = self.damage + tonumber( gPrinters.plugins[ "General" ].armorUpgrade )
		self:Setarmor( tonumber( gPrinters.plugins[ "General" ].armorUpgrade ) )

		armour = ents.Create( "gattachment" )
		armour:SetPos( self:GetPos() )
		armour:SetParent( self )
		armour:SetAngles( self:GetAngles() )
		armour:setModel( "models/gprinter/gprinter_armour.mdl" )
		armour:Spawn()
	end

	// Fan Attachment
	if ( gPrinters.plugins[ "General" ].cooler == true ) && attach == 3 && self.hasFan == 0  then
		self.hasFan = 1
		self:Setfan( val )
		local fan = ents.Create( "gattachment" )
		fan:SetPos( self:GetPos() )
		fan:SetParent( self )
		fan:SetAngles( self:GetAngles() )
		fan:setModel( "models/gprinter/gprinter_block_fan.mdl" )
		fan:Spawn()
	end

	if ( gPrinters.plugins[ "General" ].moreprint == true ) && attach == 4 then
		self:Setmoreprint( val )
		local moreprint = ents.Create( "gattachment" )
		moreprint:SetPos( self:GetPos() )
		moreprint:SetParent( self )
		moreprint:SetAngles( self:GetAngles() )
		moreprint:setModel( "models/gprinter/gprinter_block_moreprint.mdl" )
		moreprint:Spawn()
	end

	if ( gPrinters.plugins[ "General" ].silencer == true ) && attach == 5 then
		self:Setsilencer( val )
		self.sound = CreateSound( self, Sound( self.data.sound ) )
		self.sound:SetSoundLevel( 10 )
		self.sound:PlayEx( 0.3, 100 )
		local silencer = ents.Create( "gattachment" )
		silencer:SetPos( self:GetPos() )
		silencer:SetParent( self )
		silencer:SetAngles( self:GetAngles() )
		silencer:setModel( "models/gprinter/gprinter_block_silencer.mdl" )
		silencer:Spawn()
	end


	if ( gPrinters.plugins[ "General" ].fastprint == true ) && attach == 6 && self.hasPipes == 0 then
		self.hasPipes = 1
		self:Setpipes( val )
		local pipes = ents.Create( "gattachment" )
		pipes:SetPos( self:GetPos() )
		pipes:SetParent( self )
		pipes:SetAngles( self:GetAngles() )
		pipes:setModel( "models/gprinter/gprinter_pipes.mdl" )
		pipes:setColor( Color( self.data.color.r, self.data.color.g, self.data.color.b, 150 ) )
		pipes:Spawn()
	end

	if ( gPrinters.plugins[ "General" ].scanner == true ) && attach == 7 then
		self.isSecured = true
		self:Setscanner( val )
		local scanner = ents.Create( "gattachment" )
		scanner:SetPos( self:GetPos() )
		scanner:SetParent( self )
		scanner:SetAngles( self:GetAngles() )
		scanner:setModel( "models/gprinter/gprinter_scanner.mdl" )
		scanner:Spawn()
	end

	local up = CreateSound( self, Sound( "upgrade.mp3" ) )
	up:SetSoundLevel( 100 )
	up:PlayEx( 1, 100 )
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
		self:StopSound( self.data.sound )
	end
end

function ENT:opengMenu( ply, select )
	self.selections = self.selections or {}
	self.selections[ply] = select
end


if SERVER then
	util.AddNetworkString( "gPrinters.sendID" )
	util.AddNetworkString( "gPrinters.openUpgrades" )
	util.AddNetworkString( "gPrinters.addUpgrade" )

	net.Receive( "gPrinters.addUpgrade", function( len, ply )
		local ent = net.ReadEntity()
		local upgrade = net.ReadUInt( 8 )

		//Prices
		local prices = {
			gPrinters.plugins[ "General" ].antennaup,
			gPrinters.plugins[ "General" ].armourup,
			gPrinters.plugins[ "General" ].fanup,
			gPrinters.plugins[ "General" ].moreprintup,
			gPrinters.plugins[ "General" ].silencerup,
			gPrinters.plugins[ "General" ].pipesup,
			gPrinters.plugins[ "General" ].scannerup
		}

		if not ply:canAfford( prices[ upgrade ] ) then
			ply:ChatPrint( "You can't afford this upgrade!" )
			return
		end

		//Stop wasting player money if they already upgraded the entity.
		if upgrade == 1 && ent:Getantenna() == 1 then return end
		if upgrade == 2 && ent:Getarmour() == 1 then return end
		if upgrade == 3 && ent:Getfan() == 1 then return end
		if upgrade == 4 && ent:Getmoreprint() == 1 then return end
		if upgrade == 5 && ent:Getsilencer() == 1 then return end
		if upgrade == 6 && ent:Getpipes() == 1 then return end
		if upgrade == 7 && ent:Getscanner() == 1 then return end

		ply:addMoney( -prices[ upgrade ] )
		ent:AttachModel( upgrade, 1 )
	end )

	net.Receive( "gPrinters.sendID", function( len, ply )
		local printer = net.ReadEntity()
		local select = net.ReadUInt( 8 )
		if not IsValid( printer ) then return end
		printer:opengMenu( ply, select )
	end )
end