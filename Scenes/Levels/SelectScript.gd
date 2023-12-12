extends Area2D

@export var level : PackedScene
@export var speed = 20

@onready var path : PathFollow2D = get_parent() as PathFollow2D
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var marker = %Marker
@onready var label = %Label
@export var ship : CharacterBody2D 
@onready var UI := get_tree().get_root().get_node("MapScreen/UI") as CanvasLayer

func _ready():
	print(UI)

func _process(delta):
	path.set_progress(path.get_progress() + speed * delta)
	if not visible_on_screen_notifier_2d.is_on_screen():
		label.visible = true
		var direction_to_planet = ship.global_position.direction_to(global_position)

		marker.position.x = clamp(direction_to_planet.x*360,0+20,360-10)
		marker.position.y = clamp(direction_to_planet.y*180,0,180-10)
		#print(label.text +": "+ str(marker.position))
	else:
		label.visible = false

func _physics_process(delta):
	if has_overlapping_bodies():
		if Input.is_action_just_released("ui_accept"):
			get_tree().paused=true
			UI.pass_parameters(level)
			
			
			
