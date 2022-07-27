
USEPICKUP.STATS = {}

function USEPICKUP.STATS:Prepare()

    self.Config = USEPICKUP.Config -- fml what have i done here ..

    local stats = {
        damage = {
            sort = 1,
            --name    = "Damage",
            val     = {
                min = 0,
                max = 0
            },
            bib     = true,
        },
        rpm = {
            sort = 2,
            --name    = "RPM",
            val     = {
                min = 0,
                max = 0
            },
            bib     = true,
        },
        clipsize  = {
            sort = 3,
            --name    = "Clipsize",
            val     = {
                min = 0,
                max = 0
            },
            bib     = true,
        },
        spread = {
            sort = 4,
            --name    = "Spread",
            val     = {
                min = 0,
                max = 0
            },
            bib     = false,
        },
        recoil = {
            sort = 5,
            --name    = "Recoil",
            val     = {
                min = 0,
                max = 0
            },
            bib     = false,
        },
    }

    local average = {
        total = 0, -- hope nothing breaks by not doing it individually
        damage = {
            sum = 0,
        },
        rpm = {
            sum = 0,
        },
        clipsize = {
            sum = 0,
        },
        spread = {
            sum = 0,
        },
        recoil = {
            sum = 0,
        },
    }

    local weps = weapons.GetList()

    -- ttt fix for fucked up stats
    for k, v in pairs( weps ) do
        if WEAPON_PISTOL and WEAPON_HEAVY and v.Kind and v.Kind != WEAPON_PISTOL and v.Kind != WEAPON_HEAVY then
            weps[k] = nil
        end
    end

    for k, v in pairs( weps ) do
        if !v.ClassName or table.HasValue( self.Config.StatsBaseBlacklist, self:GetWeaponBase( v ) ) or table.HasValue( self.Config.StatsClassBlacklist, v.ClassName ) then
            weps[k] = nil
        end
    end

    for _, v in pairs( weps ) do
        local did_count = false

        local dmg = self:GetWeaponDamage( v )
        if dmg and dmg > stats.damage.val.max then
            stats.damage.val.max = dmg
            average.damage.sum = average.damage.sum + dmg
            did_count = true
        end

        local rpm = self:GetWeaponRPM( v )
        if rpm and rpm > stats.rpm.val.max then
            stats.rpm.val.max = rpm
            average.rpm.sum = average.rpm.sum + rpm
            did_count = true
        end

        local clipmax = self:GetWeaponClipSize( v )
        if clipmax and clipmax > stats.clipsize.val.max then
            stats.clipsize.val.max = clipmax
            average.clipsize.sum = average.clipsize.sum + clipmax
            did_count = true
        end

        local spread = self:GetWeaponSpread( v ) -- check on that later bois
        if spread and spread > stats.spread.val.max then
            stats.spread.val.max = spread
            average.spread.sum = average.spread.sum + spread
            did_count = true
        end
        
        local recoil = self:GetWeaponRecoil( v )
        if recoil and recoil > stats.recoil.val.max then
            stats.recoil.val.max = recoil
            average.recoil.sum = average.recoil.sum + recoil
            did_count = true
        end
    
        if did_count then
            average.total = average.total + 1
        end
    end

    for k, v in pairs( stats ) do
        v.val.min = v.val.max -- set min to max
    end

    -- determine mins based on max
    for _, v in pairs( weapons.GetList() ) do
        local dmg = self:GetWeaponDamage( v )
        if dmg and dmg > 0 and dmg < stats.damage.val.min then
            stats.damage.val.min = dmg
        end

        local rpm = self:GetWeaponRPM( v )
        if rpm and rpm > 0 and rpm < stats.rpm.val.min then
            stats.rpm.val.min = rpm
        end

        local clipmax = self:GetWeaponClipSize( v )
        if clipmax and clipmax > 0 and clipmax < stats.clipsize.val.min then
            stats.clipsize.val.min = clipmax
        end

        local spread = self:GetWeaponSpread( v )
        if spread and spread > 0 and spread < stats.spread.val.min then
            stats.spread.val.min = spread
        end
        
        local recoil = self:GetWeaponRecoil( v )
        if recoil and recoil > 0 and recoil < stats.recoil.val.min then
            stats.recoil.val.min = recoil
        end
    end

    self.AverageStats = average
    self.GlobalMax = stats

