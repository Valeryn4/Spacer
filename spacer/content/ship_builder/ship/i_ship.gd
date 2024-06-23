class_name GameIShip
extends RigidBody2D

signal change_agression(self_ship)
signal updated_agression_list()

func get_component() -> Array :
	return []

func get_pilot() -> GameIPilot :
	return null

func activate() -> void :
	pass

func clear_component() -> void :
	pass

func read_ship_data_and_emplace() -> void :
	pass


func build_ship(_structures: Array[Node], _is_read_config := false) -> void :
	pass

func add_shape_component(id: int, shape: Node2D) -> void :
	pass

func add_module_component(id: int, module: Node2D) -> void :
	pass

func add_structure_component(_node: Node2D) -> void :
	pass

func apply_damage(_damage: GameDamage) -> void :
	pass

func get_agression_from(_node: GameIShip) -> float :
	return 0.0

func is_attak_from(_node: GameIShip) -> bool :
	return false


func _entered_detected(_node: GameIShip) -> void :
	pass

func _exited_detected(_node: GameIShip) -> void :
	pass
