extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

<<<<<<< Updated upstream
signal checkpoint_activated(global_position) 



func _on_body_entered(body):
	animated_sprite_2d.play("Active")
	emit_signal("checkpoint_activated")
=======
func _on_body_entered(body):
	animated_sprite_2d.play("Active")
	body.set_spawn(global_position)
>>>>>>> Stashed changes
