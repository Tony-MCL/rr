extends Node

@onready var score_controller: Node = $ScoreController
@onready var target_a: TargetBody = $TargetA
@onready var target_near: TargetBody = $TargetNear
@onready var target_far: TargetBody = $TargetFar
@onready var result_label: Label = $ResultLabel

var cannonball_a := RigidBody2D.new()
var cannonball_b := RigidBody2D.new()
var awarded_events: Array[StringName] = []


func _ready() -> void:
	add_child(cannonball_a)
	add_child(cannonball_b)
	score_controller.skill_shot_awarded.connect(_on_skill_shot_awarded)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	var first_points: int = int(score_controller.register_skill_shot_target_hit(cannonball_a, target_a))
	_check(first_points == 0, "First qualifying target hit should establish origin only.", failures)

	var near_points: int = int(score_controller.register_skill_shot_target_hit(cannonball_a, target_near))
	_check(near_points == 0, "Target hit below Long Shot threshold should award 0.", failures)

	score_controller.reset_skill_shot_tracking(cannonball_a)
	score_controller.register_skill_shot_target_hit(cannonball_a, target_a)
	var far_points: int = int(score_controller.register_skill_shot_target_hit(cannonball_a, target_far))
	_check(far_points == 1000, "Target hit at or above Long Shot threshold should award 1000.", failures)
	_check(int(score_controller.get_score()) == 1000, "Long Shot should contribute 1000 to score.", failures)
	_check(awarded_events.size() == 1 and awarded_events[0] == &"long_shot", "Long Shot should emit one skill-shot event.", failures)

	score_controller.register_skill_shot_target_hit(cannonball_b, target_far)
	var isolated_points: int = int(score_controller.register_skill_shot_target_hit(cannonball_b, target_near))
	_check(isolated_points == 0, "Skill-shot tracking should be isolated per cannonball.", failures)

	if failures.is_empty():
		result_label.text = "LONG SHOT FOUNDATION: PASS\nFirst hit: origin only\nShort gap: +0\nLong gap: +1000\nEvent: long_shot\nPer-ball tracking: isolated"
		print("PHASE 6 LONG SHOT TEST: PASS")
	else:
		result_label.text = "LONG SHOT FOUNDATION: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _on_skill_shot_awarded(_cannonball: RigidBody2D, skill_shot_id: StringName, _points: int) -> void:
	awarded_events.append(skill_shot_id)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
