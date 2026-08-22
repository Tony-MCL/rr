extends Node

@onready var score_controller: Node = $ScoreController
@onready var target: TargetBody = $Construction/Target
@onready var cannonball: RigidBody2D = $Cannonball
@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []
	var score_at_9 := 0
	var score_at_10 := 0
	var score_at_14 := 0
	var score_at_15 := 0
	var score_at_19 := 0
	var score_at_20 := 0

	for hit_number in range(1, 21):
		score_controller.register_construction_hit(cannonball, target)
		match hit_number:
			9:
				score_at_9 = score_controller.get_score()
			10:
				score_at_10 = score_controller.get_score()
			14:
				score_at_14 = score_controller.get_score()
			15:
				score_at_15 = score_controller.get_score()
			19:
				score_at_19 = score_controller.get_score()
			20:
				score_at_20 = score_controller.get_score()

	_check(score_at_9 == 610, "Score after hit 9 should be 610.", failures)
	_check(score_at_10 - score_at_9 == 600, "Hit 10 should award 100 series points + 500 milestone.", failures)
	_check(score_at_14 == 1610, "Score after hit 14 should be 1610.", failures)
	_check(score_at_15 - score_at_14 == 1100, "Hit 15 should award 100 series points + 1000 milestone.", failures)
	_check(score_at_19 == 3110, "Score after hit 19 should be 3110.", failures)
	_check(score_at_20 - score_at_19 == 3100, "Hit 20 should award 100 series points + 3000 milestone.", failures)
	_check(score_controller.get_construction_milestone_bonus(9) == 0, "Hit 9 should have no milestone bonus.", failures)
	_check(score_controller.get_construction_milestone_bonus(10) == 500, "Hit 10 milestone should be 500.", failures)
	_check(score_controller.get_construction_milestone_bonus(15) == 1000, "Hit 15 milestone should be 1000.", failures)
	_check(score_controller.get_construction_milestone_bonus(20) == 3000, "Hit 20 milestone should be 3000.", failures)
	_check(score_controller.get_construction_milestone_bonus(21) == 0, "Hit 21 should have no milestone bonus.", failures)
	_check(score_controller.get_score() == 6210, "Total score after 20 hits should be 6210.", failures)

	if failures.is_empty():
		result_label.text = "CONSTRUCTION MILESTONES: PASS\n10: 100 + 500\n15: 100 + 1000\n20: 100 + 3000\n20-hit total: 6210"
		print("PHASE 6 CONSTRUCTION MILESTONES TEST: PASS")
	else:
		result_label.text = "CONSTRUCTION MILESTONES: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
