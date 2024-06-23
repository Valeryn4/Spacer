class_name GameIPilot
extends Node



func get_info_icon() -> Texture :
	return null

func get_info_name() -> StringName :
	return &""

func get_info_description() -> String :
	return ""
	
func get_info_fraction() -> GameScope.Fractions :
	return GameScope.Fractions.None

func get_karma_from_fraction(_fraction: GameScope.Fractions) -> float :
	return GameScope.DEFAULT_KARMA

func get_karma_from_pilot(_pilot: GameIPilot) -> float :
	return GameScope.DEFAULT_KARMA

func calculate_karma_from_pilot(_pilot: GameIPilot) -> float :
	return GameScope.DEFAULT_KARMA

func is_attak(_pilot: GameIPilot) -> bool :
	return false

func get_target_list() -> Array[Node2D] :
	return []
