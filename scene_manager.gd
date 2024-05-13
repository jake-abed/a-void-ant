class_name SceneManager
extends Node

const scene_void = preload("res://scenes/levels/void_room.tscn")
const scene_hills = preload("res://scenes/levels/hills.tscn")

var spawn_door_tag: String

func go_to_level(level: String, destination: String) -> void:
	
