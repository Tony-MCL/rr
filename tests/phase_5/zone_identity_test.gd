extends Node2D

@onready var zone_1_peg: TargetBody = $Zone1/Targets/Peg
@onready var zone_3_peg: TargetBody = $Zone3/NestedGroup/Peg
@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	var zone_1_result := zone_1_peg.get_zone_id()
	var zone_3_result := zone_3_peg.get_zone_id()
	var passed := zone_1_result == 1 and zone_3_result == 3

	result_label.text = "ZONE IDENTITY TEST: %s\nZone 1 direct child: %d\nZone 3 nested child: %d" % [
		"PASS" if passed else "FAIL",
		zone_1_result,
		zone_3_result,
	]

	print(result_label.text)
