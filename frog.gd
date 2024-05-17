extends CharacterBody2D

const JUMP_VELOCITY = -600.0

@export var jump_wait_time := 3.0
@export var flip := true

@onready var hitbox: Area2D = $HitBox
@onready var hurtbox: Area2D = $HurtBox
@onready var jump_timer := $JumpTimer
@onready var sprite := $Sprite2D
@onready var anim_state : AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	anim_state.travel("idle")
	hitbox.body_entered.connect(_hitbox_entered)
	jump_timer.wait_time = jump_wait_time
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	if flip:
		sprite.flip_h = flip


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y > 0:
		anim_state.travel("fall")

	move_and_slide()

func _on_jump_timer_timeout() -> void:
	velocity.y += JUMP_VELOCITY
	anim_state.travel("jump")

func _hitbox_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
