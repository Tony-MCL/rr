extends Area2D

signal ball_caught(ball: RigidBody2D)

@export_category("Movement")
@export_range(0.0, 500.0, 10.0) var movement_half_width: float = 320.0
@export_range(0.0, 1000.0, 10.0) var movement_speed: float = 220.0
@export_enum("Left:-1", "Right:1") var starting_direction: int = 1

var _origin_x: float = 0.0
var _direction: float = 1.0


func _ready() -> void:
	_origin_x = position.x
	_direction = 1.0 if starting_direction >= 0 else -1.0
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if movement_half_width <= 0.0 or movement_speed <= 0.0:
		return

	position.x += _direction * movement_speed * delta

	var left_limit := _origin_x - movement_half_width
	var right_limit := _origin_x + movement_half_width

	if position.x <= left_limit:
		position.x = left_limit
		_direction = 1.0
	elif position.x >= right_limit:
		position.x = right_limit
		_direction = -1.0


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("cannonball"):
		return

	var cannonball := body as RigidBody2D
	if cannonball == null:
		return

	if cannonball.has_meta("catcher_processed"):
		return

	cannonball.set_meta("catcher_processed", true)
	ball_caught.emit(cannonball)
	print("BALL CAUGHT")
	cannonball.call_deferred("queue_free")
