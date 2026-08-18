class_name LevelConfiguration
extends Resource

@export_category("Level Identity")
@export_range(1, 9999, 1) var level_id: int = 1
@export_range(1, 999, 1) var level_pack: int = 1
@export_range(1, 999, 1) var content_version: int = 1
@export var is_published: bool = false

@export_category("Starting Ammunition")
@export_range(0, 999, 1) var starting_ammunition: int = 5


func get_validation_errors() -> PackedStringArray:
	var errors := PackedStringArray()

	if level_id < 1:
		errors.append("level_id must be 1 or greater")
	if level_pack < 1:
		errors.append("level_pack must be 1 or greater")
	if content_version < 1:
		errors.append("content_version must be 1 or greater")
	if starting_ammunition < 0:
		errors.append("starting_ammunition cannot be negative")

	return errors


func is_valid() -> bool:
	return get_validation_errors().is_empty()
