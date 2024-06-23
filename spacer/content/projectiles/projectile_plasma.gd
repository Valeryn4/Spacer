extends GameProjectile

const ANIM_EMIT := &"emit"
const ANIM_FLY := &"fly"
const ANIM_EXPLOTION := &"explotion"


@onready var _anim := %Anim as AnimatedSprite2D


### VIRTUAL

func _emit() -> void :
	_anim.play(ANIM_EMIT)
	_anim.flip_v = randf() > 0.5

func _fly() -> void :
	_anim.play(ANIM_FLY)

func _explotion() -> void :
	_anim.play(ANIM_EXPLOTION)
	

func _contact(_body: Node, _damage: GameDamage) -> void :
	pass

func _destroy() -> void :
	pass


### #############


func _on_animated_sprite_2d_animation_finished() -> void:
	if _anim.animation == ANIM_EMIT :
		fly()
	elif _anim.animation == ANIM_EXPLOTION :
		destroy()
