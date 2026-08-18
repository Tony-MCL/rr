extends RigidBody2D


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body == null:
		return

	if body.has_method("register_hit"):
		body.register_hit(self)
