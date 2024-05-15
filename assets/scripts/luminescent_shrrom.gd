extends Sprite2D

@onready var light := $PointLight2D
@onready var low_val := randf_range(0.75, 0.9)
@onready var high_val := randf_range(1.3, 1.45)
@onready var time := randf_range(3.0, 5.0)
@onready var min_light_scale := randf_range(9.0, 10.0)
@onready var max_light_scale := randf_range(12.0, 14.0)

func _ready():
	print(light.scale)
	light.energy = low_val
	light.scale = Vector2(min_light_scale, min_light_scale)
	modulate_light_strength()
	modulate_light_size()

func _process(delta):
	pass

func modulate_light_strength() -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(light, "energy", high_val, time)
	tween.tween_property(light, "energy", low_val, time)
	tween.set_loops()

func modulate_light_size() -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(light, "scale", Vector2(min_light_scale, min_light_scale), time * 2.5)
	tween.tween_property(light, "scale", Vector2(max_light_scale, max_light_scale), time * 2.5)
	tween.set_loops()
