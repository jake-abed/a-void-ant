extends Node2D

const main_menu := preload("res://scenes/menus/main_menu.tscn")

@onready var anim_player := $AnimationPlayer


func _ready():
	anim_player.animation_finished.connect(_load_main_menu)
	fade()

func fade() -> void:
	anim_player.play("fade")

func _load_main_menu(_anim) -> void:
	get_tree().change_scene_to_packed(main_menu)
