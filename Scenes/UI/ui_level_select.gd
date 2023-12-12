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
			planet_info.text = "My name is Yoshikage Kira. I'm 33 years old. My house is in the northeast section of Morioh, where all the villas are, and I am not married. I work as an employee for the Kame Yu department stores, and I get home every day by 8 PM at the latest. I don't smoke, but I occasionally drink. I'm in bed by 11 PM, and make sure I get eight hours of sleep, no matter what. After having a glass of warm milk and doing about twenty minutes of stretches before going to bed, I usually have no problems sleeping until morning. Just like a baby, I wake up without any fatigue or stress in the morning. I was told there were no issues at my last check-up. I'm trying to explain that I'm a person who wishes to live a very quiet life. I take care not to trouble myself with any enemies, like winning and losing, that would cause me to lose sleep at night. That is how I deal with society, and I know that is what brings me happiness. Although, if I were to fight I wouldn't lose to anyone."
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
