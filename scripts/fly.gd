extends Bug

func _physics_process(delta):
	find_food()
	move(delta)

func move(delta: float):
	velocity = velocity.lerp(direction_to_food * speed, accel * delta)
	look_at(nav.target_position)
	move_and_slide()
