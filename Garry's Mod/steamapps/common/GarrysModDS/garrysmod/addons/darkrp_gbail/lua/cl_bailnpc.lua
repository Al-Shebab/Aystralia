--        ____        _ _
--       |  _ \      (_) |   Package Information
--   __ _| |_) | __ _ _| |   @package      gBail
--  / _` |  _ < / _` | | |   @author       Guurgle
-- | (_| | |_) | (_| | | |   @build        1.0.2
--  \__, |____/ \__,_|_|_|   @release      06/26/2016
--   __/ |    _              _____                       _
--  |___/    | |            / ____|                     | |
--           | |__  _   _  | |  __ _   _ _   _ _ __ __ _| | ___
--           | '_ \| | | | | | |_ | | | | | | | '__/ _` | |/ _ \
--           | |_) | |_| | | |__| | |_| | |_| | | | (_| | |  __/
--           |_.__/ \__, |  \_____|\__,_|\__,_|_|  \__, |_|\___|
--                   __/ |                          __/ |
--                  |___/                          |___/ 

surface.CreateFont("Roboto20", { font = "Roboto", size = 20, weight = 360, antialias = true })
surface.CreateFont("Roboto26", { font = "Roboto", size = 26, weight = 500, antialias = true })

function bailNPC.openMenu()
    if (IsValid(bailNPC.bailMenu) or bailNPC.canUseMenu(LocalPlayer()) == false) then return end

    bailNPC.bailMenu = vgui.Create("GFrame")
    local bailMenu = bailNPC.bailMenu
    bailMenu:SetTitle(bailNPC.menuTitle)
    bailMenu:SetSize(600, 354)
    bailMenu:Center()

    local scrollPanel = vgui.Create("GScrollPanel", bailMenu)
    scrollPanel:Dock(FILL)

    local prisonerList = vgui.Create("DIconLayout", scrollPanel)
    prisonerList:Dock(FILL)
    prisonerList:SetSpaceY(5)
    prisonerList:SetSpaceX(0)

    local prisonEmpty = vgui.Create("DLabel", bailMenu)
    prisonEmpty:SetFont("Roboto20")
    prisonEmpty:SetText(bailNPC.prisonEmptyText)
    prisonEmpty:SizeToContents()
    prisonEmpty:Center()


    prisonerList.Think = function(self)
        if (prisonerList) then prisonEmpty:SetVisible(table.Count(prisonerList:GetChildren()) < 1) end
    end

    for k, v in pairs(player.GetAll()) do
        if (not v:isArrested()) then continue end

        prisonerList[v] = prisonerList:Add("DButton")
        prisonerList[v]:SetSize(570, 60)
        prisonerList[v]:SetText("")

        prisonerList[v].bailEnd = v:GetNWFloat("bailEnd")

        prisonerList[v].Think = function()
            prisonerList[v].bailPrice = bailNPC.calculatePrice(LocalPlayer(), v)

            if (not v:isArrested() or (prisonerList[v].bailEnd - CurTime()) <= 5) then 
                prisonerList[v]:Remove()
                prisonerList[v] = nil
            end

            scrollPanel:InvalidateLayout()
            prisonerList:InvalidateChildren()
        end

        prisonerList[v].DoClick = function()
            if (LocalPlayer():canAfford(prisonerList[v].bailPrice)) then
                netstream.Start("bailMenu", v)
            else notification.AddLegacy(bailNPC.cannotAffordMessage, 1, 3) end
        end

        prisonerList[v].Paint = function(self, w, h)
            if (self:IsHovered()) then surface.SetDrawColor(35, 35, 35, 255) else surface.SetDrawColor(30, 30, 30, 255) end
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(20, 20, 20, 255)
            surface.DrawOutlinedRect(0, 0, w, h)


            surface.SetFont("Roboto20")
            surface.SetTextColor(255, 255, 255, 255)

            local timeLeft = bailNPC.timeLeft(v)
            local timeText = (string.NiceTime(timeLeft) .. ((timeLeft < 60) and "" or " (" .. timeLeft .. "s)"))
            local priceText = DarkRP.formatMoney(prisonerList[v].bailPrice)

            surface.SetTextPos((self:GetWide() - surface.GetTextSize(timeText) - 10), 5)
            surface.DrawText(timeText)

            surface.SetTextPos((self:GetWide() - surface.GetTextSize(priceText) - 10), 33)
            surface.DrawText(priceText)
        end

        prisonerList[v].PerformLayout = function(self)
            if (scrollPanel.VBar:IsVisible()) then self:SetSize(570, 60) else self:SetSize(590, 60) end
        end

        prisonerList[v].clientAvatar    = vgui.Create("AvatarImage", prisonerList[v])
        prisonerList[v].clientAvatar:SetSize(50, 50)
        prisonerList[v].clientAvatar:SetPos(5, 5)
        prisonerList[v].clientAvatar:SetPlayer(v, 64)

        prisonerList[v].clientName      = vgui.Create("DLabel", prisonerList[v])
        prisonerList[v].clientName:SetPos(60, 5)
        prisonerList[v].clientName:SetText((v:GetName() .. " ") or "")
        prisonerList[v].clientName:SetFont("Roboto26")
        prisonerList[v].clientName:SizeToContents()

        prisonerList[v].arresterName    = vgui.Create("DLabel", prisonerList[v])
        prisonerList[v].arresterName:SetPos(60, 33)
        prisonerList[v].arresterName:SetText((v:GetNWString("bailArrester") != "" and string.format(bailNPC.arrestedText, v:GetNWString("bailArrester")) .. " ") or "")
        prisonerList[v].arresterName:SetFont("Roboto20")
        prisonerList[v].arresterName:SizeToContents()
    end
end