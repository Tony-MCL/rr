class_name SlideMovement
extends MovementBase

@export_category("Slide Movement")
@export var travel_offset: Vector2 = Vector2(200.0, 0.0)
@export_range(1.0, 2000.0, 1.0) var speed: float = 120.0
@export_range(0.0, 1.0, 0.01) var start_phase: float = 0.0

var _phase: float = 0.0
var _direction: float = 1.0


func _ready() -> void:
	super._ready()
	_apply_start_phase()


func _process(delta: float) -> void:
	var distance := travel_offset.length()
	if distance <= 0.001 or speed <= 0.0:
		return

	_phase += _direction * (speed / distance) * delta

	if _phase >= 1.0:
		_phase = 1.0
		_direction = -1.0
	elif _phase <= 0.0:
		_phase = 0.0
		_direction = 1.0

	position = get_initial_position() + travel_offset * _phase


func reset_movement() -> void:
	super.reset_movement()
	_direction = 1.0
	_apply_start_phase()


func get_phase() -> float:
	return _phase


func get_direction() -> float:
	return _direction


func _apply_start_phase() -> void:
	_phase = clampf(start_phase, 0.0, 1.0)
	position = get_initial_position() + travel_offset * _phase
