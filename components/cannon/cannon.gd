extends Node2D

const CANNONBALL_SCENE: PackedScene = preload("res://components/balls/cannonball/cannonball.tscn")

@export_category("Aiming")
@export_range(1.0, 89.0, 1.0) var angle_limit_degrees: float = 85.0
@export_range(0.01, 1.0, 0.01) var drag_sensitivity: float = 0.20
@export_range(1.0, 50.0, 1.0) var tap_drag_threshold: float = 8.0

@export_category("Firing")
@export_range(100.0, 3000.0, 10.0) var shoot_speed: float = 1450.0

@onready var barrel: Node2D = $Barrel
@onready var muzzle: Marker2D = $Barrel/Muzzle

var _angle_degrees: float = 0.0
var _pointer_pressed: bool = false
var _pointer_travel: float = 0.0


func _ready() -> void:
	_apply_angle()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_pointer_button(event.pressed)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventScreenDrag:
		_handle_pointer_drag(event.relative)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_pointer_button(event.pressed)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion and _pointer_pressed:
		_handle_pointer_drag(event.relative)
		get_viewport().set_input_as_handled()


func _handle_pointer_button(pressed: bool) -> void:
	if pressed:
		_pointer_pressed = true
		_pointer_travel = 0.0
		return

	if not _pointer_pressed:
		return

	_pointer_pressed = false
	if _pointer_travel <= tap_drag_threshold:
		_fire()


func _handle_pointer_drag(relative_motion: Vector2) -> void:
	if not _pointer_pressed:
		return

	_pointer_travel += relative_motion.length()
	_rotate_from_drag(relative_motion.x)


func _rotate_from_drag(horizontal_delta: float) -> void:
	_angle_degrees = clampf(
		_angle_degrees - horizontal_delta * drag_sensitivity,
		-angle_limit_degrees,
		angle_limit_degrees
	)
	_apply_angle()


func _apply_angle() -> void:
	barrel.rotation_degrees = _angle_degrees


func _fire() -> void:
	var cannonball := CANNONBALL_SCENE.instantiate() as RigidBody2D
	if cannonball == null:
		push_error("Cannonball scene did not instantiate as RigidBody2D.")
		return

	var scene_root := get_tree().current_scene
	if scene_root == null:
		push_error("Cannot fire cannonball without a current scene.")
		cannonball.queue_free()
		return

	scene_root.add_child(cannonball)
	cannonball.global_position = muzzle.global_position
	cannonball.linear_velocity = barrel.global_transform.y.normalized() * shoot_speed
