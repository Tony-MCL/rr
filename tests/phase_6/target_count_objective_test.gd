extends Node

@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var one_hit_target: TargetBody = $OneHitTarget
@onready var three_hit_target: TargetBody = $ThreeHitTarget
@onready var solid_target: TargetBody = $SolidTarget
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()


func _ready() -> void:
	add_child(cannonball)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []
	objective_controller.add_target_count_objective(&"targets", 2, true)
	objective_controller.register_target_for_objectives(one_hit_target)
	objective_controller.register_target_for_objectives(three_hit_target)
	objective_controller.register_target_for_objectives(solid_target)

	_check(objective_controller.get_objective_current_value(&"targets") == 0, "Target count should start at 0.", failures)

	one_hit_target.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"targets") == 1, "One-hit target should count once when destroyed.", failures)

	one_hit_target.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"targets") == 1, "Destroyed one-hit target must not count twice.", failures)

	three_hit_target.register_hit(cannonball)
	three_hit_target.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"targets") == 1, "Three-hit target must not count before final hit.", failures)

	three_hit_target.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"targets") == 2, "Three-hit target should count once on final hit.", failures)
	_check(objective_controller.is_objective_complete(&"targets"), "Target-count objective should complete at required count.", failures)

	_check(not solid_target.register_hit(cannonball), "Solid target should reject target hit.", failures)
	_check(objective_controller.get_objective_current_value(&"targets") == 2, "Solid must never affect target count.", failures)

	if failures.is_empty():
		result_label.text = "TARGET COUNT OBJECTIVE: PASS\nOne-hit: +1 on destruction\nThree-hit: +1 on final hit only\nDestroyed repeat: ignored\nSolid: excluded\nRequired 2: complete"
		print("PHASE 6 TARGET COUNT OBJECTIVE TEST: PASS")
	else:
		result_label.text = "TARGET COUNT OBJECTIVE: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
