extends Node

signal score_changed(current_score: int)

var _current_score: int = 0


func get_score() -> int:
	return _current_score


func add_score(points: int) -> void:
	if points <= 0:
		return

	_current_score += points
	score_changed.emit(_current_score)


func reset_score() -> void:
	_current_score = 0
	score_changed.emit(_current_score)
