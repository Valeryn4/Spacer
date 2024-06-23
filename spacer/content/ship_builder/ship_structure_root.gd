class_name GameShipBuilderRoot
extends CollisionShape2D

@onready var _area_root: GameShipRootArea = %Area2DRoot as GameShipRootArea

func change_statce_connector(state: GameStructureConnector.State) -> void :
	for area_shape in _area_root.get_children() :
		var connector := area_shape as GameStructureConnector
		if connector :
			connector.state = state
