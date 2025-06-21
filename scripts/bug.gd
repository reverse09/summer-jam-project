class_name Bug
extends CharacterBody2D

signal bug_died

const STARTING_HEALTH = 1
@export var speed = 100.0
@export var accel = 4
@export var health = STARTING_HEALTH

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var wave_manager = $"../../WaveManager"

func _physics_process(delta):
	var direction = Vector3()
	var closest_food = null
	var min_dist = INF
	var fly_pos = global_position

	for food in get_tree().get_nodes_in_group("food"):
		var dist = fly_pos.distance_to(food.global_position)
		if dist < min_dist:
			min_dist = dist
			closest_food = food

	nav.target_position = closest_food.global_position

	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed , accel * delta)

	look_at(nav.target_position)
	move_and_slide()

func take_damage():
	health -= 1
	if (health <= 0):
		self.queue_free()
		wave_manager.enemy_death()
	
