extends Node
class_name ObjectiveController

signal objective_progress_changed(objective_id: StringName, current_value: int, required_value: int)
signal bonus_trigger_ready()
signal final_evaluation_changed(all_mandatory_complete: bool)

enum ObjectiveKind {
	SCORE,
	TARGET_COUNT,
	DESIGNATED_TARGETS,
	CLEAR_ALL,
}

var _objectives: Dictionary = {}
var _bonus_trigger_emitted: bool = false
var _last_final_evaluation: bool = false
var _score_controller: Node = null
var _counted_destroyed_targets: Dictionary = {}
var _registered_clear_all_targets: Dictionary = {}
var _destroyed_clear_all_targets: Dictionary = {}


func clear_objectives() -> void:
	_objectives.clear()
	_bonus_trigger_emitted = false
	_last_final_evaluation = false
	_counted_destroyed_targets.clear()
	_registered_clear_all_targets.clear()
	_destroyed_clear_all_targets.clear()


func bind_score_controller(score_controller: Node) -> void:
	if _score_controller != null and _score_controller.score_changed.is_connected(_on_score_changed):
		_score_controller.score_changed.disconnect(_on_score_changed)

	_score_controller = score_controller
	if _score_controller == null:
		return

	if not _score_controller.score_changed.is_connected(_on_score_changed):
		_score_controller.score_changed.connect(_on_score_changed)
	_on_score_changed(int(_score_controller.get_score()))


func add_score_objective(
	objective_id: StringName,
	required_score: int,
	mandatory: bool = true
) -> void:
	add_objective(objective_id, ObjectiveKind.SCORE, required_score, mandatory, true)
	if _score_controller != null:
		set_objective_progress(objective_id, int(_score_controller.get_score()))


func add_target_count_objective(
	objective_id: StringName,
	required_targets: int,
	mandatory: bool = true
) -> void:
	add_objective(objective_id, ObjectiveKind.TARGET_COUNT, required_targets, mandatory, false)


func add_designated_target_objective(
	objective_id: StringName,
	required_targets: int,
	mandatory: bool = true
) -> void:
	add_objective(objective_id, ObjectiveKind.DESIGNATED_TARGETS, required_targets, mandatory, false)


func add_clear_all_objective(
	objective_id: StringName,
	mandatory: bool = true
) -> void:
	if objective_id == &"":
		return
	_objectives[objective_id] = {
		"kind": ObjectiveKind.CLEAR_ALL,
		"required_value": _registered_clear_all_targets.size(),
		"current_value": _destroyed_clear_all_targets.size(),
		"mandatory": mandatory,
		"is_score_objective": false,
	}
	_emit_final_evaluation_if_changed()


func register_target_for_objectives(target: TargetBody) -> void:
	if target == null or target.is_solid():
		return

	var target_key := target.get_instance_id()
	_registered_clear_all_targets[target_key] = true
	_sync_clear_all_objectives()

	if not target.hit_requirement_reached.is_connected(_on_target_destroyed):
		target.hit_requirement_reached.connect(_on_target_destroyed)


func add_objective(
	objective_id: StringName,
	kind: ObjectiveKind,
	required_value: int,
	mandatory: bool = true,
	is_score_objective: bool = false
) -> void:
	if objective_id == &"" or required_value <= 0:
		return

	_objectives[objective_id] = {
		"kind": kind,
		"required_value": required_value,
		"current_value": 0,
		"mandatory": mandatory,
		"is_score_objective": is_score_objective,
	}
	_emit_final_evaluation_if_changed()


func set_objective_progress(objective_id: StringName, current_value: int) -> void:
	if not _objectives.has(objective_id):
		return

	var state: Dictionary = _objectives[objective_id]
	var required_value: int = int(state.get("required_value", 0))
	var clamped_value := clampi(current_value, 0, required_value)
	if int(state.get("current_value", 0)) == clamped_value:
		return

	state["current_value"] = clamped_value
	_objectives[objective_id] = state
	objective_progress_changed.emit(objective_id, clamped_value, required_value)
	_evaluate_bonus_trigger()
	_emit_final_evaluation_if_changed()


func increment_objective(objective_id: StringName, amount: int = 1) -> void:
	if amount <= 0 or not _objectives.has(objective_id):
		return
	var current_value := get_objective_current_value(objective_id)
	set_objective_progress(objective_id, current_value + amount)


