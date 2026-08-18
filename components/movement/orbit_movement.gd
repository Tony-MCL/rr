class_name OrbitMovement
extends MovementBase

@export_category("Orbit Movement")
@export var radius: Vector2 = Vector2(120.0, 120.0)
@export_range(-720.0, 720.0, 1.0) var degrees_per_second: float = 90.0
@export_range(0.0, 1.0, 0.01) var start_phase: float = 0.0

var _phase: float = 0.0


func _ready() -> void:
	super._ready()
	_apply_start_phase()


func _process(delta: float) -> void:
	_phase = fposmod(_phase + (degrees_per_second / 360.0) * delta, 1.0)
	_apply_phase_position()


func reset_movement() -> void:
	super.reset_movement()
	_apply_start_phase()


func get_phase() -> float:
	return _phase


func _apply_start_phase() -> void:
	_phase = clampf(start_phase, 0.0, 1.0)
	_apply_phase_position()


func _apply_phase_position() -> void:
	var angle := TAU * _phase
	position = get_initial_position() + Vector2(cos(angle) * radius.x, sin(angle) * radius.y)
