extends StaticBody2D

var mouse_position

func _process(delta):
	mouse_position = get_global_mouse_position()
	position = mouse_position
