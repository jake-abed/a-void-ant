extends Control

const intro := preload("res://scenes/intro.tscn")

@onready var start := $VBoxContainer/Start
@onready var controls := $VBoxContainer/Controls

func _ready():
	start.grab_focus()
	start.pressed.connect(_start_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_pressed() -> void:
	get_tree().change_scene_to_packed(intro)
