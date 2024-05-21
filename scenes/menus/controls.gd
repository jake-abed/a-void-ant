extends Control

@onready var back := $CanvasLayer/Panel/BackButton

func _ready():
	back.grab_focus()
	back.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	self.queue_free()
