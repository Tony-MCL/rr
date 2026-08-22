extends Node

@onready var score_controller: Node = $ScoreController
@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var result_label: Label = $ResultLabel

var bonus_trigger_count: int = 0
var final_states: Array[bool] = []


func _ready() -> void:
	objective_controller.bind_score_controller(score_controller)
	objective_controller.bonus_trigger_ready.connect(_on_bonus_trigger_ready)
	objective_controller.final_evaluation_changed.connect(_on_final_evaluation_changed)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	objective_controller.add_score_objective(&"score_only", 100, true)
	_check(objective_controller.get_objective_current_value(&"score_only") == 0, "Score objective should start at 0.", failures)
	_check(not objective_controller.is_objective_complete(&"score_only"), "Score objective must begin incomplete.", failures)

	score_controller.add_score(60)
	_check(objective_controller.get_objective_current_value(&"score_only") == 60, "Score objective should follow ScoreController progress.", failures)
	_check(bonus_trigger_count == 0, "Score-only objective must not trigger bonus below threshold.", failures)

	score_controller.add_score(40)
	_check(objective_controller.is_objective_complete(&"score_only"), "Score objective should complete at threshold.", failures)
	_check(bonus_trigger_count == 1, "Score-only objective should trigger bonus exactly once at threshold.", failures)
	_check(objective_controller.final_evaluate(), "Score-only final evaluation should pass once threshold is reached.", failures)

	objective_controller.clear_objectives()
	score_controller.reset_score()
	bonus_trigger_count = 0
	objective_controller.add_score_objective(&"combined_score", 100, true)
	objective_controller.add_objective(&"other_required", ObjectiveController.ObjectiveKind.TARGET_COUNT, 1, true, false)

	score_controller.add_score(100)
	_check(objective_controller.is_objective_complete(&"combined_score"), "Combined score part should complete at threshold.", failures)
	_check(not objective_controller.is_bonus_trigger_ready(), "Combined level must wait for mandatory non-score objective.", failures)
	_check(bonus_trigger_count == 0, "Score alone must not trigger combined bonus phase.", failures)

	objective_controller.set_objective_progress(&"other_required", 1)
	_check(objective_controller.is_bonus_trigger_ready(), "Combined bonus trigger should become ready when non-score objective completes.", failures)
	_check(bonus_trigger_count == 1, "Combined objective should trigger bonus once when non-score requirements complete.", failures)
	_check(objective_controller.final_evaluate(), "Combined final evaluation should pass when both parts are complete.", failures)

	if failures.is_empty():
		result_label.text = "SCORE OBJECTIVE: PASS\nAutomatic score tracking\nScore-only trigger at threshold\nCombined level waits for non-score requirement\nFinal evaluation uses all mandatory objectives"
		print("PHASE 6 SCORE OBJECTIVE TEST: PASS")
	else:
		result_label.text = "SCORE OBJECTIVE: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _on_bonus_trigger_ready() -> void:
	bonus_trigger_count += 1


func _on_final_evaluation_changed(state: bool) -> void:
	final_states.append(state)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
