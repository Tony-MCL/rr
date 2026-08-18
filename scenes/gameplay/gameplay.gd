extends Node2D

@export_group("Level Startup")
@export_range(1, 9999, 1) var starting_level_id: int = 1
@export var load_starting_level_on_ready: bool = true

@onready var level_loader: LevelLoader = $LevelLoader
@onready var ammo_controller: Node = $AmmoController


func _ready() -> void:
	level_loader.level_loaded.connect(_on_level_loaded)

	if load_starting_level_on_ready:
		level_loader.load_level(starting_level_id)


func _on_level_loaded(_level: Node, configuration: LevelConfiguration) -> void:
	ammo_controller.set_ammunition(configuration.starting_ammunition)
	print(
		"LEVEL %d STARTING AMMUNITION: %d"
		% [configuration.level_id, configuration.starting_ammunition]
	)
