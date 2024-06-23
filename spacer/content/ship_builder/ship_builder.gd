class_name GameShipBuilder
extends RefCounted

const PKG := preload(GameScope.ShipBasePacked) as PackedScene
const NO_INDEX := -1

var pilot: GameIPilot = null
var ship_data: GameShipData = null
var structure_list: Array[Node] = []

func set_pilot(new_pilot: GameIPilot) -> GameShipBuilder :
	pilot = new_pilot
	return self

func set_ship_data(new_ship_data: GameShipData) -> GameShipBuilder :
	ship_data = new_ship_data
	return self

func set_structure_ship(list: Array[Node]) -> GameShipBuilder :
	structure_list = list
	return self

func build_on_stantion() -> GameIShip :
	var ship := PKG.instantiate() as GameIShip
	
	
	if ship_data :
		for idx in ship_data.get_count() :
			var key := ship_data.get_component_from_id(idx)
			var position := ship_data.get_position_from_id(idx)
			var rotation := ship_data.get_rotation_from_id(idx)
			var scale := ship_data.get_scale_from_id(idx)
			
			var packed := GameDB.get_struct_pkg(key)
			var structure := packed.instantiate() as GameStructureShip
			structure.position = position
			structure.rotation = rotation
			structure.scale = scale
			
			var module := structure.get_module()
			ship.add_child(module)
			module.owner = ship
			ship.add_module_component(idx, module)
			
			var shapes := structure.get_collisions()
			for shape in shapes :
				ship.add_child(shape)
				shape.owner = ship
				ship.add_shape_component(idx, shape)
	
	if structure_list :
		for node in structure_list :
			var structure := node as GameStructureShip
			var module := structure.get_module()
			ship.add_child(module)
			module.owner = ship
			ship.add_module_component(NO_INDEX, module)
			
			var shapes := structure.get_collisions()
			for shape in shapes :
				ship.add_child(shape)
				shape.owner = ship
				ship.add_shape_component(NO_INDEX, shape)
	
	
	return ship



static func pack_ship(ship: GameIShip) -> PackedScene : 
	var pkg := PackedScene.new()
	pkg.pack(ship)
	return pkg

static func unpack_ship(pkg: PackedScene) -> GameIShip :
	return pkg.instantiate()
