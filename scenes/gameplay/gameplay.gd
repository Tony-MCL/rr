extends Node2D

@export_group("Level Startup")
@export_range(1, 9999, 1) var starting_level_id: int = 1
@export var load_starting_level_on_ready: bool = true

@onready var level_loader: LevelLoader = $LevelLoader
@onready var ball_manager: Node = $BallManager
@onready var ammo_controller: Node = $AmmoController
@onready var score_controller: Node = $ScoreController
@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var verification_hud: VerificationHud = $VerificationHud


func _ready() -> void:
	level_loader.level_loaded.connect(_on_level_loaded)
	objective_controller.bind_score_controller(score_controller)
	verification_hud.bind_controllers(
		score_controller,
		ammo_controller,
		objective_controller,
		ball_manager
	)

	if load_starting_level_on_ready:
		level_loader.load_level(starting_level_id)


func _on_level_loaded(_level: Node, configuration: LevelConfiguration) -> void:
	ammo_controller.set_ammunition(configuration.starting_ammunition)
	print(
		"LEVEL %d STARTING AMMUNITION: %d"
		% [configuration.level_id, configuration.starting_ammunition]
	)
