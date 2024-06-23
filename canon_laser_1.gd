extends GameCanon

@export var pkg_projectile: PackedScene = null
@export var is_traveling_projectile: bool = false
@export var spread_deg: float = 5.0

@onready var _collision_shape: CollisionShape2D = %CollisionShape2D as CollisionShape2D
@onready var _circle_shape: CircleShape2D = _collision_shape.shape as CircleShape2D

func _ready() -> void:
	_circle_shape.radius = radius

func _start_shot() -> void : #virtual
	pass

func _shot(target: Node2D) -> void : #virtual
	var projectile: GameProjectile = pkg_projectile.instantiate() as GameProjectile
	if projectile :
		projectile.damage_owner = owner
		projectile.damage = damage
		projectile.damage_explotion = damage_explotion
		projectile.position = _emmiter.global_position
		projectile.rotation = _head.global_rotation 
		projectile.rotation_degrees += randf_range(-spread_deg, spread_deg)
		
		speed_projectile = projectile.speed
		if is_traveling_projectile :
			projectile.travel_to = target
		get_tree().current_scene.add_child(projectile)

func _stop_shot() -> void : #virtual
	pass

func _start_reload() -> void : #virtual
	pass

func _completed_reload() -> void : #virtual
	pass


func _on_shot_anim_animation_finished() -> void:
	pass # Replace with function body.
