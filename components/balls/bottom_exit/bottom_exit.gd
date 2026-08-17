extends Area2D

signal ball_exited(ball: RigidBody2D)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("cannonball"):
		return

	var cannonball := body as RigidBody2D
	if cannonball == null:
		return

	ball_exited.emit(cannonball)
	print("BALL EXITED")
	cannonball.call_deferred("queue_free")
