extends Node

const scene_void = preload("res://scenes/levels/void.tscn")
const scene_hills = preload("res://scenes/levels/hills.tscn")

signal room_change

var spawn_door_tag: String
var current_room: String = "Void"

func go_to_level(level: String, destination: String) -> void:
	var game_node: Node = $/root/Game
	var player: Player = $/root/Game/Player
	var scene_to_load: PackedScene
	
	match level:
		"Void":
			scene_to_load = scene_void
		"Hills": scene_to_load = scene_hills
		
	if scene_to_load != null:
		spawn_door_tag = destination
		room_change.emit()
		game_node.get_node(current_room).queue_free()
		game_node.add_child(scene_to_load.instantiate())
		current_room = level
		var marker = game_node.get_node(current_room + "/" + destination + "/Spawn")
		player.global_position = marker.global_position


