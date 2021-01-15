if (not CLIENT) then return end

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

// This tells the client what entity got selected
net.Receive("zrush_MachineCrateBuilder_SelectEntity_net", function(len)
    local ent = net.ReadEntity()
    LocalPlayer().zrush_MachineCrateBuilder_SelectedEntity = ent
end)

// This handels the build ui
hook.Add("PostDrawHUD", "a.zrush.PostDrawHUD.cl.MachineCrateBuilder", function()
    local ent = LocalPlayer().zrush_MachineCrateBuilder_SelectedEntity

    if (IsValid(ent)) then
        local AcceptKey = language.GetPhrase(input.GetKeyName(zrush.config.MachineBuilder.AcceptKey))
        local CancelKey = language.GetPhrase(input.GetKeyName(zrush.config.MachineBuilder.CancelKey))

        draw.WordBox(4, wMod * 780, hMod * 720, tostring(AcceptKey) .. zrush.language.VGUI.MachineBuilder["BuildEntity"], "zrush_swep_font01", zrush.default_colors["grey06"], zrush.default_colors["white01"])
        surface.SetDrawColor(zrush.default_colors["green01"])
        surface.SetMaterial(zrush.default_materials["zrush_dissamble_icon"])
        surface.DrawTexturedRect(wMod * 660, hMod * 700, wMod * 130, hMod * 130)

        draw.WordBox(4, wMod * 780, hMod * 800, tostring(CancelKey) .. zrush.language.VGUI.MachineBuilder["Cancel"], "zrush_swep_font01", zrush.default_colors["grey06"], zrush.default_colors["white01"])
        surface.SetDrawColor(zrush.default_colors["red02"])
        surface.SetMaterial(zrush.default_materials["zrush_cancel_icon"])
        surface.DrawTexturedRect(wMod * 670, hMod * 790, wMod * 110, hMod * 110)
    end
end)

local sModel

local function BuildAction_net(ent)

    net.Start("zrush_MachineCrateBuilder_BuildEntity_net")
    net.WriteEntity(ent)
    net.SendToServer()
    LocalPlayer().zrush_MachineCrateBuilder_SelectedEntity = nil

    if IsValid(sModel) then
        sModel:Remove()
    end

    zrush.f.Debug("Building Action")
end

local function CancelAction_net(ent)
    net.Start("zrush_MachineCrateBuilder_DeselectEntity_net")
    net.WriteEntity(ent)
    net.SendToServer()


    if IsValid(sModel) then
        sModel:Remove()
    end

    LocalPlayer().zrush_MachineCrateBuilder_SelectedEntity = nil
    LocalPlayer():EmitSound("zrush_sfx_deconnect")
    zrush.f.Debug("Building Canceled")
end

