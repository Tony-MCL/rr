extends Node

@onready var score_controller: Node = $ScoreController
@onready var zone_1_target: TargetBody = $Zone1/Zone1Target
@onready var zone_3_target: TargetBody = $Zone3/Zone3Target
@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	zone_1_target.target_hit.connect(score_controller.register_target_hit)
	zone_3_target.target_hit.connect(score_controller.register_target_hit)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(zone_1_target.register_hit(null), "Zone 1 first hit should be valid.", failures)
	_check(score_controller.get_score() == 10, "Zone 1 first hit should award 10 points.", failures)

	_check(zone_1_target.register_hit(null), "Zone 1 second hit should be valid.", failures)
	_check(score_controller.get_score() == 20, "Zone 1 second hit should add 10 points.", failures)

	_check(zone_1_target.register_hit(null), "Zone 1 third hit should be valid.", failures)
	_check(score_controller.get_score() == 120, "Zone 1 destroying hit should add 100 points for a 120 total.", failures)

	_check(not zone_1_target.register_hit(null), "Destroyed Zone 1 target must reject another hit.", failures)
	_check(score_controller.get_score() == 120, "Destroyed target must not award additional score.", failures)

	_check(zone_3_target.register_hit(null), "Zone 3 first hit should be valid.", failures)
	_check(score_controller.get_score() == 150, "Zone 3 first hit should add 30 points.", failures)

	_check(zone_3_target.register_hit(null), "Zone 3 second hit should be valid.", failures)
	_check(score_controller.get_score() == 180, "Zone 3 second hit should add 30 points.", failures)

	_check(zone_3_target.register_hit(null), "Zone 3 third hit should be valid.", failures)
	_check(score_controller.get_score() == 480, "Zone 3 destroying hit should add 300 points.", failures)

	if failures.is_empty():
		result_label.text = "THREE-HIT SCORING: PASS\nZone 1: 10 + 10 + 100 = 120\nZone 3: 30 + 30 + 300 = 360\nCombined total: 480\nDestroyed repeat: +0"
		print("PHASE 6 THREE-HIT SCORING TEST: PASS")
	else:
		result_label.text = "THREE-HIT SCORING: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
