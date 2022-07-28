
if SERVER then
    include( "sv.lua" )
    --AddCSLuaFile( "cl.lua" ) not needed
else
    --include( "cl.lua" )
end

local SlotColors = {
    [1]  = Color( 255, 150, 0 ),
    [2] = Color( 255, 75, 0 ),
    [3]   = Color( 75, 150, 75 ),
    [4] = Color( 255, 0, 0 ),   -- ?
    [5] = Color( 255, 0, 0 ),   -- ?
    [6]   = Color( 255, 255, 255 ),   -- ?
    [7]  = Color( 255, 255, 255 ),   -- ?
}

-----------------------

local cfg = USEPICKUP.Config

function USEPICKUP.COMP:FindWeaponToDrop( p, wep, nodrop )
    for k, v in pairs(p:GetWeapons()) do
        if v.Slot and v.Slot == wep.Slot then
            --p:DropWeapon( v )
            if !nodrop then
                p:DropWeapon( v )
            end
            return v
        end
    end
end

function USEPICKUP.COMP:CanInteract( p )
    return p and IsValid( p ) and p:Alive() and true or false
end

function USEPICKUP.COMP:GetWeaponColor( wep )
    return wep and wep.Slot and SlotColors[wep.Slot] or Color( 255, 255, 255 )
end

function USEPICKUP.COMP:GetWeaponName( wep )
    if cfg.NameOverride[wep:GetClass()] then return cfg.NameOverride[wep:GetClass()] end
    return wep.PrintName or "No weapon name"
end

-- stats compare validation
function USEPICKUP.COMP:CanCompare( a, b )
    a = a and self:JBCheckWeaponReplacements(nil, a) and weapons.Get( rep_a ) or a
    b = b and self:JBCheckWeaponReplacements(nil, b) and weapons.Get( rep_b ) or b

    local a_stats = USEPICKUP.STATS:GetWeaponStats( a )
    local b_stats = USEPICKUP.STATS:GetWeaponStats( b )
    
    return a_stats and a_stats != {} and b_stats and b_stats != {} and USEPICKUP_COMPARE_WEAPON or USEPICKUP_COMPARE_GLOBAL
end

-- overrides
-- WE NEED THIS SHARED
local reregister = {};
local function reregisterWeapon(old,new)
    reregister[old] = new;
end

reregisterWeapon("weapon_ak47","weapon_jb_ak47");
reregisterWeapon("weapon_aug","weapon_jb_m4a1");
reregisterWeapon("weapon_awp","weapon_jb_awp");
reregisterWeapon("weapon_deagle","weapon_jb_deagle");
reregisterWeapon("weapon_elite","weapon_jb_usp");
reregisterWeapon("weapon_famas","weapon_jb_famas");
reregisterWeapon("weapon_fiveseven","weapon_jb_fiveseven");
reregisterWeapon("weapon_g3sg1","weapon_jb_m4a1");
reregisterWeapon("weapon_galil","weapon_jb_galil");
reregisterWeapon("weapon_glock","weapon_jb_glock");
reregisterWeapon("weapon_m249","weapon_jb_scout");
reregisterWeapon("weapon_m3","weapon_jb_scout");
reregisterWeapon("weapon_m4a1","weapon_jb_m4a1");
reregisterWeapon("weapon_mac10","weapon_jb_mac10");
reregisterWeapon("weapon_mp5navy","weapon_jb_mp5navy");
reregisterWeapon("weapon_p228","weapon_jb_fiveseven");
reregisterWeapon("weapon_p90","weapon_jb_p90");
reregisterWeapon("weapon_scout","weapon_jb_scout");
reregisterWeapon("weapon_sg550","weapon_jb_scout");
reregisterWeapon("weapon_sg552","weapon_jb_sg552");
reregisterWeapon("weapon_tmp","weapon_jb_tmp");
reregisterWeapon("weapon_ump45","weapon_jb_ump");
reregisterWeapon("weapon_usp","weapon_jb_usp");
reregisterWeapon("weapon_xm1014","weapon_jb_scout");
reregisterWeapon("weapon_knife","weapon_jb_knife");
reregisterWeapon("weapon_hegrenade","weapon_jb_knife");
reregisterWeapon("weapon_smokegrenade","weapon_jb_knife");
reregisterWeapon("weapon_flashbang","weapon_jb_knife");


function USEPICKUP.COMP:JBCheckWeaponReplacements(ply,entity)
    if reregister[entity:GetClass()] then
        return reregister[entity:GetClass()];
    end
    return false;
end

if SERVER then
    --
