-- This file will be used to add groups to the rainbow physgun whitelist.
-- How to add a group?
-- Make a extra space under the ranks made here... Or Change the rank name on the ones premade
-- rbpg_addgroup('ULX RANK')

-- Adding groups:

function AddGroups()
if not SERVER then return end
rbpg_addgroup('ayssie')
end
hook.Add( "Initialize", "load rbpg groups", AddGroups);