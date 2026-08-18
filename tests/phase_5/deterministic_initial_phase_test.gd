extends Node2D

@onready var static_movement: StaticMovement = $StaticMovement
@onready var slide_movement: SlideMovement = $SlideMovement
@onready var rotation_movement: RotationMovement = $RotationMovement
@onready var orbit_movement: OrbitMovement = $OrbitMovement
@onready var status_label: Label = $StatusLabel


func _ready() -> void:
	await get_tree().process_frame
	_run_test()


func _run_test() -> void:
	var static_start: Transform2D = static_movement.transform
	var slide_start: Transform2D = slide_movement.transform
	var rotation_start: Transform2D = rotation_movement.transform
	var orbit_start: Transform2D = orbit_movement.transform

	await get_tree().create_timer(0.75).timeout

	static_movement.position += Vector2(37.0, 19.0)
	static_movement.rotation += 0.7

	static_movement.reset_movement()
	slide_movement.reset_movement()
	rotation_movement.reset_movement()
	orbit_movement.reset_movement()

	var static_reset: bool = _transform_matches(static_movement.transform, static_start)
	var slide_reset: bool = _transform_matches(slide_movement.transform, slide_start)
	var rotation_reset: bool = _transform_matches(rotation_movement.transform, rotation_start)
	var orbit_reset: bool = _transform_matches(orbit_movement.transform, orbit_start)
	var passed: bool = static_reset and slide_reset and rotation_reset and orbit_reset

	status_label.text = "DETERMINISTIC INITIAL PHASE TEST: %s\nStatic identical: %s\nSlide identical: %s\nRotation identical: %s\nOrbit identical: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if static_reset else "NO",
		"YES" if slide_reset else "NO",
		"YES" if rotation_reset else "NO",
		"YES" if orbit_reset else "NO",
	]


func _transform_matches(a: Transform2D, b: Transform2D) -> bool:
	return a.origin.distance_to(b.origin) < 0.1 and absf(a.get_rotation() - b.get_rotation()) < 0.001
