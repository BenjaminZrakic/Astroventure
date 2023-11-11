extends Node2D


@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel

@export var next_level: PackedScene

var level_time = 0.0
var start_level_msec = 0.0


func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_level_msec = Time.get_ticks_msec() #vrijeme od pocetka u ms
	if not next_level is PackedScene:
		level_completed.next_level_button.text = "Victory screen"

func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msec
	level_time_label.text = str(level_time / 1000.0)

func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true

func go_to_next_level():
	await LevelTransition.fade_to_black()
	if not next_level is PackedScene: get_tree().change_scene_to_file("res://Scenes/victory_screen.tscn")
	else: get_tree().change_scene_to_packed(next_level)
	#LevelTransition.fade_from_black()
	get_tree().paused = false

func _on_level_completed_retry():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	
