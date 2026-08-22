extends Node

@onready var score_controller: Node = $ScoreController
@onready var construction_a: ConstructionGroup = $ConstructionA
@onready var construction_b: ConstructionGroup = $ConstructionB
@onready var ball_a: RigidBody2D = $BallA
@onready var ball_b: RigidBody2D = $BallB
@onready var result_label: Label = $ResultLabel

var _observed_series_points: Array[int] = []


func _ready() -> void:
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	for index in range(6):
		var target := _create_target(construction_a, "A%d" % (index + 1))
		target.valid_target_hit.connect(_on_valid_target_hit)
		_check(target.register_hit(ball_a), "Construction A hit %d should be valid." % (index + 1), failures)

	_check(_observed_series_points == [10, 20, 40, 60, 80, 100], "First six construction hits should award 10, 20, 40, 60, 80, 100.", failures)
	_check(score_controller.get_construction_series_length(ball_a) == 6, "Ball A series length should be 6.", failures)
	_check(score_controller.get_score() == 310, "Six-hit construction series should total 310 points.", failures)

	for index in range(2):
		var target := _create_target(construction_a, "BallB_A%d" % (index + 1))
		target.valid_target_hit.connect(_on_valid_target_hit)
		_check(target.register_hit(ball_b), "Ball B hit %d should be valid." % (index + 1), failures)

	_check(score_controller.get_construction_series_length(ball_b) == 2, "Ball B must keep an independent series length of 2.", failures)
	_check(score_controller.get_construction_series_length(ball_a) == 6, "Ball B must not alter Ball A's series.", failures)
	_check(score_controller.get_score() == 340, "Ball B independent 10 + 20 should bring total to 340.", failures)

	score_controller.break_construction_series(ball_a)
	var after_break := _create_target(construction_a, "AfterBreak")
	after_break.valid_target_hit.connect(_on_valid_target_hit)
	_check(after_break.register_hit(ball_a), "Hit after explicit break should be valid.", failures)
	_check(score_controller.get_construction_series_length(ball_a) == 1, "Explicit break should restart Ball A at series length 1.", failures)
	_check(_observed_series_points[-1] == 10, "First hit after break should award 10 series points.", failures)

	var other_construction := _create_target(construction_b, "OtherConstruction")
	other_construction.valid_target_hit.connect(_on_valid_target_hit)
	_check(other_construction.register_hit(ball_a), "Other construction hit should be valid.", failures)
	_check(score_controller.get_construction_series_length(ball_a) == 1, "Changing construction should restart the series at 1.", failures)
	_check(_observed_series_points[-1] == 10, "First hit in another construction should award 10 series points.", failures)

	var ungrouped_target := _create_target(self, "UngroupedTarget")
	ungrouped_target.valid_target_hit.connect(_on_valid_target_hit)
	_check(ungrouped_target.register_hit(ball_a), "Ungrouped target hit should be valid.", failures)
	_check(score_controller.get_construction_series_length(ball_a) == 0, "Ungrouped target should break the construction series.", failures)
	_check(_observed_series_points[-1] == 0, "Ungrouped target should award 0 construction-series points.", failures)

	_check(score_controller.get_score() == 360, "Construction-series score should total 360 after all scoring hits.", failures)

	if failures.is_empty():
		result_label.text = "CONSTRUCTION SERIES: PASS\nA: 10 + 20 + 40 + 60 + 80 + 100 = 310\nSeparate ball: 10 + 20\nBreak restart: +10\nNew construction restart: +10\nUngrouped break: +0\nSeries score total: 360"
		print("PHASE 6 CONSTRUCTION SERIES TEST: PASS")
	else:
		result_label.text = "CONSTRUCTION SERIES: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _create_target(parent_node: Node, target_name: String) -> TargetBody:
	var target := TargetBody.new()
	target.name = target_name
	target.hits_required = 1
	target.removal_delay_seconds = 5.0
	parent_node.add_child(target)
	return target


func _on_valid_target_hit(target: TargetBody, cannonball: RigidBody2D, _current_hits: int, _required_hits: int) -> void:
	_observed_series_points.append(score_controller.register_construction_hit(cannonball, target))


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
