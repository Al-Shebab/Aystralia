TOOL.Category = "Construction"
TOOL.Name = "#Fading Doors"

TOOL.ClientConVar["key"] = "41"
TOOL.ClientConVar["swap"] = "0"
TOOL.ClientConVar["reversed"] = "0"
TOOL.ClientConVar["mat"] = "sprites/heatwave"

list.Add("FDoorMaterials", "sprites/heatwave")
list.Add("FDoorMaterials", "models/wireframe")
list.Add("FDoorMaterials", "debug/env_cubemap_model")
list.Add("FDoorMaterials", "models/shadertest/shader3")
list.Add("FDoorMaterials", "models/shadertest/shader4")
list.Add("FDoorMaterials", "models/shadertest/shader5")
list.Add("FDoorMaterials", "models/shiny")
list.Add("FDoorMaterials", "models/debug/debugwhite")
list.Add("FDoorMaterials", "Models/effects/comball_sphere")
list.Add("FDoorMaterials", "Models/effects/comball_tape")
list.Add("FDoorMaterials", "Models/effects/splodearc_sheet")
list.Add("FDoorMaterials", "Models/effects/vol_light001")
list.Add("FDoorMaterials", "models/props_combine/stasisshield_sheet")
list.Add("FDoorMaterials", "models/props_combine/portalball001_sheet")
list.Add("FDoorMaterials", "models/props_combine/com_shield001a")
list.Add("FDoorMaterials", "models/props_c17/frostedglass_01a")
list.Add("FDoorMaterials", "models/props_lab/Tank_Glass001")
list.Add("FDoorMaterials", "models/props_combine/tprings_globe")
list.Add("FDoorMaterials", "models/rendertarget")
list.Add("FDoorMaterials", "models/screenspace")
list.Add("FDoorMaterials", "brick/brick_model")
list.Add("FDoorMaterials", "models/props_pipes/GutterMetal01a")
list.Add("FDoorMaterials", "models/props_pipes/Pipesystem01a_skin3")
list.Add("FDoorMaterials", "models/props_wasteland/wood_fence01a")
list.Add("FDoorMaterials", "models/props_foliage/tree_deciduous_01a_trunk")
list.Add("FDoorMaterials", "models/props_c17/FurnitureFabric003a")
list.Add("FDoorMaterials", "models/props_c17/FurnitureMetal001a")
list.Add("FDoorMaterials", "models/props_c17/paper01")
list.Add("FDoorMaterials", "models/flesh")

if SERVER then
	util.AddNetworkString("DrawFadeDoor")
end

