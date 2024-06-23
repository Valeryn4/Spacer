class_name GameStructureInfoData
extends Resource

const ShipStructureType := GameScope.ShipStructureType
const ShipStructureKey := GameScope.ShipStructureKey

@export var info_name: StringName = &"structure_name"
@export_multiline var info_description: String = "description"
@export var info_structure_type: ShipStructureType = ShipStructureType.None
@export var info_structure_key: ShipStructureKey = ShipStructureKey.None
@export var info_icon: Texture = null

@export_subgroup("Parameters")
@export var param_base_price: float = 0.0
@export var param_mass: float = 0.0
@export var param_armor: float = 0.0
@export var param_health: float = 0.0

@export_subgroup("Require")
@export var req_ship_energy: float = 0.0

@export_subgroup("Modification")
@export var add_ship_energy: float = 0.0
@export var add_ship_shield: float = 0.0
@export var add_ship_health: float = 0.0


func get_info_name_translate() -> StringName :
	return tr(info_name)

func get_info_description_translate() -> String :
	return tr(info_description)
