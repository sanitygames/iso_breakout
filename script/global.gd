extends Node

var window_size = Vector2.ZERO

# convert orthographic to isometric
func o2i(pos: Vector2) -> Vector2:
	var iso_norm = Vector2(pos.x - pos.y, 0.5 * (pos.x + pos.y))
	return iso_norm * 0.50  + Vector2(160, 10)