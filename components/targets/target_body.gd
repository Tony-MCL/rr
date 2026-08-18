extends StaticBody2D
class_name TargetBody

signal target_hit(target: TargetBody, current_hits: int, required_hits: int)
signal hit_requirement_reached(target: TargetBody)

enum PhysicalRole {
	TARGET,
	SOLID,
}

@export_category("Physical Role")
@export var physical_role: PhysicalRole = PhysicalRole.TARGET

@export_category("Hit Configuration")
@export_enum("One Hit:1", "Three Hits:3") var hits_required: int = 1

var _valid_hits: int = 0


func is_target() -> bool:
	return physical_role == PhysicalRole.TARGET


func is_solid() -> bool:
	return physical_role == PhysicalRole.SOLID


func get_valid_hits() -> int:
	return _valid_hits


func is_hit_requirement_reached() -> bool:
	return is_target() and _valid_hits >= hits_required


func register_hit(_cannonball: RigidBody2D) -> bool:
	if not is_target():
		return false

	if is_hit_requirement_reached():
		return false

	_valid_hits += 1
	target_hit.emit(self, _valid_hits, hits_required)
	print("TARGET HIT: %s %d/%d" % [name, _valid_hits, hits_required])

	if is_hit_requirement_reached():
		hit_requirement_reached.emit(self)
		print("TARGET HIT REQUIREMENT REACHED: %s" % name)

	return true
