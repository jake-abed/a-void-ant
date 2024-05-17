extends Area2D

@export var marker: Marker2D

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_checkpoint(marker.global_position)
