class_name Player extends CharacterBody2D

const SPEED = 275.0
const BALL_SPEED = 100.0
const JUMP_VELOCITY = -350.0
const INERTIA := 0.1

enum State {Normal, Void, Dash}

@export_group("Attached Nodes")
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var anim_player: AnimationPlayer
@export var anim_tree: AnimationTree
@export var ball_timer: Timer
@export var ball_particles: GPUParticles2D

@onready var direction: Vector2 = Vector2.ZERO

@onready var grounded := false
@onready var balled := false
@onready var can_ball := true

@onready var anim_states: AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	anim_tree.active = true
	ball_timer.timeout.connect(_ball_timer_timeout)

func _process(delta):
	set_sprite_direction()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and !balled:
		velocity.y += gravity * delta
		grounded = false
	
	if (is_on_floor() && !grounded && !balled):
		grounded = true
		anim_states.travel("Move")
	
	if (balled == false && can_ball && Input.is_action_just_pressed("void_ball")):
		balled = true
		can_ball = false
		anim_states.travel("into_ball")
		ball_particles.emitting = true
		ball_timer.start()
	
	if (balled):
		direction.y = Input.get_axis("move_up", "move_down")
		if direction.y:
			velocity.y = direction.y * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !balled:
		anim_states.travel("Jump")
		velocity.y = JUMP_VELOCITY
		grounded = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction.x = Input.get_axis("move_left", "move_right")
	anim_tree.set("parameters/Move/blend_position", direction.x)
	anim_tree.set("parameters/Jump/blend_position", velocity.y)
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

func _ball_timer_timeout() -> void:
	if balled:
		ball_particles.emitting = false
		anim_states.travel("Jump")
		balled = false
		can_ball = false
		ball_timer.wait_time = 8.0
		print("exiting ball, resetting timer")
		ball_timer.start()
	else:
		print("Can ball again!")
		ball_timer.wait_time = 3.0
		can_ball = true
