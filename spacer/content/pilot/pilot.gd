class_name GamePilot
extends GameIPilot


@export var info_icon: Texture = null
@export var info_name: StringName = &"PilotName"
@export_multiline var info_description: String = ""


var other_pilot_karma := {}
var fraction_karma := {}
var target_list: Array[Node2D] = []

func get_info_icon() -> Texture :
	return info_icon

func get_info_name() -> StringName :
	return info_name

func get_info_description() -> String :
	return info_description
	
func get_info_fraction() -> GameScope.Fractions :
	return GameScope.Fractions.None

func get_karma_from_fraction(fraction: GameScope.Fractions) -> float :
	return fraction_karma.get(fraction, GameScope.DEFAULT_KARMA)

func get_karma_from_pilot(pilot: GameIPilot) -> float :
	return other_pilot_karma.get(pilot, GameScope.DEFAULT_KARMA)

func calculate_karma_from_pilot(pilot: GameIPilot) -> float :
	var res := get_karma_from_pilot(pilot) + (get_karma_from_fraction(pilot.get_info_fraction()) * GameScope.KARMA_FRACTION_MUL)
	return res

func is_attak(pilot: GameIPilot) -> bool :
	var res = minf(calculate_karma_from_pilot(pilot), pilot.calculate_karma_from_pilot(self))
	return res <= GameScope.KARMA_ATTAK

func get_target_list() -> Array[Node2D] :
	return []
