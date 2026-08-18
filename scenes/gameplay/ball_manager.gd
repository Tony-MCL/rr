extends Node

const CANNONBALL_SCENE: PackedScene = preload("res://components/balls/cannonball/cannonball.tscn")

var _next_shot_id: int = 1
var _active_balls_by_shot: Dictionary = {}


func spawn_ordinary_ball(spawn_position: Vector2, direction: Vector2, speed: float) -> RigidBody2D:
	if has_active_shot():
		print("ORDINARY FIRE BLOCKED: ACTIVE SHOT")
		return null

	var shot_id := _claim_next_shot_id()
	var cannonball := CANNONBALL_SCENE.instantiate() as RigidBody2D
	if cannonball == null:
		push_error("Cannonball scene did not instantiate as RigidBody2D.")
		return null

	var scene_root := get_tree().current_scene
	if scene_root == null:
		push_error("Cannot spawn cannonball without a current scene.")
		cannonball.queue_free()
		return null

	cannonball.set_meta("shot_id", shot_id)
	scene_root.add_child(cannonball)
	cannonball.global_position = spawn_position
	cannonball.linear_velocity = direction.normalized() * speed
	_register_active_ball(shot_id, cannonball)
	print("SHOT %d STARTED" % shot_id)
	return cannonball


func register_ball_exit(cannonball: RigidBody2D) -> void:
	if cannonball == null:
		return

	if not cannonball.has_meta("shot_id"):
		push_warning("Exited cannonball had no shot_id metadata.")
		return

	var shot_id := int(cannonball.get_meta("shot_id"))
	if not _active_balls_by_shot.has(shot_id):
		push_warning("Exited cannonball belonged to untracked shot %d." % shot_id)
		return

	var active_balls: Array = _active_balls_by_shot[shot_id]
	active_balls.erase(cannonball)

	if active_balls.is_empty():
		_active_balls_by_shot.erase(shot_id)
		print("SHOT %d TRACKING: 0 ACTIVE BALLS" % shot_id)
	else:
		_active_balls_by_shot[shot_id] = active_balls
		print("SHOT %d TRACKING: %d ACTIVE BALLS" % [shot_id, active_balls.size()])


func has_active_shot() -> bool:
	return not _active_balls_by_shot.is_empty()


func _claim_next_shot_id() -> int:
	var shot_id := _next_shot_id
	_next_shot_id += 1
	return shot_id


func _register_active_ball(shot_id: int, cannonball: RigidBody2D) -> void:
	if not _active_balls_by_shot.has(shot_id):
		_active_balls_by_shot[shot_id] = []

	var active_balls: Array = _active_balls_by_shot[shot_id]
	active_balls.append(cannonball)
	_active_balls_by_shot[shot_id] = active_balls
	print("SHOT %d TRACKING: %d ACTIVE BALL" % [shot_id, active_balls.size()])
