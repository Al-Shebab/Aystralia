AddCSLuaFile()

game.AddParticles("particles/zerochain_zmlab_vfx.pcf")
game.AddParticles("particles/zerochain_zmlab_filter_vfx.pcf")
game.AddParticles("particles/zerochain_zmlab_meth_vfx.pcf")
game.AddParticles("particles/zerochain_zmlab_liquids_vfx.pcf")

PrecacheParticleSystem("zmlab_aluminium_fill01")
PrecacheParticleSystem("zmlab_cleaning")
PrecacheParticleSystem("zmlab_frozen_tray")
PrecacheParticleSystem("zmlab_meth_filling")
PrecacheParticleSystem("zmlab_meth_breaking")
PrecacheParticleSystem("zmlab_methylamin_fill")
PrecacheParticleSystem("zmlab_aluminium_drops")
PrecacheParticleSystem("zmlab_sell_effect_small")
PrecacheParticleSystem("zmlab_sell_effect_big")
PrecacheParticleSystem("zmlab_methsludge_fill")
PrecacheParticleSystem("zmlab_cleand_gas")
PrecacheParticleSystem("zmlab_poison_gas")

util.PrecacheModel("models/zerochain/zmlab/zmlab_transportcrate_full.mdl")
util.PrecacheModel("models/zerochain/zmlab/zmlab_sludge.mdl")
