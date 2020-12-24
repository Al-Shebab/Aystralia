function fcd.getChopNPCById(id)
    if !id then return end

    for i, v in pairs(ents.FindByClass('chopshop')) do
        if v:GetnpcID() == id then
            return v
        end
    end
end

function fcd.getChopNPCId(ent)
    if !ent then return end

    return ent:GetnpcId()
end
