extends Area2D

signal speed_up_snake
signal speed_up_owl

func _on_FlashUtil_area_entered(area):
	if area.name == "Head":
		queue_free()
		emit_signal("speed_up_snake")
	elif area.name == "Owl":
		queue_free()
		emit_signal("speed_up_owl")
		
