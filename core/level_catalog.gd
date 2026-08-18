class_name LevelCatalog
extends Resource

@export var entries: Array[LevelCatalogEntry] = []


func get_entry(level_id: int) -> LevelCatalogEntry:
	for entry in entries:
		if entry != null and entry.level_id == level_id:
			return entry

	return null


func get_published_entries() -> Array[LevelCatalogEntry]:
	var published_entries: Array[LevelCatalogEntry] = []

	for entry in entries:
		if entry != null and entry.is_published:
			published_entries.append(entry)

	published_entries.sort_custom(
		func(a: LevelCatalogEntry, b: LevelCatalogEntry) -> bool:
			return a.progression_order < b.progression_order
	)
	return published_entries
