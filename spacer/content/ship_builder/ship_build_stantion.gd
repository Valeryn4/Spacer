class_name GameShipBuildStantion
extends Node2D

@onready var _structures: Node2D = %Structures

@export var start_ship: GameShip = null

var ship: GameShip = null

func _ready() -> void:
	ship = start_ship

func activate() -> void :
	if ship :
		ship.activate()

func apply_structures() -> void :
	if not ship :
		return
	ship.build_ship(_structures.get_children())


func _on_button_pressed() -> void:
	$Button.visible = false
	apply_structures()
	ship.force_update_transform()
	activate.call_deferred()
