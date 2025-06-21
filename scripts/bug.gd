class_name Bug
extends CharacterBody2D

signal bug_died

const GRAB_DISTANCE = 30
@export var STARTING_HEALTH = 1
@onready var health = STARTING_HEALTH
@export var STARTING_SPEED = 100.0
@onready var speed = STARTING_SPEED
@export var accel = 4
@export var wobble = 10
@export var wobble_period = 2
@export var crack_coefficient = 0.1

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var wave_manager = $"../../WaveManager"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var food_container = $"../../FoodContainer"

var starting_position = null
var holding_food: bool = false
var direction_to_food : Vector2
var lifetime: float
@export var cracking: float = 0.0

func increment_lifetime(delta):
	lifetime += delta

func find_food():
	if (starting_position == null):
		starting_position = self.position
	
	if (holding_food):
		return
	
	if (speed != STARTING_SPEED):
		speed = STARTING_SPEED
		
	var closest_food = null
	var min_dist = INF
	var fly_pos = global_position

	for food in get_tree().get_nodes_in_group("food"):
		if (food.search_target == false):
			continue
		var dist = fly_pos.distance_to(food.global_position)
		if dist < GRAB_DISTANCE:
			food.get_child(0).disabled = true
			food.get_parent().remove_child(food)
			food.position = Vector2.ZERO
			self.add_child(food)
			food.search_target = false
			holding_food = true
			return
		if dist < min_dist:
			min_dist = dist
			closest_food = food
	
	if (closest_food == null):
		nav.target_position = Vector2.ZERO
	else:
		nav.target_position = closest_food.global_position
	

	direction_to_food = nav.get_next_path_position() - global_position
	direction_to_food = direction_to_food.normalized()
	
func wobble_bug():
	if (holding_food):
		return
	
	var scalar = sin(lifetime * (2 * PI) / wobble_period)
	var perpendicular = Vector2(-direction_to_food.y, direction_to_food.x)
	direction_to_food = (direction_to_food + perpendicular * scalar).normalized()
	
func run_with_food():
	if (!holding_food):
		return
	if (speed == STARTING_SPEED):
		speed = STARTING_SPEED / 4
	nav.target_position = starting_position
	direction_to_food = nav.get_next_path_position() - global_position
	direction_to_food = direction_to_food.normalized()

func take_damage():
	health -= 1
	if (health > 0):
		cracking += crack_coefficient
	if (health <= 0):
		for child in self.get_children():
			if child is Food:
				self.remove_child(child)
				food_container.add_child(child)
				child.position = self.position
				child.search_target = true
		wave_manager.enemy_death()
		animation_player.play("crack")

func update_sprite():
	sprite.material.set_shader_parameter("progress", cracking)
