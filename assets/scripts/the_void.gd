extends Area2D

@export var sprite: AnimatedSprite2D

func _ready():
	sprite.play("default")
	play_float_anim()

func _process(_delta):
	pass

func play_float_anim() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var pos_offset_up := self.global_position.y - 7.5
	var pos_offset_down := pos_offset_up + 15.0
	var duration := 2.0
	
	tween.tween_property(self, "position:y", pos_offset_up, duration)
	tween.tween_property(self, "position:y", pos_offset_down, duration)
	tween.set_loops()
