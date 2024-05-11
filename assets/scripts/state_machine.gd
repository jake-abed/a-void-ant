class_name StateMachine extends Node

signal state_changed(old_state, new_state)

@export var initial_state: State

@onready var state := initial_state

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(state)
	await owner.ready

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_state(new_state: State) -> void:
	if state is State:
		state._exit_state()
	new_state.enter_state()
	state = new_state

