class_name Zone
extends Node2D

@export_category("Zone")
@export_range(1, 4, 1) var zone_id: int = 1


func get_zone_id() -> int:
	return zone_id
