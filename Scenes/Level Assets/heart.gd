extends Area2D

@onready var animation_player = $AnimationPlayer

@onready var starting_position = global_position
@onready var pickup_delay = $PickupDelay

var follow_player = false
var speed = 20
#@onready var player = get_tree().get_root().get_node("World/Player")
@onready var collision_shape_2d = $CollisionShape2D
var heart_location
var player
var can_pick_up = false
var picking_up = false

func _ready():
	Events.pickup_hearts.connect(pickup)
	Events.player_dead.connect(reset_position)

func _physics_process(delta):
	if !picking_up:
		if !follow_player and global_position!=starting_position:
			global_position = global_position.lerp(starting_position, 0.08)
		if follow_player and heart_location != null:
			#print("Following player, hopefully")
			global_position = global_position.lerp(heart_location.global_position, 0.08)
			if player.GravityDirection == player.GravityDirections.DOWN:
				rotation_degrees = 0
			elif player.GravityDirection == player.GravityDirections.UP:
				rotation_degrees = 180
			elif player.GravityDirection == player.GravityDirections.RIGHT:
				rotation_degrees = -90
			elif player.GravityDirection == player.GravityDirections.LEFT:
				rotation_degrees = 90

func _on_body_entered(body):
	player = body
	heart_location = Marker2D.new()
	player.hearts_container.add_child(heart_location)
	heart_location.position = Vector2(player.heart_counter*-13,player.heart_counter*-3)
	player.heart_counter += 1
	follow_player = true
	collision_shape_2d.set_deferred("disabled", true)
	pickup_delay.start()
	
	

func reset_position():
	if follow_player == true:
		#global_position = starting_position
		follow_player = false
		collision_shape_2d.set_deferred("disabled", false)
		heart_location.queue_free()
		rotation_degrees = 0


func pickup():
	print("Picking up hearts")
	if follow_player:
		
		if !pickup_delay.is_stopped():
			await(pickup_delay.timeout)
		#print("Timed out")
		picking_up = true
		#follow_player = false
		var hearts = get_tree().get_nodes_in_group("Hearts")
		print(hearts.size())
		animation_player.play("pickup")
		Events.update_score.emit()


func _on_animated_sprite_2d_animation_finished():
	heart_location.queue_free()
	queue_free()



func _on_pickup_delay_timeout():
	print("Im timed out")
