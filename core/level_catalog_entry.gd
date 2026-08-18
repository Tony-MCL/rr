class_name LevelCatalogEntry
extends Resource

@export_category("Level Identity")
@export_range(1, 9999, 1) var level_id: int = 1
@export_range(1, 999, 1) var level_pack: int = 1
@export_range(1, 999, 1) var content_version: int = 1
@export var is_published: bool = false

@export_category("Loading")
@export_file("*.tscn") var scene_path: String = ""
@export_range(1, 9999, 1) var progression_order: int = 1
