extends Node2D

export var DEBUG = false

onready var score = get_node("Entity/Score")
onready var block_prefab = preload("res://scene/block.tscn")

var rest_block = 0

func _ready():
	$Data/Wall/Debug.disabled = !DEBUG
	_on_window_size_changed()
	var _e = get_tree().root.connect("size_changed", self, "_on_window_size_changed")
	_build_blocks()

func _build_blocks() -> void:
	for y in 4:
		for x in 5:
			var block = block_prefab.instance()
			block.position = Vector2(40 * (x + 1), 20 * y + 50)
			$Data.add_child(block)
			block.initialize(block.position)
			rest_block += 1
			yield(get_tree(), "idle_frame")

func _on_Ball_on_collision(collider) -> void:
	if collider.is_in_group("block"):
		score.add()
		collider.destroy()
		rest_block -= 1
		if rest_block <= 0:
			_build_blocks()

func _on_window_size_changed() -> void:
	Global.window_size = OS.get_window_safe_area().size
	$Entity.position = Global.window_size - Vector2(280, 160) - Vector2(30, 30)
