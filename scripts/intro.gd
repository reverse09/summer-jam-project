extends Node2D

@onready var game : PackedScene = preload("res://scenes/game.tscn")
var input_enabled : bool = false

func enable_input():
	input_enabled = true

func _physics_process(_delta):
	if input_enabled:
		if Input.is_action_pressed("swat"):
			get_tree().change_scene_to_packed(game)
