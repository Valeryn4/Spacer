class_name GameTargetList
extends RefCounted

var _target_list: Dictionary = {}

func has_target(target: Node2D) -> bool :
	return _target_list.has(target)

func add_target(target: Node2D) -> void :
	_target_list.has(target)

func remove_target(target: Node2D) -> void :
	_target_list.erase(target)

func remove_targets_from_target_list(othe_target_list:GameTargetList) -> void :
	for erase_key in othe_target_list._target_list :
		_target_list.erase(erase_key)

func is_empty() -> bool :
	return _target_list.is_empty()

func get_list() -> Dictionary :
	return _target_list

func clear() -> void :
	_target_list.clear()

func size() -> int :
	return _target_list.size()
