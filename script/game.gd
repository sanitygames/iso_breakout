extends Node2D

export var DEBUG = false

onready var ball = get_node("Data/Ball")
onready var ball_entity = get_node("Entity/Ball")
onready var player = get_node("Data/Player")
onready var player_entity = get_node("Entity/Player")
onready var score = get_node("Entity/Score")
onready var block_prefab = preload("res://scene/block.tscn")

var rest_block = 0
var prev_window_size = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos_norm = event.position.x / prev_window_size.x * 1.2 - 0.1
		player.position.x = clamp(mouse_pos_norm * 240, 30, 210)

func _ready():
	$Data/Wall/Debug.disabled = !DEBUG
	_set_entity_position(OS.get_window_safe_area().size)
	_build_blocks()

func _physics_process(_delta):
	# check game over
	if ball.position.y > 340:
		game_over()
	# check game clear
	if rest_block <= 0 && ball.position.y > 140:
		_build_blocks()
	# change window rect size
	var window_size = OS.get_window_safe_area().size
	if prev_window_size != window_size:
		_set_entity_position(window_size)
	# position
	player_entity.position = Global.o2i(player.position)
	ball_entity.position = Global.o2i(ball.position)

func game_over() -> void:
	set_physics_process(false)
	yield(get_tree().create_timer(1.0), "timeout")
	var _e = get_tree().reload_current_scene()
	

func _set_entity_position(new_pos: Vector2) -> void:
	prev_window_size = new_pos
	$Entity.position = new_pos - Vector2(280, 160) - Vector2(30, 30)

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

