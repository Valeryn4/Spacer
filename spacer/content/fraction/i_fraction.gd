class_name GameIFraction
extends Node


func get_fraction_key() -> GameScope.Fractions :
	return GameScope.Fractions.None

func get_info_name() -> StringName :
	return &""

func get_default_pilot_karma() -> float :
	return GameScope.DEFAULT_KARMA

func get_default_fraction_karma() -> float :
	return GameScope.DEFAULT_KARMA

func get_karma_from_pilot(_pilot: GameIPilot) -> float :
	return GameScope.DEFAULT_KARMA

func get_karma_from_fraction(_fraction: GameScope.Fractions) -> float :
	return GameScope.DEFAULT_KARMA

func add_karma_from_pilot(_pilot: GameIPilot, _val: float) -> void :
	pass

func add_karma_from_fraction(_fraction: GameScope.Fractions, _val: float) -> void :
	pass