end

-- funcs for single weps below
function USEPICKUP.STATS:GetWeaponBase( wep )
    return wep.Base or "weapon_base"
end

/* This isnt used atm as we use functions for each gamemode (cuz ttt has a translation system)
function USEPICKUP.STATS:GetWeaponName( wep ) -- we fix and use that later hehe
    if c.NameOverride[wep:GetClass()] then return c.NameOverride[wep:GetClass()] end
    return wep.GetPrintName and wep:GetPrintName() or wep.PrintName or wep.Name or "nil"
end*/

function USEPICKUP.STATS:GetWeaponDamage( wep )
    if !wep then return false end

    local base_dmg  = wep.Damage or wep.Primary and wep.Primary.Damage or false
    local mul       = wep.Shots or wep.Primary and wep.Primary.NumShots or wep.Primary and wep.Primary.Shots or 1

    return isnumber(base_dmg) and mul and base_dmg * mul or false
end

function USEPICKUP.STATS:GetWeaponRPM( wep )
    if wep.RPM then return wep.RPM end
    if wep.Primary and wep.Primary.RPM then return wep.Primary.RPM end

    local delay = wep.Delay or wep.FireDelay or wep.Primary and wep.Primary.Delay

    return isnumber(delay) and delay > 0 and (60 / delay) or false
end

function USEPICKUP.STATS:GetWeaponClipSize( wep )
    local cs = wep.Primary and wep.Primary.ClipSize or wep.ClipSize
    return isnumber(cs) and cs > 0 and cs or false
end

function USEPICKUP.STATS:GetWeaponSpread( wep )
    local pr = wep.Primary
    local s = wep.Spread or wep.Cone or wep.HipCone or wep.HipSpread or pr and (pr.Spread or pr.Cone or pr.HipCone or pr.HipSpread) or 0

    if !s then return false end

    if istable(s) then -- gay af
        s = s.hip -- use aim spread maybe? decide later
    end

    return isnumber(s) and math.Clamp( s, 0.01, s ) or false
end

function USEPICKUP.STATS:GetWeaponRecoil( wep )
    local pr = wep.Primary

    if pr then
        return pr.Recoil or pr.KickUp or false
    end

    return wep.Recoil or wep.KickUp or false
end

function USEPICKUP.STATS:GetWeaponAmmoType( wep )
    local pr = wep.Primary
    return pr and pr.Ammo or wep.Ammo and wep.Ammo or "none"
end

--

function USEPICKUP.STATS:GetGlobalMinMaxByKey( key )
    if self.GlobalMax and self.GlobalMax[key] then
        return self.GlobalMax[key].val.min, self.GlobalMax[key].val.max
    else
        return 0, 1
    end
end

function USEPICKUP.STATS:GetWeaponStats( wep )
    local class = IsValid(wep) and wep:IsWeapon() and wep:GetClass() or istable(wep) and wep.ClassName or false

    if !class then return {} end

    if table.HasValue( self.Config.StatsBaseBlacklist, self:GetWeaponBase( wep ) ) or table.HasValue( self.Config.StatsClassBlacklist, class ) then
        --print("<USEPICKUP> Blacklist: " .. class )
        return {}
    end

    local stats = {
        damage      = {
            sort    = 3,
            val     = self:GetWeaponDamage( wep ),
            bib     = true
        },
        rpm         = {
            sort    = 4,
            val     = self:GetWeaponRPM( wep ) and math.Round( self:GetWeaponRPM( wep ), 0 ) or false, -- fml
            bib     = true,
        },
        clipsize    = {
            sort    = 5,
            val     = self:GetWeaponClipSize( wep ),
            bib     = true
        },
        spread      = {
            sort    = 6,
            val     = self:GetWeaponSpread( wep ),
            bib     = false
        },
        recoil      = {
            sort    = 7,
            val     = self:GetWeaponRecoil( wep ),
            bib     = false
        }
    }

    for k, v in pairs( stats ) do
        if !v.val then
            /*print(k)
            stats[k] = nil*/
            return {} -- prevent stats from showing
        end
    end

    return stats
end

function USEPICKUP.STATS:GetAverage( key )
    if !self.AverageStats[key] then return 0 end
    return self.AverageStats[key].sum/self.AverageStats.total
end

USEPICKUP.STATS:Prepare()