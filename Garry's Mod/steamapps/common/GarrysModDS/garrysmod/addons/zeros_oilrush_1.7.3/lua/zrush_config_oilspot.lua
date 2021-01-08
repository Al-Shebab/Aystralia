zrush = zrush or {}
zrush.Holes = {}
function zrush.f.CreateOilSource(data)
    return table.insert(zrush.Holes, data)
end


zrush.f.CreateOilSource({
    chance = 50,
    depth = 15,
    burnchance = 0,
    oil_amount = math.Round(math.random(300, 2000)),
    gas_amount = math.Round(math.random(100, 500)),
    chaos_chance = 5
})

zrush.f.CreateOilSource({
    chance = 30,
    depth = 20,
    burnchance = 0,
    oil_amount = math.Round(math.random(600, 4000)),
    gas_amount = math.Round(math.random(500, 800)),
    chaos_chance = 10
})

zrush.f.CreateOilSource({
    chance = 20,
    depth = 25,
    burnchance = 0,
    oil_amount = math.Round(math.random(1500, 8000)),
    gas_amount = math.Round(math.random(500, 1000)),
    chaos_chance = 20
})
