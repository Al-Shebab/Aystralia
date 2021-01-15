if not CLIENT then return end

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

zrush = zrush or {}
zrush.VGUI = zrush.VGUI or {}
zrush.VGUI.Main = zrush.VGUI.Main or {}

local zrush_Main = {}


local zrush_MachineEntity
local zrush_LastHoverdElement

local LAST_SELECTED

/////////// General
// This Updates the machine UI
local function zrush_UpdateUI(UpdateShop)
	local ent = zrush_MachineEntity
	local HasChaosEvent = false
	local machineID = ent.MachineID

	// Here we check if the Machine that sends the UI Update Message has a Chaos Event
	if (machineID == "Drill") then
		HasChaosEvent = ent:GetJammed()
	elseif (machineID == "Burner") then
		HasChaosEvent = ent:GetOverHeat()
	elseif (machineID == "Pump") then
		HasChaosEvent = ent:GetJammed()
	elseif (machineID == "Refinery") then
		HasChaosEvent = ent:GetOverHeat()
	end

	LocalPlayer().zrush_HasChaosEvent = HasChaosEvent

	if (UpdateShop or LocalPlayer().zrush_HasChaosEvent) then
		if (IsValid(LAST_SELECTED)) then
			LAST_SELECTED:SetVisible(true)
		end

		local owner = zrush.f.GetOwner(ent)

		if (IsValid(zrush_Main.Title) and owner) then
			zrush_Main.Title:SetText(owner:Nick() .. "´s " .. zrush.language.MachineCrate[machineID])
		end

		zrush_SELECTED_MODULE = nil

		//zrush_SELECTED_FUEL = nil
		if (ent:GetClass() == "zrush_refinery") then
			zrush_SELECTED_FUEL = ent:GetFuelTypeID()
		end

		zrush_ShopMenu.ModuleName:SetText("")
		zrush_ShopMenu.ModulePrice:SetText("")
		zrush_ShopMenu.ModuleType:SetText("")
		zrush_ShopMenu.ModuleBoostAllowed:SetText("")
		zrush_ShopMenu.ModuleBoostAllowedJobs:SetText("")
		zrush_ShopMenu.ModuleDesc:SetText("")
		zrush_ShopMenu.purchase:SetVisible(false)
		zrush_ShopMenu.Sell:SetVisible(false)
		local ItemList = zrush.VGUI.ItemGenerator()

		if (zrush_SELECTED_MODULE and ItemList and table.Count(ItemList) > 0 and zrush.f.IsOwner(LocalPlayer(), ent)) then
			zrush_ShopMenu.purchase:SetVisible(true)
			zrush_ShopMenu.Sell:SetVisible(true)
		end

		zrush.VGUI.MachineActions(zrush.VGUI.Main.Panel)
		zrush.VGUI.InstalledModules(zrush.VGUI.Main.Panel)
		zrush.VGUI.ShopItems(zrush_ShopMenu.Panel)
		zrush.VGUI.RefineryFuelType(zrush.VGUI.Main.Panel)
	end

	zrush.VGUI.MachineStats(zrush.VGUI.Main.Panel)
end

// This Opens or Creates the machine UI
local function zrush_OpenUI()
	if IsValid(zrush.VGUI.Main.Panel) then
		zrush.VGUI.Main.Panel:SetVisible(true)
		zrush_UpdateUI(true)
	else
		zrush.VGUI.Main.Panel = vgui.Create("zrush_vgui_MachineMenu")
	end
end

// This closes the machine UI
local function zrush_CloseUI()
	if IsValid(zrush.VGUI.Main.Panel) then
		if (IsValid(LAST_SELECTED)) then
			LAST_SELECTED:SetVisible(false)
		end

		if (zrush.config.Debug) then
			zrush.VGUI.Main.Panel:Remove()
		else
			zrush.VGUI.Main.Panel:SetVisible(false)
		end
	end
end

