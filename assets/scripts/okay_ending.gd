extends Node2D

const main_menu := preload("res://scenes/menus/main_menu.tscn")

@onready var text_box := $Control/CanvasLayer/Panel/Dialog
@onready var continue_button := $Control/CanvasLayer/Panel/ContinueButton
@onready var anim_player := $Control/CanvasLayer/Panel/AnimationPlayer
@onready var sprite := $AnimatedSprite2D

var dialog_lines := [
	"Nothing  is...  satisfied?",
	"Nothing  thinks  you  could  have  tried  harder...",
	"Nothing  might  make  a  beetle  or  maybe  a  dog  next  time..."
]

var dialog_anim_names := [
	"line_one",
	"line_two",
	"line_three",
]

func _ready():
	sprite.play("default")
	continue_button.grab_focus()
	continue_button.pressed.connect(_on_continue_pressed)
	anim_player.animation_finished.connect(_on_anim_finished)
	
	anim_player.play("fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_continue_pressed() -> void:
	if anim_player.current_animation == "fade_in":
		return
	if anim_player.is_playing():
		anim_player.seek(anim_player.current_animation_length)
		return
	if !dialog_lines.is_empty():
		text_box.text = dialog_lines.pop_front()
		anim_player.play(dialog_anim_names.pop_front())
		return
	elif dialog_lines.is_empty():
		continue_button.release_focus()
		anim_player.play("fade_out")

func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == &"fade_in":
		text_box.text = dialog_lines.pop_front()
		anim_player.play(dialog_anim_names.pop_front())
	if anim_name == &"fade_out":
		get_tree().change_scene_to_packed(main_menu)
