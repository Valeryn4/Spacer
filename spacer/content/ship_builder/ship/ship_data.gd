class_name GameShipData
extends Resource
## Resource contains pos build info ship
## used thid res on load and save information

const ShipStructureKey :=  GameScope.ShipStructureKey

## Positions pool element. Index is ID
@export var component_positions_from_ID: PackedVector2Array = []
## Scales pool element. Index is ID
@export var component_scale_from_ID: PackedVector2Array = []
## Rotations pool element. Index is ID
@export var component_rotations_from_ID: PackedFloat32Array = []

var component_ID_from_shape: Dictionary = {}

## Component keys in pool. Index is ID
@export var component_list: Array[ShipStructureKey] = []

## Iterator pos allocation
@export var current_iter: int = 0 :
	set(val) :
		current_iter = val
		if current_iter >= component_list.size() :
			realloc(maxi(5, current_iter * 1.2))

func get_count() -> int :
	return current_iter + 1

func realloc(new_size: int) -> void :
	component_list.resize(new_size)
	component_rotations_from_ID.resize(new_size)
	component_positions_from_ID.resize(new_size)

## add [GameScope.ShipStructureKey] to list
## @return current index (ID) element
func add_component_structure(structure: ShipStructureKey) -> int :
	var current_idx := current_iter
	current_iter += 1
	component_list[current_iter] = structure
	
	return current_idx

## get [GameScope.ShipStructureKey] from ID
## @return [GameScope.ShipStructureKey]
func get_component_from_id(id: int) -> ShipStructureKey :
	return component_list[id]

#ADD SHAPES

func add_id_from_shape(id: int, node: Node2D) -> void :
	component_ID_from_shape[node] = id

func get_id_from_shape(node: Node2D) -> Node2D :
	return component_ID_from_shape[node]

#ADD POSITION

func set_position_structure_from_id(id: int, pos: Vector2) -> void :
	component_positions_from_ID[id] = pos

func get_position_from_id(id: int) -> Vector2 :
	return component_positions_from_ID[id]

#ADD ROTATION

func set_rotation_structure_from_id(id: int, rot: float) -> void :
	component_rotations_from_ID[id] = rot

func get_rotation_from_id(id: int) -> float :
	return component_rotations_from_ID[id]

#ADD SCALE

func set_scale_structure_from_id(id: int, pos: Vector2) -> void :
	component_scale_from_ID[id] = pos

func get_scale_from_id(id: int) -> Vector2 :
	return component_scale_from_ID[id]


func clear() -> void :
	component_positions_from_ID.clear()
	component_rotations_from_ID.clear()
	component_scale_from_ID.clear()
	component_ID_from_shape.clear()
	component_list.clear()
	current_iter = 0
