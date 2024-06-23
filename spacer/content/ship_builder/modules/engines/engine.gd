class_name GameEngine
extends GameModule

@export var force := 100.0

var is_started := false

func start() -> void :
	if not is_started:
		is_started = true
		_start()

func stop() -> void :
	if is_started :
		is_started = false
		_stop()

func _start() -> void :
	pass

func _stop() -> void :
	pass

func get_force_vector_local() -> Vector2 :
	return Vector2.UP.rotated(global_rotation)

func get_force() -> Vector2 :
	return get_force_vector_local() * force

func get_global_force_position() -> Vector2 :
	return global_position
