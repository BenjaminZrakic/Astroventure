extends Node2D

@onready var mercury_path_follow_2d = $MercuryPath/MercuryPathFollow2D
@onready var venus_path_follow_2d = $VenusPath/VenusPathFollow2D
@onready var earth_path_follow_2d = $EarthPath/EarthPathFollow2D
@onready var mars_path_follow_2d = $MarsPath/MarsPathFollow2D


var path_array = [mercury_path_follow_2d,venus_path_follow_2d,earth_path_follow_2d,mars_path_follow_2d]
