class_name Powerup
extends Area2D

@export var parent: Node2D
@export var power: String

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		label.visible = false

func give_power(player: Player) -> void:
	label.visible = false
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel()
	
	tween.tween_property(parent, "scale", Vector2(0,0), 0.5)
	tween.tween_property(parent, "global_position", player.global_position, 0.5)
	await tween.finished
	parent.queue_free()
