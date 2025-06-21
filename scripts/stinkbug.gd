extends Bug
class_name Stinkbug

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
