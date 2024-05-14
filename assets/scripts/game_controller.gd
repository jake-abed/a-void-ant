class_name GameController
extends Node2D

@onready var fade_player := $FadeLayer/AnimationPlayer

func _ready():
	SceneManager.room_change.connect(_on_room_change)

func _process(delta):
	pass

func _on_room_change() -> void:
	fade_player.queue("fade")
