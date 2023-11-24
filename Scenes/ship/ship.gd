extends CharacterBody2D

@export var speed = 20
@export var rotation_speed = 1.5

@export var camera : Camera2D
@onready var animated_sprite = $AnimatedSprite

var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	velocity -= transform.y * Input.get_axis("ui_down", "ui_up") * speed

func handle_animations():
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		animated_sprite.play("fire")
	else:
		animated_sprite.play("default")

func _physics_process(delta):
	get_input()
	handle_animations()
	rotation += rotation_direction * rotation_speed * delta
	velocity *= 0.95
	move_and_slide()

