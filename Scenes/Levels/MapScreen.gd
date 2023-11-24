extends Node2D

@onready var mercury_path_follow_2d = $MercuryPath/MercuryPathFollow2D
@onready var venus_path_follow_2d = $VenusPath/VenusPathFollow2D
@onready var earth_path_follow_2d = $EarthPath/EarthPathFollow2D
@onready var mars_path_follow_2d = $MarsPath/MarsPathFollow2D
@onready var jupiter_path_follow_2d = $JupiterPath2D/JupiterPathFollow2D
@onready var saturn_path_follow_2d = $SaturnPath2D/SaturnPathFollow2D

@onready var path_array = [mercury_path_follow_2d,venus_path_follow_2d,
earth_path_follow_2d,mars_path_follow_2d, 
jupiter_path_follow_2d,saturn_path_follow_2d]

@onready var ship = $Ship
@onready var mercury = $MercuryPath/MercuryPathFollow2D/Mercury
@onready var venus = $VenusPath/VenusPathFollow2D/Venus
@onready var earth = $EarthPath/EarthPathFollow2D/Earth
@onready var mars = $MarsPath/MarsPathFollow2D/Mars
@onready var jupiter = $JupiterPath2D/JupiterPathFollow2D/Jupiter
@onready var saturn = $SaturnPath2D/SaturnPathFollow2D/Saturn



var rng = RandomNumberGenerator.new()

func _ready():
	for path in path_array:
		path.progress_ratio = rng.randf()
	#ship.global_position = earth.global_position
