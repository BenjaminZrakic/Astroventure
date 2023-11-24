extends Area2D

@export var level : PackedScene
@export var speed = 20

@onready var path : PathFollow2D = get_parent() as PathFollow2D
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var marker = %Marker
@onready var label = %Label
@export var ship : CharacterBody2D 


func _process(delta):
	path.set_progress(path.get_progress() + speed * delta)
	if not visible_on_screen_notifier_2d.is_on_screen():
		label.visible = true
		var direction_to_planet = ship.global_position.direction_to(global_position)

		marker.position.x = clamp(direction_to_planet.x*330,0+20,360-10)
		marker.position.y = clamp(direction_to_planet.y*170,0,180-10)
		#print(label.text +": "+ str(marker.position))
	else:
		label.visible = false

func _physics_process(delta):
	if has_overlapping_bodies():
		if Input.is_action_just_released("ui_accept"):
			get_tree().change_scene_to_packed(level)
