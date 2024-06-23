class_name GameShip
extends GameIShip

const ANGLE_MAX_ENGINE := PI * 0.25

@onready var _root_builder := %ShipBuilderRoot as GameShipBuilderRoot
@onready var _collision_shape_radar := %CollisionShapeRadar as CollisionShape2D
@onready var _shape_circle_radar := _collision_shape_radar.shape as CircleShape2D

@export_category("Configuration")

@export var speed_max: float = 4000.0
@export var radar_radius: float = 500.0 :
	set(val) :
		radar_radius = val
		if _shape_circle_radar :
			_shape_circle_radar.radius = radar_radius

@export_subgroup("Config Resources")

@export var ship_data: GameShipData = null
@export var structure_ship_data: GameStructureShipData = null


var _target_list: GameTargetList = GameTargetList.new()


var ship_components: GamepShipComponents = GamepShipComponents.new()

var is_acivated := false
var is_engine_activated := false

var pilot: GameIPilot = null

################################################
## IMPL PRIVATE OVERRIDE #######################
################################################


func _ready() -> void:
	if structure_ship_data :
		pass
	else :
		ship_data = GameShipData.new()



###############################################
## PUBLIC METHODS #############################
###############################################


func get_pilot() -> GameIPilot :
	return pilot

func activate() -> void :
	is_acivated = true
	freeze = false


func apply_damage(_damage: GameDamage) -> void :
	pass



func get_agression_from(_node: GameIShip) -> float :
	return 0.0

#region Building


func clear_component() -> void :
	
	for node in ship_components.component_list:
		if node :
			node.queue_free()
	
	ship_components.clear()
	ship_data.clear()
	_root_builder.change_statce_connector(GameStructureConnector.State.None)

func read_ship_data_and_emplace() -> void :
	var components := ship_data.component_list
	var structures: Array[Node] = []
	for id in components.size() :
		var structure_key := components[id] 
		
		var pkg := GameDB.get_struct_pkg(structure_key)
		var component := pkg.instantiate() as GameStructureShip
		
		var local_pos := ship_data.get_position_from_id(id)
		var rot := ship_data.get_rotation_from_id(id)
		var sc := ship_data.get_scale_from_id(id)
		
		component.position = local_pos + global_position
		component.rotation = rot
		component.scale = sc
		structures.append(component)
	build_ship(structures, true)


func build_ship(structures: Array[Node], is_read_config := false) -> void :
	clear_component()
	
	ship_data.realloc(structures.size())
	for node in structures :
		var structure: GameStructureShip = node as GameStructureShip
		if structure :
			var is_connect: bool = structure.is_inside_tree() and structure.is_connected_on_ship()
			if is_read_config or is_connect :
				var local: Vector2 = to_local(structure.global_position)
				
				var idx := ship_data.add_component_structure(structure.structure_key)
				ship_data.set_position_structure_from_id(idx, local)
				ship_data.set_rotation_structure_from_id(idx, structure.rotation)
				ship_data.set_scale_structure_from_id(idx, structure.scale)
				
				for shape in structure.get_collisions() :
					if shape is Node2D :
						ship_data.add_id_from_shape(idx, shape)
						var local_position: Vector2 = to_local(shape.global_position)
						var global_rot: float = shape.global_rotation
						var parent: Node = shape.get_parent()
						parent.remove_child(shape)
						shape.position = local_position
						shape.name = "CS"
						add_child(shape, true)
						shape.global_rotation = global_rot
						shape.owner = self
						add_structure_component(shape)
			
			node.queue_free()
	
	_shape_circle_radar.radius = radar_radius
	
	if not is_read_config :
		ResourceSaver.save(ship_data, "res://test.tres", ResourceSaver.FLAG_CHANGE_PATH  )

func add_shape_component(id: int, shape: Node2D) -> void :
	pass

func add_module_component(id: int, module: Node2D) -> void :
	pass

