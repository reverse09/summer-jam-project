extends Node

var food_count = 0
var intensity = 0

@export var camera : Camera2D

@export var screen_cracks_1 : Node2D
@export var screen_cracks_2 : Node2D
@export var screen_cracks_3 : Node2D

@export var sfx_stream : AudioStreamPlayer
@export var music_loop : AudioStreamPlayer
@export var voice_stream : AudioStreamPlayer

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
var food_loss_lines = [
	preload("res://sounds/voice lines/food loss 1.WAV"),
	preload("res://sounds/voice lines/food loss 2.WAV"),
	preload("res://sounds/voice lines/food loss 3.WAV"),
	preload("res://sounds/voice lines/food loss 4.WAV"),
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
		music_loop.stream = load("res://sounds/Music Stage 2.mp3")
	elif intensity == 2:
		screen_cracks_1.visible = false
		screen_cracks_2.visible = true
		music_loop.stream = load("res://sounds/Music Stage 3.mp3")
	elif intensity == 3:
		screen_cracks_2.visible = false
		screen_cracks_3.visible = true
		music_loop.stream = load("res://sounds/Music Stage 4.mp3")
	elif intensity == 4:
		music_loop.stream = load("res://sounds/Game Over Music.wav")
	music_loop.play()

func play_sound(sound_path):
	var full_sound_path = "res://sounds/" + sound_path
	var sound = load(full_sound_path)
	sfx_stream.stream = sound
	sfx_stream.play()

func play_bug_kill_line():
	if voice_stream.playing:
		return
	if int(RandomNumberGenerator.new().randf_range(1,5)) != 1:
		return
	await get_tree().create_timer(0.3).timeout
	var random_index = randi() % bug_kill_lines.size()
	voice_stream.stream = bug_kill_lines[random_index]
	voice_stream.play()

func play_round_end_line():
	voice_stream.stop()
	await get_tree().create_timer(0.3).timeout
	var random_index = randi() % round_end_lines.size()
	voice_stream.stream = round_end_lines[random_index]
	voice_stream.play()

func play_food_loss_line():
	voice_stream.stop()
	await get_tree().create_timer(0.3).timeout
	var random_index = randi() % food_loss_lines.size()
	voice_stream.stream = food_loss_lines[random_index]
	voice_stream.play()
