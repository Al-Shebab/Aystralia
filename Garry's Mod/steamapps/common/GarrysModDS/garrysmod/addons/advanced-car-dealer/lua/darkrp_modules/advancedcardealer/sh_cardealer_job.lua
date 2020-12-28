TEAM_CARDEALER = DarkRP.createJob( "Car dealer", {
    color = Color( 27, 151, 253, 255 ),
    model = {
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl"
    },
    description = [[The car dealer is able to sell vehicles to
                    all other players, and earn a commission for each
					car sold.]],
    weapons = { "cardealer_tablet" },
    command = "cardealer",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
} )

DarkRP.createEntity( "Stand", {
    ent = "cardealer_stand",
    model = "models/stim/venatuss/car_dealer/stand.mdl",
    price = 1000,
    max = 5,
    cmd = "cardealer_stand",
    allowed = { TEAM_CARDEALER }
})
