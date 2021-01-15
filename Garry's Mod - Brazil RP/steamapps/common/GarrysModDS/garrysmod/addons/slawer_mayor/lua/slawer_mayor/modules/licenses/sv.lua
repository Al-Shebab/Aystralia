local intNextLicenseGive = 0

Slawer.Mayor:NetReceive("ToggleGunLicense", function(pPlayer, tbl)
	if not Slawer.Mayor:HasAccess(pPlayer) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NoAccess"))
		return
	end

	if intNextLicenseGive > CurTime() then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("WaitUntilNextLicense"):format(math.Round(intNextLicenseGive - CurTime())))
		return
	end

	if not tbl.p || not IsValid(tbl.p) || not tbl.p:IsPlayer() then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
		return
	end

	intNextLicenseGive = CurTime() + 5
	tbl.p:setDarkRPVar("HasGunlicense", not tbl.p:getDarkRPVar("HasGunlicense"))

	DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("LicenseSucessfullyUpdated"))
end)