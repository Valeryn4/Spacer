class_name GameStructureConnector
extends CollisionShape2D

@onready var _in: Node2D = %In
@onready var _out: Node2D = %Out

enum State {
	In,
	Out,
	None
}

@export var state: State = State.None :
	set(val) :
		state = val
		if _in and _out :
			_update_state()

func _ready() -> void:
	_update_state()

func _update_state() -> void :
	match state :
		State.None :
			_in.visible = false
			_out.visible = false
		State.In :
			_in.visible = true
			_out.visible = false
		State.Out :
			_in.visible = false
			_out.visible = true
	
	var parent_collision_object := get_parent() as CollisionObject2D
	if parent_collision_object :
		if parent_collision_object.collision_layer == 0 :
			_in.visible = false
		if parent_collision_object.collision_mask == 0 :
			_out.visible = false
		
