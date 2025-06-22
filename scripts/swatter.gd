extends Area2D
class_name Swatter

@onready var animation_sprite = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var swat_sfx: AudioStreamPlayer2D = $SwatSFX
@onready var confusion_timer: Timer = $ConfusionTimer

var mouse_position
var confused: bool = false

func enable_confusion():
	if (confused):
		return
	
	confused = true
	confusion_timer.start()

func swat():
	var bodies: Array[Node2D] = get_overlapping_bodies()
	for body in bodies:
		if body is Bug:
			body.take_damage()
			
	animation_sprite.play("swat")
	swat_sfx.play()

func _process(delta):

	mouse_position = get_global_mouse_position()
	if (confused):
		position = -mouse_position
		##position = (-1 * mouse_position) + origin_position + origin_position
	else:
		position = mouse_position
	
	if Input.is_action_just_pressed("swat"):
		swat()
		

func _on_confusion_timer_timeout() -> void:
	confusion_timer.stop()
	confused = false
