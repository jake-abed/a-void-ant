extends Node

const scene_void = preload("res://scenes/levels/void.tscn")
const scene_hills = preload("res://scenes/levels/hills.tscn")
const scene_cave = preload("res://scenes/levels/cave.tscn")
const scene_hills2 = preload("res://scenes/levels/hills_2.tscn")

signal room_change

var spawn_door_tag: String
var current_room: String = "Void"

func go_to_level(level: String, destination: String) -> void:
	var player: Player = $/root/Game/Player
	var level_node = $/root/Game/Level
	var scene_to_load: PackedScene
	
	match level:
		"Void":
			scene_to_load = scene_void
		"Hills":
			scene_to_load = scene_hills
		"Cave":
			scene_to_load = scene_cave
		"Hills2":
			scene_to_load = scene_hills2
		
	if scene_to_load != null:
		spawn_door_tag = destination
		room_change.emit()
		level_node.get_node(current_room).queue_free()
		var scene_instance := scene_to_load.instantiate()
		level_node.call_deferred("add_child", scene_instance)
		current_room = level
		var marker = scene_instance.get_node(destination + "/Spawn")
		player.global_position = marker.global_position