else
    local cvarCrouchToggle = CreateClientConVar( "jb_cl_option_togglecrouch", "0", true, false )
    local cvarWalkToggle = CreateClientConVar( "jb_cl_option_togglewalk", "0", true, false )
    local walking = false;

    hook.Add("PlayerBindPress", "JB.PlayerBindPress.KeyBinds", function(pl, bind, pressed)
        if string.find( bind,"+menu_context" ) then
            // see cl_context_menu.lua
        elseif string.find( bind,"+menu" ) then
            if pressed then
                RunConsoleCommand("jb_dropweapon")
            end
            return true;
        elseif string.find( bind,"+use" ) and pressed then
            /*local tr = LocalPlayer():GetEyeTrace();
            if tr and IsValid(tr.Entity) and tr.Entity:IsWeapon() then
                RunConsoleCommand("jb_pickup");
                return true;
            end*/
        elseif string.find( bind,"gm_showhelp" ) then
            if pressed then
                JB.MENU_HELP_OPTIONS();
            end
            return true;
        elseif string.find( bind,"gm_showteam" ) then
            if pressed then
                JB.MENU_TEAM();
            end
            return true;
        elseif string.find( bind,"gm_showspare2" ) then
            if pressed then
                if LocalPlayer():Team() == TEAM_PRISONER then
                    JB.MENU_LR();
                elseif LocalPlayer():Team() == TEAM_GUARD then
                    JB.MENU_WARDEN()
                end
            end
            return true;
        elseif string.find( bind,"warden" ) then
            return true;
        elseif cvarCrouchToggle:GetBool() and pressed and string.find( bind,"duck" ) then
            if pl:Crouching() then
                pl:ConCommand("-duck");
            else
                pl:ConCommand("+duck");
            end
            return true;
        elseif cvarWalkToggle:GetBool() and pressed and string.find( bind,"walk" ) then
            if walking then
                pl:ConCommand("-walk");
            else
                pl:ConCommand("+walk");
            end
            walking=!walking;
            return true;
        elseif string.find(bind,"+voicerecord") and pressed and ((pl:Team() == TEAM_PRISONER and (CurTime() - JB.RoundStartTime) < 30) or (not pl:Alive())) then
            JB:DebugPrint("You can't use voice chat - you're dead or the round isn't 30 seconds in yet.");
            return true;
        end
    end)

    // TARGET ID
    local uniqueid,ent,text_x,text_y,text,text_sub,text_wide,text_tall,text_color
    -- fuck those errors
    local drawSimpleShadowText = JB.Util.drawSimpleShadowText
    local setFont = surface.SetFont
    local getTextSize = surface.GetTextSize;
    JB.Gamemode.HUDDrawTargetID = function()
        if LocalPlayer():GetObserverMode() ~= OBS_MODE_NONE then return end

        ent = LocalPlayer():GetEyeTrace().Entity;

        if (not IsValid(ent) ) then return end;

        text = "ERROR"
        text_sub = "Something went terribly wrong!";

        if (ent:IsPlayer()) then
            text = ent:Nick()
            text_sub = ent:GetPos():Distance(LocalPlayer():EyePos()) < 200 and (ent:Health().."% HP"..(ent.GetRebel and ent:GetRebel() and " | Rebel" or ent.GetWarden and ent:GetWarden() and " | Warden" or ""));
            text_color = team.GetColor(ent:Team());
        /*elseif (ent:IsWeapon()) then
            local tab=weapons.Get(ent:GetClass())
            text = tab and tab.PrintName or ent:GetClass();
            if( tableHasValue(JB.LastRequestPlayers,LocalPlayer()) and JB.LastRequestTypes[JB.LastRequest] and not JB.LastRequestTypes[JB.LastRequest]:GetCanPickupWeapons() ) then
                text_sub = "Can not pick up in LR";
            else
                local bind = inputLookupBinding("+use");
                text_sub = ent:GetPos():Distance(LocalPlayer():EyePos()) > 200 and "" or ((not bind) and "Bind a key to +use to pick up") or ("Press "..bind.." to pick up");
            end

            text_color = JB.Color.white;*/
        else
            return
        end

        text_x,text_y = ScrW()/2, ScrH() *.6;
        drawSimpleShadowText(text,"JBNormal",text_x,text_y,text_color,1,1);

        if text_sub and text_sub ~= "" then

            setFont("JBNormal");
            text_wide,text_tall = getTextSize(text);

            text_y = text_y + text_tall*.9;

            drawSimpleShadowText(text_sub,"JBSmall",text_x,text_y,JB.Color.white,1,1);

        end
    end
end