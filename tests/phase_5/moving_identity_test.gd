extends Node2D

@onready var movement: SlideMovement = $Zone3/SlideMovement
@onready var wheel: ConstructionGroup = $Zone3/SlideMovement/RotationMovement/Wheel
@onready var status_label: Label = $StatusLabel

var _sample_target: TargetBody
var _start_position: Vector2
var _start_rotation: float
var _initial_zone_id: int
var _initial_construction_id: StringName


func _ready() -> void:
	_sample_target = _find_target(wheel)
	if _sample_target == null:
		status_label.text = "MOVING IDENTITY TEST: FAIL\nNo target found"
		return

	_start_position = movement.global_position
	_start_rotation = $Zone3/SlideMovement/RotationMovement.rotation
	_initial_zone_id = _sample_target.get_zone_id()
	_initial_construction_id = _sample_target.get_construction_id()

	await get_tree().create_timer(2.2).timeout
	_run_test()


func _run_test() -> void:
	var moved: bool = movement.global_position.distance_to(_start_position) > 20.0
	var rotated: bool = absf($Zone3/SlideMovement/RotationMovement.rotation - _start_rotation) > 0.2
	var zone_before: bool = _initial_zone_id == 3
	var construction_before: bool = _initial_construction_id == &"wheel_small"
	var zone_after: bool = _sample_target.get_zone_id() == 3
	var construction_after: bool = _sample_target.get_construction_id() == &"wheel_small"
	var passed: bool = moved and rotated and zone_before and construction_before and zone_after and construction_after

	status_label.text = "MOVING IDENTITY TEST: %s\nActually moved: %s\nActually rotated: %s\nZone before/after: %s / %s\nConstruction before/after: %s / %s" % [
		"PASS" if passed else "FAIL",
		"YES" if moved else "NO",
		"YES" if rotated else "NO",
		str(_initial_zone_id), str(_sample_target.get_zone_id()),
		str(_initial_construction_id), str(_sample_target.get_construction_id()),
	]


func _find_target(root: Node) -> TargetBody:
	if root is TargetBody:
		return root as TargetBody
	for child in root.get_children():
		var found := _find_target(child)
		if found != null:
			return found
	return null
