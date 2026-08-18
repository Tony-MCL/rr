class_name ConstructionGroup
extends Node2D

@export_category("Construction")
@export var construction_id: StringName = &"construction"


func get_construction_id() -> StringName:
	return construction_id


func get_pivot_global_position() -> Vector2:
	return global_position


func set_pivot_rotation_degrees(angle_degrees: float) -> void:
	rotation_degrees = angle_degrees
