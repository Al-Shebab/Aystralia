Slawer.Mayor.Colors = {
	Blue = Color(40, 116, 166),
	LightGrey = Color(125, 125, 125),
	Grey = Color(44, 47, 51),
	DarkGrey = Color(35, 39, 42),
	Red = Color(192, 57, 43),
	Green = Color(39, 174, 96),
	Black = Color(25, 25, 25),
}

function Slawer.Mayor:HasAccess(pPlayer)
	return pPlayer:isMayor()
end