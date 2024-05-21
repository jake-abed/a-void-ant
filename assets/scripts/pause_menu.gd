extends Control

const controls := preload("res://scenes/menus/controls.tscn")

@export var pause_button: Button
@export var unstick_button: Button
@export var player: Player
@export var controls_button := Button

@onready var panel := $TextureRect
@onready var pause_label := $Label
@onready var controls_open := false

func _ready():
	pause_button.pressed.connect(_pause_button_pressed)
	unstick_button.pressed.connect(_to_last_checkpoint)
	controls_button.pressed.connect(_controls_button_pressed)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
		if controls_open:
			get_node("Controls").queue_free()

func _pause_button_pressed() -> void:
	toggle_pause()

func toggle_pause() -> void:
	if controls_open:
		return
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused

func _to_last_checkpoint() -> void:
	player.return_to_checkpoint()
	toggle_pause()

func _controls_button_pressed() -> void:
	var controls_instance := controls.instantiate()
	controls_open = true
	panel.visible = false
	pause_label.visible = false
	controls_instance.tree_exited.connect(_controls_closed)
	add_child(controls_instance)

func _controls_closed() -> void:
	controls_open = false
	panel.visible = true
	pause_label.visible = true
