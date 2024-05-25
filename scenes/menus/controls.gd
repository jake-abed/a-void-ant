extends Control

@onready var back := $CanvasLayer/Panel/BackButton

func _ready():
	back.grab_focus()
	back.pressed.connect(_on_back_pressed)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_select"):
		self.queue_free()

func _on_back_pressed() -> void:
	self.queue_free()
