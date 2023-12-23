extends ColorRect

@onready var retry_button = %RetryButton
@onready var resume_button = %ResumeButton
@onready var pause_menu_tab = %PauseMenuTab
@onready var options_menu_tab = %OptionsMenuTab
@onready var anti_gravity_check = %AntiGravityCheck

signal retry()
signal main_menu()
signal map_screen()

func _ready():
	anti_gravity_check.button_pressed = Globals.invert_anti_gravity_controls

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Pause")
		if visible == false:
			get_tree().paused = true
			show()
			resume_button.grab_focus()
		else:
			get_tree().paused = false
			hide()

func _on_retry_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/Screens/main_menu.tscn")
	get_tree().paused = false


func _on_resume_button_pressed():
	get_tree().paused = false
	hide()


func _on_map_screen_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/Levels/MapScreen.tscn")
	get_tree().paused = false


func _on_options_pressed():
	pause_menu_tab.hide()
	options_menu_tab.show()


func _on_back_button_pressed():
	options_menu_tab.hide()
	pause_menu_tab.show()


func _on_anti_gravity_check_pressed():
	Globals.invert_anti_gravity_controls = !Globals.invert_anti_gravity_controls
