extends StaticBody2D

var entity

func initialize(pos):
	entity = get_child(0)
	remove_child(entity)
	get_tree().root.get_node("Game/Entity/Blocks").add_child(entity)
	entity.position = Global.o2i(pos).round()

func destroy():
	queue_free()
	entity.queue_free()
