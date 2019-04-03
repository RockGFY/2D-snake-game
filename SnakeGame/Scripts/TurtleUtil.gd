extends Area2D

signal speed_down_snake
signal speed_down_owl

func _on_TurtleUtil_area_entered(area):
	if area.name == "Head":
		queue_free()
		emit_signal("speed_down_snake")
	elif area.name == "Owl":
		queue_free()
		emit_signal("speed_down_owl")
