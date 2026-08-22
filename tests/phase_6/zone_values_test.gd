extends Node

@onready var score_controller: Node = $ScoreController
@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(score_controller.get_zone_value(1) == 10, "Zone 1 should be worth 10 points.", failures)
	_check(score_controller.get_zone_value(2) == 20, "Zone 2 should be worth 20 points.", failures)
	_check(score_controller.get_zone_value(3) == 30, "Zone 3 should be worth 30 points.", failures)
	_check(score_controller.get_zone_value(4) == 40, "Zone 4 should be worth 40 points.", failures)
	_check(score_controller.get_zone_value(0) == 0, "Invalid zone 0 should return 0 points.", failures)
	_check(score_controller.get_zone_value(5) == 0, "Invalid zone 5 should return 0 points.", failures)
	_check(score_controller.get_score() == 0, "Zone value lookup must not change the current score.", failures)

	if failures.is_empty():
		result_label.text = "GLOBAL ZONE VALUES: PASS\nZone 1 = 10\nZone 2 = 20\nZone 3 = 30\nZone 4 = 40\nInvalid zone = 0"
		print("PHASE 6 GLOBAL ZONE VALUES TEST: PASS")
	else:
		result_label.text = "GLOBAL ZONE VALUES: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
