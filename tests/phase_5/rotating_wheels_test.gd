extends Node2D

@onready var small_rotation: RotationMovement = $SmallRotatingWheel
@onready var large_rotation: RotationMovement = $LargeRotatingWheel
@onready var small_wheel: ConstructionGroup = $SmallRotatingWheel/Wheel
@onready var large_wheel: ConstructionGroup = $LargeRotatingWheel/Wheel
@onready var status_label: Label = $StatusLabel

var _small_initial_rotation: float
var _large_initial_rotation: float


func _ready() -> void:
	_small_initial_rotation = small_rotation.rotation
	_large_initial_rotation = large_rotation.rotation
	await get_tree().create_timer(2.0).timeout
	_run_test()


func _run_test() -> void:
	var small_rotated: bool = absf(small_rotation.rotation - _small_initial_rotation) > 1.5
	var large_rotated: bool = absf(large_rotation.rotation - _large_initial_rotation) > 1.0
	var small_identity: bool = _all_targets_match_construction(small_wheel, "wheel_small")
	var large_identity: bool = _all_targets_match_construction(large_wheel, "wheel_large")
	var small_shape_count: bool = _count_target_children(small_wheel) == 6
	var large_shape_count: bool = _count_target_children(large_wheel) == 12
	var passed: bool = small_rotated and large_rotated and small_identity and large_identity and small_shape_count and large_shape_count

	status_label.text = "ROTATING WHEELS TEST: %s\nSmall rotated: %s\nLarge rotated: %s\nSmall identity kept: %s\nLarge identity kept: %s\nWheel geometry intact: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if small_rotated else "NO",
		"YES" if large_rotated else "NO",
		"YES" if small_identity else "NO",
		"YES" if large_identity else "NO",
		"YES" if small_shape_count and large_shape_count else "NO",
	]


func _count_target_children(group: Node) -> int:
	var count: int = 0
	for child in group.get_children():
		if child is TargetBody:
			count += 1
	return count


func _all_targets_match_construction(group: Node, expected_id: String) -> bool:
	for child in group.get_children():
		if child is TargetBody and child.get_construction_id() != expected_id:
			return false
	return true
