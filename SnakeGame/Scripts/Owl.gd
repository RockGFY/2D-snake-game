extends Area2D

signal snake_dead
signal owl_dead

const DIR_CHANGE_FREQ = 3
const DIRECTION = {
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1),
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0)
}
const WIDTH = 1280
const HEIGHT = 800
const OFFSET = 50

var dir = DIRECTION.UP
var elapsed_time = 0
var speed = 1

func _process(delta):
	elapsed_time += delta
	if elapsed_time > DIR_CHANGE_FREQ:
		elapsed_time = 0
		set_random_dir()
	move()

func _on_Area2D_area_entered(area):
	if area.name == "Head" or area.name == "Tail":
		queue_free()
		emit_signal("snake_dead")
		get_tree().reload_current_scene()
	if area.name == "Bullet":
		queue_free()
		area.queue_free()
		emit_signal("owl_dead")
		
func set_random_dir():
	randomize()
	var num = randi() % 100 + 1
	
	if num <= 25:
		dir = DIRECTION.UP
	elif num > 25 and num <= 50:
		dir = DIRECTION.DOWN
	elif num > 50 and num <= 75:
		dir = DIRECTION.LEFT
	elif num > 75 and num <= 100:
		dir = DIRECTION.RIGHT
	
func move():
	position += dir * speed
	check_out_of_bound()
	
func check_out_of_bound():
	if position.x < 0 or position.x > WIDTH - OFFSET or position.y < 0 or position.y > HEIGHT - OFFSET:
		set_random_dir()

func change_speed(new_speed):
	speed = new_speed