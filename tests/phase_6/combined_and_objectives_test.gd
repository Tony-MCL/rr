extends Node

@onready var score_controller: Node = $ScoreController
@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var target_a: TargetBody = $TargetA
@onready var target_b: TargetBody = $TargetB
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()
var bonus_trigger_count: int = 0


func _ready() -> void:
	add_child(cannonball)
	objective_controller.bind_score_controller(score_controller)
	objective_controller.bonus_trigger_ready.connect(_on_bonus_trigger_ready)
	objective_controller.add_score_objective(&"score", 100, true)
	objective_controller.add_target_count_objective(&"targets", 2, true)
	objective_controller.register_target_for_objectives(target_a)
	objective_controller.register_target_for_objectives(target_b)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	score_controller.add_score(100)
	_check(objective_controller.is_objective_complete(&"score"), "Score objective should complete at threshold.", failures)
	_check(not objective_controller.is_objective_complete(&"targets"), "Target objective should still be pending.", failures)
	_check(not objective_controller.final_evaluate(), "Final evaluation must remain false while one mandatory objective is pending.", failures)
	_check(bonus_trigger_count == 0, "Score completion alone must not trigger bonus when a mandatory non-score objective exists.", failures)

	target_a.register_hit(cannonball)
	_check(objective_controller.get_objective_current_value(&"targets") == 1, "First destroyed target should advance target objective to 1/2.", failures)
	_check(not objective_controller.final_evaluate(), "AND chain must remain incomplete at 1/2 targets.", failures)
	_check(bonus_trigger_count == 0, "Bonus must not trigger before all mandatory non-score objectives complete.", failures)

	target_b.register_hit(cannonball)
	_check(objective_controller.is_objective_complete(&"targets"), "Second destroyed target should complete target objective.", failures)
	_check(bonus_trigger_count == 1, "Completing mandatory non-score objectives should trigger bonus exactly once.", failures)
	_check(objective_controller.final_evaluate(), "Final evaluation should be true because score and target objectives are both complete.", failures)

	objective_controller.clear_objectives()
	bonus_trigger_count = 0
	objective_controller.add_score_objective(&"score_pending", 200, true)
	objective_controller.add_objective(&"manual_non_score", ObjectiveController.ObjectiveKind.TARGET_COUNT, 1, true, false)
	objective_controller.set_objective_progress(&"manual_non_score", 1)
	_check(bonus_trigger_count == 1, "Non-score completion should trigger bonus even when score is still pending.", failures)
	_check(not objective_controller.final_evaluate(), "Final evaluation must remain false while mandatory score is pending.", failures)

	if failures.is_empty():
		result_label.text = "COMBINED AND OBJECTIVES: PASS\nAll mandatory objectives use AND\nScore alone: no bonus when non-score pending\nNon-score completion: bonus trigger\nFinal evaluation: all mandatory required\nScore may remain pending after bonus trigger"
		print("PHASE 6 COMBINED AND OBJECTIVES TEST: PASS")
	else:
		result_label.text = "COMBINED AND OBJECTIVES: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _on_bonus_trigger_ready() -> void:
	bonus_trigger_count += 1


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
