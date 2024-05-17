class_name Pellet
extends Area2D

@onready var sprite := $AnimatedSprite2D

func _ready():
	sprite.play()
	body_entered.connect(_on_body_entered)
	play_float_anim()

func _process(delta):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.gain_void(1)
		SceneManager.set_collected(name)
		queue_free()

func play_float_anim() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	var tween2 := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var pos_offset_up := global_position.y - 3.0
	var pos_offset_down := pos_offset_up + 6.0
	var duration := 1.0
	
	tween.tween_property(self, "global_position:y", pos_offset_up, duration)
	tween.tween_property(self, "global_position:y", pos_offset_down, duration)
	tween2.tween_property(self, "scale", scale * 1.4, duration * 1.2)
	tween2.tween_property(self, "scale", scale * 0.8, duration * 1.2)
	tween.set_loops()
	tween2.set_loops()
