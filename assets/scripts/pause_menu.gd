extends Control

@export var pause_button: Button
@export var unstick_button: Button
@export var player: Player

func _ready():
	pause_button.pressed.connect(_pause_button_pressed)
	unstick_button.pressed.connect(_to_last_checkpoint)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func _pause_button_pressed() -> void:
	toggle_pause()

func toggle_pause() -> void:
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused

func _to_last_checkpoint() -> void:
	player.return_to_checkpoint()
	toggle_pause()
