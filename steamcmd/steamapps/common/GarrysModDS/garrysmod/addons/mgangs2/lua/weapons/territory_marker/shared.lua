SWEP.Author				= "Zephruz"
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= ""

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

-- Config
SWEP.CreateMenu = false
SWEP.BoxBounds = {false, false}
SWEP.Flag = {
	mdl = "models/zerochain/mgangs2/mgang_flagpost.mdl",
	pos = false,
}

SWEP.nextAttFixTime = CurTime() + 1

function SWEP:PrimaryAttack()
	if (IsValid(self.CreateMenu) or CurTime() < self.nextAttFixTime) then return false end

	self.nextAttFixTime = CurTime() + 1

	local tr = self.Owner:GetEyeTrace()

	if (self.Flag.pos) then
		self.BoxBounds[1] = (self.BoxBounds[1] || tr.HitPos)
	end

	self.Flag.pos = (self.Flag.pos or tr.HitPos)
end

function SWEP:SecondaryAttack()
	if (IsValid(self.CreateMenu) or !self.BoxBounds or !self.BoxBounds[1] or !self.BoxBounds[2] or !self.Flag.pos) then return false end

	local tr = self.Owner:GetEyeTrace()

	if (CLIENT) then
		local data = {
			boxPos = self.BoxBounds,
			flagPos = self.Flag.pos,
			flagMdl = self.Flag.mdl,
		}

		local tcMenu = mg2.vgui:GetMenu("mg2.TerritoryCreate")

		if (tcMenu) then
			tcMenu:SetTerritoryBounds(data.boxPos)
			tcMenu:SetTerritoryPos(data.flagPos)
			
			tcMenu:Init()

			self.CreateMenu = tcMenu.frame
		end
	end
end

function SWEP:Reload()
	local own = self.Owner

	self.BoxBounds = {false,false}
	self.Flag.pos = false
end

function SWEP:SetStatus(id)
	if !(self.Status[id]) then return false end

	self._statusid = (id or 1)
end

function SWEP:Think()
	if (!self.instrTbl && mg2.lang) then
		self.instrTbl = {
			mg2.lang:GetTranslation("territory.CreatorInfo1"),
			mg2.lang:GetTranslation("territory.CreatorInfo2"),
			mg2.lang:GetTranslation("territory.CreatorInfo3")
		}
	end

	if (!self.instrTbl || IsValid(self.CreateMenu)) then return false end

	self.instrTbl[1] = (mg2.lang && (self.Flag.pos && mg2.lang:GetTranslation("territory.CreatorInfo1") || mg2.lang:GetTranslation("territory.flag.CreatorInfo")) || "")

	local own = self.Owner
	local tr = own:GetEyeTrace()

	if (CLIENT && IsValid(own) && input.IsMouseDown(MOUSE_LEFT)) then
		self.BoxBounds[2] = WorldToLocal(tr.HitPos, Angle(0,0,0), self.BoxBounds[1] or tr.HitPos, Angle(0,0,0))
	end
end