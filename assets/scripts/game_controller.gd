class_name GameController
extends Node2D

@onready var fade_player := $FadeLayer/AnimationPlayer
@onready var player := $Player

func _ready():
	SceneManager.room_change.connect(_fade_in)
	player.respawn.connect(_fade_in)

func _process(delta):
	pass

func _fade_in() -> void:
	fade_player.play("fade")
