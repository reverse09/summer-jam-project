extends Node

var rich_text_label: $RichTextLabel

func _ready():
	SceneTree.create_timer(0.2)

func _on_Timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rich_text_label.set_text(char(rng.randi_range(33, 126)))
