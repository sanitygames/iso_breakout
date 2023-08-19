extends KinematicBody2D

signal on_collision(collider)

export var MAX_SPEED := 400
export var ADD_SPEED := 2

var INITIAL_POSITION := Vector2(120, 230)
var INITIAL_DIRECTION := Vector2(1, -1).normalized()
var INITIAL_SPEED := 40.0

var direction = INITIAL_DIRECTION
var speed := INITIAL_SPEED

onready var entity = get_tree().root.get_node("Game/Entity/Ball")

func _physics_process(delta):
	var velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.is_in_group("player"):
			direction = clamp_angle((position - collision.collider.position).normalized())
		else:
			direction = clamp_angle(direction.bounce(collision.normal))

		speed = min(MAX_SPEED, speed + ADD_SPEED)
		emit_signal("on_collision", collision.collider)

	entity.position = Global.o2i(position)

	if position.y > 400:
		var _e = get_tree().reload_current_scene()


func reset() -> void:
	position = INITIAL_POSITION
	direction = INITIAL_DIRECTION
	speed = INITIAL_SPEED

func clamp_angle(v: Vector2) -> Vector2:
		var clamp_sin_abs = clamp(abs(v.y), sin(20.0 / 180 * PI), sin(70.0 / 180 * PI)) 
		var clamp_cos = cos(asin(clamp_sin_abs))
		return Vector2(sign(v.x) * clamp_cos, clamp_sin_abs * sign(v.y)).normalized()
