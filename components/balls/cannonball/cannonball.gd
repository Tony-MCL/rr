extends RigidBody2D

var _contact_bodies: Dictionary = {}


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if body == null:
		return

	var body_id := body.get_instance_id()
	if _contact_bodies.has(body_id):
		return

	_contact_bodies[body_id] = true

	if body.has_method("register_hit"):
		body.register_hit(self)


func _on_body_exited(body: Node) -> void:
	if body == null:
		return

	_contact_bodies.erase(body.get_instance_id())
