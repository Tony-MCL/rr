extends CanvasLayer
class_name VerificationHud

@export var visible_during_development: bool = true

@onready var score_label: Label = $Panel/Margin/VBox/ScoreLabel
@onready var ammo_label: Label = $Panel/Margin/VBox/AmmoLabel
@onready var multiplier_label: Label = $Panel/Margin/VBox/MultiplierLabel
@onready var objective_label: Label = $Panel/Margin/VBox/ObjectiveLabel
@onready var state_label: Label = $Panel/Margin/VBox/StateLabel

var _current_multiplier: int = 1
var _objective_status: Dictionary = {}
var _bonus_triggered: bool = false
var _final_complete: bool = false


func _ready() -> void:
	visible = visible_during_development
	_refresh_multiplier()
	_refresh_objectives()
	_refresh_state()


func bind_controllers(
	score_controller: Node,
	ammo_controller: Node,
	objective_controller: ObjectiveController,
	ball_manager: Node
) -> void:
	if score_controller != null:
		if not score_controller.score_changed.is_connected(_on_score_changed):
			score_controller.score_changed.connect(_on_score_changed)
		if score_controller.has_signal("shot_multiplier_changed") and not score_controller.shot_multiplier_changed.is_connected(_on_shot_multiplier_changed):
			score_controller.shot_multiplier_changed.connect(_on_shot_multiplier_changed)
		_on_score_changed(int(score_controller.get_score()))

	if ammo_controller != null:
		if not ammo_controller.ammunition_changed.is_connected(_on_ammunition_changed):
			ammo_controller.ammunition_changed.connect(_on_ammunition_changed)
		_on_ammunition_changed(int(ammo_controller.get_ammunition()))

	if objective_controller != null:
		if not objective_controller.objective_progress_changed.is_connected(_on_objective_progress_changed):
			objective_controller.objective_progress_changed.connect(_on_objective_progress_changed)
		if not objective_controller.bonus_trigger_ready.is_connected(_on_bonus_trigger_ready):
			objective_controller.bonus_trigger_ready.connect(_on_bonus_trigger_ready)
		if not objective_controller.final_evaluation_changed.is_connected(_on_final_evaluation_changed):
			objective_controller.final_evaluation_changed.connect(_on_final_evaluation_changed)
		_final_complete = objective_controller.final_evaluate()
		_refresh_state()

	if ball_manager != null and ball_manager.has_signal("shot_completed"):
		if not ball_manager.shot_completed.is_connected(_on_shot_completed):
			ball_manager.shot_completed.connect(_on_shot_completed)


func _on_score_changed(current_score: int) -> void:
	score_label.text = "Score: %d" % current_score


func _on_ammunition_changed(current_ammunition: int) -> void:
	ammo_label.text = "Ammo: %d" % current_ammunition


func _on_shot_multiplier_changed(_shot_id: int, multiplier: int) -> void:
	_current_multiplier = maxi(multiplier, 1)
	_refresh_multiplier()


func _on_shot_completed(_shot_id: int) -> void:
	_current_multiplier = 1
	_refresh_multiplier()


func _on_objective_progress_changed(
	objective_id: StringName,
	current_value: int,
	required_value: int
) -> void:
	_objective_status[objective_id] = {
		"current": current_value,
		"required": required_value,
	}
	_refresh_objectives()


func _on_bonus_trigger_ready() -> void:
	_bonus_triggered = true
	_refresh_state()


func _on_final_evaluation_changed(all_mandatory_complete: bool) -> void:
	_final_complete = all_mandatory_complete
	_refresh_state()


func _refresh_multiplier() -> void:
	multiplier_label.text = "Shot multiplier: x%d" % _current_multiplier


func _refresh_objectives() -> void:
	if _objective_status.is_empty():
		objective_label.text = "Objectives: no progress reported"
		return

	var parts: Array[String] = []
	for objective_id in _objective_status:
		var state: Dictionary = _objective_status[objective_id]
		parts.append(
			"%s %d/%d" % [
				String(objective_id),
				int(state.get("current", 0)),
				int(state.get("required", 0)),
			]
		)
	objective_label.text = "Objectives: " + ", ".join(parts)


func _refresh_state() -> void:
	state_label.text = "Bonus trigger: %s | Final: %s" % [
		"YES" if _bonus_triggered else "NO",
		"PASS" if _final_complete else "PENDING",
	]
