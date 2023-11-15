extends Node2D

@export var retracted = false

func _ready():
	$RetractExtendTimer.start()
	if !retracted:
		$HazardArea.set_collision_layer_value(3, true)
		show()
	else:
		$HazardArea.set_collision_layer_value(3, false)
		hide()

func _on_retract_extend_timer_timeout():
	if retracted:
		$HazardArea.set_collision_layer_value(3, true)
		show()
	else:
		$HazardArea.set_collision_layer_value(3, false)
		hide()
	retracted = !retracted
