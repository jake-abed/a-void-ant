extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
