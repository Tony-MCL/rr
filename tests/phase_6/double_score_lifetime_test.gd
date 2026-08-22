extends Node

@onready var score_controller: Node = $ScoreController
@onready var result_label: Label = $ResultLabel

var shot_a_ball := RigidBody2D.new()
var shot_b_ball := RigidBody2D.new()
var observed_resets: Array[int] = []


func _ready() -> void:
	add_child(shot_a_ball)
	add_child(shot_b_ball)
	shot_a_ball.set_meta("shot_id", 101)
	shot_b_ball.set_meta("shot_id", 202)
	score_controller.shot_multiplier_changed.connect(_on_shot_multiplier_changed)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	score_controller.activate_double_score(shot_a_ball)
	score_controller.activate_double_score(shot_a_ball)
	_check(int(score_controller.get_shot_multiplier(shot_a_ball)) == 4, "Shot A should reach x4 before shot completion.", failures)

	score_controller.end_double_score_for_shot(101)
	_check(int(score_controller.get_shot_multiplier(shot_a_ball)) == 1, "Shot completion should reset Shot A to x1.", failures)

	score_controller.activate_double_score(shot_a_ball)
	score_controller.activate_double_score(shot_b_ball)
	_check(int(score_controller.get_shot_multiplier(shot_a_ball)) == 2, "Shot A should be x2 before bonus trigger.", failures)
	_check(int(score_controller.get_shot_multiplier(shot_b_ball)) == 2, "Shot B should be x2 before bonus trigger.", failures)

	score_controller.end_double_score_for_bonus_trigger()
	_check(int(score_controller.get_shot_multiplier(shot_a_ball)) == 1, "Bonus trigger should reset Shot A to x1.", failures)
	_check(int(score_controller.get_shot_multiplier(shot_b_ball)) == 1, "Bonus trigger should reset Shot B to x1.", failures)
	_check(observed_resets.count(101) >= 2, "Shot A reset should emit multiplier x1.", failures)
	_check(observed_resets.count(202) >= 1, "Shot B bonus-trigger reset should emit multiplier x1.", failures)

	if failures.is_empty():
		result_label.text = "DOUBLE SCORE LIFETIME: PASS\nShot end: reset to x1\nBonus trigger: reset all active shots\nScore unchanged"
		print("PHASE 6 DOUBLE SCORE LIFETIME TEST: PASS")
	else:
		result_label.text = "DOUBLE SCORE LIFETIME: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _on_shot_multiplier_changed(shot_id: int, multiplier: int) -> void:
	if multiplier == 1:
		observed_resets.append(shot_id)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
