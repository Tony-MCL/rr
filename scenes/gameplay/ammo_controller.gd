extends Node

signal ammunition_changed(current_ammunition: int)

@export_range(0, 999, 1) var starting_ammunition: int = 5

var _current_ammunition: int = 0


func _ready() -> void:
	set_ammunition(starting_ammunition)


func get_ammunition() -> int:
	return _current_ammunition


func set_ammunition(amount: int) -> void:
	_current_ammunition = maxi(amount, 0)
	ammunition_changed.emit(_current_ammunition)
	print("AMMUNITION: %d" % _current_ammunition)


func has_ammunition() -> bool:
	return _current_ammunition > 0


func consume_one() -> bool:
	if not has_ammunition():
		return false

	_current_ammunition -= 1
	ammunition_changed.emit(_current_ammunition)
	print("AMMUNITION: %d" % _current_ammunition)
	return true


func add_ammunition(amount: int = 1) -> void:
	if amount <= 0:
		return

	_current_ammunition += amount
	ammunition_changed.emit(_current_ammunition)
	print("AMMUNITION: %d" % _current_ammunition)
