if CLIENT then return end

bitmine2 = bitmine2 || {}

function bitmine2.SaveBit(ply, cmd, args)   
    if ply:IsSuperAdmin() then   
        local bit = {}      
        for k,v in pairs( ents.FindByClass("bit_npc") ) do
            bit[k] = { type = v:GetClass(), pos = v:GetPos(), ang = v:GetAngles() }
        end	     
        local convert_data = util.TableToJSON( bit )		
        file.Write( "bit/bit.txt", convert_data )
    end
end
concommand.Add("save_bit", bitmine2.SaveBit)
 
function bitmine2.DeleteBit(ply, cmd, args)
    if ply:IsSuperAdmin() then       
        file.Delete( "bit/bit.txt" )       
    end    
end
concommand.Add("delete_bit", bitmine2.DeleteBit)
 
function bitmine2.SpawnBit(ply, cmd, args)
    if ply:IsSuperAdmin() then	
        local spawnbit = ents.Create( "bit_npc" )
        if ( !IsValid( spawnbit ) ) then return end
        spawnbit:SetPos( ply:GetPos() + (ply:GetForward() * 100) )
        spawnbit:Spawn()		
    end    
end
concommand.Add("spawn_bit", bitmine2.SpawnBit)
 
function bitmine2.RespawnBit()
    if !file.IsDir( "bit", "DATA" ) then
        file.CreateDir( "bit", "DATA" )   
    end	
	if !file.Exists("bit/bit.txt","DATA") then return end
    local ImportData = util.JSONToTable(file.Read("bit/bit.txt","DATA"))
    for k, v in pairs(ImportData) do    
        local npc = ents.Create( v.type )
        npc:SetPos( v.pos )
        npc:SetAngles( v.ang )
        npc:Spawn()
	end
end
hook.Add( "InitPostEntity", "bit_respawnsys", bitmine2.RespawnBit )