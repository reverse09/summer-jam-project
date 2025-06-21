class_name Bug
extends CharacterBody2D

signal bug_died

const STARTING_HEALTH = 1
@export var speed = 100.0
@export var accel = 4
@export var health = STARTING_HEALTH
@export var crack_coefficient = 0.1

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var wave_manager = $"../../WaveManager"

var direction_to_food : Vector2

func find_food():
	var closest_food = null
	var min_dist = INF
	var fly_pos = global_position

	for food in get_tree().get_nodes_in_group("food"):
		var dist = fly_pos.distance_to(food.global_position)
		if dist < min_dist:
			min_dist = dist
			closest_food = food

	nav.target_position = closest_food.global_position

	direction_to_food = nav.get_next_path_position() - global_position
	direction_to_food = direction_to_food.normalized()

func take_damage():
	health -= 1
	if (health <= 0):
		self.queue_free()
		wave_manager.enemy_death()
	
