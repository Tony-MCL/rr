extends Node

signal score_changed(current_score: int)

const ZONE_VALUES := {
	1: 10,
	2: 20,
	3: 30,
	4: 40,
}

var _current_score: int = 0


func get_score() -> int:
	return _current_score


func get_zone_value(zone_id: int) -> int:
	return int(ZONE_VALUES.get(zone_id, 0))


func add_score(points: int) -> void:
	if points <= 0:
		return

	_current_score += points
	score_changed.emit(_current_score)


func register_target_hit(target: TargetBody, current_hits: int, required_hits: int) -> void:
	if target == null:
		return

	var zone_value := get_zone_value(target.get_zone_id())
	if zone_value <= 0:
		return

	if required_hits == 1 and current_hits == 1:
		add_score(zone_value)
		return

	if required_hits == 3 and current_hits >= 1 and current_hits <= 3:
		if current_hits == 3:
			add_score(zone_value * 10)
		else:
			add_score(zone_value)


func reset_score() -> void:
	_current_score = 0
	score_changed.emit(_current_score)
