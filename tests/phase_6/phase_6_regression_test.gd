extends Node

const TEST_SCENES: Array[String] = [
	"res://tests/phase_6/score_controller_test.tscn",
	"res://tests/phase_6/zone_values_test.tscn",
	"res://tests/phase_6/one_hit_scoring_test.tscn",
	"res://tests/phase_6/three_hit_scoring_test.tscn",
	"res://tests/phase_6/construction_series_test.tscn",
	"res://tests/phase_6/construction_milestones_test.tscn",
	"res://tests/phase_6/chained_construction_multipliers_test.tscn",
	"res://tests/phase_6/general_series_foundation_test.tscn",
	"res://tests/phase_6/long_shot_test.tscn",
	"res://tests/phase_6/extra_ball_bonus_test.tscn",
	"res://tests/phase_6/double_score_test.tscn",
	"res://tests/phase_6/double_score_stacking_test.tscn",
	"res://tests/phase_6/double_score_lifetime_test.tscn",
	"res://tests/phase_6/objective_controller_test.tscn",
	"res://tests/phase_6/score_objective_test.tscn",
	"res://tests/phase_6/target_count_objective_test.tscn",
	"res://tests/phase_6/designated_target_objective_test.tscn",
	"res://tests/phase_6/clear_all_objective_test.tscn",
	"res://tests/phase_6/combined_and_objectives_test.tscn",
	"res://tests/phase_6/bonus_trigger_final_evaluation_test.tscn",
	"res://tests/phase_6/verification_hud_test.tscn",
]

@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	_run_regression()


func _run_regression() -> void:
	var failures: Array[String] = []
	var passed_count := 0

	for scene_path in TEST_SCENES:
		var packed_scene := load(scene_path) as PackedScene
		if packed_scene == null:
			failures.append("LOAD FAILED: %s" % scene_path)
			continue

		var test_instance := packed_scene.instantiate()
		$TestHost.add_child(test_instance)

		# All Phase 6 focused tests perform their assertions during _ready().
		# One process frame is enough for the result label to be updated while
		# keeping the regression runner deterministic and fast.
		await get_tree().process_frame

		var test_result_label := test_instance.get_node_or_null("ResultLabel") as Label
		if test_result_label == null:
			failures.append("NO RESULT LABEL: %s" % scene_path)
		elif "PASS" not in test_result_label.text or "FAIL" in test_result_label.text:
			failures.append("FAILED: %s\n%s" % [scene_path, test_result_label.text])
		else:
			passed_count += 1

		test_instance.queue_free()
		await get_tree().process_frame

	if failures.is_empty():
		result_label.text = (
			"PHASE 6 REGRESSION: PASS\n"
			+ "%d / %d focused tests passed\n" % [passed_count, TEST_SCENES.size()]
			+ "Scoring layers: verified\n"
			+ "Bonuses: verified\n"
			+ "Objectives: verified\n"
			+ "Temporary HUD: verified"
		)
		print("PHASE 6 REGRESSION TEST: PASS (%d/%d)" % [passed_count, TEST_SCENES.size()])
	else:
		result_label.text = (
			"PHASE 6 REGRESSION: FAIL\n"
			+ "%d / %d focused tests passed\n\n" % [passed_count, TEST_SCENES.size()]
			+ "\n\n".join(failures)
		)
		push_error("PHASE 6 REGRESSION TEST: FAIL (%d failure(s))" % failures.size())
