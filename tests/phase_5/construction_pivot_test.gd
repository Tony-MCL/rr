extends Node2D

@onready var construction: ConstructionGroup = $ConstructionGroup
@onready var block_left: TargetBody = $ConstructionGroup/BlockLeft
@onready var block_right: TargetBody = $ConstructionGroup/BlockRight
@onready var result_label: Label = $CanvasLayer/ResultLabel


func _ready() -> void:
	var pivot_before := construction.get_pivot_global_position()
	var left_distance_before := block_left.global_position.distance_to(pivot_before)
	var right_distance_before := block_right.global_position.distance_to(pivot_before)

	construction.set_pivot_rotation_degrees(90.0)

	var pivot_after := construction.get_pivot_global_position()
	var left_distance_after := block_left.global_position.distance_to(pivot_after)
	var right_distance_after := block_right.global_position.distance_to(pivot_after)

	var pivot_stayed_fixed := pivot_before.is_equal_approx(pivot_after)
	var left_radius_preserved := is_equal_approx(left_distance_before, left_distance_after)
	var right_radius_preserved := is_equal_approx(right_distance_before, right_distance_after)
	var passed := pivot_stayed_fixed and left_radius_preserved and right_radius_preserved

	result_label.text = "CONSTRUCTION PIVOT TEST: %s\nPivot fixed: %s\nLeft radius preserved: %s\nRight radius preserved: %s\nRotation applied: %.0f°" % [
		"PASS" if passed else "FAIL",
		"YES" if pivot_stayed_fixed else "NO",
		"YES" if left_radius_preserved else "NO",
		"YES" if right_radius_preserved else "NO",
		construction.rotation_degrees,
	]
