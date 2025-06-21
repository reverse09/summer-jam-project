extends Bug
class_name Firefly

var FIREFLY_LIGHT_SCENE = preload("res://scenes/firefly_light.tscn")
var FIREFLIGHT_ALPHA = 0.4

func _init():
	var firefly_light = FIREFLY_LIGHT_SCENE.instantiate()
	firefly_light.modulate.a = FIREFLIGHT_ALPHA
	self.add_child(firefly_light)

func _physics_process(delta):
	increment_lifetime(delta)
	find_food()
	wobble_bug()
	run_with_food()
	update_sprite()
	
	move(delta)

func move(delta: float):
	velocity = direction_to_food * speed
	look_at(nav.target_position)
	move_and_slide()
