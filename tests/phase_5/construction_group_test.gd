extends Node2D

@onready var grouped_a: TargetBody = $Zone/ConstructionAlpha/GroupedA
@onready var grouped_b: TargetBody = $Zone/ConstructionAlpha/GroupedB
@onready var nearby_ungrouped: TargetBody = $Zone/NearbyUngrouped
@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	var grouped_a_id := grouped_a.get_construction_id()
	var grouped_b_id := grouped_b.get_construction_id()
	var nearby_id := nearby_ungrouped.get_construction_id()
	var passed := grouped_a_id == &"alpha" and grouped_b_id == &"alpha" and nearby_id == &""

	result_label.text = "CONSTRUCTION GROUP TEST: %s\nGrouped A: %s\nGrouped B: %s\nNearby ungrouped: %s" % [
		"PASS" if passed else "FAIL",
		str(grouped_a_id),
		str(grouped_b_id),
		"NONE" if nearby_id == &"" else str(nearby_id),
	]

	print(result_label.text)
