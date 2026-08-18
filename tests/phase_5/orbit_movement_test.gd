extends Node2D

@onready var movement: OrbitMovement = $OrbitMovement
@onready var status_label: Label = $StatusLabel

var _center: Vector2
var _initial_orbit_position: Vector2
var _completed: bool = false


func _ready() -> void:
	_center = movement.get_initial_position()
	_initial_orbit_position = movement.global_position
	await get_tree().create_timer(2.2).timeout
	_run_test()


func _run_test() -> void:
	if _completed:
		return
	_completed = true

	var moved: bool = movement.global_position.distance_to(_initial_orbit_position) > 30.0
	var offset: Vector2 = movement.position - _center
	var radius_preserved: bool = absf(offset.length() - 120.0) < 1.0
	var phase_progressed: bool = movement.get_phase() > 0.45 and movement.get_phase() < 0.65
	var rotation_unchanged: bool = is_equal_approx(movement.rotation, movement.get_initial_rotation())

	movement.reset_movement()
	var expected_reset: Vector2 = _center + Vector2(cos(TAU * movement.start_phase) * movement.radius.x, sin(TAU * movement.start_phase) * movement.radius.y)
	var reset_ok: bool = movement.position.distance_to(expected_reset) < 0.1

	var passed: bool = moved and radius_preserved and phase_progressed and rotation_unchanged and reset_ok
	status_label.text = "ORBIT MOVEMENT TEST: %s\nMoved around center: %s\nRadius preserved: %s\nPhase progressed: %s\nOwn rotation unchanged: %s\nReset phase: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if moved else "NO",
		"YES" if radius_preserved else "NO",
		"YES" if phase_progressed else "NO",
		"YES" if rotation_unchanged else "NO",
		"YES" if reset_ok else "NO",
	]
