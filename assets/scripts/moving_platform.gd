extends Path2D

@export var anim_player: AnimationPlayer

func _ready():
	anim_player.play("move")

func _process(delta):
	pass
