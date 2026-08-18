extends Node2D

@onready var movement: RotationMovement = $RotationMovement
@onready var status_label: Label = $StatusLabel

var _initial_marker_position: Vector2
var _completed: bool = false


func _ready() -> void:
	_initial_marker_position = $RotationMovement/Marker.global_position
	await get_tree().create_timer(2.2).timeout
	_run_test()


func _run_test() -> void:
	if _completed:
		return
	_completed = true

	var marker_moved := $RotationMovement/Marker.global_position.distance_to(_initial_marker_position) > 20.0
	var radius_preserved := is_equal_approx($RotationMovement/Marker.position.length(), 70.0)
	var rotated := absf(rad_to_deg(movement.rotation - movement.get_initial_rotation())) > 120.0

	movement.reset_movement()
	var reset_ok := is_equal_approx(movement.rotation, movement.get_initial_rotation() + TAU * movement.start_phase)

	var passed := marker_moved and radius_preserved and rotated and reset_ok
	status_label.text = "ROTATION MOVEMENT TEST: %s\nMarker moved: %s\nRadius preserved: %s\nRotation progressed: %s\nReset phase: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if marker_moved else "NO",
		"YES" if radius_preserved else "NO",
		"YES" if rotated else "NO",
		"YES" if reset_ok else "NO",
	]
