extends Node

@onready var score_controller: Node = $ScoreController
@onready var ammo_controller: Node = $AmmoController
@onready var objective_controller: ObjectiveController = $ObjectiveController
@onready var verification_hud: VerificationHud = $VerificationHud
@onready var result_label: Label = $ResultLabel

var cannonball := RigidBody2D.new()


func _ready() -> void:
	add_child(cannonball)
	cannonball.set_meta("shot_id", 601)
	verification_hud.bind_controllers(
		score_controller,
		ammo_controller,
		objective_controller,
		null
	)
	_run_test()


func _run_test() -> void:
	var failures: Array[String] = []

	ammo_controller.set_ammunition(7)
	score_controller.add_score(125)
	objective_controller.add_objective(
		&"targets",
		ObjectiveController.ObjectiveKind.TARGET_COUNT,
		3,
		true,
		false
	)
	objective_controller.set_objective_progress(&"targets", 2)
	score_controller.activate_double_score(cannonball)

	_check(verification_hud.score_label.text == "Score: 125", "HUD should show current score.", failures)
	_check(verification_hud.ammo_label.text == "Ammo: 7", "HUD should show current ammunition.", failures)
	_check(verification_hud.multiplier_label.text == "Shot multiplier: x2", "HUD should show current shot multiplier.", failures)
	_check("targets 2/3" in verification_hud.objective_label.text, "HUD should show objective progress.", failures)
	_check("Final: PENDING" in verification_hud.state_label.text, "HUD should show pending final state.", failures)

	objective_controller.set_objective_progress(&"targets", 3)
	_check("Bonus trigger: YES" in verification_hud.state_label.text, "HUD should show bonus trigger state.", failures)
	_check("Final: PASS" in verification_hud.state_label.text, "HUD should show final completion state.", failures)

	verification_hud._on_shot_completed(601)
	_check(verification_hud.multiplier_label.text == "Shot multiplier: x1", "HUD should return multiplier display to x1 after shot completion.", failures)

	if failures.is_empty():
		result_label.text = "TEMPORARY VERIFICATION HUD: PASS\nScore: visible\nAmmo: visible\nShot multiplier: visible\nObjective progress: visible\nBonus/final state: visible"
		print("PHASE 6 TEMPORARY VERIFICATION HUD TEST: PASS")
	else:
		result_label.text = "TEMPORARY VERIFICATION HUD: FAIL\n" + "\n".join(failures)
		for failure in failures:
			push_error(failure)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)
