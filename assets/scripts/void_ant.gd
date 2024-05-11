class_name Player extends CharacterBody2D

const SPEED = 275.0
const JUMP_VELOCITY = -300.0
const INERTIA := 0.1

enum State {Normal, Void, Dash}

@export_group("Attached Nodes")
@export var sprite: AnimatedSprite2D
@export var collision_shape: CollisionShape2D
@export var camera: Camera2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	sprite.play("idle")

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
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func set_sprite_direction() -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
	else: pass
