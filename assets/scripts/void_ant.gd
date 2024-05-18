class_name Player extends CharacterBody2D

signal respawn
signal update_health(health: String)

const SPEED = 311.0
const DASH_SPEED = 600.0
const BALL_SPEED = 250.0
const JUMP_VELOCITY = -469.0
const INERTIA := 0.4

enum State {Normal, Void, Dash}

var rooms_entered = 0

@export var void_points: int = 5

@export_group("Attached Nodes")
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var anim_player: AnimationPlayer
@export var anim_tree: AnimationTree
@export var ball_timer: Timer
@export var coyote_timer: Timer
@export var dash_timer: Timer
@export var room_timer: Timer
@export var invuln_timer: Timer
@export var ball_particles: GPUParticles2D
@export var dash_particles: GPUParticles2D
@export var jump_audio: AudioStreamPlayer2D
@export var ball_audio: AudioStreamPlayer2D

@export_group("Ability Values")
@export var movement_factor: float = 10.0
@export var dash_factor: float = 3.0

@onready var direction: Vector2 = Vector2.ZERO
@onready var facing_factor := 1.0
@onready var checkpoint: Vector2
@onready var area: Area2D = $Area2D
@onready var interactables: Array[Area2D] = []

# In light of not using a state machine, these are the state bools
@onready var grounded := false
@onready var can_change_rooms := true
@onready var balled := false
@onready var can_ball := true
@onready var ball_acquired := true
@onready var can_jump := false
@onready var can_dash := true
@onready var dash_acquired := true
@onready var dashing := false
@onready var invuln := false
@onready var shot_acquired := false
@onready var can_shoot := false

@onready var anim_states: AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	# Start the animation tree if it isn't running.
	anim_tree.active = true
	# Set starting checkpoint as current position
	set_checkpoint(global_position)
	# Connect all timers.
	ball_timer.timeout.connect(_ball_timer_timeout)
	coyote_timer.timeout.connect(_coyote_timer_timeout)
	dash_timer.timeout.connect(_dash_timer_timeout)
	room_timer.timeout.connect(_on_room_change_timeout)
	invuln_timer.timeout.connect(_on_invuln_timeout)
	
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)
	SceneManager.room_change.connect(_on_room_change)

func _process(delta):
	set_sprite_direction()
	if Input.is_action_just_pressed("interact") && interactables.size() > 0:
		if interactables[0] is Powerup:
			enable_powerup(interactables[0].power)
			interactables[0].give_power(self)

func _physics_process(delta):
	# Set the facing_factor to affect direction-based movements.
	if sprite.flip_h:
		facing_factor = -1.0
	else:
		facing_factor = 1.0
	
	# Set per frame movement X speed based off current movement type.
	var speed := SPEED
	if balled:
		speed = BALL_SPEED
	
	# Reset abilitity to jump if the player has touched the floor.
	if (is_on_floor()):
		can_jump = true
	
	# If the player has left the floor, start coyote timer and let player be affected by gravity.
	if not is_on_floor() && !balled:
		if coyote_timer.is_stopped() && can_jump:
			coyote_timer.start()
			pass
		if !dashing:
			velocity.y += gravity * delta
		grounded = false
	
	# Allow dash if possible.
	if dash_acquired && can_dash && !balled && Input.is_action_just_pressed("dash"):
		dash()
	
	# At this point, we know enough about player movement to set animations.
	if (is_on_floor() && !grounded && !balled):
		grounded = true
		anim_states.travel("Move")
	
	# Allow void ball ability.
	if (balled == false && ball_acquired && can_ball && Input.is_action_just_pressed("void_ball")):
		balled = true
		can_ball = false
		anim_states.travel("into_ball")
		ball_audio.play()
		ball_particles.emitting = true
		ball_timer.start()
	
	if invuln:
		velocity.x = 0
		move_and_slide()
		return
	
	# Execute void ball y-movement.
	if (balled):
		direction.y = Input.get_axis("move_up", "move_down")
		if direction.y:
			velocity.y += direction.y * speed * movement_factor * delta
			velocity.y = clamp(velocity.y, -speed, speed)
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump and !balled:
		grounded = false
		can_jump = false
		jump_audio.play()
		anim_states.travel("jump")
		velocity.y += JUMP_VELOCITY
		if dashing:
			velocity.y = 0
			velocity.x = DASH_SPEED * dash_factor * facing_factor
	if velocity.y > 0 && !balled:
		anim_states.travel("falling")
	
	# Get the input direction and handle the movement/deceleration.
	direction.x = Input.get_axis("move_left", "move_right")
	anim_tree.set("parameters/Move/blend_position", direction.x)
	if direction.x && !dashing:
		velocity.x += direction.x * speed * movement_factor * delta
		velocity.x = clamp(velocity.x, -speed, speed)
	elif !balled && dashing:
		speed = SPEED * dash_factor
		velocity.x =  facing_factor * DASH_SPEED
		velocity.y = 0
	else:
		velocity.x = move_toward(velocity.x, 0, movement_factor / INERTIA)
	move_and_slide()

func set_sprite_direction() -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
	else: pass

func dash() -> void:
	if can_dash:
		can_dash = false
		ball_audio.pitch_scale = 4
		ball_audio.play()
		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		dash_timer.wait_time = 0.25
		dash_timer.start()
		dashing = true
		dash_particles.emitting = true
		tween.tween_property(self, "dash_factor", 3.0, 0.125)
		tween.tween_property(self, "dash_factor", 1.0, 0.125)
	else:
		pass

func start_coyote_timer() -> void:
	coyote_timer.start()

## Timeout functions

func _ball_timer_timeout() -> void:
	if balled:
		ball_particles.emitting = false
		anim_states.travel("from_ball")
		balled = false
		can_ball = false
		ball_audio.stop()
		ball_timer.wait_time = 2.0
		ball_timer.start()
	else:
		ball_timer.wait_time = 1.0
		can_ball = true

func _coyote_timer_timeout() -> void:
	can_jump = false

func _dash_timer_timeout() -> void:
	if dashing:
		dashing = false
		ball_audio.stop()
		ball_audio.pitch_scale = 0.75
		dash_timer.wait_time = 1.2
		dash_timer.start()
	else:
		can_dash = true
		dash_factor = 3.0

func _on_room_change_timeout() -> void:
	can_change_rooms = true

func _on_invuln_timeout() -> void:
	invuln = false

func _on_room_change() -> void:
	can_change_rooms = false
	room_timer.wait_time = 0.1
	room_timer.start()
	rooms_entered += 1

func take_damage(amount: int) -> void:
	if invuln:
		return
	invuln = true
	invuln_timer.start()
	respawn.emit()
	void_points -= amount
	global_position = checkpoint
	anim_states.travel("respawn")

func gain_void(amount: int) -> void:
	void_points += amount

func set_checkpoint(pos: Vector2) -> void:
	checkpoint = pos

# Interactions with Area2D entered and exited
func _on_area_entered(area: Area2D) -> void:
	if area is Powerup:
		interactables.push_back(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Powerup:
		interactables.pop_front()

func enable_powerup(name: String) -> void:
	match name:
		"dash":
			dash_acquired = true
		"ball":
			ball_acquired = true
