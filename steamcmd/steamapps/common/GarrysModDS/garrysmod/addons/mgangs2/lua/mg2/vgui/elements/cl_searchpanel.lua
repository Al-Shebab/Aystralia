--[[
    MGangs 2 - (SH) VGUI ELEMENT - Search panel
    Developed by Zephruz
]]

local SPANEL = {}

function SPANEL:Init()
    self.curPage = 1
    self.totalPages = 1
    self.pageResults = {}

    self:LoadSearchContainer()
    self:LoadSearchPanel()
end

function SPANEL:SetCurrentPage(val)
    self.curPage = val
end

function SPANEL:GetCurrentPage()
    return self.curPage
end

function SPANEL:SetTotalPages(val)
    self.totalPages = val
end

function SPANEL:GetTotalPages()
    return self.totalPages
end

function SPANEL:LoadSearchContainer()
    if (IsValid(self.searchCont)) then self.searchCont:Remove() end

    self.searchCont = vgui.Create("mg2.Container", self)
    self.searchCont:Dock(TOP)
    self.searchCont:SetTall(30)

    -- Search bar
    local searchBar = vgui.Create("mg2.TextEntry", self.searchCont)
    searchBar:Dock(FILL)
    searchBar:DockMargin(3,3,0,3)
    searchBar:SetPlaceholder("Search...")
    searchBar.OnEnter = function(s)
        self:OnSearch(s:GetText())
    end

    -- Page info
    local curPageInfo = vgui.Create("DPanel", self.searchCont)
    curPageInfo:Dock(RIGHT)
    curPageInfo:DockMargin(0,3,3,3)
    curPageInfo:SetWide(50)
    curPageInfo.Paint = function(s,w,h)
        local curPage, totalPages = self:GetCurrentPage(), self:GetTotalPages()

        draw.SimpleText(curPage .. " / " .. totalPages,"mg2.GANGMENU.SMALL",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    -- Next page
    local nextPg = vgui.Create("mg2.Button", self.searchCont)
    nextPg:SetText(">")
    nextPg:SetWide(20)
    nextPg:Dock(RIGHT)
    nextPg:DockMargin(3,3,3,3)
    nextPg.DoClick = function(s)
        local curPage, totalPages = self:GetCurrentPage(), self:GetTotalPages()
        local toPg = curPage + 1

        if (toPg <= totalPages) then
            local nextPg = self:OnNextPage(toPg)

            if (nextPg) then
                self:SetCurrentPage(toPg)
            end
        end
    end

    -- Previous page
    local prevPg = vgui.Create("mg2.Button", self.searchCont)
    prevPg:SetText("<")
    prevPg:SetWide(20)
    prevPg:Dock(RIGHT)
    prevPg:DockMargin(3,3,0,3)
    prevPg.DoClick = function(s)
        local curPage, totalPages = self:GetCurrentPage(), self:GetTotalPages()

        if (curPage > 1) then
            local toPg = curPage - 1
            local prevPg = self:OnPreviousPage(toPg)

            if (prevPg) then
                self:SetCurrentPage(toPg)
            end
        end
    end
end

function SPANEL:LoadSearchPanel()
    if (IsValid(self.searchPanel)) then self.searchPanel:Remove() end

    -- Search/result panel
    self.searchPanel = vgui.Create("mg2.Scrollpanel", self)
    self.searchPanel:Dock(FILL)
end

function SPANEL:SetResults(results)
    self.pageResults = results

    if !(IsValid(self.searchPanel)) then self:LoadSearchPanel() end

    self.searchPanel:Clear()

    for k,v in pairs(results) do
        self:OnSetupResult(self.searchPanel, v)
    end
end

function SPANEL:GetResults(results)
    return self.pageResults
end

function SPANEL:OnSearch(sVal) end
function SPANEL:OnSetupResult(res) end
function SPANEL:OnPreviousPage(pg) end
function SPANEL:OnNextPage(pg) end
function SPANEL:Paint(w,h) end

vgui.Register("mg2.Searchpanel", SPANEL, "DPanel")