extends CharacterBody2D

@export var speed = 20
@export var rotation_speed = 1.5

@export var camera : Camera2D

var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	velocity -= transform.y * Input.get_axis("ui_down", "ui_up") * speed

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	velocity *= 0.95
	move_and_slide()
