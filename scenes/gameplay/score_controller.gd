extends Node

signal score_changed(current_score: int)
signal skill_shot_awarded(cannonball: RigidBody2D, skill_shot_id: StringName, points: int)

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

const GENERAL_SERIES_NONE: StringName = &"none"
const GENERAL_SERIES_PURE_PEG: StringName = &"pure_peg"
const GENERAL_SERIES_PURE_BLOCK: StringName = &"pure_block"
const GENERAL_SERIES_MIXED: StringName = &"mixed"

const SKILL_SHOT_LONG_SHOT: StringName = &"long_shot"
const LONG_SHOT_POINTS: int = 1000
const LONG_SHOT_MIN_DISTANCE: float = 600.0

var _current_score: int = 0
var _construction_series_by_ball: Dictionary = {}
var _general_series_by_ball: Dictionary = {}
var _skill_shot_by_ball: Dictionary = {}


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
	var current_series_base_points: int = int(state.get("current_series_base_points", 0))
	var current_series_multiplier: int = int(
		state.get("current_series_multiplier", get_construction_chain_multiplier(qualifying_series_count))
	)

	if previous_construction_id == construction_id:
		series_length += 1
	else:
		if previous_construction_id != &"" and construction_id in visited_constructions:
			qualifying_series_count = 0
			visited_constructions = []
		series_length = 1
		current_series_qualified = false
		current_series_base_points = 0
		current_series_multiplier = get_construction_chain_multiplier(qualifying_series_count)
		if construction_id not in visited_constructions:
			visited_constructions.append(construction_id)

	var series_points := get_construction_series_value(series_length)
	var milestone_bonus := get_construction_milestone_bonus(series_length)
	var base_points := series_points + milestone_bonus
	var awarded_multiplier := current_series_multiplier

	if series_length == CONSTRUCTION_QUALIFYING_LENGTH and not current_series_qualified:
		qualifying_series_count += 1
		current_series_qualified = true
		var qualified_multiplier := get_construction_chain_multiplier(qualifying_series_count)
		if qualified_multiplier > current_series_multiplier:
			var retroactive_adjustment := current_series_base_points * (
				qualified_multiplier - current_series_multiplier
			)
			add_score(retroactive_adjustment)
		current_series_multiplier = qualified_multiplier
		awarded_multiplier = qualified_multiplier

	current_series_base_points += base_points

	_construction_series_by_ball[ball_key] = {
		"construction_id": construction_id,
		"series_length": series_length,
		"qualifying_series_count": qualifying_series_count,
		"current_series_qualified": current_series_qualified,
		"visited_constructions": visited_constructions,
		"current_series_base_points": current_series_base_points,
		"current_series_multiplier": current_series_multiplier,
	}

	add_score(base_points * awarded_multiplier)
	return series_points * awarded_multiplier


func register_general_target_hit(cannonball: RigidBody2D, target: TargetBody) -> void:
	if cannonball == null or target == null or not target.is_target():
		return

	var ball_key := cannonball.get_instance_id()
	var state: Dictionary = _general_series_by_ball.get(ball_key, {})
	var series_length: int = int(state.get("series_length", 0)) + 1
	var has_peg: bool = bool(state.get("has_peg", false)) or target.is_peg()
	var has_block: bool = bool(state.get("has_block", false)) or target.is_block()

	_general_series_by_ball[ball_key] = {
		"series_length": series_length,
		"has_peg": has_peg,
		"has_block": has_block,
	}


func register_skill_shot_target_hit(cannonball: RigidBody2D, target: TargetBody) -> int:
	if cannonball == null or target == null or not target.is_target():
		return 0

	var ball_key := cannonball.get_instance_id()
	var state: Dictionary = _skill_shot_by_ball.get(ball_key, {})
	var current_position := target.global_position
	var awarded_points := 0

	if state.has("last_target_position"):
		var last_position: Vector2 = state["last_target_position"]
		if last_position.distance_to(current_position) >= LONG_SHOT_MIN_DISTANCE:
			awarded_points = LONG_SHOT_POINTS
			add_score(awarded_points)
			skill_shot_awarded.emit(cannonball, SKILL_SHOT_LONG_SHOT, awarded_points)

	_skill_shot_by_ball[ball_key] = {
		"last_target_position": current_position,
	}
	return awarded_points


func get_general_series_length(cannonball: RigidBody2D) -> int:
	if cannonball == null:
		return 0
	var state: Dictionary = _general_series_by_ball.get(cannonball.get_instance_id(), {})
	return int(state.get("series_length", 0))


func get_general_series_type(cannonball: RigidBody2D) -> StringName:
	if cannonball == null:
		return GENERAL_SERIES_NONE

	var state: Dictionary = _general_series_by_ball.get(cannonball.get_instance_id(), {})
	if state.is_empty():
		return GENERAL_SERIES_NONE

	var has_peg: bool = bool(state.get("has_peg", false))
	var has_block: bool = bool(state.get("has_block", false))
	if has_peg and has_block:
		return GENERAL_SERIES_MIXED
	if has_peg:
		return GENERAL_SERIES_PURE_PEG
	if has_block:
		return GENERAL_SERIES_PURE_BLOCK
	return GENERAL_SERIES_NONE


func break_general_series(cannonball: RigidBody2D) -> void:
	if cannonball == null:
		return
	_general_series_by_ball.erase(cannonball.get_instance_id())


func reset_skill_shot_tracking(cannonball: RigidBody2D) -> void:
	if cannonball == null:
		return
	_skill_shot_by_ball.erase(cannonball.get_instance_id())


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
	_general_series_by_ball.clear()
	_skill_shot_by_ball.clear()
	score_changed.emit(_current_score)
