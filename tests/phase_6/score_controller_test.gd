extends Node

@onready var score_controller: Node = $ScoreController
@onready var result_label: Label = $ResultLabel

var _observed_scores: Array[int] = []


func _ready() -> void:
	score_controller.score_changed.connect(_on_score_changed)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(score_controller.get_score() == 0, "Initial score should be 0.", failures)

	score_controller.add_score(10)
	_check(score_controller.get_score() == 10, "Score should be 10 after adding 10.", failures)

	score_controller.add_score(25)
	_check(score_controller.get_score() == 35, "Score should be 35 after adding 25.", failures)

	score_controller.add_score(0)
	score_controller.add_score(-5)
	_check(score_controller.get_score() == 35, "Zero or negative score additions must be ignored.", failures)

	score_controller.reset_score()
	_check(score_controller.get_score() == 0, "Score should return to 0 after reset.", failures)
	_check(_observed_scores == [10, 35, 0], "score_changed should report 10, 35, 0 exactly once each.", failures)

	if failures.is_empty():
		result_label.text = "SCORE CONTROLLER: PASS\n0 -> 10 -> 35 -> 0\nSignal values: 10, 35, 0"
		print("PHASE 6 SCORE CONTROLLER TEST: PASS")
	else:
		result_label.text = "SCORE CONTROLLER: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)


func _on_score_changed(current_score: int) -> void:
	_observed_scores.append(current_score)
