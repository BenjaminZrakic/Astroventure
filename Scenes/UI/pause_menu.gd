extends ColorRect

@onready var retry_button = %RetryButton

signal retry()
signal main_menu()
signal map_screen()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Pause")
		if visible == false:
			get_tree().paused = true
			show()
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
