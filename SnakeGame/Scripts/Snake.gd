extends Node2D

signal snake_dead

# constants
const GAP = 40
const DIRECTION = {
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1),
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0)
}
const ROTATION = {
	UP = deg2rad(-90),
	DOWN = deg2rad(90),
	LEFT = deg2rad(180),
	RIGHT = deg2rad(0)
}
const WIDTH = 1280
const HEIGHT = 800
const TICK = 0.005

# variables
var dir = DIRECTION.RIGHT
var rot = ROTATION.RIGHT
var next_tail_dir = DIRECTION.RIGHT
var prev_dir = DIRECTION.RIGHT
onready var tail = preload("res://Scenes/Tail.tscn")
onready var bullet = preload("res://Scenes/Bullet.tscn")
var elapsed_time = 0
var speed = 1
var bullet_reload = 0.0
var reload_time = 0.5
	
# Called when the node enters the scene tree for the first time.
func _ready():
	add_tail()
	add_tail()
	add_tail()

func _input(event):
	if Input.is_action_pressed("ui_up") and dir != DIRECTION.DOWN:
		dir = DIRECTION.UP
		rot = ROTATION.UP
	elif Input.is_action_pressed("ui_down") and dir != DIRECTION.UP:
		dir = DIRECTION.DOWN
		rot = ROTATION.DOWN
	elif Input.is_action_pressed("ui_left") and dir != DIRECTION.RIGHT:
		dir = DIRECTION.LEFT
		rot = ROTATION.LEFT
	elif Input.is_action_pressed("ui_right") and dir != DIRECTION.LEFT:
		dir = DIRECTION.RIGHT
		rot = ROTATION.RIGHT
	elif Input.is_key_pressed(KEY_SPACE):
		fire()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bullet_reload -= delta
	elapsed_time += delta
	if elapsed_time > TICK:
		elapsed_time = 0
		move()
		check_out_of_bound()

func move():
	var dir_change = false
	if(prev_dir != dir):
		prev_dir = dir
		dir_change = true
	var head_pos = get_node("Head").position
	get_node("Head").position += dir * speed
	get_node("Head").rotation = rot
	
	if(dir_change):
		for i in range(1, get_child_count()):
			get_child(i).add_to_tail(head_pos, dir)

func add_tail():
	var tail_instance = tail.instance()
	tail_instance.set_speed(speed)
	var prev_tail = get_child(get_child_count() - 1)
	if prev_tail.name != "Head":
		tail_instance.dir = prev_tail.dir
		for i in range(0, prev_tail.pos_array.size()):
			tail_instance.pos_array.append(prev_tail.pos_array[i])
			tail_instance.directions.append(prev_tail.directions[i])
		tail_instance.position = prev_tail.position - prev_tail.dir * GAP
	else:
		tail_instance.dir = dir
		tail_instance.position = prev_tail.position - dir * GAP
		
	add_child(tail_instance)
	
func remove_tail():
	var end_tail = get_child(get_child_count() - 1)
	if end_tail.name != "Head":
		end_tail.queue_free()
	
func fire():
	if bullet_reload <= 0.0:
		var new_bullet = bullet.instance()
		new_bullet.position = get_node("Head").position
		new_bullet.dir = get_node(".").dir
		get_parent().get_node("Bullets").add_child(new_bullet)
		bullet_reload = reload_time
		get_viewport().audio_listener_enable_2d = true
		$Head/Sprite/AudioStreamPlayer2D.play()
		

func check_out_of_bound():
	var head_pos = get_node("Head").position
	if head_pos.x < 0 or head_pos.x > WIDTH or head_pos.y < 0 or head_pos.y > HEIGHT:
		emit_signal("snake_dead")
		
func change_speed(var new_speed):
	speed = new_speed
	for i in range(1, get_child_count()):
			get_child(i).speed = new_speed
	