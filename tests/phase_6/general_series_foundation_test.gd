extends Node

@onready var score_controller: Node = $ScoreController
@onready var peg_a: TargetBody = $PegA
@onready var peg_b: TargetBody = $PegB
@onready var block_a: TargetBody = $BlockA
@onready var block_b: TargetBody = $BlockB
@onready var result_label: Label = $ResultLabel

var ball_one := RigidBody2D.new()
var ball_two := RigidBody2D.new()


func _ready() -> void:
	add_child(ball_one)
	add_child(ball_two)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(peg_a.is_peg(), "Peg scene must report PEG shape.", failures)
	_check(block_a.is_block(), "StraightBlock scene must report BLOCK shape.", failures)

	score_controller.register_general_target_hit(ball_one, peg_a)
	score_controller.register_general_target_hit(ball_one, peg_b)
	_check(score_controller.get_general_series_length(ball_one) == 2, "Two peg hits should produce general-series length 2.", failures)
	_check(score_controller.get_general_series_type(ball_one) == &"pure_peg", "Peg-only run should classify as pure_peg.", failures)

	score_controller.register_general_target_hit(ball_one, block_a)
	_check(score_controller.get_general_series_length(ball_one) == 3, "Adding a block should extend the series to 3.", failures)
	_check(score_controller.get_general_series_type(ball_one) == &"mixed", "Peg plus block run should classify as mixed.", failures)

	score_controller.register_general_target_hit(ball_two, block_a)
	score_controller.register_general_target_hit(ball_two, block_b)
	_check(score_controller.get_general_series_length(ball_two) == 2, "Second ball should track its own series length.", failures)
	_check(score_controller.get_general_series_type(ball_two) == &"pure_block", "Block-only run should classify as pure_block.", failures)
	_check(score_controller.get_general_series_length(ball_one) == 3, "Second ball must not alter first ball series.", failures)

	var score_before: int = int(score_controller.get_score())
	score_controller.register_general_target_hit(ball_one, peg_a)
	_check(int(score_controller.get_score()) == score_before, "General-series foundation must not award undecided score values.", failures)

	score_controller.break_general_series(ball_one)
	_check(score_controller.get_general_series_length(ball_one) == 0, "General-series break should reset length.", failures)
	_check(score_controller.get_general_series_type(ball_one) == &"none", "General-series break should reset classification.", failures)

	if failures.is_empty():
		result_label.text = "GENERAL SERIES FOUNDATION: PASS\nPure peg: tracked\nPure block: tracked\nMixed: tracked\nPer-ball state: isolated\nBreak: reset\nBonus score: intentionally 0"
		print("PHASE 6 GENERAL SERIES FOUNDATION TEST: PASS")
	else:
		result_label.text = "GENERAL SERIES FOUNDATION: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
