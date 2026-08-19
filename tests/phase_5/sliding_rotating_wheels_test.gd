extends Node2D

@onready var small_root: SlideMovement = $SmallCombined
@onready var large_root: SlideMovement = $LargeCombined
@onready var small_rotation: RotationMovement = $SmallCombined/Rotation
@onready var large_rotation: RotationMovement = $LargeCombined/Rotation
@onready var status_label: Label = $StatusLabel

var _small_start_position: Vector2
var _large_start_position: Vector2
var _small_start_rotation: float
var _large_start_rotation: float


func _ready() -> void:
	_small_start_position = small_root.position
	_large_start_position = large_root.position
	_small_start_rotation = small_rotation.rotation
	_large_start_rotation = large_rotation.rotation
	await get_tree().create_timer(2.2).timeout
	_run_test()


func _run_test() -> void:
	var small_slid: bool = small_root.position.distance_to(_small_start_position) > 20.0
	var large_slid: bool = large_root.position.distance_to(_large_start_position) > 20.0
	var small_rotated: bool = absf(small_rotation.rotation - _small_start_rotation) > 0.5
	var large_rotated: bool = absf(large_rotation.rotation - _large_start_rotation) > 0.5
	var small_identity: bool = _wheel_identity_matches($SmallCombined/Rotation/Wheel, "wheel_small")
	var large_identity: bool = _wheel_identity_matches($LargeCombined/Rotation/Wheel, "wheel_large")
	var passed: bool = small_slid and large_slid and small_rotated and large_rotated and small_identity and large_identity

	status_label.text = "SLIDE + ROTATION TEST: %s\nSmall slid: %s\nSmall rotated: %s\nLarge slid: %s\nLarge rotated: %s\nSmall identity kept: %s\nLarge identity kept: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if small_slid else "NO",
		"YES" if small_rotated else "NO",
		"YES" if large_slid else "NO",
		"YES" if large_rotated else "NO",
		"YES" if small_identity else "NO",
		"YES" if large_identity else "NO",
	]


func _wheel_identity_matches(wheel: Node, expected_id: String) -> bool:
	for child in wheel.get_children():
		if child is TargetBody and child.get_construction_id() != expected_id:
			return false
	return true