func get_objective_current_value(objective_id: StringName) -> int:
	if not _objectives.has(objective_id):
		return 0
	var state: Dictionary = _objectives[objective_id]
	return int(state.get("current_value", 0))


func get_objective_required_value(objective_id: StringName) -> int:
	if not _objectives.has(objective_id):
		return 0
	var state: Dictionary = _objectives[objective_id]
	return int(state.get("required_value", 0))


func is_objective_complete(objective_id: StringName) -> bool:
	if not _objectives.has(objective_id):
		return false
	var required_value := get_objective_required_value(objective_id)
	if required_value <= 0:
		return false
	return get_objective_current_value(objective_id) >= required_value


func are_all_mandatory_objectives_complete() -> bool:
	var has_mandatory := false
	for objective_id in _objectives:
		var state: Dictionary = _objectives[objective_id]
		if not bool(state.get("mandatory", true)):
			continue
		has_mandatory = true
		if not is_objective_complete(objective_id):
			return false
	return has_mandatory


func are_all_mandatory_non_score_objectives_complete() -> bool:
	var has_non_score_mandatory := false
	for objective_id in _objectives:
		var state: Dictionary = _objectives[objective_id]
		if not bool(state.get("mandatory", true)) or bool(state.get("is_score_objective", false)):
			continue
		has_non_score_mandatory = true
		if not is_objective_complete(objective_id):
			return false
	return has_non_score_mandatory


func has_mandatory_non_score_objective() -> bool:
	for objective_id in _objectives:
		var state: Dictionary = _objectives[objective_id]
		if bool(state.get("mandatory", true)) and not bool(state.get("is_score_objective", false)):
			return true
	return false


func has_mandatory_score_objective() -> bool:
	for objective_id in _objectives:
		var state: Dictionary = _objectives[objective_id]
		if bool(state.get("mandatory", true)) and bool(state.get("is_score_objective", false)):
			return true
	return false


func is_bonus_trigger_ready() -> bool:
	if has_mandatory_non_score_objective():
		return are_all_mandatory_non_score_objectives_complete()
	if has_mandatory_score_objective():
		return are_all_mandatory_objectives_complete()
	return false


func final_evaluate() -> bool:
	return are_all_mandatory_objectives_complete()


func _on_score_changed(current_score: int) -> void:
	for objective_id in _objectives:
		var state: Dictionary = _objectives[objective_id]
		if int(state.get("kind", -1)) != ObjectiveKind.SCORE:
			continue
		set_objective_progress(objective_id, current_score)


func _on_target_destroyed(target: TargetBody) -> void:
	if target == null or target.is_solid():
		return

	var target_key := target.get_instance_id()
	if _registered_clear_all_targets.has(target_key):
		_destroyed_clear_all_targets[target_key] = true
		_sync_clear_all_objectives()

	if _counted_destroyed_targets.has(target_key):
		return
	_counted_destroyed_targets[target_key] = true

	for objective_id in _objectives:
		var state: Dictionary = _objectives[objective_id]
		var kind := int(state.get("kind", -1))
		if kind == ObjectiveKind.TARGET_COUNT:
			increment_objective(objective_id, 1)
		elif kind == ObjectiveKind.DESIGNATED_TARGETS and target.is_objective_target():
			increment_objective(objective_id, 1)


func _sync_clear_all_objectives() -> void:
	var required_value := _registered_clear_all_targets.size()
	var current_value := _destroyed_clear_all_targets.size()

	for objective_id in _objectives:
		var state: Dictionary = _objectives[objective_id]
		if int(state.get("kind", -1)) != ObjectiveKind.CLEAR_ALL:
			continue

		var changed := int(state.get("required_value", 0)) != required_value or int(state.get("current_value", 0)) != current_value
		state["required_value"] = required_value
		state["current_value"] = current_value
		_objectives[objective_id] = state
		if changed:
			objective_progress_changed.emit(objective_id, current_value, required_value)

	_evaluate_bonus_trigger()
	_emit_final_evaluation_if_changed()


func _evaluate_bonus_trigger() -> void:
	if _bonus_trigger_emitted or not is_bonus_trigger_ready():
		return
	_bonus_trigger_emitted = true
	bonus_trigger_ready.emit()


func _emit_final_evaluation_if_changed() -> void:
	var current_evaluation := final_evaluate()
	if current_evaluation == _last_final_evaluation:
		return
	_last_final_evaluation = current_evaluation
	final_evaluation_changed.emit(current_evaluation)
