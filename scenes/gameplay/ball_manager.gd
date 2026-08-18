extends Node

const CANNONBALL_SCENE: PackedScene = preload("res://components/balls/cannonball/cannonball.tscn")

var _next_shot_id: int = 1


func spawn_ordinary_ball(spawn_position: Vector2, direction: Vector2, speed: float) -> RigidBody2D:
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
	print("SHOT %d STARTED" % shot_id)
	return cannonball


func _claim_next_shot_id() -> int:
	var shot_id := _next_shot_id
	_next_shot_id += 1
	return shot_id
