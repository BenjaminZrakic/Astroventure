extends Node

@onready var player = $"../Player"
@onready var timer = $"../Timer"
@onready var level_time_label = %LevelTimeLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	level_time_label.text = timer.time_left


func _on_timer_timeout():
	player.queue_free()


func _on_area_2d_body_entered(body):
	timer.stop()


func _on_area_2d_body_exited(body):
	timer.start()
