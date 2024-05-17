class_name Pellet
extends Area2D

@export var room: String

@onready var sprite := $AnimatedSprite2D

func _ready():
	sprite.play()
	body_entered.connect(_on_body_entered)

func _process(delta):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.gain_void(1)
		SceneManager.set_collected(room, name)
		queue_free()
