extends Node

@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var result_label: Label = $ResultLabel

var progress_events: int = 0
var bonus_trigger_events: int = 0
var final_events: Array[bool] = []


func _ready() -> void:
	objective_controller.objective_progress_changed.connect(_on_progress_changed)
	objective_controller.bonus_trigger_ready.connect(_on_bonus_trigger_ready)
	objective_controller.final_evaluation_changed.connect(_on_final_evaluation_changed)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	objective_controller.add_objective(&"score", ObjectiveController.ObjectiveKind.SCORE, 100, true, true)
	objective_controller.add_objective(&"targets", ObjectiveController.ObjectiveKind.TARGET_COUNT, 2, true, false)

	_check(not objective_controller.final_evaluate(), "Objectives should begin incomplete.", failures)
	_check(not objective_controller.is_bonus_trigger_ready(), "Bonus trigger should begin false.", failures)

	objective_controller.set_objective_progress(&"score", 100)
	_check(objective_controller.is_objective_complete(&"score"), "Score objective should complete at threshold.", failures)
	_check(not objective_controller.is_bonus_trigger_ready(), "Score completion alone must not trigger bonus when a gameplay objective remains.", failures)

	objective_controller.increment_objective(&"targets")
	_check(objective_controller.get_objective_current_value(&"targets") == 1, "Target progress should increment to 1.", failures)
	_check(not objective_controller.is_bonus_trigger_ready(), "Partial gameplay objective must not trigger bonus.", failures)

	objective_controller.increment_objective(&"targets")
	_check(objective_controller.is_objective_complete(&"targets"), "Target objective should complete at 2.", failures)
	_check(objective_controller.is_bonus_trigger_ready(), "Completed mandatory gameplay objectives should make bonus trigger ready.", failures)
	_check(objective_controller.final_evaluate(), "All mandatory objectives complete should pass final evaluation.", failures)
	_check(bonus_trigger_events == 1, "Bonus trigger should emit exactly once.", failures)
	_check(progress_events == 3, "Expected exactly three progress events.", failures)
	_check(final_events == [true], "Final evaluation signal should change to true once.", failures)

	objective_controller.increment_objective(&"targets")
	_check(bonus_trigger_events == 1, "Completed objective must not emit bonus trigger repeatedly.", failures)
	_check(progress_events == 3, "Clamped completed objective must not emit duplicate progress.", failures)

	if failures.is_empty():
		result_label.text = "OBJECTIVE CONTROLLER: PASS\nRegistry/state: working\nProgress signals: working\nBonus trigger: once\nFinal evaluation: separate\nNo concrete objective rules yet"
		print("PHASE 6 OBJECTIVE CONTROLLER TEST: PASS")
	else:
		result_label.text = "OBJECTIVE CONTROLLER: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _on_progress_changed(_objective_id: StringName, _current_value: int, _required_value: int) -> void:
	progress_events += 1


func _on_bonus_trigger_ready() -> void:
	bonus_trigger_events += 1


func _on_final_evaluation_changed(all_mandatory_complete: bool) -> void:
	final_events.append(all_mandatory_complete)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
