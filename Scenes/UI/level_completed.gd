extends ColorRect

@onready var next_level_button = %NextLevelButton
@onready var retry_button = %RetryButton
@onready var hearts = $CenterContainer/VBoxContainer/Hearts
@onready var time = $CenterContainer/VBoxContainer/Time
@onready var level_goal_time = $CenterContainer/VBoxContainer/LevelGoalTime
@onready var score = $CenterContainer/VBoxContainer/Score

signal retry()
signal next_level()

func show_data(heartsCollected, heartsMax, level_time, level_best_time):
	hearts.text += str(heartsCollected)+"/"+str(heartsMax)
	time.text += str(level_time)
	level_goal_time.text += str(level_best_time)
	score.text += str(calculate_score(heartsCollected, level_time, level_best_time))
	

func calculate_score(heartsCollected, level_time, level_best_time):
	var score := 0.0
	print(level_time-level_best_time)
	score += heartsCollected*200 
	if level_time < level_best_time:
		score+=abs(level_time-level_best_time)*50
	
	return score

func _on_retry_button_pressed():
	retry.emit()


func _on_next_level_button_pressed():
	next_level.emit()


func show_yourself():
	show()
	$AnimationPlayer.play("show")
