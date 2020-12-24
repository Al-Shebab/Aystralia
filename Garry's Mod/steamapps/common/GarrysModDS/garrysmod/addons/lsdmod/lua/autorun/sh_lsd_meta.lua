if(SERVER) then
  util.AddNetworkString("SendLSDDamage")
end

local p = FindMetaTable("Player")

function p:GetLSD()
     return self:GetNW2Float("LSD",0)
end

local noRetumb = true

hook.Add( "EntityEmitSound", "RandomThumper", function( t )
  if(LocalPlayer && LocalPlayer():GetLSD() > 0) then
    t.Pitch = math.random(50,175)
    t.DSP = 133
    if(noRetumb) then
      noRetumb = false
      timer.Simple(1,function()
        if(IsValid(t.Entity)) then
          t.Entity:EmitSound(t.SoundName)
        end
        noRetumb = true
      end)
    end
    return true
  end
end )

hook.Add("EntityTakeDamage","DoLSDDamage",function(ent)
  if(ent:IsPlayer() && ent:GetLSD() > 0) then
    net.Start("SendLSDDamage")
    net.Send(ent)
  end
end)


sound.Add( {
	name = "underwater_lsd",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 80,
	pitch = { 95, 110 },
	sound = "lsd/underwater.wav"
} )

if CLIENT then
hook.Add("PlayerFootstep","LSDFootstep",function( ply, pos, foot, sound, volume, rf )
  if(LocalPlayer():GetLSD() > 0) then
  	ply:EmitSound( "lsd/movement/step"..(foot+1)..".wav" )
  	return true
  end
end)

hook.Add("EntityFireBullets","LSDBullets",function(ent)
  if(IsFirstTimePredicted() && ent:GetLSD() > 0) then
    ent:EmitSound("lsd/movement/shoot.wav")
  end
end)

function createUnderwater()
  local ply = LocalPlayer()
  ply:StopSound("underwater_lsd")
  timer.Remove("UnderwaterSimulator")
  ply:EmitSound("underwater_lsd")
  timer.Create("UnderwaterSimulator",SoundDuration("underwater_lsd"),0,function()
    if(IsValid(ply) && ply:OnGround() && ply:GetLSD() > 0) then
      ply:StopSound("underwater_lsd")
      createUnderwater(ply)
    end
  end)
end

hook.Add( "KeyPress", "LSD_Random", function( ply, key )
	if ( ply:GetLSD() > 0 && key == IN_JUMP && ply:OnGround() ) then
		surface.PlaySound("lsd/boing.wav")
	end
end )

local nSound = 0
net.Receive("SendLSDDamage",function()
  if(nSound < CurTime()) then
    surface.PlaySound("lsd/enviroment/explosion.wav")
    nSound = CurTime() + 0.25
  end
end)

end
