extends ColorRect

@onready var retry_button = %RetryButton

signal retry()
signal main_menu()

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
	retry.emit()


func _on_next_level_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	main_menu.emit()


func _on_resume_button_pressed():
	get_tree().paused = false
	hide()
