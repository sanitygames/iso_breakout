extends KinematicBody2D

onready var entity = get_tree().root.get_node("Game/Entity/Player")

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos_norm = event.position.x / Global.window_size.x * 1.4 - 0.2
		position.x = clamp(mouse_pos_norm * 240, 30, 210)
		entity.position = Global.o2i(position)

func _ready():
	entity.position = Global.o2i(position)