if CLIENT then
	language.Add("Tool.fading_door.name", "Fading Doors")
	language.Add("Tool.fading_door.desc", "Makes anything into a fadable door")
	language.Add("Tool.fading_door.0", "Click on something to make it a fading door. Right click to copy data. Reload to remove fading door.")
	
	function TOOL:BuildCPanel()
		self:AddControl("Header",   {Text = "#Tool.fading_door.name", Description = "#Tool.fading_door.desc"})
		self:AddControl("CheckBox", {Label = "Reversed", Command = "fading_door_reversed"})
		self:AddControl("CheckBox", {Label = "Toggle Active", Command = "fading_door_swap"})
		self:AddControl("Numpad", {Label = "Button", ButtonSize = "22", Command = "fading_door_key"})
		self:MatSelect("fading_door_mat", list.Get("FDoorMaterials"), true, 0.33, 0.33)
	end
	
	local EFFECT = {}
	
	net.Receive("DrawFadeDoor",function()
		local String = net.ReadString()
		if String == "0" then
			EFFECT.Type = nil
			EFFECT.Ent = nil
			if EFFECT.Remove == false then EFFECT.Remove = true end
		else
			EFFECT.Type = nil
			EFFECT.Ent = nil
			if EFFECT.Remove == nil then util.Effect("render_fade_door", EffectData()) end
			EFFECT.Remove = false
			
			local Table = string.Explode("_",String)
			local Ent = ents.GetByIndex(tonumber(Table[1]))
			if IsValid(Ent) then
				EFFECT.Type = tonumber(Table[2])
				EFFECT.Ent = Ent
			end
		end
	end)
	
	function EFFECT:Init(data) end

	function EFFECT:Think()
		-- This makes the effect always visible.
		local pl = LocalPlayer()
		local Pos = pl:EyePos()
		local Trace = {}
		Trace.start = Pos
		Trace.endpos = Pos+(pl:GetAimVector()*10)
		Trace.filter = {pl}
		local TR = util.TraceLine(Trace)
		self:SetPos(TR.HitPos)
		
		-- Remove when ent is not valid.
		if !IsValid(EFFECT.Ent) then
			EFFECT.Type = nil
			EFFECT.Ent = nil
			EFFECT.Remove = true
		end
		
		if EFFECT.Remove or EFFECT.Remove == nil then
			EFFECT.Remove = nil
			return false
		end
		return true
	end
	
	function EFFECT:Render()
		if IsValid(EFFECT.Ent) then
			if EFFECT.Type == 1 then
				halo.Add({EFFECT.Ent}, Color(255, 255, 255, 255), 10, 10, 1, true, false)
			elseif EFFECT.Type == 2 then
				halo.Add({EFFECT.Ent}, Color(100, 255, 100, 255), 10, 10, 1, true, false)
			else
				halo.Add({EFFECT.Ent}, Color(255, 150, 50, 255), 10, 10, 1, true, false)
			end
		end
	end
	
	effects.Register(EFFECT,"render_fade_door",true)
	
	function TOOL:LeftClick(tr)
		if !tr.Entity or !tr.Entity:IsValid() then return false end
		if tr.Entity:IsPlayer() or tr.HitWorld then return false end
		return true
	end
	
	function TOOL:RightClick(tr)
		if !tr.Entity or !tr.Entity:IsValid() then return false end
		if tr.Entity:IsPlayer() or tr.HitWorld then return false end
		return true
	end

	function TOOL:Reload(tr)
		if !tr.Entity or !tr.Entity:IsValid() then return false end
		if tr.Entity:IsPlayer() or tr.HitWorld then return false end
		return true
	end
	
	return
end

local function fadeActivate(self)
	if self.fadeActive then return end
	self.fadeActive = true
	self.fadeMaterial = self:GetMaterial()
	self.fadeDoorMaterial = self.fadeDoorMaterial or "sprites/heatwave"
	self:SetMaterial(self.fadeDoorMaterial)
	self:DrawShadow(false)
	if self.fadeCanDisableMotion then self:SetNotSolid(true) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		self.fadeMoveable = phys:IsMoveable()
		phys:EnableMotion(false)
	end
	
	if WireLib then
		Wire_TriggerOutput(self,  "FadeActive",  1)
	end
end

local function fadeDeactivate(self)
	self.fadeActive = false
	if self:GetMaterial() == self.fadeDoorMaterial and self.fadeMaterial then self:SetMaterial(self.fadeMaterial) end
	self:DrawShadow(true)
	if self.fadeCanDisableMotion then self:SetNotSolid(false) else self:SetCollisionGroup(COLLISION_GROUP_NONE) end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(self.fadeMoveable or false)
		phys:Wake()
	end
	
	if WireLib then
		Wire_TriggerOutput(self,  "FadeActive",  0)
	end
end

local function onUp(pl, Ent)
	if IsValid(Ent) then
		local Activate = false
		if Ent.fadeToggle then
			if Ent.fadeReversed then
				Activate = !Ent.fadeActive
			else
				Activate = Ent.fadeActive
			end
		elseif Ent.fadeReversed then
			Activate = true
		end
		if Activate then
			if !Ent.fadeActive then Ent:fadeActivate() end
		else
			if Ent.fadeActive then Ent:fadeDeactivate() end
		end
	end
