class_name StateMachine extends Node

signal state_changed(old_state, new_state)

@export var initial_state := NodePath()

@onready var state := get_node(initial_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
