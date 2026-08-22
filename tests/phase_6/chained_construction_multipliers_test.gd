extends Node

@onready var score_controller: Node = $ScoreController
@onready var construction_a_target: TargetBody = $ConstructionA/Target
@onready var construction_b_target: TargetBody = $ConstructionB/Target
@onready var construction_c_target: TargetBody = $ConstructionC/Target
@onready var construction_d_target: TargetBody = $ConstructionD/Target
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()


func _ready() -> void:
	add_child(cannonball)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	var a_total := _hit_construction(construction_a_target, 6)
	_check(a_total == 310, "First construction should score 310 at x1.", failures)
	_check(score_controller.get_construction_chain_count(cannonball) == 1, "First qualifying construction should set chain count to 1.", failures)
	_check(score_controller.get_active_construction_multiplier(cannonball) == 1, "First qualifying construction multiplier should be x1.", failures)

	var b_total := _hit_construction(construction_b_target, 6)
	_check(b_total == 1550, "Second construction should score 1550 at x5.", failures)
	_check(score_controller.get_construction_chain_count(cannonball) == 2, "Second qualifying construction should set chain count to 2.", failures)
	_check(score_controller.get_active_construction_multiplier(cannonball) == 5, "Second qualifying construction multiplier should be x5.", failures)

	var c_total := _hit_construction(construction_c_target, 6)
	_check(c_total == 7750, "Third construction should score 7750 at x25.", failures)
	_check(score_controller.get_construction_chain_count(cannonball) == 3, "Third qualifying construction should set chain count to 3.", failures)
	_check(score_controller.get_active_construction_multiplier(cannonball) == 25, "Third qualifying construction multiplier should be x25.", failures)

	var d_total := _hit_construction(construction_d_target, 6)
	_check(d_total == 7750, "Fourth construction should remain capped at x25.", failures)
	_check(score_controller.get_active_construction_multiplier(cannonball) == 25, "Fourth qualifying construction multiplier should remain x25.", failures)

	score_controller.break_construction_series(cannonball)
	var restart_total := _hit_construction(construction_a_target, 6)
	_check(restart_total == 310, "Explicit break should restart the super-chain at x1.", failures)

	var before_return := score_controller.get_score()
	_hit_construction(construction_b_target, 6)
	var return_start := score_controller.get_score()
	score_controller.register_construction_hit(cannonball, construction_a_target)
	var return_points := score_controller.get_score() - return_start
	_check(return_points == 10, "Returning to a previously left construction should end the super-chain and restart at x1.", failures)
	_check(score_controller.get_construction_chain_count(cannonball) == 0, "Return to a previous construction should clear qualifying chain count.", failures)
	_check(score_controller.get_score() > before_return, "Return test should continue producing construction score.", failures)

	if failures.is_empty():
		result_label.text = "CHAINED CONSTRUCTION MULTIPLIERS: PASS\nFirst qualifying series: x1\nSecond: x5\nThird: x25\nFourth+: x25 cap\nBreak: restart x1\nReturn to previous: super-chain ends"
		print("PHASE 6 CHAINED CONSTRUCTION MULTIPLIERS TEST: PASS")
	else:
		result_label.text = "CHAINED CONSTRUCTION MULTIPLIERS: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _hit_construction(target: TargetBody, hit_count: int) -> int:
	var start_score := score_controller.get_score()
	for index in range(hit_count):
		score_controller.register_construction_hit(cannonball, target)
	return score_controller.get_score() - start_score


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
