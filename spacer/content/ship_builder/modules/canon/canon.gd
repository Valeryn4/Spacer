class_name GameCanon
extends GameModule

signal started_reload()
signal completed_reload()
signal started_shot()
signal finished_shot()
signal shoted()

@onready var _head := %Head as Node2D
@warning_ignore("unused_private_class_variable")
@onready var _emmiter := %Emmitor as Marker2D
@onready var _detector := %Detector as Area2D
@onready var _time_reload := %TimerReload as Timer
@onready var _time_shot := %TimerShot as Timer
@onready var _radius_area_helper := %RadiusAreaHelper as Node2D

@export_group("Shoot")
@export var active: bool = true :
	set(val) :
		active = val
		if is_inside_tree() :
			set_physics_process(active and _count_detected > 0)

## Usually turrets shoot at their own targets.
@export var auto_shoot: bool = true

@export_subgroup("DPS")
## the number of shots in one firing cycle.
## The equivalent of a clip
@export var shot_count_cicle: int = 1
## waiting time between shots within a single firing cycle
@export var wait_time_shot_cicle: float = 0.2
## reload time between firing cycles
@export var wait_time_reload: float = 1.0
## direct damage, from a direct hit by a projectile, if any
@export var damage: float = 10.0
## applied damage after the destruction of the projectile, if any
@export var damage_explotion: float = 10.0
## Readeble property.
## It is used to calculate preemptive firing
@export var speed_projectile: float = 0.0

@export_subgroup("Look")
## Shoot at one constant target, not the nearest one
## It will pursue one target, after it is detected, until it goes beyond the radius
@export var is_lock_target: bool = false
## The rotation speed of the gun turret in degrees per second
@export var speed_rot_deg_from_sec: float = 360.0
## Detected radius target
@export var radius: float = 150.0
## Shoot only if the target is in the hit zone
@export var is_shoot_on_targeted: bool = false
## Acceptable angle of attack allowed, works if the flag is enabled: [GameCanon.@is_shoot_on_targeted]
@export var shot_deg_min: float = 15.0

var _shot_count: int = 0
var _active: bool = false
var _count_detected: int = 0
var _current_traget: Node2D = null
var _last_target_pos: Vector2 = Vector2.ZERO
var _target_list_on_detected: GameTargetList = GameTargetList.new()
var target_list_on_ship: GameTargetList = null

func _ready() -> void:
	_time_reload.wait_time = wait_time_reload
	_time_shot.wait_time = wait_time_shot_cicle
	
	set_physics_process(active and _count_detected > 0)

## PUBLIC

func emplace_on_ship() -> void :
	_radius_area_helper.visible = false

func set_visible_builder(val: bool) -> void :
	_radius_area_helper.visible = val

func start_shot() -> void :
	if not _active :
		_active = true
		
		started_shot.emit()
		_start_shot()

func shot(target: Node2D) -> void :
	if active :
		if _time_shot.is_stopped() and _time_reload.is_stopped() :
			_time_shot.start(wait_time_shot_cicle)
			shoted.emit()
			_shot(target)

func stop_shot() -> void :
	if _active :
		_active = false
		finished_shot.emit()
		_stop_shot()
		
		_time_shot.stop()
		reload()

func reload() -> void :
	if _time_reload.is_stopped() :
		_time_reload.start(wait_time_reload)
		started_reload.emit()
		_start_reload()

func get_dps() -> float :
	var dps_cicle := (damage * shot_count_cicle) * (1.0 / (wait_time_shot_cicle * shot_count_cicle))
	var dps = dps_cicle * (1.0 / wait_time_reload)
	return dps


#region Virtual Overrided

func _start_shot() -> void : #virtual
	pass

func _shot(_target: Node2D) -> void : #virtual
	pass

func _stop_shot() -> void : #virtual
	pass

func _start_reload() -> void : #virtual
	pass

func _completed_reload() -> void : #virtual
	pass


#endregion


#region Targeting

func add_target(target: Node2D) -> void :
	if _detector.overlaps_body(target) :
		_target_list_on_detected.add_target(target)

func remove_target(target: Node2D) -> void :
	if _current_traget == target :
		_current_traget = null
	
	_target_list_on_detected.remove_target(target)

