function fcd.chopShopPopUp()
    local bg = vgui.Create( 'fcdCheck' )
    bg.question = 'Claim current vehicle as stolen?'

    function bg.yes.onYesClicked()
      net.Start( 'fcd_chopshopyes' )
        net.WriteEntity( LocalPlayer():GetVehicle() )
      net.SendToServer()

      bg:Remove()
    end
end

net.Receive( 'fcd_chopshopmenu', fcd.chopShopPopUp )

function fcd.chopShopNPCPopUp()
    local id = net.ReadString()
    local veh = net.ReadEntity()

    local vehid = veh:GetVehicleClass()
    local price = fcd.cfg.chopShop['defaultSellPrice']

    if fcd.dataVehicles[ vehID ] then
          price = fcd.dataVehicles[vehid].price * fcd.cfg.chopShop['sellPercentage']
    end

    local w, h = 450, 500
    local x, y = ScrW() / 2 - (w / 2), ScrH() / 2 - (h / 2)

    local bg = vgui.Create( 'fcdDFrame' )
    bg:SetSize(w, h)
    bg:SetPos(x, y)
    bg:addCloseButton()
    bg.title = fcd.cfg.chopShopTranslate['npcMenuTitle']
    bg.titleSize = 25

    function bg:PaintOver(w, h)
        draw.SimpleText('Sell this vehicle for '..DarkRP.formatMoney(price)..'?', 'fcd_font_18', w / 2, h - 150, fcd.clientVal('mainTextColor'), 1)
    end

    local mdl = bg:Add('DModelPanel')
    mdl:SetSize(w, h - 150)
    mdl:SetPos(0, 15)
    mdl:SetModel(veh:GetModel() or 'models/buggy.mdl')

    fcd.fixMdlPos(mdl)

    local btn = {
      [1] = {
        txt = "Yes",
        func = function()
            net.Start('fcd_chopshopsellvehicle')
                net.WriteString(id)
            net.SendToServer()

            bg:Remove()
        end
      },
      [2] = {
        txt = "No",
        func = function()
            bg:Remove()
        end
      }
    }

    local btny = h - 150 + 28 + 16

    for i, v in pairs(btn) do
      local btn = bg:Add("fcdDButton")
      btn:SetSize(w, 50)
      btn:SetPos(0, btny)
      btn.text = v.txt

      btn.DoClick = v.func

      btny = btny + 55
    end
end

net.Receive( 'fcd_chopshopnpcmenu', fcd.chopShopNPCPopUp )
