extends CanvasLayer

@onready var begin_button = %BeginButton
@onready var abort_button = %AbortButton
@onready var animation_player = $AnimationPlayer
@onready var planet = %Planet
@onready var planet_info = %planet_info
@onready var text_timer = $TextTimer


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

var print_text = false
@export var print_speed = 0.001

func pass_parameters(level : PackedScene, sprite_frames : SpriteFrames, planet_name):
	next_level = level
	planet.sprite_frames = sprite_frames
	planet.play("default")
	match planet_name:
		PlanetNames.Mercury:
			planet_info.text = "Hello this is Earth speaking. 								  You are entering Mercurys orbit. Mercury is planet that is closest to the Sun. So be aware of the heat. You will feel that gravity is much weaker than gravity on Earth, but that shouldn't be a problem. Also, very helpful, Mercury has no atmosphere at all, so metheors can be an issue. 			Collect that element and come home safe. Good luck commander."
			
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
		
		
	#print_text()
	planet_info.visible_characters=0
	show()
	text_timer.start()
	#print_text = true
	#animation_player.play("AnimateText")
	
func _process(delta):
	if print_text:
		planet_info.visible_characters+=1
		if planet_info.visible_ratio==1.0:
			print_text= false

func _on_begin_button_button_up():
	await LevelTransition.fade_to_black()
	if not next_level is PackedScene: get_tree().change_scene_to_file("res://Scenes/Screens/victory_screen.tscn")
	else: get_tree().change_scene_to_packed(next_level)
	#LevelTransition.fade_from_black()
	get_tree().paused = false


func _on_abort_button_button_up():
	hide()
	print_text= false
	get_tree().paused = false




func _on_timer_timeout():
	planet_info.visible_characters+=1
