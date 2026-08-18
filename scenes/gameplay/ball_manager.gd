extends Node

signal shot_completed(shot_id: int)

const CANNONBALL_SCENE: PackedScene = preload("res://components/balls/cannonball/cannonball.tscn")

@export_category("Technical Protection")
@export_range(1.0, 600.0, 1.0) var ball_failsafe_timeout_seconds: float = 120.0

@onready var ammo_controller: Node = $"../AmmoController"

var _next_shot_id: int = 1
var _active_balls_by_shot: Dictionary = {}
var _ordinary_ball_loaded: bool = false


func _ready() -> void:
	call_deferred("_load_next_ball_if_available")


func spawn_ordinary_ball(spawn_position: Vector2, direction: Vector2, speed: float) -> RigidBody2D:
	if has_active_shot():
		print("ORDINARY FIRE BLOCKED: ACTIVE SHOT")
		return null

	if not _ordinary_ball_loaded:
		print("ORDINARY FIRE BLOCKED: NO LOADED BALL")
		return null

	var cannonball := CANNONBALL_SCENE.instantiate() as RigidBody2D
	if cannonball == null:
		push_error("Cannonball scene did not instantiate as RigidBody2D.")
		return null

	var scene_root := get_tree().current_scene
	if scene_root == null:
		push_error("Cannot spawn cannonball without a current scene.")
		cannonball.queue_free()
		return null

	if not ammo_controller.consume_one():
		_ordinary_ball_loaded = false
		print("ORDINARY FIRE BLOCKED: NO AMMUNITION")
		cannonball.queue_free()
		return null

	_ordinary_ball_loaded = false
	var shot_id := _claim_next_shot_id()
	_configure_and_launch_ball(cannonball, shot_id, spawn_position, direction, speed)
	print("SHOT %d STARTED" % shot_id)
	return cannonball


func spawn_bonus_ball(spawn_position: Vector2, direction: Vector2, speed: float) -> RigidBody2D:
	var shot_id := _get_active_shot_id()
	if shot_id == -1:
		print("BONUS BALL BLOCKED: NO ACTIVE SHOT")
		return null

	var cannonball := CANNONBALL_SCENE.instantiate() as RigidBody2D
	if cannonball == null:
		push_error("Bonus cannonball scene did not instantiate as RigidBody2D.")
		return null

	_configure_and_launch_ball(cannonball, shot_id, spawn_position, direction, speed)
	print("SHOT %d BONUS BALL SPAWNED" % shot_id)
	return cannonball


func register_ball_exit(cannonball: RigidBody2D) -> void:
	_register_ball_removed(cannonball, "EXITED")


func register_ball_caught(cannonball: RigidBody2D) -> void:
	if cannonball != null and cannonball.has_meta("shot_id"):
		ammo_controller.add_ammunition(1)
	_register_ball_removed(cannonball, "CAUGHT")


func has_active_shot() -> bool:
	return not _active_balls_by_shot.is_empty()


func _claim_next_shot_id() -> int:
	var shot_id := _next_shot_id
	_next_shot_id += 1
	return shot_id


func _get_active_shot_id() -> int:
	if _active_balls_by_shot.is_empty():
		return -1

	return int(_active_balls_by_shot.keys()[0])


func _configure_and_launch_ball(
	cannonball: RigidBody2D,
	shot_id: int,
	spawn_position: Vector2,
	direction: Vector2,
	speed: float
) -> void:
	var scene_root := get_tree().current_scene
	if scene_root == null:
		push_error("Cannot spawn cannonball without a current scene.")
		cannonball.queue_free()
		return

	cannonball.set_meta("shot_id", shot_id)
	scene_root.add_child(cannonball)
	cannonball.global_position = spawn_position
	cannonball.linear_velocity = direction.normalized() * speed
	_register_active_ball(shot_id, cannonball)
	_start_ball_failsafe(shot_id, cannonball)


func _register_active_ball(shot_id: int, cannonball: RigidBody2D) -> void:
	if not _active_balls_by_shot.has(shot_id):
		_active_balls_by_shot[shot_id] = []

	var active_balls: Array = _active_balls_by_shot[shot_id]
	active_balls.append(cannonball)
	_active_balls_by_shot[shot_id] = active_balls
	print("SHOT %d TRACKING: %d ACTIVE BALL(S)" % [shot_id, active_balls.size()])


func _register_ball_removed(cannonball: RigidBody2D, removal_reason: String) -> void:
	if cannonball == null:
		return

	if not cannonball.has_meta("shot_id"):
		push_warning("%s cannonball had no shot_id metadata." % removal_reason.capitalize())
		return

	var shot_id := int(cannonball.get_meta("shot_id"))
	if not _active_balls_by_shot.has(shot_id):
		push_warning("%s cannonball belonged to untracked shot %d." % [removal_reason.capitalize(), shot_id])
		return

	var active_balls: Array = _active_balls_by_shot[shot_id]
	active_balls.erase(cannonball)

	if active_balls.is_empty():
		_active_balls_by_shot.erase(shot_id)
		print("SHOT %d TRACKING: 0 ACTIVE BALLS (%s)" % [shot_id, removal_reason])
		_complete_shot(shot_id)
	else:
		_active_balls_by_shot[shot_id] = active_balls
		print("SHOT %d TRACKING: %d ACTIVE BALL(S)" % [shot_id, active_balls.size()])


func _complete_shot(shot_id: int) -> void:
	print("SHOT %d COMPLETED" % shot_id)
	shot_completed.emit(shot_id)
	_load_next_ball_if_available()


func _load_next_ball_if_available() -> void:
	if has_active_shot():
		return

	if ammo_controller.has_ammunition():
		_ordinary_ball_loaded = true
		print("NEXT BALL LOADED")
	else:
		_ordinary_ball_loaded = false
		print("NO AMMUNITION REMAINING")


func _start_ball_failsafe(shot_id: int, cannonball: RigidBody2D) -> void:
	var timer := get_tree().create_timer(ball_failsafe_timeout_seconds)
	timer.timeout.connect(_on_ball_failsafe_timeout.bind(shot_id, cannonball))


func _on_ball_failsafe_timeout(shot_id: int, cannonball: RigidBody2D) -> void:
	if not is_instance_valid(cannonball):
		return

	if not _active_balls_by_shot.has(shot_id):
		return

	var active_balls: Array = _active_balls_by_shot[shot_id]
	if not active_balls.has(cannonball):
		return

	push_warning("Shot %d cannonball exceeded %.0f seconds; removing it via technical failsafe." % [shot_id, ball_failsafe_timeout_seconds])
	_register_ball_removed(cannonball, "FAILSAFE")
	cannonball.queue_free()
