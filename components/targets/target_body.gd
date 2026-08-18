extends StaticBody2D
class_name TargetBody

signal target_hit(target: TargetBody, current_hits: int, required_hits: int)
signal hit_requirement_reached(target: TargetBody)
signal state_changed(target: TargetBody, previous_state: TargetState, new_state: TargetState)

enum PhysicalRole {
	TARGET,
	SOLID,
}

enum TargetState {
	ACTIVE,
	DAMAGED,
	DESTROYED_DELAY,
	REMOVED,
}

@export_category("Physical Role")
@export var physical_role: PhysicalRole = PhysicalRole.TARGET

@export_category("Hit Configuration")
@export_enum("One Hit:1", "Three Hits:3") var hits_required: int = 1

@export_category("Removal")
@export_range(0.0, 5.0, 0.05) var removal_delay_seconds: float = 0.35

var _valid_hits: int = 0
var _state: TargetState = TargetState.ACTIVE


func is_target() -> bool:
	return physical_role == PhysicalRole.TARGET


func is_solid() -> bool:
	return physical_role == PhysicalRole.SOLID


func get_valid_hits() -> int:
	return _valid_hits


func get_target_state() -> TargetState:
	return _state


func is_hit_requirement_reached() -> bool:
	return is_target() and _valid_hits >= hits_required


func register_hit(_cannonball: RigidBody2D) -> bool:
	if not is_target():
		return false

	if _state == TargetState.DESTROYED_DELAY or _state == TargetState.REMOVED:
		return false

	_valid_hits += 1
	target_hit.emit(self, _valid_hits, hits_required)
	print("TARGET HIT: %s %d/%d" % [name, _valid_hits, hits_required])

	if _valid_hits >= hits_required:
		hit_requirement_reached.emit(self)
		print("TARGET HIT REQUIREMENT REACHED: %s" % name)
		_enter_destroyed_delay()
	elif hits_required > 1:
		_set_state(TargetState.DAMAGED)

	return true


func _enter_destroyed_delay() -> void:
	_set_state(TargetState.DESTROYED_DELAY)
	_apply_state_visual()

	if removal_delay_seconds <= 0.0:
		_remove_target()
		return

	var timer := get_tree().create_timer(removal_delay_seconds)
	timer.timeout.connect(_remove_target)


func _remove_target() -> void:
	if _state == TargetState.REMOVED:
		return

	_set_state(TargetState.REMOVED)
	queue_free()


func _set_state(new_state: TargetState) -> void:
	if _state == new_state:
		return

	var previous_state := _state
	_state = new_state
	state_changed.emit(self, previous_state, new_state)
	print("TARGET STATE: %s %s -> %s" % [name, TargetState.keys()[previous_state], TargetState.keys()[new_state]])
	_apply_state_visual()


func _apply_state_visual() -> void:
	var visual := get_node_or_null("Visual") as CanvasItem
	if visual == null:
		return

	match _state:
		TargetState.ACTIVE:
			visual.modulate = Color(1.0, 1.0, 1.0, 1.0)
		TargetState.DAMAGED:
			visual.modulate = Color(1.0, 0.72, 0.72, 1.0)
		TargetState.DESTROYED_DELAY:
			visual.modulate = Color(1.0, 1.0, 1.0, 0.35)
		TargetState.REMOVED:
			visual.visible = false
