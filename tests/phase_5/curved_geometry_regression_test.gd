extends Node2D

@onready var small_a: TargetBody = $SmallA
@onready var small_b: TargetBody = $SmallB
@onready var large_a: TargetBody = $LargeA
@onready var large_b: TargetBody = $LargeB
@onready var status_label: Label = $StatusLabel


func _ready() -> void:
	await get_tree().process_frame
	_run_test()


func _run_test() -> void:
	var small_snap: bool = _snap_distance(small_a, "SnapRight", small_b, "SnapLeft") < 0.1
	var large_snap: bool = _snap_distance(large_a, "SnapRight", large_b, "SnapLeft") < 0.1
	var small_collision: bool = _collision_matches_visual(small_a) and _collision_matches_visual(small_b)
	var large_collision: bool = _collision_matches_visual(large_a) and _collision_matches_visual(large_b)
	var passed: bool = small_snap and large_snap and small_collision and large_collision

	status_label.text = "CURVED GEOMETRY REGRESSION: %s\nSmall snap joined: %s\nLarge snap joined: %s\nSmall collision matches: %s\nLarge collision matches: %s" % [
		"PASS" if passed else "FAIL",
		"YES" if small_snap else "NO",
		"YES" if large_snap else "NO",
		"YES" if small_collision else "NO",
		"YES" if large_collision else "NO",
	]


func _snap_distance(a: Node, a_snap_name: String, b: Node, b_snap_name: String) -> float:
	var a_snap: Marker2D = a.get_node(a_snap_name) as Marker2D
	var b_snap: Marker2D = b.get_node(b_snap_name) as Marker2D
	return a_snap.global_position.distance_to(b_snap.global_position)


func _collision_matches_visual(target: Node) -> bool:
	var collision: CollisionPolygon2D = target.get_node("CollisionPolygon2D") as CollisionPolygon2D
	var visual: Polygon2D = target.get_node("Visual") as Polygon2D
	if collision.polygon.size() != visual.polygon.size():
		return false
	for i in range(collision.polygon.size()):
		if collision.polygon[i].distance_to(visual.polygon[i]) > 0.001:
			return false
	return true