end
numpad.Register("Fading Door onUp", onUp)

local function onDown(pl, Ent)
	if IsValid(Ent) then
		local Activate = true
		if Ent.fadeToggle then
			if Ent.fadeReversed then
				Activate = Ent.fadeActive
			else
				Activate = !Ent.fadeActive
			end
		elseif Ent.fadeReversed then
			Activate = false
		end
		if Activate then
			if !Ent.fadeActive then Ent:fadeActivate() end
		else
			if Ent.fadeActive then Ent:fadeDeactivate() end
		end
	end
end
numpad.Register("Fading Door onDown", onDown)

local function getWireInputs(Ent)
	local inputs = Ent.Inputs
	local names, types, descs = {}, {}, {}
	if inputs then
		local num
		for _, data in pairs(inputs) do
			num = data.Num
			names[num] = data.Name
			types[num] = data.Type
			descs[num] = data.Desc
		end
	end
	return names, types, descs
end

local function doWireInputs(Ent)
	local inputs = Ent.Inputs
	if !inputs then
		Wire_CreateInputs(Ent, {"Fade"})
		return
	end
	local names, types, descs = {}, {}, {}
	local num
	for _, data in pairs(inputs) do
		num = data.Num
		names[num] = data.Name
		types[num] = data.Type
		descs[num] = data.Desc
	end
	table.insert(names, "Fade")
	WireLib.AdjustSpecialInputs(Ent, names, types, descs)
end

local function doWireOutputs(Ent)
	local outputs = Ent.Outputs
	if !outputs then
		Wire_CreateOutputs(Ent, {"FadeActive"})
		return
	end
	local names, types, descs = {}, {}, {}
	local num
	for _, data in pairs(outputs) do
		num = data.Num
		names[num] = data.Name
		types[num] = data.Type
		descs[num] = data.Desc
	end
	table.insert(names, "FadeActive")
	WireLib.AdjustSpecialOutputs(Ent, names, types, descs)
end

local function TriggerInput(self, name, value, ...)
	if name == "Fade" then
		if value == 0 then onUp(nil, self) else onDown(nil, self) end
	elseif self.fadeTriggerInput then
		return self:fadeTriggerInput(name, value, ...)
	end
end

local function PreEntityCopy(self)
	if self then
		local info = WireLib.BuildDupeInfo(self)
		if info then duplicator.StoreEntityModifier(self, "WireDupeInfo", info) end
		if self.fadePreEntityCopy then self:fadePreEntityCopy() end
	end
end

local function PostEntityPaste(self, pl, Ent, ents)
	if self then
		if self.EntityMods and self.EntityMods.WireDupeInfo then WireLib.ApplyDupeInfo(pl, self, self.EntityMods.WireDupeInfo, function(id) return ents[id] end) end
		if self.fadePostEntityPaste then self:fadePostEntityPaste(pl, Ent, ents) end
	end
end