func _on_timer_reload_timeout() -> void:
	completed_reload.emit()
	_completed_reload()
	if _active : 
		_time_shot.start(wait_time_shot_cicle)


func _on_timer_shot_timeout() -> void:
	if _shot_count == shot_count_cicle :
		_shot_count = 0
		reload()
		return
	_shot_count += 1
	


func _on_detector_area_entered(area: Area2D) -> void:
	var body := area.get_parent() as Node2D
	if body == ship_owner :
		return
	
	if target_list_on_ship.has_target(body) :
		_target_list_on_detected.add_target(body)
	
	_count_detected += 1
	
	set_physics_process(active and _count_detected > 0)
	


func _on_detector_area_exited(area: Area2D) -> void:
	var body := area.get_parent() as Node2D
	if body == ship_owner :
		return
	
	if body == _current_traget :
		_current_traget = null
	_target_list_on_detected.remove_target(body)
	
	_count_detected -= 1
	
	set_physics_process(active and _count_detected > 0)



#endregion


#region Physics


static func get_shoot_vector(u:float, v:Vector2, r0:Vector2) -> Vector2:
	# cross - проекция векторного произведения на ось OZ
	var sin_phi : float = v.cross(r0) / (r0.length() * u)
	
	if abs(sin_phi) > 1: # нет решений
		return Vector2.ZERO
	
	var cos_phi : float = sqrt(1 - sin_phi**2)
	# знак tsing такой же, как и у времени
	var tsign : float = u*r0.length()*cos_phi - v.dot(r0)
	
	if tsign < 0:
		return Vector2.ZERO
	# не забываем про минус
	return r0.rotated(-asin(sin_phi)).normalized()


func _process_check_target() -> void :
	if _target_list_on_detected.is_empty() :
		_current_traget = null
		set_physics_process(active and _count_detected > 0)
		return
	
	var is_need_find_target: bool = (
		not _current_traget or 
		not is_lock_target)
	
	if is_need_find_target :
		var last_distance: float = 10000000.0
		var new_target: Node2D = null
		
		for node in _target_list_on_detected.get_list() :
			var distance := to_local(node.global_position).length()
			if distance < last_distance :
				new_target = node
				last_distance = distance
		
		if new_target != _current_traget :
			_current_traget = new_target
			_last_target_pos = new_target.global_position


func _process_activate_shot() -> void :
	if _current_traget :
		start_shot()
	else :
		stop_shot()


func _process_rotation_to_target(delta: float) -> void :
	if _current_traget :
		var direction_current := Vector2.RIGHT.rotated(_head.rotation)
		var direction_target: Vector2 = Vector2.ZERO
		var target_pos: Vector2 = _current_traget.global_position
		if _current_traget is RigidBody2D :
			direction_target = GameCanon.get_shoot_vector(
				speed_projectile, 
				_current_traget.linear_velocity ,
				to_local(target_pos)
			)
		elif _current_traget is CharacterBody2D :
			direction_target = GameCanon.get_shoot_vector(
				speed_projectile, 
				_current_traget.velocity ,
				to_local(target_pos)
			)
		else :
			var target_dir := _last_target_pos.direction_to(_current_traget.global_position)
			var target_speed := _last_target_pos.distance_to(_current_traget.global_position)
			direction_target = GameCanon.get_shoot_vector(
				speed_projectile * delta, 
				target_dir * target_speed,
				to_local(target_pos)
			)
		
		var need_rad := direction_current.angle_to(direction_target)
		var step := deg_to_rad(speed_rot_deg_from_sec * delta)
		var next_rot := move_toward(0.0, need_rad, step)
		
		_head.rotate(next_rot)
		
		if auto_shoot :
			if is_shoot_on_targeted :
				direction_current = Vector2.RIGHT.rotated(_head.rotation)
				need_rad = abs(direction_current.angle_to(direction_target))
				var need_deg := rad_to_deg(need_rad)
				if need_deg <= shot_deg_min:
					shot(_current_traget)
			else :
				shot(_current_traget)


func _physics_process(delta: float) -> void:
	if active :
		
		_process_check_target()
		_process_activate_shot()
		_process_rotation_to_target(delta)
	else :
		set_physics_process(false)

#endregion

