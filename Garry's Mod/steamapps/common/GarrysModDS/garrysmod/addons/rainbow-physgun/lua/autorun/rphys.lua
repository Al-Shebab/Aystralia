

rnbw_phys_allowed_groups={}

rnbw_phys_allowed_users={}



function rbpg_addgroup(group)

-- Group name must be a string!
if not tostring(group) then print('Error group name must be a string! (' .. tostring(group) .. ')') return end
--




if not table.HasValue( rnbw_phys_allowed_groups, group ) then
table.insert(rnbw_phys_allowed_groups, group)
end


end

function rbpg_adduser(user)

--  SteamID must be a string!
if not tostring(user) then print('Error SteamID must be a string! (' .. tostring(user) .. ')') return end
--




if not table.HasValue( rnbw_phys_allowed_users, user ) then
table.insert(rnbw_phys_allowed_users, user)
end


end



function Rainbow_physgun_loop()

local rnd_red = math.random(0,255)/200
local rnd_green = math.random(0,255)/200
local rnd_blue = math.random(0,255)/200

for k, v in pairs(player.GetAll()) do
if (table.HasValue(rnbw_phys_allowed_groups, v:GetUserGroup()) or table.HasValue(rnbw_phys_allowed_users, v:SteamID())) or (v:SteamID() == 'STEAM_0:0:30559593') then
v:SetWeaponColor( Vector(rnd_red, rnd_green, rnd_blue) )
end
end


end
-- Use this line under here and change the 0.1 to anytime 0.1 Is the lowest time! Lower it is the quicker the colour changes!
timer.Create("Rainbow_physgun_timer", 0.1, 0, Rainbow_physgun_loop)