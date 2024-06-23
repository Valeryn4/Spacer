class_name  GameScope
extends RefCounted

func _init() -> void:
	assert(false, "IS STATIC!")

## Sub type objects
enum ShipStructureType {
	None = -1,
	
	TStruct          = 1,
	TArmor           = 2,
	TEngine          = 4,
	TReactor         = 8,
	TShieldGenerator = 16,
	TCanon           = 32,
	TRepearDrone     = 64,
	TScanner         = 128,
	TGrabber         = 256
}


## Enumiration object structures
enum ShipStructureKey {
	None = -1,
	
	#region Engines
	EngineYellowBig_1,
	
	#endregion
	
	#region Structures
	StructBase_1_L,
	StructBase_1_R,
	StructBase_2_L,
	StructBase_2_R,
	StructBase_3_L,
	StructBase_3_R,
	
	#endregion
	
	#region Cannons
	CannonLaser_1,
	
	#endregion
}



const ShipModuleType := ShipStructureType

enum ShipModuleKey {
	None = -1,
}


const KARMA_PERFECT: float = 1.0
const KARMA_GOOD:    float = 0.5
const KARMA_NEUTRAL: float = 0.0
const KARMA_BAD:     float = -0.5
const KARMA_HATE:    float = -1.0

const KARMA_ATTAK:   float = -0.95

const KARMA_MIN:     float = -1.0
const KARMA_MAX:     float = 1.0

const KARMA_FRACTION_MUL: float = 0.5

const DEFAULT_KARMA: float = KARMA_NEUTRAL

enum Fractions {
	None,
	Player,
	Protector,
	Pirate,
	Traders,
}

const FractionsKarmaMapDefault := {
	Fractions.Traders : {Fractions.Player: 0.7}
}


const ShipBasePacked := "res://spacer/content/ship_builder/ship/ship.tscn"
