
LSD_STORE = {}
LSD_STORE.Items = {}

function LSD_STORE:AddItem(tbl)
  table.insert(self.Items,tbl)
end

LSD_STORE:AddItem({name="Flask",
  price=500,
  model="models/gonzo/lsd/flask.mdl",
  color=Color(100,150,235),
  ent="sent_lsd_flask",
  maxamount=5})

LSD_STORE:AddItem({name="Gas Can",
  price=600,
  model="models/gonzo/lsd/gas.mdl",
  override=Vector(24,0,10),
  color=Color(50,75,255),
  ent="sent_lsd_gas",
  maxamount=3})

LSD_STORE:AddItem({name="Bunsen burner",
  price=1000,
  model="models/gonzo/lsd/pyro.mdl",
  color=Color(200,200,200),
  ent="sent_lsd_pyro",
  maxamount=3})

LSD_STORE:AddItem({name="Acid Hydrazide",
  price=1000,
  model="models/gonzo/lsd/bottle.mdl",
  color=Color(175,64,220),
  ent="sent_lsd_bottle",
  maxamount=5})

LSD_STORE:AddItem({name="Flask support",
  price=400,model="models/gonzo/lsd/flank_support.mdl",
  color=Color(75,75,75),
  ent="sent_lsd_flank_support",
  maxamount=3})

LSD_STORE:AddItem({name="Fridge",
  price=1500,
  model="models/gonzo/lsd/freezer.mdl",
  color=Color(255,175,125),
  ent="sent_lsd_freezer",
  maxamount=2})

LSD_STORE:AddItem({name="Magic Powder",
  price=750,
  model="models/gonzo/lsd/powder.mdl",
  color=Color(100,255,175),
  ent="sent_lsd_powder",
  maxamount=5})

LSD_STORE:AddItem({name="Paper",
  price=100,
  model="models/props/cs_office/Paper_towels.mdl",
  color=Color(255,255,100),
  ent="sent_lsd_paper",
  maxamount=10})
