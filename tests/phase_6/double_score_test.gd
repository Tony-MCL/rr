extends Node

@onready var score_controller: Node = $ScoreController
@onready var double_target: TargetBody = $Zone1/DoubleTarget
@onready var same_shot_target: TargetBody = $Zone2/SameShotTarget
@onready var other_shot_target: TargetBody = $Zone1/OtherShotTarget
@onready var result_label: Label = $ResultLabel

var shot_ball_a := RigidBody2D.new()
var shot_ball_b := RigidBody2D.new()
var other_shot_ball := RigidBody2D.new()


func _ready() -> void:
	shot_ball_a.set_meta("shot_id", 101)
	shot_ball_b.set_meta("shot_id", 101)
	other_shot_ball.set_meta("shot_id", 202)
	add_child(shot_ball_a)
	add_child(shot_ball_b)
	add_child(other_shot_ball)

	double_target.bonus_activated.connect(score_controller.register_target_bonus)
	double_target.valid_target_hit.connect(score_controller.register_shot_target_hit)
	same_shot_target.valid_target_hit.connect(score_controller.register_shot_target_hit)
	other_shot_target.valid_target_hit.connect(score_controller.register_shot_target_hit)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(score_controller.get_shot_multiplier(shot_ball_a) == 1, "Shot should begin at x1.", failures)
	_check(double_target.register_hit(shot_ball_a), "Double Score target hit should be valid.", failures)
	_check(score_controller.get_shot_multiplier(shot_ball_a) == 2, "Double Score should activate x2 for the shot.", failures)
	_check(score_controller.get_shot_multiplier(shot_ball_b) == 2, "All balls with the same shot_id should share x2.", failures)
	_check(score_controller.get_score() == 20, "Activation hit in Zone 1 should be doubled from 10 to 20.", failures)

	_check(same_shot_target.register_hit(shot_ball_b), "Second ball in same shot should hit valid target.", failures)
	_check(score_controller.get_score() == 60, "Zone 2 hit from another ball in same shot should add doubled 40.", failures)

	_check(score_controller.get_shot_multiplier(other_shot_ball) == 1, "Different shot should remain at x1.", failures)
	_check(other_shot_target.register_hit(other_shot_ball), "Different-shot target hit should be valid.", failures)
	_check(score_controller.get_score() == 70, "Different shot Zone 1 hit should add normal 10.", failures)

	if failures.is_empty():
		result_label.text = "SHOT-WIDE DOUBLE SCORE: PASS\nActivation hit: doubled\nSame shot, second ball: x2\nDifferent shot: x1\nTotal: 70"
		print("PHASE 6 SHOT-WIDE DOUBLE SCORE TEST: PASS")
	else:
		result_label.text = "SHOT-WIDE DOUBLE SCORE: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
