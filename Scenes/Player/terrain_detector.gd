extends Area2D

signal terrain_entered(terrain_type)

const bitmask : int = 255

enum TerrainType {
	
	NORMAL = 1,
	ICE = 2
}