local function onRemove(self)
	if self.fadeDeactivate then self:fadeDeactivate() end
	self.isFadingDoor = nil
	self.PreEntityCopy = self.fadePreEntityCopy
	self.fadePreEntityCopy = nil
	self.PostEntityPaste = self.fadePostEntityPaste
	self.fadePostEntityPaste = nil
	self.TriggerInput = self.fadeTriggerInput
	self.fadeTriggerInput = nil
	duplicator.ClearEntityModifier(self, "Fading Door")
	if self.fadeUpNum then numpad.Remove(self.fadeUpNum) end
	if self.fadeDownNum then numpad.Remove(self.fadeDownNum) end
	self.fadeActive = nil
	self.fadeMaterial = nil
	if IsValid(self.FadingDoorDummy) then self.FadingDoorDummy:Remove() end
	self.FadingDoorDummy = nil
	self.fadeToggle = nil
	self.fadeDoorMaterial = nil
	self.fadeMoveable = nil
	self.fadeCanDisableMotion = nil
	self.fadeDeactivate = nil
	self.fadeUpNum = nil
	self.fadeDownNum = nil
	self.fadeToggleActive = nil
	self.fadeReversed = nil
	self.fadeActivate = nil
	self.fadeKey = nil
	if self.OnDieFunctions then
		self.OnDieFunctions["UndoFadingDoor"..self:EntIndex()] = nil
		self.OnDieFunctions["Fading Doors"] = nil
	end
	if WireLib then
		if self.Inputs then
			Wire_Link_Clear(self, "Fade")
			self.Inputs['Fade'] = nil
			WireLib._SetInputs(self)
		end
		if self.Outputs then
			local port = self.Outputs['FadeActive']
			if port then
				for i,inp in ipairs(port.Connected) do
					if inp.Entity:IsValid() then
						Wire_Link_Clear(inp.Entity, inp.Name)
					end
				end
			end
			self.Outputs['FadeActive'] = nil
			WireLib._SetOutputs(self)
		end
	end
	if self.EntityMods and self.EntityMods.WireDupeInfo and self.EntityMods.WireDupeInfo.Wires then self.EntityMods.WireDupeInfo.Wires.Fade = nil end
end

local function dooEet(pl, Ent, stuff)
	if Ent.isFadingDoor then
		if Ent.fadeDeactivate then Ent:fadeDeactivate() end
		RemoveKeys(Ent)
	else
		Ent.isFadingDoor = true
		Ent.fadeActivate = fadeActivate
		Ent.fadeDeactivate = fadeDeactivate
		Ent.fadeToggleActive = fadeToggleActive
		Ent:CallOnRemove("Fading Doors", RemoveKeys)
		if WireLib then
			doWireInputs(Ent)
			doWireOutputs(Ent)
			Ent.fadeTriggerInput = Ent.fadeTriggerInput or Ent.TriggerInput
			Ent.TriggerInput = TriggerInput
			if !Ent.IsWire then
				if !Ent.fadePreEntityCopy and Ent.PreEntityCopy then Ent.fadePreEntityCopy = Ent.PreEntityCopy end
				Ent.PreEntityCopy = PreEntityCopy
				if !Ent.fadePostEntityPaste and Ent.PreEntityCopy then Ent.fadePostEntityPaste = Ent.PostEntityPaste end
				Ent.PostEntityPaste = PostEntityPaste
			end
		end
	end
	Ent.fadeUpNum = numpad.OnUp(pl, stuff.key, "Fading Door onUp", Ent)
	Ent.fadeDownNum = numpad.OnDown(pl, stuff.key, "Fading Door onDown", Ent)
	Ent.fadeToggle = stuff.toggle
	Ent.fadeReversed = stuff.reversed
	Ent.fadeKey = stuff.key
	Ent.fadeCanDisableMotion = stuff.CanDisableMotion
	Ent.fadeDoorMaterial = stuff.DoorMaterial
	if stuff.reversed then Ent:fadeActivate() end
	duplicator.StoreEntityModifier(Ent, "Fading Door", stuff)
	return true
end

duplicator.RegisterEntityModifier("Fading Door", dooEet)
hook.Add("Initialize", "FadingDoor1", function() duplicator.RegisterEntityModifier("Fading Door", dooEet) end)	-- No overwrite.

if !FadingDoor then
	local function legacy(pl, Ent, data)
		return dooEet(pl, Ent, {
			key					= data.Key,
			toggle				= data.Toggle,
			reversed			= data.Inverse,
			CanDisableMotion	= data.CanDisableMotion,
			DoorMaterial		= data.DoorMaterial,
		})
	end
	duplicator.RegisterEntityModifier("FadingDoor", legacy)
	hook.Add("Initialize", "FadingDoor2", function() duplicator.RegisterEntityModifier("FadingDoor", legacy) end)	-- No overwrite.
end