///////////
/////////// Init
function zrush.VGUI.Main:Init()
	self:SetSize(1200 * wMod, 750 * hMod)
	self:Center()
	self:MakePopup()
	local machine = zrush_MachineEntity
	local ownerID = zrush.f.GetOwnerID(machine)
	local owner = player.GetBySteamID(ownerID):Nick()

	if (machine:GetClass() == "zrush_refinery") then
		zrush_SELECTED_FUEL = machine:GetFuelTypeID()
	end

	zrush_Main.Panel = vgui.Create("Panel", self)
	zrush_Main.Panel:SetPos(0 * wMod, 0 * hMod)
	zrush_Main.Panel:SetSize(700 * wMod, 750 * hMod)

	zrush_Main.Panel.Paint = function(s,w, h)
		surface.SetDrawColor(80, 80, 80, 255)
		surface.SetMaterial(zrush.default_materials["ui_machine_panel_main"])
		surface.DrawTexturedRect(0, 0, w, h)

		if zrush_Main.Panel:IsHovered() and zrush_LastHoverdElement ~= zrush_Main.Panel then
			zrush_LastHoverdElement = zrush_Main.Panel
		end
	end

	zrush_Main.Title = vgui.Create("DLabel", self)
	zrush_Main.Title:SetPos(15 * wMod, -30 * hMod)
	zrush_Main.Title:SetSize(600 * wMod, 125 * hMod)
	zrush_Main.Title:SetFont("zrush_vgui_font01")
	zrush_Main.Title:SetText(owner .. "´s " .. zrush.language.MachineCrate[machine.MachineID])
	zrush_Main.Title:SetColor(zrush.default_colors["white01"])

	zrush_Main.close = vgui.Create("DButton", self)
	zrush_Main.close:SetText("")
	zrush_Main.close:SetPos(635 * wMod, 15 * hMod)
	zrush_Main.close:SetSize(50 * wMod, 50 * hMod)
	zrush_Main.close.DoClick = function()
		zrush_CloseUI()
	end
	zrush_Main.close.Paint = function(s,w, h)
		if s:IsHovered() then
			surface.SetDrawColor(zrush.default_colors["red02_highlight"])
		else
			surface.SetDrawColor(zrush.default_colors["red02"])
		end

		surface.SetMaterial(zrush.default_materials["button02"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText("X", "zrush_vgui_font03", 25 * wMod, 25 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local HasChaosEvent = false
	local machineID = machine.MachineID

	// Here we check if the Machine that sends the UI Update Message has a Chaos Event
	if (machineID == "Drill") then
		HasChaosEvent = machine:GetJammed()
	elseif (machineID == "Burner") then
		HasChaosEvent = machine:GetOverHeat()
	elseif (machineID == "Pump") then
		HasChaosEvent = machine:GetJammed()
	elseif (machineID == "Refinery") then
		HasChaosEvent = machine:GetOverHeat()
	end

	LocalPlayer().zrush_HasChaosEvent = HasChaosEvent
	zrush.VGUI.MachineStats(self)
	zrush.VGUI.RefineryFuelType(self)
	zrush.VGUI.MachineActions(self)
	zrush.VGUI.MachineModuleShop(self)
	zrush.VGUI.InstalledModules(self)
end

// Paint
function zrush.VGUI.Main:Paint(w, h)
	surface.SetDrawColor(70, 70, 70, 0)
	surface.SetMaterial(zrush.default_materials["square"])
	surface.DrawTexturedRect(0, 0, w, h)
end

///////////
/////////// Stats
local function BuildStatTable(machine, machineID)
	local statTable = {}
	local SpeedBoost
	local ProductionBoost
	local AntiJamBoost
	local ExtraPipes
	local RefineBoost
	local CoolingBoost

	if (machineID == "Drill") then
		SpeedBoost = machine:GetSpeedBoost()

		if (SpeedBoost > 0) then
			SpeedBoost = " (-" .. math.Round(zrush.config.Machine[machineID].Speed * SpeedBoost, 2) .. "s)"
		else
			SpeedBoost = ""
		end

		ExtraPipes = machine:GetExtraPipes()

		if (ExtraPipes > 0) then
			ExtraPipes = " (+" .. ExtraPipes .. ")"
		else
			ExtraPipes = ""
		end

		AntiJamBoost = machine:GetAntiJamBoost()
		local chaoeseventBoost = 0

		if (IsValid(machine) and IsValid(machine:GetHole())) then
			chaoeseventBoost = machine:GetHole():GetChaosEventBoost()
		end

		if (AntiJamBoost > 0) then
			AntiJamBoost = " (-" .. math.Round((zrush.config.Machine[machineID].JamChance + chaoeseventBoost) * AntiJamBoost, 2) .. "%)"
		else
			AntiJamBoost = ""
		end

		aHole = machine:GetHole()

		if (IsValid(aHole)) then
			statTable[1] = {
				stat = zrush.language.VGUI["TimeprePipe"],
				statVal = zrush.f.ReturnBoostValue(machineID, "speed", machine) .. "s" .. SpeedBoost
			}

			statTable[2] = {
				stat = zrush.language.VGUI["PipesinQueue"],
				statVal = "(" .. machine:GetPipes() .. "/" .. zrush.f.ReturnBoostValue(machineID, "pipes", machine) .. ")" .. ExtraPipes
			}

			statTable[3] = {
				stat = zrush.language.VGUI["NeededPipes"],
				statVal = "(" .. (aHole:GetNeededPipes() - aHole:GetPipes()) .. ")"
			}

			statTable[4] = {
				stat = zrush.language.VGUI["JamChance"],
				statVal = zrush.f.ReturnBoostValue(machineID, "antijam", machine) .. "%" .. AntiJamBoost
			}
		end
	elseif (machineID == "Burner") then
		SpeedBoost = machine:GetSpeedBoost()

		if (SpeedBoost > 0) then
			SpeedBoost = " (-" .. math.Round(zrush.config.Machine[machineID].Speed * SpeedBoost, 2) .. "s)"
		else
			SpeedBoost = ""
		end

		ProductionBoost = machine:GetProductionBoost()

		if (ProductionBoost > 0) then
			ProductionBoost = " (+" .. math.Round(zrush.config.Machine[machineID].Amount * ProductionBoost, 2) .. ")"
		else
			ProductionBoost = ""
		end

		CoolingBoost = machine:GetCoolingBoost()
		local chaoeseventBoost = 0

		if (IsValid(machine) and IsValid(machine:GetHole())) then
			chaoeseventBoost = machine:GetHole():GetChaosEventBoost()
		end

		if (CoolingBoost > 0) then
			CoolingBoost = " (-" .. math.Round((zrush.config.Machine[machineID].OverHeat_Chance + chaoeseventBoost) * CoolingBoost, 2) .. "%)"
		else
			CoolingBoost = ""
		end

		aHole = machine:GetHole()

		if (IsValid(aHole)) then
			statTable[1] = {
				stat = zrush.language.VGUI["Speed"],
				statVal = zrush.f.ReturnBoostValue(machineID, "speed", machine) .. "s" .. SpeedBoost
			}

			statTable[2] = {
				stat = zrush.language.VGUI["BurnAmount"],
				statVal = zrush.f.ReturnBoostValue(machineID, "production", machine) .. ProductionBoost
			}

			statTable[3] = {
				stat = zrush.language.VGUI["RemainingGas"],
				statVal = math.Clamp(math.Round(aHole:GetGas(), 2), 0, 9999999)
			}

			statTable[4] = {
				stat = zrush.language.VGUI["OverHeatChance"],
				statVal = zrush.f.ReturnBoostValue(machineID, "cooling", machine) .. "%" .. CoolingBoost
			}
		end
	elseif (machineID == "Pump") then
		SpeedBoost = machine:GetSpeedBoost()

		if (SpeedBoost > 0) then
			SpeedBoost = " (-" .. math.Round(zrush.config.Machine[machineID].Speed * SpeedBoost, 2) .. "s)"
		else
			SpeedBoost = ""
		end

		ProductionBoost = machine:GetProductionBoost()

		if (ProductionBoost > 0) then
			ProductionBoost = " (+" .. math.Round(zrush.config.Machine[machineID].Amount * ProductionBoost, 2) .. ")"
		else
			ProductionBoost = ""
		end

		AntiJamBoost = machine:GetAntiJamBoost()
		local chaoeseventBoost = 0

		if (IsValid(machine) and IsValid(machine:GetHole())) then
			chaoeseventBoost = machine:GetHole():GetChaosEventBoost()
		end

		if (AntiJamBoost > 0) then
			AntiJamBoost = " (-" .. math.Round((zrush.config.Machine[machineID].JamChance + chaoeseventBoost) * AntiJamBoost, 2) .. "%)"
		else
			AntiJamBoost = ""
		end

		aHole = machine:GetHole()
		local oilBarrel = machine:GetBarrel()
		local oil = zrush.language.VGUI["NA"]

		if (IsValid(oilBarrel)) then
			oil = math.Round(math.Clamp(oilBarrel:GetOil(), 0, 9999999), 2)
		end

		if (IsValid(aHole)) then
			statTable[1] = {
				stat = zrush.language.VGUI["Speed"],
				statVal = zrush.f.ReturnBoostValue(machineID, "speed", machine) .. "s" .. SpeedBoost
			}

			statTable[2] = {
				stat = zrush.language.VGUI["PumpAmount"],
				statVal = zrush.f.ReturnBoostValue(machineID, "production", machine) .. ProductionBoost
			}

			statTable[3] = {
				stat = zrush.language.VGUI["BarrelOIL"],
				statVal = oil
			}

			statTable[4] = {
				stat = zrush.language.VGUI["RemainingOil"],
				statVal = math.Round(math.Clamp(aHole:GetOilAmount(), 0, 9999999), 2) .. zrush.config.UoM
			}

			statTable[5] = {
				stat = zrush.language.VGUI["JamChance"],
				statVal = zrush.f.ReturnBoostValue(machineID, "antijam", machine) .. "%" .. AntiJamBoost
			}
		end
	elseif (machineID == "Refinery") then
		SpeedBoost = machine:GetSpeedBoost()

		if (SpeedBoost > 0) then
			SpeedBoost = " (-" .. math.Round(zrush.config.Machine[machineID].Speed * SpeedBoost, 2) .. "s)"
		else
			SpeedBoost = ""
		end

		ProductionBoost = machine:GetProductionBoost()

		if (ProductionBoost > 0) then
			ProductionBoost = " (+" .. math.Round(zrush.config.Machine[machineID].Amount * ProductionBoost, 2) .. zrush.config.UoM .. ")"
		else
			ProductionBoost = ""
		end

		RefineBoost = machine:GetRefineBoost()

		if (RefineBoost > 0) then
			RefineBoost = " (+" .. math.Round((zrush.f.ReturnBoostValue(machineID, "production", machine) * RefineBoost) / 10, 2) .. zrush.config.UoM .. ")"
		else
			RefineBoost = ""
		end

		CoolingBoost = machine:GetCoolingBoost()

		if (CoolingBoost > 0) then
			CoolingBoost = " (-" .. math.Round(zrush.config.Machine[machineID].OverHeat_Chance * CoolingBoost, 2) .. "%)"
		else
			CoolingBoost = ""
		end

		local oilBarrel = machine:GetInputBarrel()
		local oil = zrush.language.VGUI["NA"]
		local fuelBarrel = machine:GetOutputBarrel()
		local fuel = zrush.language.VGUI["NA"]

		if (IsValid(oilBarrel)) then
			oil = math.Round(math.Clamp(oilBarrel:GetOil(), 0, 9999999), 1) .. zrush.config.UoM
		end

		if (IsValid(fuelBarrel)) then
			fuel = math.Round(math.Clamp(fuelBarrel:GetFuel(), 0, 9999999), 1) .. zrush.config.UoM
		end

		statTable[1] = {
			stat = zrush.language.VGUI["Fuel"],
			statVal = zrush.Fuel[machine:GetFuelTypeID()].name
		}

		statTable[2] = {
			stat = zrush.language.VGUI["Speed"],
			statVal = zrush.f.ReturnBoostValue(machineID, "speed", machine) .. "s" .. SpeedBoost
		}

		statTable[3] = {
			stat = zrush.language.VGUI["RefineAmount"],
			statVal = zrush.f.ReturnBoostValue(machineID, "production", machine) .. zrush.config.UoM .. ProductionBoost
		}

		statTable[4] = {
			stat = zrush.language.VGUI["RefineOutput"],
			statVal = zrush.f.ReturnBoostValue(machineID, "production", machine) * zrush.f.ReturnBoostValue(machineID, "refining", machine) .. zrush.config.UoM .. RefineBoost
		}

		statTable[5] = {
			stat = zrush.language.VGUI["OverHeatChance"],
			statVal = zrush.f.ReturnBoostValue(machineID, "cooling", machine) .. "%" .. CoolingBoost
		}

		statTable[6] = {
			stat = zrush.language.VGUI["BarrelOIL"],
			statVal = oil
		}

		statTable[7] = {
			stat = zrush.language.VGUI["BarrelFuel"],
			statVal = fuel
		}
	end

	return statTable
end

// This creates our Machien statistic panel
function zrush.VGUI.MachineStats(parent)
	if (zrush_Stats and IsValid(zrush_Stats.Panel)) then
		zrush_Stats.Panel:Remove()
	end

	zrush_Stats = {}
	local machine = zrush_MachineEntity
	local machineID = machine.MachineID
	local cState
	local stateMessage
	local astatTable = BuildStatTable(machine, machineID)
	local statPanelWith = 700
	local statOffset = 315

	if (machineID == "Drill") then
		aHole = machine:GetHole()
		cState = machine:GetState()
		stateMessage = zrush.language.VGUI.DrillTower[cState]
	elseif (machineID == "Burner") then
		aHole = machine:GetHole()
		cState = machine:GetState()
		stateMessage = zrush.language.VGUI.Burner[cState]
	elseif (machineID == "Pump") then
		aHole = machine:GetHole()
		cState = machine:GetState()
		stateMessage = zrush.language.VGUI.Pump[cState]
	elseif (machineID == "Refinery") then
		cState = machine:GetState()
		stateMessage = zrush.language.VGUI.Refinery[cState]
		statPanelWith = 425
		statOffset = 100
	end

	zrush_Stats.Panel = vgui.Create("Panel", parent)
	zrush_Stats.Panel:SetPos(0 * wMod, 75 * hMod)
	zrush_Stats.Panel:SetSize(statPanelWith * wMod, 300 * hMod)

	zrush_Stats.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)

		if zrush_Stats.Panel:IsHovered() and zrush_LastHoverdElement ~= zrush_Stats.Panel then
			zrush_LastHoverdElement = zrush_Stats.Panel
		end
	end

	zrush_Stats.Status = vgui.Create("DLabel", zrush_Stats.Panel)
	zrush_Stats.Status:SetPos(25 * wMod, 10 * hMod)
	zrush_Stats.Status:SetSize(600 * wMod, 300 * hMod)
	zrush_Stats.Status:SetFont("zrush_vgui_font03")
	zrush_Stats.Status:SetColor(zrush.default_colors["white01"])
	zrush_Stats.Status:SetText(zrush.language.VGUI["Status"])
	zrush_Stats.Status:SetAutoStretchVertical(true)
	zrush_Stats.Status:SetAutoDelete(true)

	zrush_Stats.StatusValue = vgui.Create("DLabel", zrush_Stats.Panel)
	zrush_Stats.StatusValue:SetPos((statOffset - 100) * wMod, 22 * hMod)
	zrush_Stats.StatusValue:SetSize(400 * wMod, 300 * hMod)
	zrush_Stats.StatusValue:SetFont("zrush_vgui_font05")
	zrush_Stats.StatusValue:SetColor(Color(255, 125, 0, 255))
	zrush_Stats.StatusValue:SetText(tostring(stateMessage))
	zrush_Stats.StatusValue:SetAutoStretchVertical(true)
	zrush_Stats.StatusValue:SetAutoDelete(true)
	zrush_Stats.StatusValue:SetContentAlignment(3)

	zrush_Stats.StatusLine = vgui.Create("Panel", zrush_Stats.Panel)
	zrush_Stats.StatusLine:SetPos(0 * wMod, 45 * hMod)
	zrush_Stats.StatusLine:SetSize(zrush_Stats.Panel:GetWide(), 3 * hMod)

	zrush_Stats.StatusLine.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 25)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	for i = 1, table.Count(astatTable) do
		zrush_Stats[i] = {}
		zrush_Stats[i].name = vgui.Create("DLabel", zrush_Stats.Panel)
		zrush_Stats[i].name:SetPos(25 * wMod, (25 + (33 * i)) * hMod)
		zrush_Stats[i].name:SetSize(550 * wMod, 300 * hMod)
		zrush_Stats[i].name:SetFont("zrush_vgui_font02")
		zrush_Stats[i].name:SetColor(Color(200, 200, 200))
		zrush_Stats[i].name:SetText(astatTable[i].stat)
		zrush_Stats[i].name:SetAutoStretchVertical(true)
		zrush_Stats[i].name:SetAutoDelete(true)
		zrush_Stats[i].name:SetContentAlignment(4)

		zrush_Stats[i].value = vgui.Create("DLabel", zrush_Stats.Panel)
		zrush_Stats[i].value:SetPos(statOffset * wMod, (25 + (33 * i)) * hMod)
		zrush_Stats[i].value:SetSize(300 * wMod, 300 * hMod)
		zrush_Stats[i].value:SetFont("zrush_vgui_font02")
		zrush_Stats[i].value:SetColor(Color(255, 125, 0, 255))
		zrush_Stats[i].value:SetText(astatTable[i].statVal)
		zrush_Stats[i].value:SetAutoStretchVertical(true)
		zrush_Stats[i].value:SetAutoDelete(true)
		zrush_Stats[i].value:SetContentAlignment(6)

		zrush_Stats[i].line = vgui.Create("Panel", zrush_Stats.Panel)
		zrush_Stats[i].line:SetPos(0 * wMod, (51 + (33 * i)) * hMod)
		zrush_Stats[i].line:SetSize(zrush_Stats.Panel:GetWide(), 3 * hMod)

		zrush_Stats[i].line.Paint = function(self, w, h)
			surface.SetDrawColor(255, 255, 255, 5)
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
end

///////////
/////////// Fuel Type Slection
// This creates our Machien statistic panel
function zrush.VGUI.RefineryFuelType(parent)
	local machine = zrush_MachineEntity
	local machineID = machine.MachineID

	if (machineID == "Refinery") then
		if (zrush_FuelSelection and IsValid(zrush_FuelSelection.Panel)) then
			zrush_FuelSelection.Panel:Remove()
		end

		if (zrush_FuelItems and IsValid(zrush_FuelItems.list)) then
			zrush_FuelItems.list:Remove()
		end

		zrush_FuelSelection = {}
		zrush_FuelSelection.Panel = vgui.Create("Panel", parent)
		zrush_FuelSelection.Panel:SetPos(450 * wMod, 75 * hMod)
		zrush_FuelSelection.Panel:SetSize(250 * wMod, 300 * hMod)
		zrush_FuelSelection.Panel:SetContentAlignment(7)

		zrush_FuelSelection.Panel.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 0)
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		zrush_FuelSelection.scrollpanel = vgui.Create("DScrollPanel", zrush_FuelSelection.Panel)
		zrush_FuelSelection.scrollpanel:DockMargin(0 * wMod, 0 * hMod, 15 * wMod, 0 * hMod)
		zrush_FuelSelection.scrollpanel:Dock(FILL)
		zrush_FuelSelection.scrollpanel:SetAutoDelete(true)
		zrush_FuelSelection.scrollpanel:GetVBar().Paint = function() return true end
		zrush_FuelSelection.scrollpanel:GetVBar().btnUp.Paint = function() return true end
		zrush_FuelSelection.scrollpanel:GetVBar().btnDown.Paint = function() return true end

		zrush_FuelSelection.scrollpanel.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 0)
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w - (20 * wMod), h)
		end

		// Here we create the Fuel items that can be selected or select the new fuel item if they allready exist
		zrush_FuelItems = {}
		zrush_FuelItems.list = vgui.Create("DIconLayout", zrush_FuelSelection.scrollpanel)
		zrush_FuelItems.list:SetSize(220 * wMod, 200 * hMod)
		zrush_FuelItems.list:SetPos(0 * wMod, 18 * hMod)
		zrush_FuelItems.list:SetSpaceY(6)
		zrush_FuelItems.list:SetAutoDelete(true)

		for k, v in pairs(zrush.Fuel) do
			zrush_FuelItems[k] = zrush_FuelItems.list:Add("DPanel")
			zrush_FuelItems[k]:SetSize(zrush_FuelItems.list:GetWide(), 55 * hMod)
			zrush_FuelItems[k]:SetAutoDelete(true)

			zrush_FuelItems[k].Paint = function(self, w, h)
				if self:IsHovered() and zrush_LastHoverdElement ~= k then
					zrush_LastHoverdElement = k
					surface.PlaySound("zrush/zrush_ui_hover.wav")
				end

				surface.SetDrawColor(0, 0, 0, 0)
				surface.SetMaterial(zrush.default_materials["square"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_FuelItems[k].SelectionBG = vgui.Create("DImage", zrush_FuelItems[k])
			zrush_FuelItems[k].SelectionBG:SetPos(0 * wMod, 0 * hMod)
			zrush_FuelItems[k].SelectionBG:SetSize(zrush_FuelItems.list:GetWide() - 5 * wMod, 50 * hMod)
			zrush_FuelItems[k].SelectionBG:SetVisible(true)
			zrush_FuelItems[k].SelectionBG:SetAutoDelete(true)

			zrush_FuelItems[k].SelectionBG.Paint = function(self, w, h)
				if (k == zrush_SELECTED_FUEL) then
					surface.SetDrawColor(zrush.default_colors["orange02"])
				else
					surface.SetDrawColor(70, 255, 70, 0)
				end

				surface.SetMaterial(zrush.default_materials["ui_fuel_item_selection"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_FuelItems[k].button = vgui.Create("DButton", zrush_FuelItems[k])
			zrush_FuelItems[k].button:SetPos(5 * wMod, 5 * hMod)
			zrush_FuelItems[k].button:SetSize(zrush_FuelItems.list:GetWide() - 15 * wMod, 40 * hMod)
			zrush_FuelItems[k].button:SetText("")
			zrush_FuelItems[k].button:SetAutoDelete(true)

			zrush_FuelItems[k].button.Paint = function(self, w, h)
				local panelcolor = zrush.default_colors["black01"]

				if (k == zrush_SELECTED_FUEL) then
					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a)
				else
					if (zrush_FuelItems[k].button:IsHovered()) then
						if (zrush_LastHoverdElement ~= k) then
							zrush_LastHoverdElement = k
							surface.PlaySound("zrush/zrush_ui_hover.wav")
						end

						surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a)
					else
						surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.4)
					end
				end

				surface.SetMaterial(zrush.default_materials["square"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_FuelItems[k].button.DoClick = function()
				local aMachine = zrush_MachineEntity

				if (not zrush.f.IsOwner(LocalPlayer(), machine)) then
					if IsValid(aMachine) then
						net.Start("zrush_ChangeFuel_net")
						net.WriteEntity(aMachine)
						net.WriteInt(zrush_SELECTED_FUEL, 16)
						net.SendToServer()
					end

					return
				end

				if zrush.f.HasAllowedRank(LocalPlayer(), v.ranks) then
					zrush.VGUI.DeselectItem()
					zrush_SELECTED_FUEL = k

					if zrush_SELECTED_FUEL then
						if IsValid(aMachine) then
							net.Start("zrush_ChangeFuel_net")
							net.WriteEntity(aMachine)
							net.WriteInt(zrush_SELECTED_FUEL, 16)
							net.SendToServer()
						end

						timer.Simple(0.1, function()
							zrush.VGUI.MachineStats(zrush.VGUI.Main.Panel)
							zrush.VGUI.RefineryFuelType(zrush.VGUI.Main.Panel)

							for i, w in pairs(zrush_FuelItems) do
								if (i ~= zrush_SELECTED_FUEL and IsValid(w.FuelName)) then
									w.FuelName:SetColor(zrush.default_colors["white04"])
								end
							end
						end)
					end
				else

					zrush.f.InterfaceNotify(zrush.language.VGUI["WrongUserGroup"], 3,0)
				end

				surface.PlaySound("zrush/zrush_command.wav")
			end

			zrush_FuelItems[k].FuelName = vgui.Create("DLabel", zrush_FuelItems[k].button)
			zrush_FuelItems[k].FuelName:SetPos(5 * wMod, 10 * hMod)
			zrush_FuelItems[k].FuelName:SetSize(300 * wMod, 125 * hMod)
			zrush_FuelItems[k].FuelName:SetFont("zrush_vgui_fuelitem")
			zrush_FuelItems[k].FuelName:SetText(v.name)
			if (zrush_SELECTED_FUEL == k) then
				zrush_FuelItems[k].FuelName:SetColor(zrush.default_colors["white01"])
			else
				zrush_FuelItems[k].FuelName:SetColor(zrush.default_colors["white04"])
			end
			zrush_FuelItems[k].FuelName:SetAutoDelete(true)
			zrush_FuelItems[k].FuelName:SetContentAlignment(7)

			zrush_FuelItems[k].ImageBG = vgui.Create("DImage", zrush_FuelItems[k].button)
			zrush_FuelItems[k].ImageBG:SetPos(172 * wMod, 2.5 * hMod)
			zrush_FuelItems[k].ImageBG:SetSize(35 * wMod, 35 * hMod)
			zrush_FuelItems[k].ImageBG:SetAutoDelete(true)

			zrush_FuelItems[k].ImageBG.Paint = function(self, w, h)
				local panelcolor = v.color

				if (k == zrush_SELECTED_FUEL) then
					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.75)
				else
					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.05)
				end

				surface.SetMaterial(zrush.default_materials["barrel_icon"])
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	else
		if (zrush_FuelSelection and IsValid(zrush_FuelSelection.Panel)) then
			zrush_FuelSelection.Panel:Remove()
		end
	end
end

///////////
/////////// Installed Modules
// This creates our Installed Module Panel
function zrush.VGUI.InstalledModules(parent)
	if (zrush_Modules and IsValid(zrush_Modules.Locked)) then
		zrush_Modules.Locked:Remove()
	end

	if (zrush_Modules and IsValid(zrush_Modules.LockedTitle)) then
		zrush_Modules.LockedTitle:Remove()
	end

	if (zrush_Modules and IsValid(zrush_Modules.Panel)) then
		zrush_Modules.Panel:Remove()
	end

	zrush_Modules = {}
	zrush_ModulesItem = {}
	zrush_Modules.Panel = vgui.Create("Panel", parent)
	zrush_Modules.Panel:SetPos(0 * wMod, 400 * hMod)
	zrush_Modules.Panel:SetSize(700 * wMod, 150 * hMod)
	zrush_Modules.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)

		if zrush_Modules.Panel:IsHovered() and zrush_LastHoverdElement ~= zrush_Modules.Panel then
			zrush_LastHoverdElement = zrush_Modules.Panel
		end
	end
	zrush_Modules.Panel:SetAutoDelete(true)


	local ent = zrush_MachineEntity
	local installedModules = LocalPlayer().zrush_InstalledModules

	if (installedModules ~= nil and table.Count(installedModules) > 0) then
		local m_count = 1
		for _,m_id in pairs(installedModules) do
			local mData = zrush.AbilityModules[m_id]

			zrush_ModulesItem[m_id] = vgui.Create("Panel", zrush_Modules.Panel)
			zrush_ModulesItem[m_id]:SetPos((40 + (120 * (m_count - 1))) * wMod, 25 * hMod)
			zrush_ModulesItem[m_id]:SetSize(100 * wMod, 100 * hMod)
			zrush_ModulesItem[m_id]:SetAutoDelete(true)
			zrush_ModulesItem[m_id].Paint = function(self, w, h)
				surface.SetDrawColor(0, 0, 0, 0)
				surface.SetMaterial(zrush.default_materials["square"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_ModulesItem[m_id].ImageBG = vgui.Create("DImage", zrush_ModulesItem[m_id])
			zrush_ModulesItem[m_id].ImageBG:SetPos(3 * wMod, 2.4 * hMod)
			zrush_ModulesItem[m_id].ImageBG:SetSize(97 * wMod, 97 * hMod)
			zrush_ModulesItem[m_id].ImageBG:SetAutoDelete(true)
			zrush_ModulesItem[m_id].ImageBG.Paint = function(self, w, h)
				surface.SetDrawColor(70, 255, 70)
				surface.SetMaterial(zrush.default_materials["ui_circle_selection"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_ModulesItem[m_id].ImageBG:SetVisible(false)
			local mType = mData.type
			local mIcon = zrush.default_materials["module_speed"]
			local mAmount = "nil"
			local mAmountInfoShort = "nil"

			if (mType == "pipes") then
				mAmount = mData.amount
				mAmountInfo = zrush.language.VGUI["pipes"] .. mAmount
				mAmountInfoShort = "+" .. mAmount
			else
				mAmount = 100 * mData.amount
				mAmountInfo = zrush.language.VGUI["BoostAmount"] .. mAmount .. "%"
				mAmountInfoShort = "+" .. mAmount .. "%"
			end

			zrush_ModulesItem[m_id].button = vgui.Create("DButton", zrush_ModulesItem[m_id])
			zrush_ModulesItem[m_id].button:SetPos(0 * wMod, 0 * hMod)
			zrush_ModulesItem[m_id].button:SetSize(zrush_ModulesItem[m_id].Panel:GetWide(), 100 * hMod)
			zrush_ModulesItem[m_id].button:SetText("")
			zrush_ModulesItem[m_id].button:SetAutoDelete(true)
			zrush_ModulesItem[m_id].button.Paint = function(self, w, h)
				if zrush_ModulesItem[m_id].button:IsHovered() then
					surface.SetDrawColor(110, 110, 110, 255)
				else
					surface.SetDrawColor(70, 70, 70, 255)
				end

				surface.SetMaterial(zrush.default_materials["circle"])
				surface.DrawTexturedRect(0, 0, w, h)
			end
			zrush_ModulesItem[m_id].button.DoClick = function()
				zrush_SELECTED_MODULE = m_id

				if (IsValid(LAST_SELECTED)) then
					LAST_SELECTED:SetVisible(false)
				end

				LAST_SELECTED = zrush_ModulesItem[m_id].ImageBG
				LAST_SELECTED:SetVisible(true)
				surface.PlaySound("zrush/zrush_command.wav")

				if (zrush.f.IsOwner(LocalPlayer(), ent)) then
					zrush_ShopMenu.purchase:SetVisible(false)
					zrush_ShopMenu.Sell:SetVisible(true)
				end

				zrush_ShopMenu.ModuleName:SetText(mData.name)
				zrush_ShopMenu.ModulePrice:SetText(zrush.config.Currency .. tostring(mData.price * zrush.config.SellValue))
				zrush_ShopMenu.ModuleType:SetText(zrush.language.VGUI[mType] .. "  | " .. mAmountInfoShort)

				// Show needed ranks
				local allowed = zrush.f.KeyTableConcat(mData.ranks, " | ")
				if string.len(allowed) > 25 then
					allowed = string.sub(allowed,1,25) .. "..."
				end
				zrush_ShopMenu.ModuleBoostAllowed:SetText(allowed)

				//Show needed jobs
				local allowedJobs = zrush.f.KeyTableConcat(mData.jobs, " | ")
				if string.len(allowedJobs) > 25 then
					allowedJobs = string.sub(allowedJobs,1,25) .. "..."
				end
				zrush_ShopMenu.ModuleBoostAllowedJobs:SetText(allowedJobs)
				zrush_ShopMenu.ModuleDesc:SetText(mData.desc)
			end

			if (LocalPlayer().zrush_HasChaosEvent) then
				zrush_ModulesItem[m_id].button:SetEnabled(false)
			end

			if (mType == "speed") then
				mIcon = zrush.default_materials["module_speed"]
			elseif (mType == "production") then
				mIcon = zrush.default_materials["module_production"]
			elseif (mType == "antijam") then
				mIcon = zrush.default_materials["module_antijam"]
			elseif (mType == "cooling") then
				mIcon = zrush.default_materials["module_cooling"]
			elseif (mType == "pipes") then
				mIcon = zrush.default_materials["module_morepipes"]
			elseif (mType == "refining") then
				mIcon = zrush.default_materials["module_refining"]
			end

			zrush_ModulesItem[m_id].Image = vgui.Create("DImage", zrush_ModulesItem[m_id])
			zrush_ModulesItem[m_id].Image:SetPos(20 * wMod, 20 * hMod)
			zrush_ModulesItem[m_id].Image:SetSize(60 * wMod, 60 * hMod)
			zrush_ModulesItem[m_id].Image:SetAutoDelete(true)
			zrush_ModulesItem[m_id].Image.Paint = function(self, w, h)
				surface.SetDrawColor(mData.color)
				surface.SetMaterial(mIcon)
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_ModulesItem[m_id].Title = vgui.Create("DLabel", zrush_ModulesItem[m_id])
			zrush_ModulesItem[m_id].Title:SetPos(0 * wMod, 0 * hMod)
			zrush_ModulesItem[m_id].Title:SetSize(100 * wMod, 100 * hMod)
			zrush_ModulesItem[m_id].Title:SetFont("zrush_vgui_font06")
			zrush_ModulesItem[m_id].Title:SetColor(zrush.default_colors["white01"])
			zrush_ModulesItem[m_id].Title:SetText(mAmountInfoShort)
			zrush_ModulesItem[m_id].Title:SetAutoDelete(true)
			zrush_ModulesItem[m_id].Title:SetContentAlignment(5)

			zrush_ModulesItem[m_id].ImageFG = vgui.Create("DImage", zrush_ModulesItem[m_id])
			zrush_ModulesItem[m_id].ImageFG:SetPos(7 * wMod, 7 * hMod)
			zrush_ModulesItem[m_id].ImageFG:SetSize(87 * wMod, 87 * hMod)
			zrush_ModulesItem[m_id].ImageFG:SetAutoDelete(true)
			zrush_ModulesItem[m_id].ImageFG.Paint = function(self, w, h)
				surface.SetDrawColor(255, 255, 255, 15)
				surface.SetMaterial(zrush.default_materials["glam_circle"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			m_count = m_count + 1
		end
	end

	// This creates the Background Panel for the sockets
	for i = 1, zrush.config.Machine[ent.MachineID].Module_Sockets do
		local key = "modulebg" .. i
		zrush_ModulesItem[key] = vgui.Create("DImage", zrush_Modules.Panel)
		zrush_ModulesItem[key]:SetPos((40 + (120 * (i - 1))) * wMod, 25 * hMod)
		zrush_ModulesItem[key]:SetSize(100 * wMod, 100 * hMod)
		zrush_ModulesItem[key]:SetAutoDelete(true)

		zrush_ModulesItem[key].Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetMaterial(zrush.default_materials["shadow_circle"])
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end

	if (LocalPlayer().zrush_HasChaosEvent == true) then
		zrush_Modules.Locked = vgui.Create("Panel", parent)
		zrush_Modules.Locked:SetPos(0 * wMod, 400 * hMod)
		zrush_Modules.Locked:SetSize(700 * wMod, 150 * hMod)
		zrush_Modules.Locked:SetAutoDelete(true)

		zrush_Modules.Locked.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 225)
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		zrush_Modules.LockedTitle = vgui.Create("DLabel", zrush_Modules.Locked)
		zrush_Modules.LockedTitle:SetPos(0 * wMod, 60 * hMod)
		zrush_Modules.LockedTitle:SetSize(700 * wMod, 300 * hMod)
		zrush_Modules.LockedTitle:SetFont("zrush_vgui_font03")
		zrush_Modules.LockedTitle:SetColor(Color(255, 75, 75))
		zrush_Modules.LockedTitle:SetText(zrush.language.VGUI["FixMachinefirst"])
		zrush_Modules.LockedTitle:SetAutoStretchVertical(true)
		zrush_Modules.LockedTitle:SetContentAlignment(5)
		zrush_Modules.LockedTitle:SetAutoDelete(true)
	end
end

///////////
/////////// Actions
// This creates our Action Panel
function zrush.VGUI.MachineActions(parent)
	zrush.f.Debug("zrush.VGUI.MachineActions")
	if (zrush_Actions and IsValid(zrush_Actions.Panel)) then
		zrush_Actions.Panel:Remove()
	end

	zrush_Actions = {}
	zrush_Actions.Panel = vgui.Create("Panel", parent)
	zrush_Actions.Panel:SetPos(0 * wMod, 575 * hMod)
	zrush_Actions.Panel:SetSize(700 * wMod, 175 * hMod)

	zrush_Actions.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
		if zrush_Actions.Panel:IsHovered() and zrush_LastHoverdElement ~= zrush_Actions.Panel then
			zrush_LastHoverdElement = zrush_Actions.Panel
		end
	end

	zrush_Actions.Title = vgui.Create("DLabel", zrush_Actions.Panel)
	zrush_Actions.Title:SetPos(32 * wMod, 10 * hMod)
	zrush_Actions.Title:SetSize(310 * wMod, 300 * hMod)
	zrush_Actions.Title:SetFont("zrush_vgui_font03")
	zrush_Actions.Title:SetColor(zrush.default_colors["white01"])
	zrush_Actions.Title:SetText(zrush.language.VGUI["Actions"])
	zrush_Actions.Title:SetAutoStretchVertical(true)
	zrush_Actions.Title:SetAutoDelete(true)
	local machine = zrush_MachineEntity
	local machineID = machine.MachineID
	local actionsTable = zrush.VGUI.MachineActions_CreateActionTable(machineID, machine)

	for i = 1, table.Count(actionsTable) do
		zrush_Actions[i] = vgui.Create("DButton", zrush_Actions.Panel)
		zrush_Actions[i]:SetText("")
		zrush_Actions[i]:SetPos(((125 * i) - 95) * wMod, 50 * hMod)
		zrush_Actions[i]:SetSize(100 * wMod, 100 * hMod)
		zrush_Actions[i]:SetAutoDelete(true)
		//zrush_Actions[i]:SetContentAlignment(5)
		local buttonColor = actionsTable[i][3]
		zrush_Actions[i]:SetColor(buttonColor)

		zrush_Actions[i].DoClick = function()
			net.Start("zrush_PerformAction_net")
			net.WriteEntity(zrush_MachineEntity)
			net.WriteInt(actionsTable[i][2], 16)
			net.SendToServer()
		end

		zrush_Actions[i].Paint = function(self, w, h)
			surface.SetDrawColor(buttonColor)
			surface.SetMaterial(zrush.default_materials["ui_action_button"])
			surface.DrawTexturedRect(0, 0, w, h)

			if zrush_Actions[i]:IsHovered() then
				surface.SetDrawColor(zrush.default_colors["green05"])
				surface.SetMaterial(zrush.default_materials["ui_action_button_hover"])
				surface.DrawTexturedRect(0, 0, w, h)

				if (zrush_LastHoverdElement ~= i) then
					zrush_LastHoverdElement = i
					surface.PlaySound("zrush/zrush_ui_hover.wav")
				end
			end

			surface.SetFont("zrush_vgui_font04")
			surface.SetTextColor(zrush.default_colors["white01"])
			surface.SetTextPos(5 * wMod, 80 * hMod)
			surface.DrawText(actionsTable[i][1])
			surface.SetDrawColor(255, 255, 255, 25)
			surface.SetMaterial(zrush.default_materials["ui_action_button_shine"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		zrush_Actions[i].ImageIcon = vgui.Create("DImage", zrush_Actions[i])
		zrush_Actions[i].ImageIcon:SetPos(0 * wMod, 0 * hMod)
		zrush_Actions[i].ImageIcon:SetSize(100 * wMod, 100 * hMod)
		zrush_Actions[i].ImageIcon:SetAutoDelete(true)
		zrush_Actions[i].ImageIcon:SetContentAlignment(5)

		zrush_Actions[i].ImageIcon.Paint = function(self, w, h)
			surface.SetDrawColor(Color(buttonColor.r * 0.8, buttonColor.g * 0.8, buttonColor.b * 0.8, buttonColor.a))
			surface.SetMaterial(actionsTable[i][4])
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
end

// This creates our Button Table depending on the state of the machine
function zrush.VGUI.MachineActions_CreateActionTable(machineID, machine)
	local actionsTable = {}

	if (machineID == "Drill") then
		if (machine:GetJammed()) then
			table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Repair"], 2))
		else
			if (machine:GetIsRunning()) then
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Stop"], 5))
			else
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Disassemble"], 1))
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Start"], 4))
			end
		end
	elseif (machineID == "Burner") then
		if (machine:GetOverHeat()) then
			table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["CoolDown"], 3))
		else
			if (machine:GetIsRunning()) then
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Disassemble"], 1))
			else
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Disassemble"], 1))
			end
		end
	elseif (machineID == "Pump") then
		if (machine:GetJammed()) then
			table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Repair"], 2))
		else
			if (machine:GetIsRunning()) then
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Stop"], 5))
			else
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Disassemble"], 1))
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Start"], 4))
			end
		end
	elseif (machineID == "Refinery") then
		if (machine:GetOverHeat()) then
			table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["CoolDown"], 3))
		else
			if (machine:GetIsRunning()) then
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Stop"], 5))
			else
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Disassemble"], 1))
				table.insert(actionsTable, zrush.VGUI.MachineActions_AddActionButton(zrush.language.VGUI["Start"], 4))
			end
		end
	end

	return actionsTable
end

// This creates a Button element
function zrush.VGUI.MachineActions_AddActionButton(name, btype)
	local col = zrush.default_colors["black01"]

	if (btype == 1) then
		col = zrush.default_colors["action01"]
		icon = zrush.default_materials["zrush_dissamble_icon"]
	elseif (btype == 2) then
		col = zrush.default_colors["action02"]
		icon = zrush.default_materials["zrush_dissamble_icon"]
	elseif (btype == 3) then
		col = zrush.default_colors["action03"]
		icon = zrush.default_materials["zrush_cooldown_icon"]
	elseif (btype == 4) then
		col = zrush.default_colors["action04"]
		icon = zrush.default_materials["zrush_start_icon"]
	elseif (btype == 5) then
		col = zrush.default_colors["action05"]
		icon = zrush.default_materials["zrush_stop_icon"]
	end

	local button = {}

	button = {
		[1] = name,
		[2] = btype,
		[3] = col,
		[4] = icon
	}

	return button
end

///////////
/////////// Shop Menu
// This deselects the current item and hides the module info and buttons
function zrush.VGUI.DeselectItem()
	//zrush_ShopMenu.purchase:SetEnabled( false )
	zrush_ShopMenu.purchase:SetVisible(false)
	//zrush_ShopMenu.Sell:SetEnabled( false )
	zrush_ShopMenu.Sell:SetVisible(false)

	if (IsValid(LAST_SELECTED)) then
		LAST_SELECTED:SetVisible(false)
	end

	surface.PlaySound("zrush/zrush_command.wav")
	zrush_ShopMenu.ModuleName:SetText(" ")
	zrush_ShopMenu.ModulePrice:SetText(" ")
	zrush_ShopMenu.ModuleType:SetText(" ")
	zrush_ShopMenu.ModuleBoostAllowed:SetText(" ")
	zrush_ShopMenu.ModuleDesc:SetText(" ")
end

// This Creats our Module Shop Panel
function zrush.VGUI.MachineModuleShop(parent)
	zrush_ShopMenu = {}
	// The Base Shop UI
	zrush_ShopMenu.BGPanel = vgui.Create("Panel", parent)
	zrush_ShopMenu.BGPanel:SetPos(725 * wMod, 0 * hMod)
	zrush_ShopMenu.BGPanel:SetSize(475 * wMod, 750 * hMod)

	zrush_ShopMenu.BGPanel.Paint = function(self, w, h)
		surface.SetDrawColor(80, 80, 80, 255)
		surface.SetMaterial(zrush.default_materials["ui_machine_panel_moduleshop"])
		surface.DrawTexturedRect(0, 0, w, h)

		if zrush_ShopMenu.BGPanel:IsHovered() and zrush_LastHoverdElement ~= zrush_ShopMenu.BGPanel then
			zrush_LastHoverdElement = zrush_ShopMenu.BGPanel
		end
	end

	zrush_ShopMenu.Title = vgui.Create("DLabel", zrush_ShopMenu.BGPanel)
	zrush_ShopMenu.Title:SetPos(15 * wMod, 10 * hMod)
	zrush_ShopMenu.Title:SetSize(500 * wMod, 300 * hMod)
	zrush_ShopMenu.Title:SetFont("zrush_vgui_font01")
	zrush_ShopMenu.Title:SetColor(zrush.default_colors["white01"])
	zrush_ShopMenu.Title:SetText(zrush.language.VGUI["ModuleShop"])
	zrush_ShopMenu.Title:SetAutoStretchVertical(true)

	zrush_ShopMenu.Panel = vgui.Create("Panel", zrush_ShopMenu.BGPanel)
	zrush_ShopMenu.Panel:SetPos(0 * wMod, 75 * hMod)
	zrush_ShopMenu.Panel:SetSize(475 * wMod, 475 * hMod)

	zrush_ShopMenu.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	// This creates our shop items
	zrush.VGUI.ShopItems(zrush_ShopMenu.Panel)

	// The Module Info
	zrush_ShopMenu.InfoPanel = vgui.Create("Panel", zrush_ShopMenu.BGPanel)
	zrush_ShopMenu.InfoPanel:SetPos(0 * wMod, 575 * hMod)
	zrush_ShopMenu.InfoPanel:SetSize(475 * wMod, 200 * hMod)
	zrush_ShopMenu.InfoPanel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	zrush_ShopMenu.ModuleName = vgui.Create("DLabel", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.ModuleName:SetPos(15 * wMod, 0 * hMod)
	zrush_ShopMenu.ModuleName:SetSize(500 * wMod, 125 * hMod)
	zrush_ShopMenu.ModuleName:SetFont("zrush_vgui_font02")
	zrush_ShopMenu.ModuleName:SetText("")
	zrush_ShopMenu.ModuleName:SetColor(zrush.default_colors["white01"])
	zrush_ShopMenu.ModuleName:SetContentAlignment(7)

	zrush_ShopMenu.ModulePrice = vgui.Create("DLabel", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.ModulePrice:SetPos(0 * wMod, 0 * hMod)
	zrush_ShopMenu.ModulePrice:SetSize(425 * wMod, 125 * hMod)
	zrush_ShopMenu.ModulePrice:SetFont("zrush_vgui_font06")
	zrush_ShopMenu.ModulePrice:SetText("")
	zrush_ShopMenu.ModulePrice:SetColor(Color(125, 255, 125, 255))
	zrush_ShopMenu.ModulePrice:SetContentAlignment(9)

	zrush_ShopMenu.ModuleType = vgui.Create("DLabel", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.ModuleType:SetPos(15 * wMod, -30 * hMod)
	zrush_ShopMenu.ModuleType:SetSize(500 * wMod, 125 * hMod)
	zrush_ShopMenu.ModuleType:SetFont("zrush_vgui_font04")
	zrush_ShopMenu.ModuleType:SetText("")
	zrush_ShopMenu.ModuleType:SetColor(zrush.default_colors["white01"])
	zrush_ShopMenu.ModuleType:SetContentAlignment(4)

	zrush_ShopMenu.ModuleBoostAllowed = vgui.Create("DLabel", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.ModuleBoostAllowed:SetPos(15 * wMod, -14 * hMod)
	zrush_ShopMenu.ModuleBoostAllowed:SetSize(500 * wMod, 125 * hMod)
	zrush_ShopMenu.ModuleBoostAllowed:SetFont("zrush_vgui_allowed")
	zrush_ShopMenu.ModuleBoostAllowed:SetText("")
	zrush_ShopMenu.ModuleBoostAllowed:SetColor(Color(255, 125, 125, 255))
	zrush_ShopMenu.ModuleBoostAllowed:SetContentAlignment(4)

	zrush_ShopMenu.ModuleBoostAllowedJobs = vgui.Create("DLabel", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.ModuleBoostAllowedJobs:SetPos(15 * wMod, -1 * hMod)
	zrush_ShopMenu.ModuleBoostAllowedJobs:SetSize(500 * wMod, 125 * hMod)
	zrush_ShopMenu.ModuleBoostAllowedJobs:SetFont("zrush_vgui_allowed")
	zrush_ShopMenu.ModuleBoostAllowedJobs:SetText("")
	zrush_ShopMenu.ModuleBoostAllowedJobs:SetColor(Color(255, 125, 125, 255))
	zrush_ShopMenu.ModuleBoostAllowedJobs:SetContentAlignment(4)

	zrush_ShopMenu.ModuleDesc = vgui.Create("DLabel", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.ModuleDesc:SetPos(15 * wMod, 68 * hMod)
	zrush_ShopMenu.ModuleDesc:SetSize(450 * wMod, 300 * hMod)
	zrush_ShopMenu.ModuleDesc:SetFont("zrush_vgui_font04")
	zrush_ShopMenu.ModuleDesc:SetText("")
	zrush_ShopMenu.ModuleDesc:SetColor(zrush.default_colors["white01"])
	zrush_ShopMenu.ModuleDesc:SetContentAlignment(7)
	zrush_ShopMenu.ModuleDesc:SetWrap(true)

	zrush_ShopMenu.purchase = vgui.Create("DButton", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.purchase:SetText("")
	zrush_ShopMenu.purchase:SetPos(15 * wMod, 120 * hMod)
	zrush_ShopMenu.purchase:SetSize(150 * wMod, 40 * hMod)
	zrush_ShopMenu.purchase:SetVisible(false)
	zrush_ShopMenu.purchase.DoClick = function()
		local machine = zrush_MachineEntity

		if (not zrush.f.IsOwner(LocalPlayer(), machine)) then return end

		if zrush_SELECTED_MODULE then
			net.Start("zrush_PurchaseModule_net")
			net.WriteEntity(zrush_MachineEntity)
			net.WriteInt(zrush_SELECTED_MODULE, 16)
			net.SendToServer()
		end
	end
	zrush_ShopMenu.purchase.Paint = function(self, w, h)
		if (zrush_ShopMenu.purchase:IsEnabled()) then
			if zrush_ShopMenu.purchase:IsHovered() then
				surface.SetDrawColor(125, 255, 125, 255)
			else
				surface.SetDrawColor(125, 200, 125, 255)
			end
		else
			surface.SetDrawColor(60, 75, 60, 255)
		end

		surface.SetMaterial(zrush.default_materials["button"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText(zrush.language.VGUI["Purchase"], "zrush_vgui_purchase", 75 * wMod, 20 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	zrush_ShopMenu.Sell = vgui.Create("DButton", zrush_ShopMenu.InfoPanel)
	zrush_ShopMenu.Sell:SetText("")
	zrush_ShopMenu.Sell:SetPos(310 * wMod, 120 * hMod)
	zrush_ShopMenu.Sell:SetSize(150 * wMod, 40 * hMod)
	zrush_ShopMenu.Sell:SetVisible(false)
	zrush_ShopMenu.Sell.DoClick = function()

		if (not zrush.f.IsOwner(LocalPlayer(), zrush_MachineEntity)) then
			return
		end

		if zrush_SELECTED_MODULE then
			net.Start("zrush_SellModule_net")
			net.WriteEntity(zrush_MachineEntity)
			net.WriteInt(zrush_SELECTED_MODULE, 16)
			net.SendToServer()
		end
	end
	zrush_ShopMenu.Sell.Paint = function(self, w, h)
		if (self:IsEnabled()) then
			if self:IsHovered() then
				surface.SetDrawColor(zrush.default_colors["red02"])
			else
				surface.SetDrawColor(200, 125, 125, 255)
			end
		else
			surface.SetDrawColor(75, 60, 60, 255)
		end

		surface.SetMaterial(zrush.default_materials["button"])
		surface.DrawTexturedRect(0, 0, w, h)

		draw.SimpleText(zrush.language.VGUI["Sell"], "zrush_vgui_purchase", 75 * wMod, 20 * hMod, zrush.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

// This generates a table with all the items that the user can buy
function zrush.VGUI.ItemGenerator()
	local machineType = zrush_MachineEntity.MachineID
	local ItemTable = {}

	for k, v in pairs(zrush.AbilityModules) do
		local MachineHasAllowedType

		local allowed_machines = zrush.f.CatchMachinesByModuleType(v.type)

		// Does this module work for the current machine?
		if (table.Count(allowed_machines) > 0) then
			MachineHasAllowedType = allowed_machines[machineType]
		end

		// Is this Module allready installed?
		local Installed = table.HasValue(LocalPlayer().zrush_InstalledModules,k)

		// Is this type allready installed?
		local ModuleType_AllreadyInstalled = false

		for _, m_id in pairs(LocalPlayer().zrush_InstalledModules) do
			if (zrush.AbilityModules[m_id].type == v.type) then
				ModuleType_AllreadyInstalled = true
				break
			end
		end

		if (MachineHasAllowedType and not Installed and not ModuleType_AllreadyInstalled) then
			ItemTable[k] = v
		end
	end

	return ItemTable
end

// This creates our shop items
function zrush.VGUI.ShopItems(parent)
	if (zrush_ShopItems and IsValid(zrush_ShopItems.Locked)) then
		zrush_ShopItems.Locked:Remove()
	end

	if (zrush_ShopItems and IsValid(zrush_ShopItems.LockedTitle)) then
		zrush_ShopItems.LockedTitle:Remove()
	end

	if (zrush_ShopMenu and IsValid(zrush_ShopMenu.scrollpanel)) then
		zrush_ShopMenu.scrollpanel:Remove()
	end

	zrush_ShopMenu.scrollpanel = vgui.Create("DScrollPanel", parent)
	zrush_ShopMenu.scrollpanel:DockMargin(0 * wMod, 0 * hMod, 15 * wMod, 0 * hMod)
	zrush_ShopMenu.scrollpanel:Dock(FILL)
	zrush_ShopMenu.scrollpanel:GetVBar().Paint = function() return true end
	zrush_ShopMenu.scrollpanel:GetVBar().btnUp.Paint = function() return true end
	zrush_ShopMenu.scrollpanel:GetVBar().btnDown.Paint = function() return true end

	zrush_ShopMenu.scrollpanel.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.SetMaterial(zrush.default_materials["square"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	if (zrush_ShopItems and IsValid(zrush_ShopItems.list)) then
		zrush_ShopItems.list:Remove()
	end

	if (zrush_ShopMenu and IsValid(zrush_ShopMenu.SocketsFullTitle)) then
		//zrush_ShopMenu.SocketsFullTitle:SetVisible(false)
		zrush_ShopMenu.SocketsFullTitle:Remove()
	end

	zrush_ShopItems = {}
	zrush_ShopItems.list = vgui.Create("DIconLayout", zrush_ShopMenu.scrollpanel)
	zrush_ShopItems.list:SetSize(450 * wMod, 200 * hMod)
	zrush_ShopItems.list:SetPos(0 * wMod, 18 * hMod)
	zrush_ShopItems.list:SetSpaceY(10)
	zrush_ShopItems.list:SetAutoDelete(true)

	local ItemList = zrush.VGUI.ItemGenerator()

	if ItemList and table.Count(ItemList) > 0 then
		for m_id, m_dat in pairs(ItemList) do
			// Does the player have the correct Rank do buy thsi module?
			local UserHasAllowedRank = zrush.f.HasAllowedRank(LocalPlayer(), m_dat.ranks)

			// Does the player have the correct Job do buy thsi module?
			local UserHasAllowedJob = zrush.f.HasAllowedRank(LocalPlayer(), m_dat.jobs)

			zrush_ShopItems[m_id] = zrush_ShopItems.list:Add("DPanel")
			zrush_ShopItems[m_id]:SetSize(zrush_ShopItems.list:GetWide(), 125 * hMod)
			zrush_ShopItems[m_id]:SetAutoDelete(true)

			zrush_ShopItems[m_id].Paint = function(self, w, h)
				local panelcolor = zrush.default_colors["grey05"]

				if (IsValid(zrush_ShopItems[m_id].button) and zrush_ShopItems[m_id].button:IsHovered()) then
					if (zrush_LastHoverdElement ~= m_id) then
						zrush_LastHoverdElement = m_id
						surface.PlaySound("zrush/zrush_ui_hover.wav")
					end

					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a)
				else
					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.5)
				end

				surface.SetMaterial(zrush.default_materials["ui_moduleshop_item"])
				surface.DrawTexturedRect(15 * wMod, 0, w - 20, h)
			end

			zrush_ShopItems[m_id].SelectionBG = vgui.Create("DImage", zrush_ShopItems[m_id])
			zrush_ShopItems[m_id].SelectionBG:SetPos(28.795 * wMod, 7 * hMod)
			zrush_ShopItems[m_id].SelectionBG:SetSize(113 * wMod, 113 * hMod)
			zrush_ShopItems[m_id].SelectionBG:SetVisible(false)
			zrush_ShopItems[m_id].SelectionBG:SetAutoDelete(true)
			zrush_ShopItems[m_id].SelectionBG:SetContentAlignment(5)

			zrush_ShopItems[m_id].SelectionBG.Paint = function(self, w, h)
				surface.SetDrawColor(70, 255, 70)
				surface.SetMaterial(zrush.default_materials["ui_circle_selection"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			zrush_ShopItems[m_id].ImageBG = vgui.Create("DImage", zrush_ShopItems[m_id])
			zrush_ShopItems[m_id].ImageBG:SetPos(24 * wMod, 3 * hMod)
			zrush_ShopItems[m_id].ImageBG:SetSize(120 * wMod, 120 * hMod)
			zrush_ShopItems[m_id].ImageBG:SetAutoDelete(true)

			zrush_ShopItems[m_id].ImageBG.Paint = function(self, w, h)
				surface.SetDrawColor(75, 75, 75)
				surface.SetMaterial(zrush.default_materials["circle"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			local mType = m_dat.type
			local mIcon = zrush.default_materials["module_speed"]

			if (mType == "speed") then
				mIcon = zrush.default_materials["module_speed"]
			elseif (mType == "production") then
				mIcon = zrush.default_materials["module_production"]
			elseif (mType == "antijam") then
				mIcon = zrush.default_materials["module_antijam"]
			elseif (mType == "cooling") then
				mIcon = zrush.default_materials["module_cooling"]
			elseif (mType == "pipes") then
				mIcon = zrush.default_materials["module_morepipes"]
			elseif (mType == "refining") then
				mIcon = zrush.default_materials["module_refining"]
			end

			zrush_ShopItems[m_id].ImageType = vgui.Create("DImage", zrush_ShopItems[m_id].ImageBG)
			zrush_ShopItems[m_id].ImageType:SetPos(21 * wMod, 21 * hMod)
			zrush_ShopItems[m_id].ImageType:SetSize(80 * wMod, 80 * hMod)
			zrush_ShopItems[m_id].ImageType:SetAutoDelete(true)

			zrush_ShopItems[m_id].ImageType.Paint = function(self, w, h)
				surface.SetDrawColor(m_dat.color)
				surface.SetMaterial(mIcon)
				surface.DrawTexturedRect(0, 0, w, h)
			end

			local mAmount = "nil"
			local mAmountInfoShort = "nil"

			if (mType == "pipes") then
				mAmount = m_dat.amount
				mAmountInfoShort = "+" .. mAmount
			else
				mAmount = 100 * m_dat.amount
				mAmountInfoShort = "+" .. mAmount .. "%"
			end

			zrush_ShopItems[m_id].button = vgui.Create("DButton", zrush_ShopItems[m_id])
			zrush_ShopItems[m_id].button:SetPos(0 * wMod, 0 * hMod)
			zrush_ShopItems[m_id].button:SetSize(zrush_ShopItems.list:GetWide(), 125 * hMod)
			zrush_ShopItems[m_id].button:SetText("")
			zrush_ShopItems[m_id].button:SetAutoDelete(true)
			zrush_ShopItems[m_id].button.Paint = function(self, w, h) end

			zrush_ShopItems[m_id].button.DoClick = function()
				local machine = zrush_MachineEntity
				zrush.VGUI.DeselectItem()
				zrush_SELECTED_MODULE = m_id


				if (zrush.f.IsOwner(LocalPlayer(), machine)) then

					zrush_ShopMenu.purchase:SetVisible(true)
				end

				LAST_SELECTED = zrush_ShopItems[m_id].SelectionBG
				LAST_SELECTED:SetVisible(true)
				zrush_ShopMenu.ModuleName:SetText(m_dat.name)
				zrush_ShopMenu.ModulePrice:SetText(zrush.config.Currency .. tostring(m_dat.price))
				zrush_ShopMenu.ModuleType:SetText(zrush.language.VGUI[mType] .. "  | " .. mAmountInfoShort)

				// Show the needed ranks
				local allowed = zrush.f.KeyTableConcat(m_dat.ranks, " | ")
				if string.len(allowed) > 25 then
					allowed = string.sub(allowed,1,25) .. "..."
				end
				zrush_ShopMenu.ModuleBoostAllowed:SetText(allowed)


				//Show the needed jobs
				local allowedJobs = zrush.f.KeyTableConcat(m_dat.jobs, " | ")
				if string.len(allowedJobs) > 25 then
					allowedJobs = string.sub(allowedJobs,1,25) .. "..."
				end
				zrush_ShopMenu.ModuleBoostAllowedJobs:SetText(allowedJobs)
				zrush_ShopMenu.ModuleDesc:SetText(m_dat.desc)
			end

			if (LocalPlayer().zrush_HasChaosEvent) then
				zrush_ShopItems[m_id].button:SetEnabled(false)
			end

			zrush_ShopItems[m_id].ModuleName = vgui.Create("DLabel", zrush_ShopItems[m_id].button)
			zrush_ShopItems[m_id].ModuleName:SetPos(150 * wMod, 19 * hMod)
			zrush_ShopItems[m_id].ModuleName:SetSize(300 * wMod, 125 * hMod)
			zrush_ShopItems[m_id].ModuleName:SetFont("zrush_vgui_modulename")
			zrush_ShopItems[m_id].ModuleName:SetText(m_dat.name)
			zrush_ShopItems[m_id].ModuleName:SetColor(zrush.default_colors["white01"])
			zrush_ShopItems[m_id].ModuleName:SetAutoDelete(true)
			zrush_ShopItems[m_id].ModuleName:SetContentAlignment(7)

			zrush_ShopItems[m_id].ModulePrice = vgui.Create("DLabel", zrush_ShopItems[m_id].button)
			zrush_ShopItems[m_id].ModulePrice:SetPos(125 * wMod, -30 * hMod)
			zrush_ShopItems[m_id].ModulePrice:SetSize(300 * wMod, 125 * hMod)
			zrush_ShopItems[m_id].ModulePrice:SetFont("zrush_vgui_font06")
			zrush_ShopItems[m_id].ModulePrice:SetText(zrush.config.Currency .. tostring(m_dat.price))
			zrush_ShopItems[m_id].ModulePrice:SetColor(Color(125, 255, 125, 255))
			zrush_ShopItems[m_id].ModulePrice:SetContentAlignment(6)
			zrush_ShopItems[m_id].ModulePrice:SetAutoDelete(true)

			zrush_ShopItems[m_id].ImageFG = vgui.Create("DImage", zrush_ShopItems[m_id].button)
			zrush_ShopItems[m_id].ImageFG:SetPos(33 * wMod, 12 * hMod)
			zrush_ShopItems[m_id].ImageFG:SetSize(104 * wMod, 104 * hMod)
			zrush_ShopItems[m_id].ImageFG:SetAutoDelete(true)
			zrush_ShopItems[m_id].ImageFG.Paint = function(self, w, h)
				surface.SetDrawColor(255, 255, 255, 25)
				surface.SetMaterial(zrush.default_materials["glam_circle"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			if (UserHasAllowedRank == false or UserHasAllowedJob == false) then
				zrush_ShopItems[m_id].RankLocked = vgui.Create("DButton", zrush_ShopItems[m_id])
				zrush_ShopItems[m_id].RankLocked:SetPos(145 * wMod, 40 * hMod)
				zrush_ShopItems[m_id].RankLocked:SetSize(250, 80 * hMod)
				zrush_ShopItems[m_id].RankLocked:SetText("")
				zrush_ShopItems[m_id].RankLocked:SetAutoDelete(true)

				zrush_ShopItems[m_id].RankLocked.Paint = function(self, w, h)
					surface.SetDrawColor(75, 75, 75, 200)
					surface.SetMaterial(zrush.default_materials["ui_moduleshop_item_locked"])
					surface.DrawTexturedRect(0, 0, w, h)
				end

				zrush_ShopItems[m_id].RankLockedTitle = vgui.Create("DLabel", zrush_ShopItems[m_id])
				zrush_ShopItems[m_id].RankLockedTitle:SetPos(100 * wMod, 17 * hMod)
				zrush_ShopItems[m_id].RankLockedTitle:SetSize(zrush_ShopItems[m_id]:GetWide(), 125 * hMod)
				zrush_ShopItems[m_id].RankLockedTitle:SetFont("zrush_vgui_font03")
				zrush_ShopItems[m_id].RankLockedTitle:SetText(zrush.language.VGUI["Locked"])
				zrush_ShopItems[m_id].RankLockedTitle:SetColor(Color(255, 75, 75, 255))
				zrush_ShopItems[m_id].RankLockedTitle:SetContentAlignment(5)
				zrush_ShopItems[m_id].RankLockedTitle:SetAutoDelete(true)
			end
		end
	else
		if (zrush_ShopMenu and IsValid(zrush_ShopMenu.SocketsFullTitle)) then
			zrush_ShopMenu.SocketsFullTitle:SetVisible(true)
		else
			zrush_ShopMenu.SocketsFullTitle = vgui.Create("DLabel", parent)
			zrush_ShopMenu.SocketsFullTitle:SetPos(10 * wMod, 170 * hMod)
			zrush_ShopMenu.SocketsFullTitle:SetSize(600 * wMod, 500 * hMod)
			zrush_ShopMenu.SocketsFullTitle:SetFont("zrush_vgui_font07")
			zrush_ShopMenu.SocketsFullTitle:SetColor(Color(160, 160, 160, 25))
			zrush_ShopMenu.SocketsFullTitle:SetText(zrush.language.VGUI["NonSocketfound"])
			zrush_ShopMenu.SocketsFullTitle:SetAutoStretchVertical(true)
			zrush_ShopMenu.SocketsFullTitle:SetContentAlignment(4)
			zrush_ShopMenu.SocketsFullTitle:SetAutoDelete(true)
		end

		if (IsValid(zrush_ShopMenu.purchase)) then
			zrush_ShopMenu.purchase:SetVisible(false)
		end

		if (IsValid(zrush_ShopMenu.Sell)) then
			zrush_ShopMenu.Sell:SetVisible(false)
		end
	end

	if (LocalPlayer().zrush_HasChaosEvent == true) then
		zrush_ShopItems.Locked = vgui.Create("Panel", parent)
		zrush_ShopItems.Locked:SetPos(0 * wMod, 0 * hMod)
		zrush_ShopItems.Locked:SetSize(475 * wMod, 500 * hMod)
		zrush_ShopItems.Locked:SetAutoDelete(true)

		zrush_ShopItems.Locked.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 225)
			surface.SetMaterial(zrush.default_materials["square"])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		zrush_ShopItems.LockedTitle = vgui.Create("DLabel", parent)
		zrush_ShopItems.LockedTitle:SetPos(0 * wMod, 150 * hMod)
		zrush_ShopItems.LockedTitle:SetSize(475 * wMod, 300 * hMod)
		zrush_ShopItems.LockedTitle:SetFont("zrush_vgui_font03")
		zrush_ShopItems.LockedTitle:SetColor(Color(255, 75, 75))
		zrush_ShopItems.LockedTitle:SetText(zrush.language.VGUI["FixMachinefirst"])
		zrush_ShopItems.LockedTitle:SetAutoStretchVertical(true)
		zrush_ShopItems.LockedTitle:SetContentAlignment(5)
		zrush_ShopItems.LockedTitle:SetAutoDelete(true)
	end
end

///////////
vgui.Register("zrush_vgui_MachineMenu", zrush.VGUI.Main, "Panel")

// This opens the machine ui for a user
net.Receive("zrush_OpenMachineUI_net", function(len)
	zrush_MachineEntity = net.ReadEntity()
	LocalPlayer().zrush_InstalledModules = net.ReadTable()
	zrush_OpenUI()
end)

// This updates the ui if the machine does a action
net.Receive("zrush_UpdateMachineUI_net", function(len)
	local ent = net.ReadEntity()
	local callerTable = net.ReadTable()
	local caller_UpdateShop = net.ReadBool()

	if (IsValid(zrush.VGUI.Main.Panel) and zrush.VGUI.Main.Panel:IsVisible() and ent == zrush_MachineEntity) then
		zrush.f.Debug("zrush_UpdateMachineUI_net Len:" .. len)
		zrush_MachineEntity = ent
		LocalPlayer().zrush_InstalledModules = callerTable
		zrush_UpdateUI(caller_UpdateShop)
	end
end)

// This updates the UI when the users does a action
net.Receive("zrush_TransactionComplete_net", function(len)
	local ent = net.ReadEntity()
	local callerTable = net.ReadTable()

	if (IsValid(zrush.VGUI.Main.Panel) and zrush.VGUI.Main.Panel:IsVisible() and ent == zrush_MachineEntity) then
		zrush_MachineEntity = ent
		LocalPlayer().zrush_InstalledModules = callerTable
		zrush_UpdateUI(true)
	end
end)

// Gets called if a users wants do close the ui
net.Receive("zrush_CloseMachineUI_net", function(len)
	local ent = net.ReadEntity()

	if (ent == zrush_MachineEntity) then
		zrush_CloseUI()
	end
end)

// Gets called if a users wants do close the ui
net.Receive("zrush_ForceCloseMachineUI_net", function(len)
	zrush_CloseUI()
end)
