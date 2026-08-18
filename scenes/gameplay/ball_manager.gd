extends Node

const CANNONBALL_SCENE: PackedScene = preload("res://components/balls/cannonball/cannonball.tscn")


func spawn_ordinary_ball(spawn_position: Vector2, direction: Vector2, speed: float) -> RigidBody2D:
	var cannonball := CANNONBALL_SCENE.instantiate() as RigidBody2D
	if cannonball == null:
		push_error("Cannonball scene did not instantiate as RigidBody2D.")
		return null

	var scene_root := get_tree().current_scene
	if scene_root == null:
		push_error("Cannot spawn cannonball without a current scene.")
		cannonball.queue_free()
		return null

	scene_root.add_child(cannonball)
	cannonball.global_position = spawn_position
	cannonball.linear_velocity = direction.normalized() * speed
	return cannonball
