extends Node2D

@onready var path = $Path2D/PathFollow2D
@export var speed = 100

var reverse = false

func _process(delta):
	if not reverse:
		path.set_progress(path.get_progress() + speed * delta)
		if path.progress_ratio == 1:
			reverse = true
	else:
		path.set_progress(path.get_progress() - speed * delta)
		if path.progress_ratio == 0:
			reverse = false
		
