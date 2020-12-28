--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
--[[
    Generated using: DarkRP | Entity Generator
    https://csite.io/tools/gmod-darkrp-entity
--]]
DarkRP.createEntity("Piano", {
    ent = "gmt_instrument_piano",
    model = "models/fishy/furniture/piano.mdl",
    price = 1000,
    max = 1,
    cmd = "gmt_instrument_piano",
    category = "Piano",
    allowed = {TEAM_PIANIST},
    customCheck = function(ply) return
        table.HasValue({TEAM_PIANIST}, ply:Team())
    end,
    CustomCheckFailMsg = "",
})