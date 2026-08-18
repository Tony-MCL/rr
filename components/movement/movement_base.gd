class_name MovementBase
extends Node2D

var _initial_position: Vector2
var _initial_rotation: float


func _ready() -> void:
	capture_initial_transform()


func capture_initial_transform() -> void:
	_initial_position = position
	_initial_rotation = rotation


func reset_movement() -> void:
	position = _initial_position
	rotation = _initial_rotation


func get_initial_position() -> Vector2:
	return _initial_position


func get_initial_rotation() -> float:
	return _initial_rotation
