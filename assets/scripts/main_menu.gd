extends Control

const intro := preload("res://scenes/intro.tscn")
const controls := preload("res://scenes/menus/controls.tscn")

@onready var start := $VBoxContainer/Start
@onready var controls_button := $VBoxContainer/Controls


func _ready():
	SceneManager.reset()
	start.grab_focus()
	start.pressed.connect(_start_pressed)
	controls_button.pressed.connect(_on_controls_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_pressed() -> void:
	get_tree().change_scene_to_packed(intro)

func _on_controls_pressed() -> void:
	var controls_instance := controls.instantiate()
	add_child(controls_instance)
	controls_instance.tree_exited.connect(_controls_closed)


func _controls_closed() -> void:
	controls_button.grab_focus()
