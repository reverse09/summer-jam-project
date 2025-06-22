extends Bug
class_name Stinkbug

@onready var enemy_container = $"../../EnemyContainer"
var STINK_CLOUD_SCENE = preload("res://scenes/stink_cloud.tscn")
var STINK_CLOUD_ALPHA = 0.4
var spawned_cloud = false

func spawn_cloud():
	if (spawned_cloud == true):
		return
		
	if (health <= 0):
		var stink_cloud = STINK_CLOUD_SCENE.instantiate()
		stink_cloud.position = position
		stink_cloud.modulate.a = STINK_CLOUD_ALPHA
		enemy_container.add_child(stink_cloud)
		for child in stink_cloud.get_children():
			if child is Timer:
				child.start()
		spawned_cloud = true
		
		
	

func _physics_process(delta):
	increment_lifetime(delta)
	find_food()
	wobble_bug()
	run_with_food()
	update_sprite()
	spawn_cloud()
	
	move(delta)

func move(delta: float):
	velocity = direction_to_food * speed
	look_at(nav.target_position)
	move_and_slide()
