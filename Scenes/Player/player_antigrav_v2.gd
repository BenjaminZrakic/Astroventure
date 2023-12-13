extends CharacterBody2D

@export var movement_data : PlayerMovementData 
@export var reset_level_on_death = false
@export var world_boundary_active = false

@onready var animated_sprite = $AnimatedSprite
@onready var coyote_jump_timer = $"Coyote Jump Timer"

@onready var reset_movement_speed_jump_timer = $"ResetMovementSpeedJump Timer"
@onready var starting_position = global_position
@onready var wall_jump_timer = $"Wall Jump Timer"
@onready var camera_2d = $Camera2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var air_jump = false
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_wall_normal = Vector2.ZERO

enum GravityDirections{DOWN, UP, LEFT, RIGHT}
var GravityDirection = GravityDirections.DOWN
var GravDrive = 1
var GravityX = false
var CheckpointGravityDirection = GravityDirections.DOWN
var playerDead = false
var leftClamp = -INF
var rightClamp = INF

#terrain stuff
var friction_multiplier = 1
var speed_multiplier = 1
var acceleration_multiplier = 1
var reset_movement = false

func _physics_process(delta):
	if not playerDead:
		apply_gravity(delta)

		handle_wall_jump()
		handle_jump()
		
		reset_movement_values(delta)
		
		# Get the input direction and handle the movement/deceleration.
		var input_axis = Input.get_axis("ui_left", "ui_right")
		apply_acceleration(input_axis, delta)
		apply_air_accelaration(input_axis, delta)
		apply_friction(input_axis, delta)
		apply_air_resistance(input_axis, delta)

		var was_on_floor = is_on_floor()
		var was_on_wall = is_on_wall_only()
		if was_on_wall:
			was_wall_normal = get_wall_normal()
		move_and_slide()
		if world_boundary_active:
			position.x = clamp(position.x, leftClamp, rightClamp)
		var just_left_ledge = was_on_floor and not is_on_floor() # and velocity.y >= 0 
		if just_left_ledge:
			coyote_jump_timer.start()
		#if Input.is_action_just_pressed("ui_accept"):
		#	movement_data = load("res://Resources/FasterMovement.tres")
		
		just_wall_jumped = false
		var just_left_wall = was_on_wall and not is_on_wall_only()
		if just_left_wall:
			wall_jump_timer.start()
		update_animations(input_axis)

func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		if not GravityX:
			velocity.y += gravity * delta * movement_data.gravity_scale * GravDrive
			velocity.y = clamp(velocity.y, -600,600)
		else:
			velocity.x += gravity * delta * movement_data.gravity_scale * GravDrive
			velocity.x = clamp(velocity.x, -600,600)

func handle_jump():

	#print(coyote_jump_timer.time_left)
	
	if is_on_floor() or is_on_wall(): 
		air_jump = true
	# Handle Jump.
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
#			if reset_movement_speed_jump_timer.is_stopped():
#				reset_movement_speed_jump_timer.start()
			
			if not GravityX: 
				velocity.y = movement_data.jump_velocity * GravDrive
			else:
				velocity.x = movement_data.jump_velocity * GravDrive
			coyote_jump_timer.stop()

	elif not is_on_floor():
		if Input.is_action_just_released("ui_up"):
			if not GravityX:
				if velocity.y < movement_data.jump_velocity/2: 
					velocity.y = movement_data.jump_velocity/2 
			else:
			
				if velocity.x < movement_data.jump_velocity/2: 
					velocity.x = movement_data.jump_velocity/2

		if Input.is_action_just_pressed("ui_up") and air_jump and not just_wall_jumped:
			if not GravityX:
				velocity.y = movement_data.jump_velocity *0.8 * GravDrive
			else:
				velocity.x = movement_data.jump_velocity *0.8 * GravDrive
			air_jump = false
			


func handle_wall_jump():
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0:
		return
	
	var wall_normal = get_wall_normal() #vector that points away from the wall
	
	if wall_jump_timer.time_left > 0.0:
		wall_normal = was_wall_normal
		
	if Input.is_action_just_pressed("ui_up"):
		
		if not GravityX:
			velocity.x = wall_normal.x*movement_data.speed 
			velocity.y = movement_data.jump_velocity * GravDrive
		else:
			velocity.y = wall_normal.y*movement_data.speed
			velocity.x = movement_data.jump_velocity*GravDrive
		just_wall_jumped = true
	
#	if Input.is_action_just_pressed("ui_up") and wall_normal == Vector2.RIGHT:
#		velocity.x = wall_normal.x*movement_data.speed
#		velocity.y = movement_data.jump_velocity

func apply_acceleration(input_axis, delta):
	if input_axis!=0 and is_on_floor():
		if not GravityX:
			velocity.x = move_toward(velocity.x, movement_data.speed*speed_multiplier*input_axis, movement_data.accelaration*acceleration_multiplier*delta)
		else: 
			velocity.y = move_toward(velocity.y, movement_data.speed*speed_multiplier*input_axis*-1, movement_data.accelaration*acceleration_multiplier*delta)


func apply_air_accelaration(input_axis, delta):
	if is_on_floor():
		return 
	if input_axis!=0:
		if not GravityX:
			velocity.x = move_toward(velocity.x, movement_data.speed*speed_multiplier*input_axis, movement_data.air_accelaration*delta)
		else:
			velocity.y = move_toward(velocity.y, movement_data.speed*speed_multiplier*input_axis*-1 , movement_data.air_accelaration*delta)
			
