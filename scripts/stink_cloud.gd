extends Area2D
class_name Stink_Cloud

const HOVER_THRESHOLD = 0.5
var hover_frames: float = 0
@onready var area2d: Area2D = $Area2D
@onready var destruction_timer: Timer = $DestructionTimer
@onready var swatter: Swatter = $"../../Swatter"

func _process(delta: float) -> void:
	var overlapping = area2d.get_overlapping_areas()
	if (overlapping.size() <= 0):
		hover_frames = 0
		return
	
	if (hover_frames > HOVER_THRESHOLD):
		swatter.enable_confusion()
	
	for area in overlapping:
		if (area is Swatter):
			hover_frames += delta

func _on_destruction_timer_timeout() -> void:
	destruction_timer.stop()
	self.queue_free()
