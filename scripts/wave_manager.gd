extends Node

@export var vfx : Node

@onready var enemy_container: Node = $"../EnemyContainer"
@onready var food_container: Node = $"../FoodContainer"
@onready var food_spawn_region: Node =  $"../FoodSpawnRegion"
@onready var music_loop: AudioStreamPlayer = $"../Music/MusicLoop"
@onready var fail_animation: AnimationPlayer = $"../Failscreen/FailAnimation"
@onready var game = preload("res://scenes/game.tscn")
@onready var number_label: RichTextLabel = $NumberLabel

const STARTING_FOOD = 4
const BUG_SPAWN_OFFSET = 400
const FOOD_SCENE = preload("res://scenes/food.tscn")
const ENEMY_TYPES = {
	## TODO: "scene": null -> preload("res://enemies/something")
	"fly": {
		"scene": preload("res://scenes/fly.tscn"),
		"difficulty": 3,
		"earliest_appearance": 1,
	},
	"beetle": {
		"scene": preload("res://scenes/beetle.tscn"),
		"difficulty": 5,
		"earliest_appearance": 2,
	},
	"firefly": {
		"scene": preload("res://scenes/firefly.tscn"),
		"difficulty": 5,
		"earliest_appearance": 6,
	},
	"stinkbug": {
		"scene": preload("res://scenes/stinkbug.tscn"),
		"difficulty": 5,
		"earliest_appearance": 8,
	},
	"spider": {
		"scene": preload("res://scenes/spider.tscn"),
		"difficulty": 4,
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
var failed: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	spawn_food()
	start_wave()

func start_music_loop():
	music_loop.play()

func spawn_food():
	var rect = food_spawn_region.get_child(0).shape.get_rect()
	
	for n in food:
		var food_instance: Node = FOOD_SCENE.instantiate()
		var position = Vector2(((randi() % int(rect.size.x)) + rect.position.x),((randi() % int(rect.size.y)) + rect.position.y))
		food_instance.position = position
		food_container.add_child(food_instance)
	

func start_wave():
	kills = 0
	enemy_queue = []
	difficulty_budget = 0
	wave += 1
	print("Started Wave " + str(wave))
	number_label.text = "[center]" + str(wave) + "[/center]"
	difficulty_budget = get_difficulty_budget()
	allocate_difficulty_budget()
	enemy_count = enemy_queue.size()
	
	wave_active = true
	$SpawnTimer.start()
	$WaveTimer.start()

func _process(delta):
	check_food()
	if (wave_active):
		if (kills >= enemy_count):
			win()

func get_difficulty_budget() -> int:
	## TODO: Replace this with something that's fun
	return floor((45/(1 + (pow(2.718,-0.9 * (wave - 5))))) + wave + 5)
	
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
	var position = Vector2.RIGHT.rotated(randf() * TAU) * BUG_SPAWN_OFFSET
	enemy.position = position
	enemy_container.add_child(enemy)
	print("Spawned: " + key)

func win():
	if (!wave_active):
		return
	
	print("You won the Wave!")
	vfx.play_round_end_line()
	wave_active=false
	$SpawnTimer.stop()
	$WaveTimer.stop()
	
	$InterimTimer.start()

func lose():
	if (!wave_active):
		return
	print("Ran out of time :(")
	fail()

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
	vfx.play_sound("flydeath.wav")
	print("Kills: " + str(kills))

func check_food():
	if get_tree().get_nodes_in_group("food").size() == 0 and not failed:
		fail()

func fail():
	wave_active = false
	$SpawnTimer.stop()
	$WaveTimer.stop()
	fail_animation.play("fail")
	failed = true
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(game)
