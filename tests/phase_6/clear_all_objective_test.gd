extends Node

@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var target_a: TargetBody = $TargetA
@onready var target_b: TargetBody = $TargetB
@onready var objective_target: TargetBody = $ObjectiveTarget
@onready var solid: TargetBody = $Solid
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()
var bonus_trigger_count: int = 0


func _ready() -> void:
	add_child(cannonball)
	objective_controller.bonus_trigger_ready.connect(_on_bonus_trigger_ready)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	objective_controller.register_target_for_objectives(target_a)
	objective_controller.register_target_for_objectives(target_b)
	objective_controller.register_target_for_objectives(objective_target)
	objective_controller.register_target_for_objectives(solid)
	objective_controller.add_clear_all_objective(&"clear_all")

	_check(objective_controller.get_objective_required_value(&"clear_all") == 3, "Clear-all should require all three non-solid targets.", failures)
	_check(objective_controller.get_objective_current_value(&"clear_all") == 0, "Clear-all should start at 0/3.", failures)
	_check(not objective_controller.is_objective_complete(&"clear_all"), "Clear-all should not start complete.", failures)

	target_a.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"clear_all") == 1, "First destroyed target should set clear-all progress to 1/3.", failures)

	target_b.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"clear_all") == 2, "Second destroyed target should set clear-all progress to 2/3.", failures)
	_check(bonus_trigger_count == 0, "Clear-all should not trigger before the final target.", failures)

	solid.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"clear_all") == 2, "Solid should never count toward clear-all.", failures)

	objective_target.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"clear_all") == 3, "Final non-solid target should complete clear-all.", failures)
	_check(objective_controller.is_objective_complete(&"clear_all"), "Clear-all should be complete at 3/3.", failures)
	_check(bonus_trigger_count == 1, "Clear-all should emit bonus trigger exactly once.", failures)

	if failures.is_empty():
		result_label.text = "CLEAR-ALL OBJECTIVE: PASS\nNormal targets: counted\nObjective targets: counted\nSolids: excluded\nFinal target: completes 3/3\nBonus trigger: once"
		print("PHASE 6 CLEAR-ALL OBJECTIVE TEST: PASS")
	else:
		result_label.text = "CLEAR-ALL OBJECTIVE: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _on_bonus_trigger_ready() -> void:
	bonus_trigger_count += 1


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
