extends StaticBody2D
class_name TargetBody

enum PhysicalRole {
	TARGET,
	SOLID,
}

@export_category("Physical Role")
@export var physical_role: PhysicalRole = PhysicalRole.TARGET

func is_target() -> bool:
	return physical_role == PhysicalRole.TARGET

func is_solid() -> bool:
	return physical_role == PhysicalRole.SOLID
