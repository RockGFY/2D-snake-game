extends Area2D

# constants
const TICK = 0.005

# variables
var directions = []
var pos_array = []
var dir = Vector2(1, 0)
var elapsed_time = 0
var speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	if elapsed_time > TICK:
		elapsed_time = 0
		if directions.size() > 0:
			if position == pos_array[0]:
				dir = directions[0]
				remove_from_tail()
		position += dir * speed

func set_speed(var new_speed):
	speed = new_speed

func remove_from_tail():
	directions.pop_front()
	pos_array.pop_front()
	
func add_to_tail(head_pos, dir):
	pos_array.append(head_pos)
	directions.append(dir)
	
func _on_Tail_area_entered(area):
	if area.name == "Head":
		get_tree().reload_current_scene()
