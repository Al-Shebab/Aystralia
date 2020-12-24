include("sh_tierprinters_config.lua")
AddCSLuaFile("sh_tierprinters_config.lua")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "Owjo"
ENT.AdminSpawnable = true
ENT.Spawnable = true
ENT.Category = "Tier Printer"

-- This is a tabe of all networked variabes so Get and Set can be used on them
function ENT:SetupDataTables()
	-- The owner of the printer (Collected from buyer through F4)
	self:NetworkVar("Entity", 0, "owning_ent")

	-- How much money the printer is currently storing
	self:NetworkVar("Int", 1, "Money")

	-- What tier the printer is currently in
	self:NetworkVar("Int", 2, "Tier")

	-- The battery life of the printer (Regardless of if config has battery enabled on not, the framework stays but is never used. Saves me doing a bunch of checks.)
	self:NetworkVar("Int", 3, "Battery")

	-- The health that the printer has
	self:NetworkVar("Int", 4, "CHealth")

	-- First spawn check
	self:NetworkVar("Bool", 0, "FirstSpawn")
	
end
