--[[
    MGangs 2 - DARKRP EXTENSIONS - (SH) Gang Jobs
    Developed by Zephruz
]]

MG2_DARKRPEXTENSIONS:setData("GangJobs", {}, { -- DON'T EDIT THIS
    onGet = function(s,val,gangName)
        if !(gangName) then return end

        return (val && val[gangName] || false)
    end,
})



--[[
    Hooks
]]
hook.Add("OnPlayerChangedTeam", "mg2.darkrpext[OnPlayerChangedTeam]",
function(ply, lastTeam, curTeam) -- NOTE: last/curTeam is the team number
    -- TODO: Remove/add to new gang
end)
