extends Node

@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var normal_target: TargetBody = $NormalTarget
@onready var objective_target_a: TargetBody = $ObjectiveTargetA
@onready var objective_target_b: TargetBody = $ObjectiveTargetB
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()


func _ready() -> void:
	add_child(cannonball)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	objective_controller.add_designated_target_objective(&"designated", 2)
	objective_controller.register_target_for_objectives(normal_target)
	objective_controller.register_target_for_objectives(objective_target_a)
	objective_controller.register_target_for_objectives(objective_target_b)

	normal_target.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"designated") == 0, "Normal target should not count toward designated objective.", failures)

	objective_target_a.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"designated") == 1, "First Objective target should count once.", failures)
	_check(not objective_controller.is_objective_complete(&"designated"), "Objective should remain incomplete at 1/2.", failures)

	objective_target_a.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"designated") == 1, "Destroyed Objective target repeat should not count again.", failures)

	objective_target_b.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"designated") == 2, "Second Objective target should complete 2/2.", failures)
	_check(objective_controller.is_objective_complete(&"designated"), "Designated target objective should complete at required count.", failures)
	_check(objective_controller.is_bonus_trigger_ready(), "Completed designated objective should satisfy gameplay bonus trigger.", failures)

	if failures.is_empty():
		result_label.text = "DESIGNATED TARGET OBJECTIVE: PASS\nNormal target: ignored\nObjective target A: +1\nDestroyed repeat: ignored\nObjective target B: +1\nRequired 2: complete"
		print("PHASE 6 DESIGNATED TARGET OBJECTIVE TEST: PASS")
	else:
		result_label.text = "DESIGNATED TARGET OBJECTIVE: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
