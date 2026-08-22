extends Node

@onready var score_controller: Node = $ScoreController
@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var objective_target: TargetBody = $ObjectiveTarget
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()
var bonus_trigger_count: int = 0
var final_evaluation_events: Array[bool] = []


func _ready() -> void:
	add_child(cannonball)
	objective_controller.bind_score_controller(score_controller)
	objective_controller.bonus_trigger_ready.connect(_on_bonus_trigger_ready)
	objective_controller.final_evaluation_changed.connect(_on_final_evaluation_changed)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	objective_controller.add_score_objective(&"score", 1000, true)
	objective_controller.add_designated_target_objective(&"objective_targets", 1, true)
	objective_controller.register_target_for_objectives(objective_target)

	_check(not objective_controller.final_evaluate(), "Final evaluation should start false.", failures)
	_check(bonus_trigger_count == 0, "Bonus should not trigger before gameplay objective completion.", failures)

	objective_target.register_hit(cannonball)
	_check(bonus_trigger_count == 1, "Completing mandatory non-score objective should trigger bonus once.", failures)
	_check(objective_controller.is_bonus_trigger_ready(), "Bonus trigger state should be ready after gameplay objective completion.", failures)
	_check(not objective_controller.final_evaluate(), "Final evaluation must remain false while mandatory score is pending.", failures)

	score_controller.add_score(1000)
	_check(objective_controller.final_evaluate(), "Final evaluation should become true after pending score is reached.", failures)
	_check(bonus_trigger_count == 1, "Later final completion must not emit bonus trigger again.", failures)
	_check(final_evaluation_events.has(true), "Final evaluation change should report true independently of bonus trigger.", failures)

	score_controller.add_score(500)
	_check(bonus_trigger_count == 1, "Additional score after completion must not re-trigger bonus.", failures)
	_check(objective_controller.final_evaluate(), "Final evaluation should remain true after exceeding score threshold.", failures)

	if failures.is_empty():
		result_label.text = "BONUS TRIGGER / FINAL EVALUATION: PASS\nNon-score complete: bonus trigger\nScore still pending: final false\nLater score complete: final true\nBonus trigger remains once\nSystems remain separate"
		print("PHASE 6 BONUS TRIGGER FINAL EVALUATION TEST: PASS")
	else:
		result_label.text = "BONUS TRIGGER / FINAL EVALUATION: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _on_bonus_trigger_ready() -> void:
	bonus_trigger_count += 1


func _on_final_evaluation_changed(all_mandatory_complete: bool) -> void:
	final_evaluation_events.append(all_mandatory_complete)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
