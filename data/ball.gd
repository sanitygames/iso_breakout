extends KinematicBody2D

signal on_collision(collider)

export var MAX_SPEED := 800
export var ADD_SPEED := 2
export var MIN_BALL_ANGLE := 20.0
export var MAX_BALL_ANGLE := 80.0

var INITIAL_POSITION := Vector2(120, 230)
var INITIAL_DIRECTION := Vector2(1, -1).normalized()
var INITIAL_SPEED := 60.0

var direction = INITIAL_DIRECTION
var speed := INITIAL_SPEED

func _physics_process(delta):
	var velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.is_in_group("player"):
			direction = (position - collision.collider.position).normalized()
		else:
			direction = direction.bounce(collision.normal)

		direction = clamp_angle(direction)
		speed = min(MAX_SPEED, speed + ADD_SPEED)
		emit_signal("on_collision", collision.collider)

func reset() -> void:
	position = INITIAL_POSITION
	direction = INITIAL_DIRECTION
	speed = INITIAL_SPEED

func clamp_angle(v: Vector2) -> Vector2:
		var clamp_sin_abs = clamp(abs(v.y), sin(MIN_BALL_ANGLE / 180 * PI), sin(MAX_BALL_ANGLE / 180 * PI)) 
		var clamp_cos = cos(asin(clamp_sin_abs))
		return Vector2(sign(v.x) * clamp_cos, clamp_sin_abs * sign(v.y)).normalized()
