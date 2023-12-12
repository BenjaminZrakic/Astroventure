extends CanvasLayer

@onready var begin_button = %BeginButton
@onready var abort_button = %AbortButton
@onready var animation_player = $AnimationPlayer
@onready var planet = %Planet
@onready var planet_info = %planet_info


@export var next_level: PackedScene

enum PlanetNames{
	Mercury,
	Venus,
	Earth,
	Mars,
	Jupiter,
	Saturn,
	Uranus,
	Neptune
}

func pass_parameters(level : PackedScene, sprite_frames : SpriteFrames, planet_name):
	next_level = level
	planet.sprite_frames = sprite_frames
	planet.play("default")
	match planet_name:
		PlanetNames.Mercury:
			planet_info.text = "Hello this is Mercury speaking"
		PlanetNames.Venus:
			planet_info.text = "Hello this is Venus speaking"
		PlanetNames.Earth:
			planet_info.text = "Hello this is Earth speaking"
		PlanetNames.Mars:
			planet_info.text = "Hello this is Mars speaking"
		PlanetNames.Jupiter:
			planet_info.text = "Hello this is Jupiter speaking"
		PlanetNames.Saturn:
			planet_info.text = "Hello this is Saturn speaking"
		PlanetNames.Uranus:
			planet_info.text = "Hello this is Uranus speaking"
		PlanetNames.Neptune:
			planet_info.text = "Hello this is Neptune speaking"
		
		
	
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
