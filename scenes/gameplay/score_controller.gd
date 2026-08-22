extends Node

signal score_changed(current_score: int)

const ZONE_VALUES := {
	1: 10,
	2: 20,
	3: 30,
	4: 40,
}

const CONSTRUCTION_SERIES_VALUES := {
	1: 10,
	2: 20,
	3: 40,
	4: 60,
	5: 80,
}
const CONSTRUCTION_SERIES_REPEAT_VALUE: int = 100
const CONSTRUCTION_MILESTONE_BONUSES := {
	10: 500,
	15: 1000,
	20: 3000,
}
const CONSTRUCTION_CHAIN_MULTIPLIERS := {
	1: 1,
	2: 5,
	3: 25,
}
const CONSTRUCTION_CHAIN_MAX_MULTIPLIER: int = 25
const CONSTRUCTION_QUALIFYING_LENGTH: int = 6

var _current_score: int = 0
var _construction_series_by_ball: Dictionary = {}


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


func register_construction_hit(cannonball: RigidBody2D, target: TargetBody) -> int:
	if cannonball == null or target == null or not target.is_target():
		return 0

	var construction_id := target.get_construction_id()
	if construction_id == &"":
		break_construction_series(cannonball)
		return 0

	var ball_key := cannonball.get_instance_id()
	var state: Dictionary = _construction_series_by_ball.get(ball_key, {})
	var previous_construction_id: StringName = state.get("construction_id", &"")
	var series_length: int = int(state.get("series_length", 0))
	var qualifying_series_count: int = int(state.get("qualifying_series_count", 0))
	var current_series_qualified: bool = bool(state.get("current_series_qualified", false))
	var visited_constructions: Array = state.get("visited_constructions", [])

	if previous_construction_id == construction_id:
		series_length += 1
	else:
		if previous_construction_id != &"" and construction_id in visited_constructions:
			qualifying_series_count = 0
			visited_constructions = []
		series_length = 1
		current_series_qualified = false
		if construction_id not in visited_constructions:
			visited_constructions.append(construction_id)

	if series_length == CONSTRUCTION_QUALIFYING_LENGTH and not current_series_qualified:
		qualifying_series_count += 1
		current_series_qualified = true

	var multiplier := get_construction_chain_multiplier(qualifying_series_count)
	_construction_series_by_ball[ball_key] = {
		"construction_id": construction_id,
		"series_length": series_length,
		"qualifying_series_count": qualifying_series_count,
		"current_series_qualified": current_series_qualified,
		"visited_constructions": visited_constructions,
	}

	var series_points := get_construction_series_value(series_length)
	var milestone_bonus := get_construction_milestone_bonus(series_length)
	add_score((series_points + milestone_bonus) * multiplier)
	return series_points * multiplier


func get_construction_series_value(series_length: int) -> int:
	if series_length <= 0:
		return 0
	if series_length >= 6:
		return CONSTRUCTION_SERIES_REPEAT_VALUE
	return int(CONSTRUCTION_SERIES_VALUES.get(series_length, 0))


func get_construction_milestone_bonus(series_length: int) -> int:
	return int(CONSTRUCTION_MILESTONE_BONUSES.get(series_length, 0))


func get_construction_chain_multiplier(qualifying_series_count: int) -> int:
	if qualifying_series_count <= 0:
		return 1
	if qualifying_series_count >= 3:
		return CONSTRUCTION_CHAIN_MAX_MULTIPLIER
	return int(CONSTRUCTION_CHAIN_MULTIPLIERS.get(qualifying_series_count, 1))


func get_construction_series_length(cannonball: RigidBody2D) -> int:
	if cannonball == null:
		return 0
	var state: Dictionary = _construction_series_by_ball.get(cannonball.get_instance_id(), {})
	return int(state.get("series_length", 0))


func get_construction_chain_count(cannonball: RigidBody2D) -> int:
	if cannonball == null:
		return 0
	var state: Dictionary = _construction_series_by_ball.get(cannonball.get_instance_id(), {})
	return int(state.get("qualifying_series_count", 0))


func get_active_construction_multiplier(cannonball: RigidBody2D) -> int:
	return get_construction_chain_multiplier(get_construction_chain_count(cannonball))


func break_construction_series(cannonball: RigidBody2D) -> void:
	if cannonball == null:
		return
	_construction_series_by_ball.erase(cannonball.get_instance_id())


func reset_score() -> void:
	_current_score = 0
	_construction_series_by_ball.clear()
	score_changed.emit(_current_score)
