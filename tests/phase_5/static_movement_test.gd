extends Node2D

@onready var movement: StaticMovement = $StaticMovement
@onready var status_label: Label = $StatusLabel

var _start_position: Vector2
var _start_rotation: float


func _ready() -> void:
	_start_position = movement.position
	_start_rotation = movement.rotation
	await get_tree().create_timer(0.5).timeout

	var stayed_position := movement.position.is_equal_approx(_start_position)
	var stayed_rotation := is_equal_approx(movement.rotation, _start_rotation)

	movement.position += Vector2(40.0, 25.0)
	movement.rotation += deg_to_rad(30.0)
	movement.reset_movement()

	var reset_position := movement.position.is_equal_approx(_start_position)
	var reset_rotation := is_equal_approx(movement.rotation, _start_rotation)
	var passed := stayed_position and stayed_rotation and reset_position and reset_rotation

	status_label.text = "STATIC MOVEMENT TEST: %s\nStayed fixed: %s\nReset position: %s\nReset rotation: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if stayed_position and stayed_rotation else "NO",
		"YES" if reset_position else "NO",
		"YES" if reset_rotation else "NO",
	]
