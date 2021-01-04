if not SERVER then return end
zfs = zfs or {}
zfs.f = zfs.f or {}

util.AddNetworkString("zfs_sweetener_AnimEvent")
util.AddNetworkString("zfs_sweetener_FX")

//////////////////////////////////////////////////////////////
/////////////////////// Initialize ///////////////////////////
//////////////////////////////////////////////////////////////

// Called when the Sweetener Initializes
function zfs.f.Sweetener_Initialize(Sweetener)
	zfs.f.EntList_Add(Sweetener)
	Sweetener.IsFilling = false
end

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


function zfs.f.Sweetener_Use(ply, Sweetener)
	local shop = Sweetener:GetParent()

	if IsValid(shop) then
		if not zfs.f.IsOwner(ply, shop) then
			zfs.f.Notify(ply, zfs.language.Shop.NotOwner, 1)

			return
		end

		if (shop:GetCurrentState() ~= 9) then return end
		zfs.f.Shop_action_AddSweetener(shop, Sweetener.SweetenerType)
		zfs.f.Sweetener_SweetFill(Sweetener)
	end
end

function zfs.f.Sweetener_SweetFill(Sweetener)
	zfs.f.Sweetener_Animate("fill", Sweetener)
	local SweetenerType = Sweetener.SweetenerType

	if SweetenerType == "Coffe" then
		zfs.f.Sweetener_CreateEffect(Sweetener, "zfs_sweetener_coffee")
	elseif SweetenerType == "Milk" then
		zfs.f.Sweetener_CreateEffect(Sweetener, "zfs_sweetener_milk")
	elseif SweetenerType == "Chocolate" then
		zfs.f.Sweetener_CreateEffect(Sweetener, "zfs_sweetener_chocolate")
	end

	timer.Simple(4, function()
		if IsValid(Sweetener) then
			Sweetener:SetNoDraw(true)
			Sweetener:SetPos(Sweetener:GetParent():GetAttachment(Sweetener:GetParent():LookupAttachment("fruitlift")).Pos)
			zfs.f.Sweetener_Animate("idle", Sweetener)
			zfs.f.Shop_ChangeState(Sweetener:GetParent(), 11)
		end
	end)
end

//Animation
function zfs.f.Sweetener_Animate(anim, Sweetener)

	net.Start("zfs_sweetener_AnimEvent")
	net.WriteString(anim)
	net.WriteEntity(Sweetener)
	net.Broadcast()
end

// Effects
function zfs.f.Sweetener_CreateEffect(Sweetener,effect)
	net.Start("zfs_sweetener_FX")
	net.WriteEntity(Sweetener)
	net.WriteString(effect)
	net.SendPVS(Sweetener:GetPos())
end
