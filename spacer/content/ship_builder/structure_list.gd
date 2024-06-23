extends Node2D


func _ready() -> void:
	for node in get_children() :
		if node is GameStructureShip :
			node.emplaced.connect(_on_struct_emplaced.bind(node))

func _on_struct_emplaced(structs: GameStructureShip) -> void :
	for node in get_children() :
		if node is GameStructureShip :
			if node != structs :
				node._check_connect()
