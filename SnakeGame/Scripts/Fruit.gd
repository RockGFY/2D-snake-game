extends Area2D

signal fruit_consumed

func _on_Strawberry_area_entered(area):
	if area.name == "Head":
		queue_free()
		emit_signal("fruit_consumed")
