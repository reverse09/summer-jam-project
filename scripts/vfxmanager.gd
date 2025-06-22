extends Node

var food_count = 0
var intensity = 0

@export var camera : Camera2D

@export var screen_cracks_1 : Node2D
@export var screen_cracks_2 : Node2D
@export var screen_cracks_3 : Node2D

var bug_kill_lines = [
	preload("res://sounds/voice lines/bug kill 1.WAV"),
	preload("res://sounds/voice lines/bug kill 2.WAV"),
	preload("res://sounds/voice lines/bug kill 3.WAV"),
	preload("res://sounds/voice lines/bug kill 4.WAV"),
	preload("res://sounds/voice lines/bug kill 5.WAV"),
	preload("res://sounds/voice lines/bug kill 6.WAV"),
	preload("res://sounds/voice lines/bug kill 7.WAV")
]
var round_end_lines = [
	preload("res://sounds/voice lines/round end 1.WAV"),
	preload("res://sounds/voice lines/round end 2.WAV"),
	preload("res://sounds/voice lines/round end 3.WAV"),
	preload("res://sounds/voice lines/round end 4.WAV"),
	preload("res://sounds/voice lines/round end 5.WAV")
]

func _process(delta):
	
	var old_food_count = food_count
	food_count = get_tree().get_nodes_in_group("food").size()

	if food_count < old_food_count:
		intensity += 1
		update_cracks()
		camera.apply_shake()
		print("intensity: " + str(intensity))

func update_cracks():

	if intensity == 0 :
		screen_cracks_1.visible = false
		screen_cracks_2.visible = false
		screen_cracks_3.visible = false
	elif intensity == 1:
		screen_cracks_1.visible = true
	elif intensity == 2:
		screen_cracks_1.visible = false
		screen_cracks_2.visible = true
	elif intensity == 3:
		screen_cracks_2.visible = false
		screen_cracks_3.visible = true

#Camera Shake



