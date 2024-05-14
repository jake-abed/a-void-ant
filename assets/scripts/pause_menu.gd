extends Control

@export var pause_button: Button

func _ready():
	pause_button.pressed.connect(_pause_button_pressed)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func _pause_button_pressed() -> void:
	toggle_pause()

func toggle_pause() -> void:
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused
