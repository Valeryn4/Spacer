class_name GameProjectile
extends CharacterBody2D

const GROUP_DAMAGED := &"DAMAGED"

@onready var _visible_on_screen_enabled := %VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D
@onready var _area_explotion := %Area2DExplotion as Area2D


@export var damage: float = 10.0
@export var damage_explotion: float = 10.0
@export var speed: float = 500.0
@export var penetration_count: int = 0
@export var traveling_deg_sec: float = 20.0

@export var life_time := 5.0
@export var life_time_explotion := 1.0

enum State {
	None,
	Emit,
	Fly,
	Explotion,
	Destroy,
}

var curren_state: State = State.None
var damage_owner: Node = null
var travel_to: Node2D = null

func  _ready() -> void:
	if damage_owner :
		add_collision_exception_with(damage_owner)
	emit()

func emit() -> void :
	curren_state = State.Emit
	_emit()

func fly() -> void :
	curren_state = State.Fly
	_fly()

func explotion() -> void :
	curren_state = State.Explotion
	collision_mask = 0
	collision_layer = 0
	
	_explotion()
	
	# TODO fix out screen
	if not _visible_on_screen_enabled.is_on_screen() :
		destroy()

func destroy() -> void :
	curren_state = State.Destroy
	_destroy()
	
	queue_free()

func contact(body: Node, damage: GameDamage) -> void :
	_contact(body, damage)

### VIRTUAL

func _emit() -> void :
	pass

func _fly() -> void :
	pass

func _explotion() -> void :
	pass

func _contact(_body: Node, _damage: GameDamage) -> void :
	pass

func _destroy() -> void :
	pass


### #############

func _physics_process(delta: float) -> void:
	
	if curren_state == State.Fly or curren_state == State.Emit :
		life_time -= delta
		if life_time <= 0.0 :
			explotion()
			return
	
	
	if curren_state == State.Explotion :
		life_time_explotion -= delta
		if life_time_explotion <= 0.0 :
			destroy()
			return
		
	
	if curren_state == State.Fly :
		var direction := Vector2.RIGHT.rotated(global_rotation)
		if travel_to :
			var target_direction := global_position.direction_to(travel_to.global_position)
			var target_rad := direction.angle_to(target_direction)
			var rad_delta := deg_to_rad(traveling_deg_sec) * delta
			var step_rad := move_toward(0.0, target_rad, rad_delta)
			rotate(step_rad)
			direction = Vector2.RIGHT.rotated(global_rotation)
			
		
		var motion := direction * speed * delta
		var collide := move_and_collide(motion)
		if collide :
			var collider := collide.get_collider() as Node2D
			if collider :
				var object_contact: PhysicsBody2D = collider as PhysicsBody2D
				if object_contact.get_collision_layer_value(GameMasks.LAYER_SHIP) :
					object_contact = object_contact.get_parent()
				
				var dmg := GameDamage.new()
				dmg.damage_value = damage
				dmg.owner_node = owner
				dmg.contact_node = object_contact
				dmg.contact_shape_index = collide.get_collider_shape_index()
				
				contact(collider, dmg)
				if penetration_count > 0 :
					penetration_count -= 1
					add_collision_exception_with(collider)
				else :
					explotion()