function TOOL:LeftClick(tr)
	if !tr.Entity or !tr.Entity:IsValid() then return false end
	if tr.Entity:IsPlayer() or tr.HitWorld then return false end
	if CLIENT then return true end
	
	local Ent = tr.Entity
	local pl = self:GetOwner()
	
	if !IsValid(pl) then return false end
	
	local phys = Ent:GetPhysicsObject()
	local CanDisableMotion = false
	
	if phys:IsValid() then
		local MotionEnabled = phys:IsMotionEnabled()
		phys:EnableMotion(!MotionEnabled)
		CanDisableMotion = MotionEnabled != phys:IsMotionEnabled()
		phys:EnableMotion(MotionEnabled)
	end
	
	if self.AimEnt then
		self.AimEnt[pl] = nil
		net.Start("DrawFadeDoor")
		net.WriteString("0")
		net.Send(pl)
	end
	
	dooEet(pl, Ent, {
		key     			= self:GetClientNumber("key"),
		toggle   			= self:GetClientNumber("swap") == 1,
		reversed			= self:GetClientNumber("reversed") == 1,
		CanDisableMotion	= CanDisableMotion,
		DoorMaterial		= self:GetClientInfo("mat"),
	})
	
	if !IsValid(Ent.FadingDoorDummy) then
		local Dummy = ents.Create("info_null")
		Dummy.Owner = pl
		Dummy.Door = Ent
		undo.Create("Undo fading door")
		undo.AddEntity(Dummy)
		Ent.FadingDoorDummy = Dummy
		local UndoT = {Ent,self:GetOwner(),self}
		undo.AddFunction(function(Undo, UndoT)
			local Ent = UndoT[1]
			local pl = UndoT[2]
			local Tool = UndoT[3]
			if IsValid(Ent) then onRemove(Ent) end
			if IsValid(pl) then
				if Tool and Tool.AimEnt then Tool.AimEnt[pl] = nil end
				net.Start("DrawFadeDoor")
				net.WriteString("0")
				net.Send(pl)
			end
		end, UndoT)
		undo.SetPlayer(pl)
		undo.SetCustomUndoText("Undone Fading Door")
		undo.Finish()
		
		Ent:CallOnRemove("UndoFadingDoor"..Ent:EntIndex(),function(Ent)
			if Ent.FadingDoorDummy and Ent.FadingDoorDummy:IsValid() then
				if IsValid(Ent.FadingDoorDummy.Owner) then
					local PlayerID = Ent.FadingDoorDummy.Owner:UniqueID()
					local PlayerUndo = undo:GetTable()[PlayerID]
					if PlayerUndo then
						for k,v in pairs(PlayerUndo) do
							if PlayerUndo[k] and PlayerUndo[k].Name and PlayerUndo[k].Name == "Undo fading door" and PlayerUndo[k].Entities and IsValid(PlayerUndo[k].Entities[1]) and PlayerUndo[k].Entities[1]:GetTable().Door == Ent then
								undo:GetTable()[PlayerID][k] = nil
								break
							end
						end
					end
				end
				Ent.FadingDoorDummy:Remove()
			end
		end,Ent)
	end
	
	return true
end

function TOOL:RightClick(tr)
	if !tr.Entity or !tr.Entity:IsValid() then return false end
	if tr.Entity:IsPlayer() or tr.HitWorld then return false end
	if CLIENT then return true end
	local Ent = tr.Entity
	if Ent.isFadingDoor then
		local pl = self:GetOwner()
		if !IsValid(pl) then return false end
		if Ent.fadeKey != nil then pl:ConCommand("fading_door_key "..tostring(Ent.fadeKey)) end
		if Ent.fadeToggle != nil then if Ent.fadeToggle then pl:ConCommand("fading_door_swap 1") else pl:ConCommand("fading_door_swap 0") end end
		if Ent.fadeReversed != nil then if Ent.fadeReversed then pl:ConCommand("fading_door_reversed 1") else pl:ConCommand("fading_door_reversed 0") end end
		if Ent.fadeDoorMaterial != nil then pl:ConCommand("fading_door_mat "..Ent.fadeDoorMaterial) end
		return true
	end
