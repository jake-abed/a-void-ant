extends Node2D

func _ready():
	despawn_collected()

func _process(delta):
	pass

func despawn_collected() -> void:
	var room_contents = SceneManager.spawns[name]
	for key in room_contents:
		var should_spawn: bool = room_contents[key]
		if !should_spawn:
			get_node(key).queue_free()