func apply_friction(input_axis, delta):
	if input_axis==0 and is_on_floor():
		if not GravityX:
			velocity.x = move_toward(velocity.x, 0, movement_data.friction*friction_multiplier*delta)
		else:
			velocity.y = move_toward(velocity.y, 0, movement_data.friction*friction_multiplier*delta)


func apply_air_resistance(input_axis, delta):
	if input_axis==0 and not is_on_floor():
		if not GravityX:
			velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance*friction_multiplier*delta)
		else:
			velocity.y = move_toward(velocity.y, 0, movement_data.air_resistance*friction_multiplier*delta)

func update_animations(input_axis):
	if input_axis!=0:
		if GravityDirection== GravityDirections.UP or GravityDirection == GravityDirections.LEFT: 
			animated_sprite.flip_h = (input_axis>0)
		else:
			animated_sprite.flip_h = (input_axis<0)
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	if not is_on_floor():
		animated_sprite.play("jump")

func respawn():
	playerDead = true
	if reset_level_on_death:
		get_tree().reload_current_scene()
	else:
		#print("I'm dead oh no")
		velocity = Vector2.ZERO
		animated_sprite.play_backwards("respawn")
		animated_sprite.position.y += 1
		await animated_sprite.animation_finished
		if CheckpointGravityDirection == GravityDirections.DOWN:
			set_gravity_down()
		elif CheckpointGravityDirection== GravityDirections.UP:
			set_gravity_up()
		elif CheckpointGravityDirection==GravityDirections.LEFT:
			set_gravity_left()
		elif CheckpointGravityDirection==GravityDirections.RIGHT:
			set_gravity_right()
		global_position = starting_position
		await camera_2d.global_position == global_position
		animated_sprite.play("respawn")
		await animated_sprite.animation_finished
		animated_sprite.position.y-=1
		playerDead = false
		animated_sprite.play("idle")
		
func _on_hazard_detector_area_entered(area):
	respawn()

func set_gravity_down():
	if GravityDirection != GravityDirections.DOWN:
		set_up_direction(Vector2.UP)
		rotation_degrees=0
		if GravityDirection == GravityDirections.UP:
				#animated_sprite.flip_h = !animated_sprite.flip_h
				position.y += 16
		GravDrive = 1
		GravityX = false
		GravityDirection= GravityDirections.DOWN


func set_gravity_up():
	if GravityDirection!=GravityDirections.UP:
			set_up_direction(Vector2.DOWN)
			rotation_degrees=180
			if GravityDirection== GravityDirections.DOWN:
				#animated_sprite.flip_h = !animated_sprite.flip_h
				position.y -= 16
			elif GravityDirection == GravityDirections.RIGHT or GravityDirections.LEFT:
				position.y -= 8
			GravDrive = -1
			GravityX = false
			GravityDirection=GravityDirections.UP


func set_gravity_right():
	if GravityDirection != GravityDirections.RIGHT:
		rotation_degrees = -90
		set_up_direction(Vector2.LEFT)
		GravityX = true
		GravDrive = 1
		if GravityDirection==GravityDirections.LEFT:
				position.x+=16
				#animated_sprite.flip_h = !animated_sprite.flip_h
		GravityDirection=GravityDirections.RIGHT
		

func set_gravity_left():
	if GravityDirection!=GravityDirections.LEFT:
			rotation_degrees = 90
			set_up_direction(Vector2.RIGHT)
			GravityX = true
			GravDrive = -1
			if GravityDirection == GravityDirections.RIGHT:
				position.x-=16
				#animated_sprite.flip_h = !animated_sprite.flip_h
			GravityDirection=GravityDirections.LEFT

func set_spawn(new_position):
	starting_position = new_position
	CheckpointGravityDirection = GravityDirection

func _on_world_boundary_area_entered(area):
	if (velocity.x < 0 and leftClamp == -INF):
		leftClamp = global_position.x
	elif (velocity.x > 0 and rightClamp == INF):
		rightClamp = global_position.x


func _on_terrain_detector_terrain_entered(terrain_type):
	
	reset_movement_speed_jump_timer.stop()
	
	reset_movement = false
	if terrain_type==2:
		#print("Changing movement to ice")
		speed_multiplier = 1.5
		friction_multiplier = 0.1
		acceleration_multiplier= 0.2
	elif terrain_type==1:
		#print("Changing movement to normal")
		reset_movement = true
	else:
		#print("Starting reset timer")
		reset_movement_speed_jump_timer.start()



func _on_reset_movement_speed_timer_timeout():
	#print("Resetting movement")
	reset_movement = true
#	speed_multiplier = 1
#	friction_multiplier = 1
#	acceleration_multiplier = 1

func reset_movement_values(delta):
	if reset_movement:
		speed_multiplier = move_toward(speed_multiplier, 1, 0.5*delta)
		friction_multiplier = move_toward(friction_multiplier, 1, 0.5*delta)
		acceleration_multiplier = move_toward(acceleration_multiplier, 1, 0.5*delta)
		
		if speed_multiplier == 1 and friction_multiplier == 1 and acceleration_multiplier == 1:
			reset_movement = false



