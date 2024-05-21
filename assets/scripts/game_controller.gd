class_name GameController
extends Node2D

@onready var fade_player := $FadeLayer/AnimationPlayer
@onready var player := $Player
@onready var void_energy_count := $UI/CanvasLayer/VoidEnergyPanel/VoidEnergyCount
@onready var void_dash_panel := $UI/CanvasLayer/HBoxContainer/VoidDashPanel
@onready var void_dash_available_label := $UI/CanvasLayer/HBoxContainer/VoidDashPanel/VoidDashAvailableLabel
@onready var void_ball_panel := $UI/CanvasLayer/HBoxContainer/VoidBallPanel
@onready var void_ball_available_label := $UI/CanvasLayer/HBoxContainer/VoidBallPanel/VoidBallAvailableLabel

func _ready():
	fade_player.play("fade")
	SceneManager.room_change.connect(_fade_in)
	player.respawn.connect(_fade_in)
	player.update_void_points.connect(_on_update_void_points)
	player.power_enabled.connect(_on_power_enabled)
	player.power_available.connect(_on_power_available)
	player.power_used.connect(_on_power_used)

func _process(delta):
	pass

func _fade_in() -> void:
	if player.void_points <= 0:
		SceneManager.reset()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/lose.tscn")
	fade_player.play("fade")

func _on_update_void_points(points: int) -> void:
	void_energy_count.text = str(points)

func _on_power_enabled(power: String) -> void:
	print("Power enabled: " + power + "!")
	match power:
		"dash":
			void_dash_panel.visible = true
		"ball":
			void_ball_panel.visible = true

func _on_power_available(power: String) -> void:
	print("Power available: " + power + "!")
	match power:
		"dash":
			void_dash_available_label.text = "AVAILABLE!"
			void_dash_panel.self_modulate.a = 1.0
		"ball":
			void_ball_available_label.text = "AVAILABLE!"
			void_ball_panel.self_modulate.a = 1.0

func _on_power_used(power: String) -> void:
	print("Power used: " + power + "!")
	match power:
		"dash":
			void_dash_available_label.text = "UNAVAILABLE"
			void_dash_panel.self_modulate.a = 0.1
		"ball":
			void_ball_available_label.text = "UNAVAILABLE"
			void_ball_panel.self_modulate.a = 0.1

func fade_out() -> void:
	fade_player.play("fade_out")
