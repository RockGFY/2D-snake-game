extends Area2D

const SPEED = 1000
const WIDTH = 1280
const HEIGHT = 800

var dir

func _process(delta):
	move(delta)
	remove_bullet()
	
func move(var delta):
	position += delta * SPEED * dir
	
func remove_bullet():
	if out_of_bound():
		queue_free()
		
func out_of_bound():
	if position.x < 0 or position.x > WIDTH - 40 or position.y < 0 or position.y > HEIGHT:
		return true
	return false
