extends Area2D
signal swatted_enemy

@onready var animation_sprite = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var swat_sfx: AudioStreamPlayer2D = $SwatSFX

var mouse_position

func swat():
	var bodies: Array[Node2D] = get_overlapping_bodies()
	for body in bodies:
		if body is Bug:
			body.queue_free()
			emit_signal("swatted_enemy")
	animation_sprite.play("swat")
	swat_sfx.play()

func _process(delta):
	mouse_position = get_global_mouse_position()
	position = mouse_position
	
	if Input.is_action_just_pressed("swat"):
		swat()
		
	
	
	
