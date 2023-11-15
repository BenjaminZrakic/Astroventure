extends Node2D

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel

@export var next_level: PackedScene
@export var countdown = false
@export var timer = false
@export var moving_spikes : PackedScene

var level_time = 0.0
var start_level_msec = 0.0


func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	LevelTransition.fade_from_black()
	if countdown:
		animation_player.play("countdown")
		await animation_player.animation_finished
	get_tree().paused = false
	start_level_msec = Time.get_ticks_msec() #vrijeme od pocetka u ms
	if not next_level is PackedScene:
		level_completed.next_level_button.text = "Victory screen"
	
	addObjects()

func addObjects():
	var usedCells = $LevelTileMap.get_used_cells(2) + $LevelTileMap.get_used_cells(3)
	for cell in usedCells:
		var cellLayer = 2 if $LevelTileMap.get_cell_source_id(2, cell) != -1 else 3
		var cellSrcId = $LevelTileMap.get_cell_source_id(cellLayer, cell)
		var cellAlt = $LevelTileMap.get_cell_alternative_tile(cellLayer, cell)
		var place_at = to_global($LevelTileMap.map_to_local(cell))
		if cellSrcId == 3:
			place_spike(place_at, cellLayer, cellAlt)
	$LevelTileMap.clear_layer(2)
	$LevelTileMap.clear_layer(3)

func place_spike(place_at, cellLayer, cellAlt):
	var spike_instance = moving_spikes.instantiate()
	if cellLayer == 3:
		spike_instance.retracted = true
	add_child(spike_instance)
	if cellAlt == 0:
		place_at.x -=24
		place_at.y +=4
	elif cellAlt == 2:
		spike_instance.rotation = PI
		place_at.x -= 8
		place_at.y -= 12
	elif cellAlt == 3:
		spike_instance.rotation = 1.5 * PI
		place_at.x -= 8
		place_at.y += 4
	elif cellAlt == 4:
		spike_instance.rotation = 0.5 * PI
		place_at.x -= 24
		place_at.y -= 12
	spike_instance.position = place_at

func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msec
	if timer:
		level_time_label.text = str(level_time / 1000.0)

func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true

func go_to_next_level():
	await LevelTransition.fade_to_black()
	if not next_level is PackedScene: get_tree().change_scene_to_file("res://Scenes/victory_screen.tscn")
	else: get_tree().change_scene_to_packed(next_level)
	#LevelTransition.fade_from_black()
	get_tree().paused = false

func _on_level_completed_retry():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	
