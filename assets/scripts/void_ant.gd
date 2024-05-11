class_name Player extends CharacterBody2D

const SPEED = 275.0
const JUMP_VELOCITY = -300.0
const INERTIA := 0.1

enum State {Normal, Void, Dash}

@export_group("Attached Nodes")
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var anim_player: AnimationPlayer
@export var anim_tree: AnimationTree
@export var camera: Camera2D

@onready var direction: Vector2 = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	anim_tree.active = true

func _process(delta):
	set_sprite_direction()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction.x = Input.get_axis("move_left", "move_right")
	anim_tree.set("parameters/Move/blend_position", direction.x)
	print(anim_tree["parameters/Move/blend_position"])
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func set_sprite_direction() -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
	else: pass
