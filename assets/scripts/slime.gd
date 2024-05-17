extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var hitbox: Area2D
@export var hurtbox: Area2D
@export var ray: RayCast2D

const SPEED = 50.0
const JUMP_VELOCITY = -400.0

@onready var facing_factor := 1.0

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
	move_x()
	
	move_and_slide()

func _hitbox_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)

func move_x() -> void:
	if (!ray.is_colliding() or is_on_wall()) and is_on_floor():
		ray.position.x *= -1.0
		ray.target_position.x *= -1.0
		sprite.flip_h = !sprite.flip_h
		facing_factor *= -1.0
	velocity.x = SPEED * facing_factor
