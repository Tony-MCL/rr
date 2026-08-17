extends Node2D

@export_category("Aiming")
@export_range(1.0, 89.0, 1.0) var angle_limit_degrees: float = 85.0
@export_range(0.01, 1.0, 0.01) var drag_sensitivity: float = 0.20

@onready var barrel: Node2D = $Barrel

var _angle_degrees: float = 0.0


func _ready() -> void:
	_apply_angle()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		_rotate_from_drag(event.relative.x)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		_rotate_from_drag(event.relative.x)
		get_viewport().set_input_as_handled()


func _rotate_from_drag(horizontal_delta: float) -> void:
	_angle_degrees = clampf(
		_angle_degrees + horizontal_delta * drag_sensitivity,
		-angle_limit_degrees,
		angle_limit_degrees
	)
	_apply_angle()


func _apply_angle() -> void:
	barrel.rotation_degrees = _angle_degrees
