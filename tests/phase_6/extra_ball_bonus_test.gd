extends Node

@onready var ammo_controller: Node = $AmmoController
@onready var extra_ball_target: TargetBody = $ExtraBallTarget
@onready var three_hit_extra_ball_target: TargetBody = $ThreeHitExtraBallTarget
@onready var normal_target: TargetBody = $NormalTarget
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()


func _ready() -> void:
	add_child(cannonball)
	extra_ball_target.bonus_activated.connect(ammo_controller.register_target_bonus)
	three_hit_extra_ball_target.bonus_activated.connect(ammo_controller.register_target_bonus)
	normal_target.bonus_activated.connect(ammo_controller.register_target_bonus)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	_check(int(ammo_controller.get_ammunition()) == 5, "Starting ammunition should be 5.", failures)

	_check(extra_ball_target.register_hit(cannonball), "Extra Ball target hit should be valid.", failures)
	_check(int(ammo_controller.get_ammunition()) == 6, "Extra Ball should raise ammunition above starting amount.", failures)
	_check(extra_ball_target.has_bonus_activated(), "Extra Ball target should record bonus activation.", failures)

	_check(normal_target.register_hit(cannonball), "Normal target hit should be valid.", failures)
	_check(int(ammo_controller.get_ammunition()) == 6, "Normal target should not change ammunition.", failures)

	_check(three_hit_extra_ball_target.register_hit(cannonball), "First hit on three-hit Extra Ball target should be valid.", failures)
	_check(int(ammo_controller.get_ammunition()) == 7, "Three-hit Extra Ball target should award one ammunition on first valid hit.", failures)
	_check(three_hit_extra_ball_target.register_hit(cannonball), "Second hit on three-hit Extra Ball target should be valid.", failures)
	_check(int(ammo_controller.get_ammunition()) == 7, "Extra Ball bonus must activate only once per target.", failures)

	if failures.is_empty():
		result_label.text = "EXTRA BALL BONUS: PASS\nStart: 5\nExtra Ball hit: 6\nNormal target: unchanged\nThree-hit bonus: +1 once only\nAmmunition may exceed start"
		print("PHASE 6 EXTRA BALL BONUS TEST: PASS")
	else:
		result_label.text = "EXTRA BALL BONUS: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
