class_name GameStructureShip
extends RigidBody2D

signal emplaced()

const ACTION_GAME_PRESSED := "game_pressed"
const ACTION_GAME_ALT_PRESSED := "game_alt_pressed"
const ACTION_GAME_ROLL_UP := "game_roll_up"
const ACTION_GAME_ROLL_DOWN := "game_roll_down"

const MASK_STRUCTURE_INDEX := 2
const ROUND_POS: int = 8
const OFFSET := Vector2(0.0, -ROUND_POS * 0.5 )
const OFFSET_MOUSE := Vector2( 0.0, 0.0)

const LAYER_COLLISION_DRAG := false
const LAYER_COLLISION_DROP := true
const LAYER_COLLISION_EMPLACE := true

@onready var _area_detector: Area2D = %Area2DDetector as Area2D
@onready var _hover: Node2D = %Hover as Node2D
@onready var _select: Node2D = %Select as Node2D
@onready var _button_root: Node2D = %ButtonRoot as Node2D
@onready var _failed: Node2D = %Failed as Node2D

@export var structure_key: GameScope.ShipStructureKey = GameScope.ShipStructureKey.None
@export_node_path("GameModule") var module_path: NodePath = ^""

var _is_hovered := false
var is_drag := false
var is_active := true
var is_connect := false
var is_emplace := false

var _count_connect := 0
var _check_connect_queue: Array[Node2D] = []


func _ready() -> void:
	_failed.visible = false
	_connector_state_change(GameStructureConnector.State.None)
	_update_state()

func _connector_state_change(state: GameStructureConnector.State) -> void :
	for shape in _area_detector.get_children() :
		var connector: GameStructureConnector = shape as GameStructureConnector
		if connector :
			connector.state = state

func _update_state() -> void :
	_select.visible = false
	_hover.visible = false
	if is_drag :
		_select.visible = true
		_hover.visible = false
	elif _is_hovered :
		_select.visible = false
		_hover.visible = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == self :
		return
		
	if not is_active :
		return
	
	print(self, " entered to struct")
	
	_count_connect += 1
	if _count_connect > 0 and not is_connect:
		if is_connected_on_ship() and is_drag:
			is_connect = true
		_check_connect_queue.clear()
		print(self, " enable connect")


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area == self :
		return
	
	if not is_active :
		return
	
	print(self, " exit from struct")
	_count_connect -= 1
	if _count_connect == 0 :
		is_connect = false
		print(self, "disable connect")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self :
		return
	
	if not is_active :
		return
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == self :
		return
	
	if not is_active :
		return
		


func _on_area_2d_muse_mouse_entered() -> void:
	_is_hovered = true
	_update_state()


func _on_area_2d_muse_mouse_exited() -> void:
	_is_hovered = false
	_update_state()

func get_overlap_list() -> Array[Area2D] :
	return _area_detector.get_overlapping_areas()

func is_connected_on_ship() -> bool :
	_check_connect_queue.append(self)
	var res := _recursive_check(_area_detector)
	_check_connect_queue.clear()
	return res


func _check_connect() -> void :
	if is_connected_on_ship() :
		set_collision_layer_value(MASK_STRUCTURE_INDEX, LAYER_COLLISION_EMPLACE)
		is_emplace = true
		_connector_state_change(GameStructureConnector.State.In)
	else :
		is_connect = false
		is_emplace = false
		set_collision_layer_value(MASK_STRUCTURE_INDEX, LAYER_COLLISION_DROP)
	

func _recursive_check(node: Node2D) -> bool :
	if node is GameShipRootArea :
		return true
	elif node is Area2D :
		_check_connect_queue.append(node)
		var overlaps: Array[Area2D] = node.get_overlapping_areas()
		var res := false
		for overlap in overlaps :
			if not _check_connect_queue.has(overlap) :
				res = _recursive_check(overlap)
				if res :
					return true
	
	return false


func get_collisions() -> Array[Node2D] :
	var list: Array[Node2D] = []
	for node in get_children() :
		if node is CollisionShape2D or node is CollisionPolygon2D :
			list.append(node)
	return list

func emplace() -> void :
	print(self, " emplace")
	_check_connect()
	emplaced.emit()

func drop() -> void :
	is_drag = false
	Global.draged = null
	_connector_state_change(GameStructureConnector.State.None)
	_update_state()
	emplace()

func drag() -> void :
	is_drag = true
	is_emplace = false
	Global.draged = self
	_connector_state_change(GameStructureConnector.State.Out)
	_update_state()
	set_collision_layer_value(MASK_STRUCTURE_INDEX, LAYER_COLLISION_DRAG)
	rotation_degrees = 0.0

func get_module() -> GameModule :
	return get_node(module_path) as GameModule

func _physics_process(delta: float) -> void:
	if not is_active :
		return
	
	var is_draged_not_self :=  Global.draged and Global.draged != self
	
	var is_pressed := Input.is_action_just_pressed(ACTION_GAME_PRESSED)
	if is_pressed :
		if is_drag :
			drop()
		else :
			if _is_hovered :
				if not is_draged_not_self :
					drag()
					
	
	_failed.visible = not is_connect
	_button_root.global_position = global_position
	if is_drag :
		freeze = true
		var mouse_pos := get_global_mouse_position()
		mouse_pos += OFFSET_MOUSE
		mouse_pos -= Vector2(
			int(mouse_pos.x) % ROUND_POS,
			int(mouse_pos.y) % ROUND_POS
		)
		mouse_pos += OFFSET
		
		
		
		var direction := global_position.direction_to(mouse_pos)
		var distance := global_position.distance_to(mouse_pos)
		
		var collide := move_and_collide(direction * distance * delta * 10.0)
		if collide :
			var collider := collide.get_collider()
			if collider and collider is GameStructureShip :
				var structure_ship: GameStructureShip = collider as GameStructureShip
				if not structure_ship.freeze :
					structure_ship.apply_impulse(
						collide.get_normal() * 2.0, 
						structure_ship.get_position() - structure_ship.global_position)
			
			direction = direction.slide(collide.get_normal())
			move_and_collide(direction * collide.get_remainder().length())
		
		var alt_pressed := Input.is_action_just_pressed(ACTION_GAME_ALT_PRESSED)
		if alt_pressed :
			rotation_degrees += 45.0
		
		var up_roll := Input.is_action_just_pressed(ACTION_GAME_ROLL_UP)
		if up_roll :
			rotation_degrees += 45.0
		
		var down_roll := Input.is_action_just_pressed(ACTION_GAME_ROLL_DOWN)
		if down_roll :
			rotation_degrees -= 45.0
	else :
		if not is_connect :
			freeze = false
			linear_velocity = (linear_velocity.normalized() * clampf(linear_velocity.length(), 0.0, 800.0))


func _on_button_remove_pressed() -> void:
	is_active = false
	queue_free()


