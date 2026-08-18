class_name LevelLoader
extends Node

signal level_loaded(level: Node, configuration: LevelConfiguration)
signal level_unloaded

@export var active_level_path: NodePath
@export var level_catalog: LevelCatalog

var _active_level: Node = null


func load_level(level_id: int) -> Node:
	if level_catalog == null:
		push_error("LEVEL LOAD FAILED: LEVEL CATALOG NOT ASSIGNED")
		return null

	var entry := level_catalog.get_entry(level_id)
	if entry == null:
		push_error("LEVEL LOAD FAILED: LEVEL ID %d NOT FOUND" % level_id)
		return null

	if entry.scene_path.is_empty():
		push_error("LEVEL LOAD FAILED: LEVEL ID %d HAS NO SCENE PATH" % level_id)
		return null

	var resource := load(entry.scene_path)
	if resource == null or not resource is PackedScene:
		push_error("LEVEL LOAD FAILED: INVALID SCENE FOR LEVEL ID %d" % level_id)
		return null

	return load_level_scene(resource as PackedScene)


func load_level_scene(level_scene: PackedScene) -> Node:
	if level_scene == null:
		push_error("LEVEL LOAD FAILED: NO LEVEL SCENE")
		return null

	unload_level()

	var active_level := get_node_or_null(active_level_path)
	if active_level == null:
		push_error("LEVEL LOAD FAILED: ACTIVE LEVEL CONTAINER NOT FOUND")
		return null

	var level := level_scene.instantiate()
	active_level.add_child(level)

	var configuration := _get_level_configuration(level)
	if configuration == null:
		level.queue_free()
		push_error("LEVEL LOAD FAILED: LEVEL CONFIGURATION NOT FOUND")
		return null

	_active_level = level
	level_loaded.emit(level, configuration)
	print("LEVEL LOADED: %d" % configuration.level_id)
	return level


func unload_level() -> void:
	if _active_level == null:
		return

	_active_level.queue_free()
	_active_level = null
	level_unloaded.emit()
	print("LEVEL UNLOADED")


func get_active_level() -> Node:
	return _active_level


func _get_level_configuration(level: Node) -> LevelConfiguration:
	if level.has_method("get_configuration"):
		return level.get_configuration() as LevelConfiguration

	return null
