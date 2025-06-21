class_name Bug
extends CharacterBody2D

signal bug_died

@export var STARTING_HEALTH = 1
@onready var health = STARTING_HEALTH
@export var speed = 100.0
@export var accel = 4
@export var wobble = 10
@export var wobble_period = 2
@export var crack_coefficient = 0.1

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var wave_manager = $"../../WaveManager"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $Sprite2D

var direction_to_food : Vector2
var lifetime: float
@export var cracking: float = 0.0

func increment_lifetime(delta):
	lifetime += delta

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
	
func wobble_bug():
	var scalar = sin(lifetime * (2 * PI) / wobble_period)
	var perpendicular = Vector2(-direction_to_food.y, direction_to_food.x)
	direction_to_food = (direction_to_food + perpendicular * scalar).normalized()

func take_damage():
	health -= 1
	if (health > 0):
		cracking += crack_coefficient
	if (health <= 0):
		animation_player.play("crack")
		wave_manager.enemy_death()

func update_sprite():
	sprite.material.set_shader_parameter("progress", cracking)
	pass
