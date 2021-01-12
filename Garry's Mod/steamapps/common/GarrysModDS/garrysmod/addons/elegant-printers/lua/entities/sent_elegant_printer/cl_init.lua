include("shared.lua")

local screens = {}
function ENT:DetermineScreens()
    local rts

    for _, screen in next, screens do
        if not IsValid(screen.ent) or screen.ent:GetClass() ~= self:GetClass() then
            screen.ent = self
            rts = screen.rts
            break
        end
    end

    if not tex or not mat then
        local screen = {
            ent = self,
            rts = {}
        }

        -- Printer status
        local tex = GetRenderTarget(self:GetClass() .. "_" .. CurTime(), 1024, 512)
        local mat = CreateMaterial(self:GetClass() .. "_" .. CurTime(), "UnlitGeneric", {
            ["$nolod"] = 1,
            ["$alphatest"] = 1,
            ["$basetexture"] = tex:GetName()
        })
        screen.rts[1] = {
            tex = tex,
            mat = mat
        }

        -- Back label (owner)
        local tex = GetRenderTarget(self:GetClass() .. "_" .. CurTime() .. "_2", 1024, 512)
        local mat = CreateMaterial(self:GetClass() .. "_" .. CurTime() .. "_2", "VertexLitGeneric", {
            ["$nolod"] = 1,
            ["$alphatest"] = 1,
            ["$translucent"] = 1,
            ["$basetexture"] = tex:GetName()
        })
        screen.rts[2] = {
            tex = tex,
            mat = mat
        }

        screens[#screens + 1] = screen
        rts = screen.rts
    end

    return rts
end

surface.CreateFont("elegant_printers_1", {
    font = "Roboto",
    weight = 800,
    size = 48
})
surface.CreateFont("elegant_printers_2", {
    font = "Roboto",
    weight = 800,
    size = 48 * 1.33
})
surface.CreateFont("elegant_printers_3", {
    font = "Roboto",
    weight = 800,
    size = 48 * 1.66
})

local function getTextSize(text, font)
    if font then surface.SetFont(font) end
    local txtW, txtH = surface.GetTextSize(text)
    return text, txtW, txtH
end

net.Receive("elegant_printers_updatetier", function() -- GAY
    local ent = net.ReadEntity()
    local tier = net.ReadString()

    if IsValid(ent) and ent.UpdateTier then
        ent:UpdateTier(tier)
    end
end)

function ENT:Think() -- Do not let the color tool make the entity invisible
    local col = self:GetColor()
    self:SetColor(Color(col.r, col.g, col.b, 255))
    self:SetRenderMode(RENDERMODE_NORMAL)
    self:SetRenderFX(0) -- kRenderFxNone

    local lply = LocalPlayer()
    if IsValid(lply) and lply.IsSuperAdmin then
        self.Editable = lply:IsSuperAdmin()
    else
        self.Editable = true
    end
end

local gradients = {
    up = Material("vgui/gradient-u"),
    down = Material("vgui/gradient-d"),
    left = Material("vgui/gradient-l"),
    right = Material("vgui/gradient-r")
}
local w, h = 985, 400
local barSpacing = 8

function ENT:GetBars()
    if self.Bars then return self.Bars end
    local bars = {}
    bars[#bars + 1] = {
        Name = "Health",
        GetValue = function() return self:GetDurability() end,
        GetMax = function() return 100 end,
        GetText = function()
            return self:GetDurability() .. "%"
        end
    }
    if self.InkSystem ~= false then
        bars[#bars + 1] = {
            Name = "Ink",
            GetValue = function() return self:GetInk() end,
            GetMax = function() return self:GetMaxInk() end,
            GetText = function()
                return self:GetInk() .. " / " .. self:GetMaxInk()
            end
        }
    end
    bars[#bars + 1] = {
        Name = "Status",
        GetValue = function() return math.max(0, self:GetNextPrint() - CurTime()) end,
        GetMax = function() return self.PrintTime end,
        GetText = function(self)
            return math.ceil(math.Clamp(1 - self:GetValue() / self:GetMax(), 0, 1) * 100) .. "%"
        end,
        ShouldGrow = true,
        GetActive = function() return not self:IsInactive() end,
        InactiveRender = function()
            surface.SetFont("elegant_printers_2")
            local txt, txtW, txtH = getTextSize("⚠ " .. (self:GetMoney() >= self.MaxMoney and "Storage full" or "Refill ink") .. "!") -- maybe a material would be better for the warning sign
            local white = math.abs(math.sin(CurTime() * 3.5)) * 64
            surface.SetTextColor(Color(255 - white * 0.5, 255 - white, 0))
            surface.SetTextPos(w - 16 - txtW, 16)
            surface.DrawText(txt)
        end
    }
    if not self.Bars then self.Bars = bars end
    return bars
end

function ENT:DrawTranslucent()
    if not self.RTs then
        self.RTs = self:DetermineScreens()
    end

    self:DrawModel()

    -- Printer status
    render.PushRenderTarget(self.RTs[1].tex)
        cam.Start2D()
            render.OverrideAlphaWriteEnable(true, true)
            render.Clear(0, 0, 0, 0, true)
                if self:GetPos():DistToSqr(LocalPlayer():GetShootPos()) >= self.MaxRenderDistance then
                    surface.SetDrawColor(self.Gradient1)
                    surface.DrawRect(0, 0, w, h)
                else
                    if not self:GetExploding() then
                        local white = color_white
                        local black = color_black
                        if self.InvertColors then
                            white = color_black
                            black = color_white
                        end

                        surface.SetDrawColor(self.Gradient1)
                        surface.DrawRect(0, 0, w, h)

                        if self.GradientDirection ~= "none" then
                            surface.SetDrawColor(self.Gradient2)
                            surface.SetMaterial(gradients[self.GradientDirection] or gradients.down)
                            surface.DrawTexturedRect(0, 0, w, h)
                        end

                        local webMat = elegant_printers.LogoPanel:GetHTMLMaterial()
                        if webMat and not webMat:IsError() then
                            surface.SetMaterial(webMat)
                            surface.SetDrawColor(Color(255, 255, 255))
                            surface.DrawTexturedRect(16, 24, webMat:Width(), webMat:Height())
                        end

                        surface.SetFont("elegant_printers_3")
                        local txt, txtW, txtH = getTextSize(DarkRP.formatMoney(self:GetMoney()))
                        local maxedMoney = math.Clamp(self:GetMoney() / self.MaxMoney, 0, 1)
                        surface.SetTextColor(Color(255 * (1 - maxedMoney), 255 * (1 - maxedMoney * 0.025), 255 * (1 - maxedMoney * 0.5)))
                        surface.SetTextPos(16, h - txtH - 16)
                        surface.DrawText(txt)

                        surface.SetFont("elegant_printers_1")

                        local txt, txtW, txtH = getTextSize("per print: " .. DarkRP.formatMoney(self.PrintAmount))
                        surface.SetTextColor(white)
                        surface.SetTextPos(w - txtW - 16, h - txtH - 16)
                        surface.DrawText(txt)
                        if self:GetTier():Trim() ~= "" then
                            local txt, txtW, txtH2 = getTextSize("Tier: " .. self:CapitalizeString(self:GetTier()))
                            surface.SetTextColor(white)
                            surface.SetTextPos(w - txtW - 16, h - txtH - txtH2 - 16)
                            surface.DrawText(txt)
                        end

                        local bars = self:GetBars()
                        local barCount = 0
                        for _, bar in ipairs(bars) do if not bar.GetActive or bar:GetActive() then barCount = barCount + 1 end end
                        local barW, barH = (w - barSpacing * 2) / barCount - barSpacing * 2, 64
                        for i, bar in ipairs(bars) do
                            if bar.GetActive and not bar:GetActive() then
                                bar:InactiveRender()
                                continue
                            end

                            local spacing = 4
                            local y = h * 0.5

                            surface.SetFont("elegant_printers_2")
                            local name, nameW, nameH = getTextSize(bar.Name)
                            local barX, barY = 16 + (barW + barSpacing * 2) * (i - 1), y + spacing * 0.5

                            -- Bar name
                            surface.SetTextColor(white)
                            surface.SetTextPos(barX, y - nameH - spacing * 0.5)
                            surface.DrawText(name)

                            surface.SetFont("elegant_printers_1")
                            local val, valW, valH = getTextSize(bar:GetText())

                            -- Bar background and value
                            surface.SetDrawColor(Color(0, 0, 0, 127))
                            surface.DrawRect(barX, barY, barW, barH)
                            surface.SetDrawColor(Color(255, 255, 255))
                            surface.DrawOutlinedRect(barX, barY, barW, barH)
                            surface.SetTextColor(Color(255, 255, 255))
                            surface.SetTextPos(barX + barW * 0.5 - valW * 0.5, barY + barH * 0.5 - valH * 0.5)
                            surface.DrawText(val)

                            -- Bar progress and value
                            local progress = math.Clamp((bar.ShouldGrow and 1 or 0) + bar:GetValue() / bar:GetMax() * (bar.ShouldGrow and -1 or 1), 0, 1)
                            surface.DrawRect(barX + 1, barY + 1, (barW - 2) * progress, barH - 2)
                            surface.SetTextColor(Color(0, 0, 0))

                            render.SetScissorRect(barX, barY, barX + barW * progress, barY + barH, true)
                                surface.SetTextPos(barX + barW * 0.5 - valW * 0.5, barY + barH * 0.5 - valH * 0.5)
                                surface.DrawText(val)
                            render.SetScissorRect(0, 0, 0, 0, false)
                        end
                    else
                        surface.SetDrawColor(ColorRand())
                        surface.DrawRect(0, 0, w, h)
                    end
                end
            render.OverrideAlphaWriteEnable(false)
        cam.End2D()
    render.PopRenderTarget()

    -- Front status
    local pos, ang = self:GetPos(), self:GetAngles()

    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), -90)

    pos = pos + ang:Up() * 9.3
    pos = pos + ang:Forward() * -13.45
    pos = pos + ang:Right() * -7

    cam.Start3D2D(pos, ang, 0.0165)
        surface.SetMaterial(self.RTs[1].mat)
        surface.SetDrawColor(Color(255, 255, 255))
        surface.DrawTexturedRect(0, 0, 1024, 512)
    cam.End3D2D()

    -- Top status
    local pos, ang = self:GetPos(), self:GetAngles()

    ang:RotateAroundAxis(ang:Up(), 90)

    pos = pos + ang:Up() * 9.05
    pos = pos + ang:Forward() * -13.75
    pos = pos + ang:Right() * -6.33

    cam.Start3D2D(pos, ang, 0.0165)
        surface.SetMaterial(self.RTs[1].mat)
        surface.SetDrawColor(Color(255, 255, 255))
        surface.DrawTexturedRect(0, 0, 1024, 512)
    cam.End3D2D()

    -- Back label (owner)
    render.PushRenderTarget(self.RTs[2].tex)
        cam.Start2D()
            render.OverrideAlphaWriteEnable(true, true)
            render.Clear(0, 0, 0, 0, true)

            surface.SetDrawColor(Color(0, 0, 0))
            surface.DrawRect(0, 0, 1024, 512)

            surface.SetDrawColor(Color(248, 252, 248))
            local m = 8
            surface.DrawRect(m, m, 1024 - m * 2, 512 - m * 2)

            if IsValid(self:Getowning_ent()) then
                self.OwnerName = self:Getowning_ent():Nick() -- Persist after disconnection
            end
            local txt, txtW, txtH = getTextSize(DarkRP.textWrap("PROPERTY OF:\n\n" .. (self.OwnerName or "???"), "elegant_printers_3", 1024 * 0.75))
            draw.DrawText(txt, "elegant_printers_3", 48, 64, Color(0, 0, 0))

            render.OverrideAlphaWriteEnable(false)
        cam.End2D()
    render.PopRenderTarget()

    local pos, ang = self:GetPos(), self:GetAngles()

    pos = pos + ang:Up() * 6.5
    pos = pos + ang:Forward() * -10.05
    pos = pos + ang:Right() * -10

    local lm = render.ComputeLighting(pos, ang:Forward() * -1)
    render.SetLightingOrigin(pos)
    render.ResetModelLighting(lm.x, lm.y, lm.z)
    render.SetMaterial(self.RTs[2].mat)
    render.DrawQuadEasy(pos, ang:Forward() * -1, 7, 3.5, nil, ang.r * -1 + 180)
    render.SuppressEngineLighting(false)
end

net.Receive("elegant_printers_receivemoney", function()
    local ent = net.ReadEntity()
    local amt = net.ReadInt(32)

    notification.AddLegacy("You withdrew " .. DarkRP.formatMoney(amt) .. " from the " .. ent.PrintName .. ".", NOTIFY_GENERIC, 5)
    surface.PlaySound("elegant_printers/money_pickup.wav")
end)

language.Add("sent_elegant_printer", "Money Printer")
