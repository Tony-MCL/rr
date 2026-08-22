extends Node

@onready var score_controller: Node = $ScoreController
@onready var result_label: Label = $ResultLabel

var cannonball_a := RigidBody2D.new()
var cannonball_b := RigidBody2D.new()


func _ready() -> void:
	cannonball_a.set_meta("shot_id", 101)
	cannonball_b.set_meta("shot_id", 202)
	add_child(cannonball_a)
	add_child(cannonball_b)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(score_controller.get_shot_multiplier(cannonball_a) == 1, "Shot A should start at x1.", failures)
	score_controller.activate_double_score(cannonball_a)
	_check(score_controller.get_shot_multiplier(cannonball_a) == 2, "First activation should produce x2.", failures)
	score_controller.activate_double_score(cannonball_a)
	_check(score_controller.get_shot_multiplier(cannonball_a) == 4, "Second activation should produce x4.", failures)
	score_controller.activate_double_score(cannonball_a)
	_check(score_controller.get_shot_multiplier(cannonball_a) == 8, "Third activation should produce x8.", failures)

	score_controller.add_shot_score(cannonball_a, 10)
	_check(int(score_controller.get_score()) == 80, "10 points at x8 should award 80.", failures)
	_check(score_controller.get_shot_multiplier(cannonball_b) == 1, "Separate shot should remain at x1.", failures)

	if failures.is_empty():
		result_label.text = "DOUBLE SCORE STACKING: PASS\nx1 -> x2 -> x4 -> x8\n10 at x8 = 80\nSeparate shot: x1"
		print("PHASE 6 DOUBLE SCORE STACKING TEST: PASS")
	else:
		result_label.text = "DOUBLE SCORE STACKING: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
