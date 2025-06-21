extends Node2D

@export var STARTING_FOOD = 5
@export var WAVE_DURATION_SECONDS = 45
var ENEMY_TYPES = {
	"fly": {
		"scene": null,
		"difficulty": 1
	},
	"spider": {
		"scene": null,
		"difficulty": 2
	}
}

func _init():
	var food: int = STARTING_FOOD
	var wave: int = 0
	var enemy_count: int = 0

func start_wave():
	return 
	
