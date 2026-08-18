extends Node2D

@onready var small_wheel: ConstructionGroup = $SmallWheel
@onready var large_wheel: ConstructionGroup = $LargeWheel
@onready var status_label: Label = $StatusLabel


func _ready() -> void:
	await get_tree().process_frame
	_run_test()


func _run_test() -> void:
	var small_count: bool = _count_target_children(small_wheel) == 4
	var large_count: bool = _count_target_children(large_wheel) == 8
	var small_identity: bool = _all_targets_match_construction(small_wheel, "wheel_small")
	var large_identity: bool = _all_targets_match_construction(large_wheel, "wheel_large")
	var small_pivot: bool = small_wheel.get_node_or_null("Pivot") != null
	var large_pivot: bool = large_wheel.get_node_or_null("Pivot") != null
	var passed: bool = small_count and large_count and small_identity and large_identity and small_pivot and large_pivot

	status_label.text = "STATIC WHEELS TEST: %s\nSmall wheel pieces: %s\nLarge wheel pieces: %s\nSmall identity: %s\nLarge identity: %s\nShared pivots: %s" % [
		"PASS" if passed else "FAIL",
		"4" if small_count else "FAIL",
		"8" if large_count else "FAIL",
		"YES" if small_identity else "NO",
		"YES" if large_identity else "NO",
		"YES" if small_pivot and large_pivot else "NO",
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
