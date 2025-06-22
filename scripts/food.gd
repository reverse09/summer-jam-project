extends StaticBody2D
class_name Food

var search_target = true
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var sprites = [preload("res://assets/apple.tres"), preload("res://assets/cherry.tres"), preload("res://assets/grape.tres"), preload("res://assets/orange.tres")]


func _ready():
	animated_sprite_2d.sprite_frames = sprites[randi() % sprites.size()]
	animated_sprite_2d.play("default")
	var total= animated_sprite_2d.sprite_frames.get_frame_count("default")
	animated_sprite_2d.frame = randi() % total
	