end

function TOOL:Reload(tr)
	if !tr.Entity or !tr.Entity:IsValid() then return false end
	if tr.Entity:IsPlayer() or tr.HitWorld then return false end
	if CLIENT then return true end
	local Ent = tr.Entity
	
	if Ent.isFadingDoor then
		if IsValid(Ent.FadingDoorDummy) then
			if IsValid(Ent.FadingDoorDummy.Owner) then
				local PlayerID = Ent.FadingDoorDummy.Owner:UniqueID()
				local PlayerUndo = undo:GetTable()[PlayerID]
				if PlayerUndo then
					for k,v in pairs(PlayerUndo) do
						if PlayerUndo[k] and PlayerUndo[k].Name and PlayerUndo[k].Name == "Undo fading door" and PlayerUndo[k].Entities and IsValid(PlayerUndo[k].Entities[1]) and PlayerUndo[k].Entities[1]:GetTable().Door == Ent then
							undo:GetTable()[PlayerID][k] = nil
							break
						end
					end
				end
			end
			Ent.FadingDoorDummy:Remove()
		end
		onRemove(Ent)
		net.Start("DrawFadeDoor")
		net.WriteString(tostring(Ent:EntIndex()).."_1")
		net.Send(self:GetOwner())
		return true
	end
end

function TOOL:Holster()
	if CLIENT then return end
	local pl = self:GetOwner()
	if !IsValid(pl) then return false end
	if self.AimEnt and self.AimEnt[pl] != nil then
		self.AimEnt[pl] = nil
		net.Start("DrawFadeDoor")
		net.WriteString("0")
		net.Send(pl)
	end
end

function TOOL:Think()
	if CLIENT then return end
	if self.Hold then return end
	local pl = self:GetOwner()
	local trace = pl:GetEyeTrace()
	
	if trace.Hit and trace.Entity and trace.Entity:IsValid() and !trace.Entity:IsPlayer() then
		if !self.AimEnt then self.AimEnt = {} end
		if !self.OldKey then self.OldKey = {} end
		if !self.OldToggle then self.OldToggle = {} end
		if !self.OldReversed then self.OldReversed = {} end
		
		if !IsValid(pl) then return false end
		
		if trace.Entity != self.AimEnt[pl] or self:GetClientNumber("key") != self.OldKey[pl] or self:GetClientNumber("swap") != self.OldToggle[pl] or self:GetClientNumber("reversed") != self.OldReversed[pl] then
			self.AimEnt[pl] = trace.Entity
			local Key = self:GetClientNumber("key")
			self.OldKey[pl] = Key
			local Toggle = self:GetClientNumber("swap")
			self.OldToggle[pl] = Toggle
			local Reversed = self:GetClientNumber("reversed")
			self.OldReversed[pl] = Reversed
			if trace.Entity.isFadingDoor then
				Toggle = Toggle == 1
				Reversed = Reversed == 1
				if trace.Entity.fadeKey == Key and trace.Entity.fadeReversed == Reversed and trace.Entity.fadeToggle == Toggle then
					net.Start("DrawFadeDoor")
					net.WriteString(tostring(trace.Entity:EntIndex()).."_2")
					net.Send(pl)
				else
					net.Start("DrawFadeDoor")
					net.WriteString(tostring(trace.Entity:EntIndex()).."_3")
					net.Send(pl)
				end
			else
				net.Start("DrawFadeDoor")
				net.WriteString(tostring(trace.Entity:EntIndex()).."_1")
				net.Send(pl)
			end
		end
	elseif self.AimEnt and self.AimEnt[pl] != nil then
		self.AimEnt[pl] = nil
		net.Start("DrawFadeDoor")
		net.WriteString("0")
		net.Send(pl)
	end
end