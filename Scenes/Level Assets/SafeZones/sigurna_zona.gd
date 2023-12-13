extends Area2D

@export var playerSafe = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		playerSafe = true
		print("player safe")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		playerSafe = false
		print("player isnt safe")
