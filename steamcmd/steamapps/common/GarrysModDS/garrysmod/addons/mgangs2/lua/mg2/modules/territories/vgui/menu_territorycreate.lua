--[[
     MGangs 2 - TERRITORIES - (SH) Create Menu
    Developed by Zephruz
]]

if (CLIENT) then

surface.CreateFont("mg2.TERRITORYCREATEMENU.LARGE", {
    font = "Abel",
    size = 25,
})

surface.CreateFont("mg2.TERRITORYCREATEMENU.MEDIUM", {
    font = "Abel",
    size = 21,
})

surface.CreateFont("mg2.TERRITORYCREATEMENU.SMALL", {
    font = "Abel",
    size = 17,
})

end

local MENU_TERRCREATE = mg2.vgui:RegisterMenu("mg2.TerritoryCreate")

MENU_TERRCREATE:setData("TerritoryBounds", false, {shouldSave = false})
MENU_TERRCREATE:setData("TerritoryPos", false, {shouldSave = false})
MENU_TERRCREATE:setData("Territory", false, {shouldSave = false})

function MENU_TERRCREATE:Init()
    self.frame = vgui.Create("mg2.Frame")
    self.frame:SetSize(400,250)
    self.frame:SetTitle(mg2.lang:GetTranslation("territory.Create"))
    self.frame:Center()
    self.frame:MakePopup()
    self.frame:SetFrameBlur(true)

    -- Load territory options
    self:LoadOptions()

    -- Create territory
    local createTerr = vgui.Create("mg2.Button", self.frame)
    createTerr:Dock(BOTTOM)
    createTerr:DockMargin(3,0,3,3)
    createTerr:SetTall(30)
    createTerr:SetText(mg2.lang:GetTranslation("create"))
    createTerr.DoClick = function(s)
        local terr = self:GetTerritory()
        local tPos, tBounds = self:GetTerritoryPos(), self:GetTerritoryBounds()

        if (!terr or !tPos or !tBounds) then return end

        terr:SetPosition(tPos)
        terr:SetBounds(tBounds)

        local valData = terr:getValidatedData()

        zlib.network:CallAction("mg2.territories.adminRequest", {reqName = "createTerritory", data = valData},
        function(res)
            if !(IsValid(self.frame)) then return end

            self.frame:Remove()
        end)
    end
end

function MENU_TERRCREATE:LoadOptions()
    local tempTerr = self:SetTerritory(MG2_TERRITORIES:SetupTemporary())

    local tOptSPnl = vgui.Create("mg2.Scrollpanel", self.frame)
    tOptSPnl:Dock(FILL)
    tOptSPnl:DockMargin(3,3,3,3)

    local header = vgui.Create("mg2.Header", tOptSPnl)
    header:Dock(TOP)
    header:SetText(mg2.lang:GetTranslation("generaloptions"))

    -- Territory options
    local terrOpts = mg2.vgui:GetMetatableOptions("mg2.Territory", "terr.Create")
    
    for k,v in SortedPairsByMemberValue(terrOpts, "index") do
        local ele = (v.createEle && v:createEle(tOptSPnl, tempTerr))

        if (IsValid(ele)) then
            ele:SetParent(tOptSPnl)
        end
    end
end