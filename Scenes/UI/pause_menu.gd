extends ColorRect

@onready var retry_button = %RetryButton

signal retry()
signal main_menu()

func _on_retry_button_pressed():
	retry.emit()


func _on_next_level_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	main_menu.emit()
