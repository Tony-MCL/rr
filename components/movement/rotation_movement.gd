class_name RotationMovement
extends MovementBase

@export_category("Rotation Movement")
@export_range(-720.0, 720.0, 1.0) var degrees_per_second: float = 90.0
@export_range(0.0, 1.0, 0.01) var start_phase: float = 0.0

var _phase: float = 0.0


func _ready() -> void:
	super._ready()
	_apply_start_phase()


func _process(delta: float) -> void:
	rotation += deg_to_rad(degrees_per_second) * delta
	_phase = fposmod((rotation - get_initial_rotation()) / TAU, 1.0)


func reset_movement() -> void:
	super.reset_movement()
	_apply_start_phase()


func get_phase() -> float:
	return _phase


func _apply_start_phase() -> void:
	_phase = clampf(start_phase, 0.0, 1.0)
	rotation = get_initial_rotation() + TAU * _phase
