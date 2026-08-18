extends Node

@export var spawn_position: Vector2 = Vector2(540, 960)
@export var spawn_direction: Vector2 = Vector2(0.0, 1.0)
@export_range(100.0, 3000.0, 10.0) var spawn_speed: float = 900.0

@onready var ball_manager: Node = $"../BallManager"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_B:
		ball_manager.spawn_bonus_ball(spawn_position, spawn_direction, spawn_speed)
		get_viewport().set_input_as_handled()
