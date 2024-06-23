class_name GamepShipComponents
extends RefCounted

var component_list: Array[Node2D] = []


var engines: Array[GameEngine] = []


var left_trasters: Array[GameEngine] = []
var right_trasters: Array[GameEngine] = []

var forward_engines: Array[GameEngine] = []
var backward_engines: Array[GameEngine] = []

var canons: Array[GameCanon] = []

func clear() -> void :
	component_list.clear()
	engines.clear()
	left_trasters.clear()
	right_trasters.clear()
	forward_engines.clear()
	backward_engines.clear()
	canons.clear()
