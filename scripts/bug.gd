class_name Bug
extends CharacterBody2D

signal bug_died

const GRAB_DISTANCE = 35
const SWITCH_POSITION_MAX_DISTANCE = 100
const SWITCH_POSITION_MIN_DISTANCE = 300
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
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area2d: Area2D = $Area2D

var exit_position = null
var holding_food: bool = false
var direction_to_food : Vector2
var lifetime: float
var exits: Array[Vector2] = [Vector2(400, 0), Vector2(400, 350), Vector2(0, 350), Vector2(-400, 350), Vector2(-400, 0), Vector2(-400, -350), Vector2(0, -350), Vector2(400, -350)]
@export var cracking: float = 0.0

func increment_lifetime(delta):
	lifetime += delta

func find_food():
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
			food.collision_shape_2d.disabled = true
			food.get_parent().remove_child(food)
			food.position = Vector2(-10, 0)
			self.add_child(food)
			food.search_target = false
			holding_food = true
			return
		if dist < min_dist:
			min_dist = dist
			closest_food = food
	
	if (closest_food == null):
		if (position.distance_to(nav.target_position) < SWITCH_POSITION_MAX_DISTANCE or position.distance_to(nav.target_position) > SWITCH_POSITION_MIN_DISTANCE):
			nav.target_position = Vector2(randi() % 300 - 150, randi() % 300 - 150)
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
	
	if (self.position.x > 325 or self.position.x < -325 or self.position.y > 240 or self.position.y < -240):
		self.escape()
	
	if (exit_position == null):
		var distance = INF
		for exit in exits:
			var current = self.position.distance_to(exit)
			if (current < distance):
				exit_position = exit
				distance = current
			
	
	if (speed == STARTING_SPEED):
		var factor = (1.0/12.0 + (1.0/80.0) * (wave_manager.wave + 1.0))
		print(factor)
		speed = STARTING_SPEED * factor
	
	nav.target_position = exit_position
	direction_to_food = nav.get_next_path_position() - global_position
	direction_to_food = direction_to_food.normalized()

func take_damage():
	if (!(self is Firefly)):
		var overlapping = area2d.get_overlapping_areas()
		if (overlapping.size() > 0):
			for area in overlapping:
				if area is Firefly_Light:
					return
	health -= 1
	if (health > 0):
		cracking += crack_coefficient
	if (health <= 0):
		holding_food = true
		collision_shape_2d.disabled = true
		for child in self.get_children():
			if child is Food:
				self.remove_child(child)
				food_container.add_child(child)
				child.position = self.position
				child.search_target = true
		wave_manager.enemy_death()
		wave_manager.vfx.play_bug_kill_line()
		animation_player.play("crack")

func update_sprite():
	sprite.material.set_shader_parameter("progress", cracking)

func escape():
	if holding_food:
		wave_manager.enemy_death()
		wave_manager.vfx.play_sound("losefood.wav")
		wave_manager.vfx.play_food_loss_line()
		wave_manager.vfx.show_warning()
		queue_free()
