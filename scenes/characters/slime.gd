extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var hitbox: Area2D
@export var hurtbox: Area2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	sprite = $AnimatedSprite2D
	sprite.play("default")
	hitbox.body_entered.connect(_hitbox_entered)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _hitbox_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
