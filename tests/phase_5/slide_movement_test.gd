extends Node2D

@onready var slider: SlideMovement = $SlideMovement
@onready var status_label: Label = $StatusLabel

var _minimum_x: float = INF
var _maximum_x: float = -INF
var _saw_reverse: bool = false
var _previous_direction: float = 1.0
var _elapsed: float = 0.0
var _finished: bool = false


func _ready() -> void:
	_previous_direction = slider.get_direction()
	_update_label("SLIDE MOVEMENT TEST: RUNNING")


func _process(delta: float) -> void:
	if _finished:
		return

	_elapsed += delta
	_minimum_x = minf(_minimum_x, slider.position.x)
	_maximum_x = maxf(_maximum_x, slider.position.x)

	var direction := slider.get_direction()
	if direction != _previous_direction:
		_saw_reverse = true
	_previous_direction = direction

	if _elapsed >= 4.5:
		_finish_test()


func _finish_test() -> void:
	_finished = true
	var expected_start_x := slider.get_initial_position().x
	var expected_end_x := expected_start_x + slider.travel_offset.x
	var reached_start := absf(_minimum_x - minf(expected_start_x, expected_end_x)) <= 4.0
	var reached_end := absf(_maximum_x - maxf(expected_start_x, expected_end_x)) <= 4.0
	var passed := reached_start and reached_end and _saw_reverse

	_update_label(
		"SLIDE MOVEMENT TEST: %s\nReached start: %s\nReached end: %s\nReversed: %s" % [
			"PASS" if passed else "FAIL",
			"YES" if reached_start else "NO",
			"YES" if reached_end else "NO",
			"YES" if _saw_reverse else "NO",
		]
	)


func _update_label(text_value: String) -> void:
	status_label.text = text_value