// Handels the model hologram logic
hook.Add("Think", "a.zrush.Think.CL.MachineCrateBuilder", function()
    local ent = LocalPlayer().zrush_MachineCrateBuilder_SelectedEntity

    if (IsValid(ent)) then
        // Do we want do abbord the action?
        if (input.IsButtonDown(zrush.config.MachineBuilder.AcceptKey)) then
            BuildAction_net(ent)
        end

        // Do we want do cancel the action?
        if (input.IsButtonDown(zrush.config.MachineBuilder.CancelKey) or not LocalPlayer():Alive()) then
            CancelAction_net(ent)
        end

        local sEntMachineID = ent:GetMachineID()
        local tr = LocalPlayer():GetEyeTrace()
        local trEnt, trHit = tr.Entity, tr.HitPos
        local validPos, validEnt = zrush.f.MachineCrateBuilder.ValidPos(tr, sEntMachineID, LocalPlayer(), ent)



        if (zrush.f.InDistance(trHit,LocalPlayer():GetPos(),300) and zrush.f.InDistance(trHit,ent:GetPos(),300)) then
            if not IsValid(sModel) then
                local machineData = zrush.f.FindMachineDataByID(sEntMachineID)
                sModel = ClientsideModel(machineData.model, RENDERMODE_TRANSALPHA)
                sModel:SetPos(trHit)
                sModel:SetAngles(Angle(0, LocalPlayer():EyeAngles().y + -90, 0))
                sModel:Spawn()

                if (sEntMachineID == "Pump") then
                    sModel:SetBodygroup(0, 1)
                    sModel:SetBodygroup(1, 1)
                    sModel:SetBodygroup(3, 1)
                    sModel:SetBodygroup(5, 1)
                    sModel:SetBodygroup(2, 1)
                    sModel:SetBodygroup(4, 1)
                end

                sModel:SetColor(validPos and zrush.default_colors["green02"] or zrush.default_colors["red03"])
                sModel:SetRenderMode(RENDERMODE_TRANSALPHA)
                sModel:SetNoDraw(false) // Bypass the nodraw function when an entity is spawned
            else
                sModel:SetColor(validPos and zrush.default_colors["green02"] or zrush.default_colors["red03"])

                if (validPos) then
                    local ang = trEnt:GetAngles()

                    if (sEntMachineID == "Drill" and zrush.config.Drill_Mode == 0) then
                        if (IsValid(validEnt)) then
                            sModel:SetAngles(ang)
                            sModel:SetPos(validEnt:GetPos())
                        else
                            ang = tr.HitNormal:Angle()
                            ang:RotateAroundAxis(ang:Right(), -90)
                            ang:RotateAroundAxis(ang:Up(), 90)
                            sModel:SetAngles(ang)
                            sModel:SetPos(validPos)
                        end
                    elseif (sEntMachineID == "Refinery") then
                        ang = Angle(0, LocalPlayer():EyeAngles().y + -90, 0)
                        sModel:SetAngles(ang)
                        sModel:SetPos(validPos)
                    else
                        ang = trEnt:GetAngles()
                        sModel:SetAngles(ang)
                        sModel:SetPos(validEnt:GetPos())
                    end
                else
                    if (trHit) then
                        if (sEntMachineID == "Drill" and zrush.config.Drill_Mode == 0) then
                            local ang = tr.HitNormal:Angle()
                            ang:RotateAroundAxis(ang:Right(), -90)
                            sModel:SetAngles(ang)
                        else
                            sModel:SetAngles(Angle(0, LocalPlayer():EyeAngles().y + -90, 0))
                        end

                        sModel:SetPos(trHit)
                    end
                end
            end
        else
            CancelAction_net(ent)
        end
    end
end)

hook.Add("HUDPaint", "a.zrush.Think.CL.ConnectionRender", function()
    local ent = LocalPlayer().zrush_MachineCrateBuilder_SelectedEntity

    if (IsValid(ent)) then
        local tr = LocalPlayer():GetEyeTrace()
        local trHit = tr.HitPos
        local sEntMachineID = ent:GetMachineID()
        local validPos, validEnt = zrush.f.MachineCrateBuilder.ValidPos(tr, sEntMachineID, LocalPlayer(), LocalPlayer().zrush_MachineCrateBuilder_SelectedEntity)
        local color = zrush.default_colors["white01"]
        local endPoint = trHit

        if (validPos) then
            color = zrush.default_colors["green02"]

            if (sEntMachineID == "Refinery" or (sEntMachineID == "Drill" and zrush.config.Drill_Mode == 0)) then
                endPoint = validPos
            else
                endPoint = validEnt:GetPos()
            end
        else
            color = zrush.default_colors["red03"]
            endPoint = trHit
        end

        cam.Start3D()
            render.DrawLine(ent:GetPos(), endPoint, color, false)
        cam.End3D()
    end
end)



// This gets called from then machine options box
net.Receive("zrush_MachineCrate_AddModules_net", function(len, ply)
    local ent = net.ReadEntity()
    local mTable = net.ReadTable()

    if IsValid(ent) then
        ent.InstalledModules = {}
        table.CopyFromTo(mTable, ent.InstalledModules)
    end
end)
