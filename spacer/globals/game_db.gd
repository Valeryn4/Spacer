class_name GameDateBase
extends Node

const ShipStructureKey := GameScope.ShipStructureKey
const ShipStructureType := GameScope.ShipStructureType


var _cached_struct_pkg: Array[PackedScene] = []
var _cached_struct_res_info: Array[GameStructureInfoData] = []

func _ready() -> void:
	load_cache()


#region PUBLIC METHOD

## @return cached res info from key [GameScope.ShipStructureKey]
func get_struct_res_info(key: ShipStructureKey) -> GameStructureInfoData :
	return _cached_struct_res_info[key]

## @return cached packed structure from key [GameScopes.ShipStructureKey]
func get_struct_pkg(key: ShipStructureKey) -> PackedScene :
	return _cached_struct_pkg[key]

## load and cached all resource on runtime
func load_cache() -> void :
	GameDateBase.validate_data_base()
	
	_cached_struct_pkg.resize(ShipStructureKey.size())
	_cached_struct_pkg.fill(null)
	_cached_struct_res_info.resize(ShipStructureKey.size())
	_cached_struct_res_info.fill(null)
	
	for key in ShipStructureKey.keys() :
		
		var key_val: int = ShipStructureKey[key]
		if key_val == ShipStructureKey.None :
			continue
		
		var path_res_info: String = ShipStructureResInfo[key_val]
		_cached_struct_res_info[key_val] = load(path_res_info)
		
		var path_pkg: String = ShipStructurePKG[key_val]
		_cached_struct_pkg[key_val] = load(path_pkg)

#endregion


#region STATIC METHOD

## Validate date base
static func validate_data_base() -> void :
	for key in ShipStructureKey.keys() :
		
		var key_val: int = ShipStructureKey[key]
		if key_val == ShipStructureKey.None :
			continue
		
		assert(
			ShipStructureResInfo.has(key_val), 
			"GameDB Validate [%s] - RES INFO FAILED! -> key not found in ShipStructureResInfo" % key)
		var path_res_info: String = ShipStructureResInfo[key_val]
		assert(
			ResourceLoader.exists(path_res_info), 
			"GameDB Validate [%s] - RES INFO FAILED! -> %s no exists!" % [key, path_res_info])
		print(
			"GameDB Validate [%s] - RES INFO SUCCESS! -> res:%s" % [key, path_res_info])
		
		assert(
			ShipStructurePKG.has(key_val), 
			"GameDB Validate [%s] - PKG FAILED! -> key not found in ShipStructurePKG" % key)
		var path_pkg: String = ShipStructurePKG[key_val]
		assert(
			ResourceLoader.exists(path_pkg), 
			"GameDB Validate [%s] - PKG FAILED! -> %s no exists!" % [key, path_pkg])
		
		print(
			"GameDB Validate [%s] - PKG SUCCESS! -> res:%s" % [key, path_pkg])


#endregion

## Map structure enumiration from [GameScope.ShipStructureKey] to [GameStructureInfoData]
const ShipStructureResInfo := {
	#region Engines
	ShipStructureKey.EngineYellowBig_1 : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_engine_1.tres"),
	
	#endregion
	
	#region Structures
	ShipStructureKey.StructBase_1_L : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_base_left_1.tres"),
	ShipStructureKey.StructBase_1_R : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_base_right_1.tres"),
	ShipStructureKey.StructBase_2_L : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_base_2.tres"),
	ShipStructureKey.StructBase_2_R : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_base_2.tres"),
	ShipStructureKey.StructBase_3_L : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_base_left_3.tres"),
	ShipStructureKey.StructBase_3_R : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_base_right_3.tres"),
	
	#endregion
	
	#region Cannons
	ShipStructureKey.CannonLaser_1  : ("res://spacer/content/ship_builder/structures/info_data/res_info_structure_cannon_laser_1.tres"),
	
	#endregion
}

## Map structure enumiration from [GameScope.ShipStructureKey] to [PackedScene]
const ShipStructurePKG := {
	#region Engines
	ShipStructureKey.EngineYellowBig_1 : ("res://spacer/content/ship_builder/structures/structures/structure_engine_1.tscn"),
	
	#endregion
	
	#region Structures
	ShipStructureKey.StructBase_1_L : ("res://spacer/content/ship_builder/structures/structures/structure_base_1_left.tscn"),
	ShipStructureKey.StructBase_1_R : ("res://spacer/content/ship_builder/structures/structures/structure_base_1_right.tscn"),
	ShipStructureKey.StructBase_2_L : ("res://spacer/content/ship_builder/structures/structures/structure_base_2.tscn"),
	ShipStructureKey.StructBase_2_R : ("res://spacer/content/ship_builder/structures/structures/structure_base_2.tscn"),
	ShipStructureKey.StructBase_3_L : ("res://spacer/content/ship_builder/structures/structures/structure_base_3_left.tscn"),
	ShipStructureKey.StructBase_3_R : ("res://spacer/content/ship_builder/structures/structures/structure_base_3_right.tscn"),
	
	#endregion
	
	#region Cannons
	ShipStructureKey.CannonLaser_1  : ("res://spacer/content/ship_builder/structures/structures/structure_cannon_laser_1.tscn"),
	
	#endregion
}



