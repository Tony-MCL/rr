extends Node

@onready var score_controller: Node = $ScoreController
@onready var zone_1_target: TargetBody = $Zone1/Zone1Target
@onready var zone_4_target: TargetBody = $Zone4/Zone4Target
@onready var unzoned_target: TargetBody = $UnzonedTarget
@onready var solid_target: TargetBody = $Zone2/SolidTarget
@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	zone_1_target.target_hit.connect(score_controller.register_target_hit)
	zone_4_target.target_hit.connect(score_controller.register_target_hit)
	unzoned_target.target_hit.connect(score_controller.register_target_hit)
	solid_target.target_hit.connect(score_controller.register_target_hit)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(zone_1_target.register_hit(null), "Zone 1 target hit should be valid.", failures)
	_check(score_controller.get_score() == 10, "Zone 1 one-hit target should award 10 points.", failures)

	_check(zone_4_target.register_hit(null), "Zone 4 target hit should be valid.", failures)
	_check(score_controller.get_score() == 50, "Zone 4 one-hit target should add 40 points.", failures)

	_check(unzoned_target.register_hit(null), "Unzoned target hit should still be a valid target hit.", failures)
	_check(score_controller.get_score() == 50, "Unzoned target should award 0 points.", failures)

	_check(not solid_target.register_hit(null), "Solid target must reject target damage.", failures)
	_check(score_controller.get_score() == 50, "Solid target must not award score.", failures)

	if failures.is_empty():
		result_label.text = "ONE-HIT SCORING: PASS\nZone 1: +10\nZone 4: +40\nUnzoned: +0\nSolid: +0\nTotal: 50"
		print("PHASE 6 ONE-HIT SCORING TEST: PASS")
	else:
		result_label.text = "ONE-HIT SCORING: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
