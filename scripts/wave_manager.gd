extends Node

@onready var enemy_container: Node = $"../EnemyContainer"

const STARTING_FOOD = 5
const ENEMY_TYPES = {
	## TODO: "scene": null -> preload("res://enemies/something")
	"fly": {
		"scene": preload("res://scenes/fly.tscn"),
		"difficulty": 3,
		"earliest_appearance": 1,
	},
	"beetle": {
		"scene": null,
		"difficulty": 5,
		"earliest_appearance": 2,
	},
	"spider": {
		"scene": null,
		"difficulty": 6,
		"earliest_appearance": 4,
	}
}

var food: int = STARTING_FOOD
var wave: int = 0
var enemy_count: int = 0
var kills: int = 0
var enemy_queue: Array = []
var difficulty_budget: int = 0
var wave_active: bool = false

func _ready():
	randomize()
	start_wave()

func start_wave():
	kills = 0
	enemy_queue = []
	difficulty_budget = 0
	wave += 1
	print("Started Wave " + str(wave))
	difficulty_budget = get_difficulty_budget()
	allocate_difficulty_budget()
	enemy_count = enemy_queue.size()
	
	wave_active = true
	$SpawnTimer.start()
	$WaveTimer.start()

func _process(delta):
	if (wave_active):
		if (kills >= enemy_count):
			win()

func get_difficulty_budget() -> int:
	## TODO: Replace this with something that's fun
	return floor((2) * ((wave) ^ 2)  + 25)
	
	
## Repeatedly pick a random enemy, and if it is valid, add it to enemy queue
func allocate_difficulty_budget():
	var keys = ENEMY_TYPES.keys()
	var key = null
	var value = null
	while (difficulty_budget > 0):
		## Assumes "fly" is the lowest difficulty
		if (difficulty_budget <= ENEMY_TYPES["fly"].difficulty):
			enemy_queue.append("fly")
			difficulty_budget = 0
			continue
		
		key = keys[randi() % keys.size()]
		value = ENEMY_TYPES[key]
		
		if (value["earliest_appearance"] > wave):
			continue
		
		if (value["difficulty"] > difficulty_budget):
			continue
			
		difficulty_budget -= value.difficulty
		enemy_queue.append(key)

func spawn_enemy(key):
	var enemy = ENEMY_TYPES[key].scene.instantiate()
	enemy_container.add_child(enemy)
	print("Spawned: " + key)

func win():
	if (!wave_active):
		return
	
	print("You won the Wave!")
	wave_active=false
	$SpawnTimer.stop()
	$WaveTimer.stop()
	
	$InterimTimer.start()

func lose():
	if (!wave_active):
		return
		
	$SpawnTimer.stop()
	$WaveTimer.stop()
	print("Ran out of time :(")

func _on_spawn_timer_timeout() -> void:
	if (!wave_active):
		return
		
	if (enemy_queue.is_empty()):
		$SpawnTimer.stop()
		return
	
	var key = enemy_queue.pop_front()
	spawn_enemy(key)


func _on_wave_timer_timeout() -> void:
	if (!wave_active):
		return
	
	lose()


func _on_interim_timer_timeout() -> void:
	if (wave_active):
		return
	start_wave()
	$InterimTimer.stop()

func enemy_death():
	if (!wave_active):
		return
	
	kills += 1
	print("Kills: " + str(kills))
