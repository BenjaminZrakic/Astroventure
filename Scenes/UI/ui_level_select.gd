extends CanvasLayer

@onready var begin_button = %BeginButton
@onready var abort_button = %AbortButton
@onready var animation_player = $AnimationPlayer

@export var next_level: PackedScene

func pass_parameters(level : PackedScene):
	next_level = level
	show()
	animation_player.play("AnimateText")
	



func _on_begin_button_button_up():
	await LevelTransition.fade_to_black()
	if not next_level is PackedScene: get_tree().change_scene_to_file("res://Scenes/Screens/victory_screen.tscn")
	else: get_tree().change_scene_to_packed(next_level)
	#LevelTransition.fade_from_black()
	get_tree().paused = false


func _on_abort_button_button_up():
	hide()
	get_tree().paused = false
