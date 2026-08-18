extends Node2D

@onready var small_slide: SlideMovement = $SmallSlidingWheel
@onready var large_slide: SlideMovement = $LargeSlidingWheel
@onready var status_label: Label = $StatusLabel

var _small_start: Vector2
var _large_start: Vector2


func _ready() -> void:
	_small_start = small_slide.position
	_large_start = large_slide.position
	await get_tree().create_timer(2.2).timeout
	_run_test()


func _run_test() -> void:
	var small_moved: bool = small_slide.position.distance_to(_small_start) > 40.0
	var large_moved: bool = large_slide.position.distance_to(_large_start) > 40.0
	var small_identity: bool = _wheel_identity_kept($SmallSlidingWheel/Wheel, "wheel_small")
	var large_identity: bool = _wheel_identity_kept($LargeSlidingWheel/Wheel, "wheel_large")
	var geometry_intact: bool = _count_targets($SmallSlidingWheel/Wheel) == 6 and _count_targets($LargeSlidingWheel/Wheel) == 12
	var passed: bool = small_moved and large_moved and small_identity and large_identity and geometry_intact

	status_label.text = "SLIDING WHEELS TEST: %s\nSmall moved: %s\nLarge moved: %s\nSmall identity kept: %s\nLarge identity kept: %s\nWheel geometry intact: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if small_moved else "NO",
		"YES" if large_moved else "NO",
		"YES" if small_identity else "NO",
		"YES" if large_identity else "NO",
		"YES" if geometry_intact else "NO",
	]


func _wheel_identity_kept(wheel: Node, expected_id: String) -> bool:
	for child in wheel.get_children():
		if child is TargetBody and child.get_construction_id() != expected_id:
			return false
	return true


func _count_targets(wheel: Node) -> int:
	var count: int = 0
	for child in wheel.get_children():
		if child is TargetBody:
			count += 1
	return count
