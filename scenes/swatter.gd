extends StaticBody2D

@onready var animation_sprite = $AnimatedSprite2D

var mouse_position

func _process(delta):
	mouse_position = get_global_mouse_position()
	position = mouse_position
	
	if Input.is_action_just_pressed("swat"):
		animation_sprite.play("swat")
		
	
	
	
