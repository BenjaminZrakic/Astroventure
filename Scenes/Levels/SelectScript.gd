extends Area2D

@export var level : PackedScene


var rotation_direction = 0


func _physics_process(delta):
	if has_overlapping_bodies():
		if Input.is_action_just_released("ui_accept"):
			get_tree().change_scene_to_packed(level)
