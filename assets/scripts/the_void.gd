extends Area2D

@export var sprite: AnimatedSprite2D
@export var light : PointLight2D

func _ready():
	sprite.play("default")
	play_float_anim()
	adjust_lighting()

func _process(_delta):
	pass

# Simple tweened floating animation to make the void float a little.
func play_float_anim() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var pos_offset_up := self.global_position.y - 7.5
	var pos_offset_down := pos_offset_up + 15.0
	var duration := 2.0
	
	tween.tween_property(self, "position:y", pos_offset_up, duration)
	tween.tween_property(self, "position:y", pos_offset_down, duration)
	tween.set_loops()

func adjust_lighting() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "energy", 1.4, 1.5)
	tween.tween_property(light, "energy", 1.1, 1.5)
	tween.set_loops()
