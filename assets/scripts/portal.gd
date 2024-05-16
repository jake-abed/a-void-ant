class_name Portal
extends Area2D

@export var target_room: String
@export var target_location: String
@export var face_right := true

@export_group("Attached Nodes")
@export var collision_shape: CollisionShape2D
@export var spawn: Marker2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.can_change_rooms:
			SceneManager.go_to_level(target_room, target_location)