func add_structure_component(node: Node2D) -> void :
	ship_components.component_list.append(node)
	var components := node.get_children()
	for component in components :
		if component is GameEngine :
			var engine: GameEngine = component as GameEngine
			ship_components.engines.append(engine)
			_parse_engine(engine)
			engine.owner = self
		elif component is GameCanon :
			var canon: GameCanon = component as GameCanon
			ship_components.canons.append(canon)
			canon.ship_owner = self
			canon.target_list_on_ship = _target_list
			canon.emplace_on_ship()
			canon.owner = self




func _parse_engine(engine: GameEngine) -> void :
	
	var vec := engine.get_force_vector_local()
	var up := absf(Vector2.UP.angle_to(vec))
	var down := absf(Vector2.DOWN.angle_to(vec))
	var left := absf(Vector2.LEFT.angle_to(vec))
	var right := absf(Vector2.RIGHT.angle_to(vec))
	if up <= ANGLE_MAX_ENGINE :
		ship_components.forward_engines.append(engine)
	elif down <= ANGLE_MAX_ENGINE :
		ship_components.backward_engines.append(engine)
	else :
		var local_offset := to_local(engine.global_position)
		if left <= ANGLE_MAX_ENGINE and local_offset.y <= 0:
			ship_components.left_trasters.append(engine)
		elif right <= ANGLE_MAX_ENGINE and local_offset.y > 0 :
			ship_components.left_trasters.append(engine)
		elif right <= ANGLE_MAX_ENGINE and local_offset.y <= 0 :
			ship_components.right_trasters.append(engine)
		elif left <= ANGLE_MAX_ENGINE and local_offset.y > 0 :
			ship_components.right_trasters.append(engine)
	
	pass

#endregion

#region Detected Othe Ships


func _entered_detected(node: GameIShip) -> void :
	var karma := get_agression_from(node)
	
	if karma <= GameScope.KARMA_ATTAK :
		_target_list.add_target(node)
		_add_target(node)
	
	node.change_agression.connect(_on_ship_change_agressin)


func _exited_detected(node: GameIShip) -> void :
	_target_list.erase(node)
	
	node.change_agression.disconnect(_on_ship_change_agressin)
	_remove_target(node)


func _on_ship_change_agressin(node: GameIShip) -> void :
	var karma := get_agression_from(node)
	if karma <= GameScope.KARMA_ATTAK :
		_target_list.add_target(node)
		_add_target(node)
	else :
		_target_list.remove_target(node)
		_remove_target(node)
	

func _add_target(target: Node2D) -> void :
	for canon in ship_components.canons :
		canon.add_target(target)

func _remove_target(target: Node2D) -> void :
	for canon in ship_components.canons :
		canon.remove_target(target)

#endregion

#region Physics


func _active_engine(_delta: float, engines: Array[GameEngine], force_max: float) -> void :
	for engine in engines :
		var g_pos := engine.get_global_force_position()
		g_pos -= global_position
		engine.start()
		var force := engine.get_force() * force_max
		apply_force(force, g_pos)

func _physics_process(delta: float) -> void:
	if not is_acivated :
		return
	
	is_engine_activated = Input.is_action_pressed("game_engine_active")
	
	if is_engine_activated :
		_active_engine(delta, ship_components.forward_engines, 1.0)
		
	var local_target_direction := get_local_mouse_position().normalized()
	var angle := Vector2.UP.angle_to(local_target_direction)
	var factor := angle / PI
	var force_angular := ease(absf(factor), 0.3)
	if factor < 0 :
		_active_engine(delta, ship_components.left_trasters, force_angular)
	else :
		_active_engine(delta, ship_components.right_trasters, force_angular)

#endregion

#region Slots



func _on_area_2d_radar_body_entered(body: Node2D) -> void:
	var ship := body as GameIShip
	if ship :
		_entered_detected(ship)


func _on_area_2d_radar_body_exited(body: Node2D) -> void:
	var ship := body as GameIShip
	if ship :
		_exited_detected(ship)

#endregion
