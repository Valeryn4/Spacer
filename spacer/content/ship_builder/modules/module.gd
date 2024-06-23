class_name GameModule
extends Node2D

const ShipModuleKey := GameScope.ShipModuleKey
const ShipModuleType := GameScope.ShipModuleType

@onready var shapes := %Shapes as Node2D

@export var module_type: ShipModuleType = ShipModuleType.None
@export var module_key: ShipModuleKey = ShipModuleKey.None

var ship_owner: GameIShip = null

func set_visible_builder(val: bool) -> void :
	pass

