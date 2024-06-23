extends Node



var _fractions := {}

func get_fraction(fraction: GameScope.Fractions) -> GameIFraction :
	return _fractions[fraction]

func get_karma_pilot_on_fraction(pilot: GameIPilot, on_fraction:GameScope.Fractions) -> float :
	var game_fraction := get_fraction(on_fraction)
	return game_fraction.get_karma_from_pilot(pilot)

func get_karma_fraction_on_fraction(fraction: GameScope.Fractions, on_fraction: GameScope.Fractions) -> float :
	var game_fraction := get_fraction(on_fraction)
	return game_fraction.get_karma_from_fraction(fraction)

func add_karma_pilot_to_fraction(pilot: GameIPilot, on_fraction:GameScope.Fractions, val: float) -> void :
	var game_fraction := get_fraction(on_fraction)
	game_fraction.add_karma_from_pilot(pilot, val)

func add_karma_fraction_to_fraction(fraction: GameScope.Fractions, on_fraction:GameScope.Fractions, val: float) -> void :
	var game_fraction := get_fraction(on_fraction)
	game_fraction.add_karma_from_fraction(fraction, val)
