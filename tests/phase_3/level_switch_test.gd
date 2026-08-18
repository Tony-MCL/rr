extends Node

@onready var level_loader: LevelLoader = $LevelLoader
@onready var active_level: Node = $ActiveLevel


func _ready() -> void:
	if not _load_and_verify(1):
		return
	if not _load_and_verify(2):
		return
	if not _load_and_verify(1):
		return

	print("PHASE 3 LEVEL SWITCH TEST: PASS")


func _load_and_verify(level_id: int) -> bool:
	var loaded_level := level_loader.switch_level(level_id)
	if loaded_level == null:
		push_error("LEVEL SWITCH TEST FAILED: LEVEL %d DID NOT LOAD" % level_id)
		return false

	if active_level.get_child_count() != 1:
		push_error(
			"LEVEL SWITCH TEST FAILED: EXPECTED 1 ACTIVE LEVEL, FOUND %d"
			% active_level.get_child_count()
		)
		return false

	var configuration := loaded_level.get_configuration() as LevelConfiguration
	if configuration == null or configuration.level_id != level_id:
		push_error("LEVEL SWITCH TEST FAILED: WRONG ACTIVE LEVEL")
		return false

	print("LEVEL SWITCH VERIFIED: %d" % level_id)
	return true
