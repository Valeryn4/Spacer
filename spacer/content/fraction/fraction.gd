class_name GameFraction
extends GameIFraction



@export var fraction_key: GameScope.Fractions = GameScope.Fractions.None
@export var info_name: StringName = &"Fraction Name"
@export var default_pilot_karma: float = GameScope.DEFAULT_KARMA
@export var default_fraction_karma: float = GameScope.DEFAULT_KARMA

var _pilot_karma_list := {}
var _fraction_karma_list := {}



func get_fraction_key() -> GameScope.Fractions :
	return fraction_key

func get_info_name() -> StringName :
	return info_name

func get_default_pilot_karma() -> float :
	return default_pilot_karma

func get_default_fraction_karma() -> float :
	return default_fraction_karma


func get_karma_from_pilot(pilot: GameIPilot) -> float :
	return _pilot_karma_list.get(pilot, get_default_pilot_karma())

func get_karma_from_fraction(fraction: GameScope.Fractions) -> float :
	return _fraction_karma_list.get(fraction, get_default_fraction_karma())

func add_karma_from_pilot(pilot: GameIPilot, val: float) -> void :
	var current_karma := get_karma_from_pilot(pilot)
	var new_karma = clampf(
		val + current_karma, 
		GameScope.KARMA_MIN, 
		GameScope.KARMA_MAX)
	
	_pilot_karma_list[pilot] = new_karma

func add_karma_from_fraction(fraction: GameScope.Fractions, val: float) -> void :
	var current_karma := get_karma_from_fraction(fraction)
	var new_karma = clampf(
		val + current_karma, 
		GameScope.KARMA_MIN, 
		GameScope.KARMA_MAX)
	
	_fraction_karma_list[fraction] = new_karma
