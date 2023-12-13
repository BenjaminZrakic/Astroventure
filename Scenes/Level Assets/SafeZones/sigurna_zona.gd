extends Area2D

@export var playerSafe = false
@onready var dayNightCycle = get_tree().get_root().get_node("Mercury/CanvasLayer3/DayNightCycle")


func _on_body_entered(body):
	if body.is_in_group("Player"):
		dayNightCycle._set_playerSafe(true)
		print("player safe")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		dayNightCycle._set_playerSafe(false)
		print("player isnt safe")
