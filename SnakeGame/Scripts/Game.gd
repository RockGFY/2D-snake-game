extends Node2D

const WIDTH = 1280
const HEIGHT = 800
const TIME_OUT = 10

onready var fruit = preload("res://Scenes/Fruit.tscn")
onready var owl = preload("res://Scenes/Owl.tscn")
onready var flash = preload("res://Scenes/FlashUtil.tscn")
onready var turtle = preload("res://Scenes/TurtleUtil.tscn")
onready var snake = get_node("Snake")
onready var lab = get_node("ScoreLabel")

var init_owl_pos = [Vector2(0,740), Vector2(600, 740), Vector2(1220, 740)]
var index = 0
var timer
var score = 0

func _ready():
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.set_wait_time(TIME_OUT)
	add_child(timer)
	timer.start()
	snake.connect("snake_dead", self, "snake_dead_spawn")
	add_fruit()
	add_owl()
	add_owl()
	add_owl()

func add_utils():
	var rand_num = get_random_num(1, 100)
	
	if rand_num < 50:
		var new_flash = flash.instance()
		new_flash.position = get_random_pos()
		new_flash.connect("speed_up_snake", self, "speed_up_snake")
		new_flash.connect("speed_up_owl", self, "speed_up_owl")
		get_node("Utils").add_child(new_flash)
	elif rand_num >= 50 and rand_num < 100:
		var new_turtle = turtle.instance()
		new_turtle.position = get_random_pos()
		new_turtle.connect("speed_down_snake", self, "speed_down_snake")
		new_turtle.connect("speed_down_owl", self, "speed_down_owl")
		get_node("Utils").add_child(new_turtle)

func add_owl():
	var new_owl = owl.instance()
	new_owl.position = get_next_spawn_pos()
	new_owl.connect("snake_dead", self, "snake_dead_spawn")
	new_owl.connect("owl_dead", self, "owl_dead_spawn")
	get_node("Owls").add_child(new_owl)

func add_fruit():
	var new_fruit = fruit.instance()
	new_fruit.position = get_random_pos()
	new_fruit.connect("fruit_consumed", self, "add_tail_new_fruit")
	get_node("Fruits").add_child(new_fruit)

func snake_dead_spawn():
	score = 0
	lab.set_text(str(score))
	get_tree().reload_current_scene()
	#print("SNAKE DEAD")
	
func owl_dead_spawn():
	score = score + 1
	lab.set_text(str(score))
	add_owl()
	snake.remove_tail()

func add_tail_new_fruit():
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://eat.wav")
	player.play()
	score = score + 5
	lab.set_text(str(score))
	add_fruit()
	snake.add_tail()

func get_random_pos():
	randomize()
	var x = randi() % (WIDTH - 80) + 5
	var y = randi() % (HEIGHT - 100) + 5
	return Vector2(x, y)

func get_random_num(var minimum, var maximum):
	randomize()
	return randi() % maximum + minimum
	
func get_next_spawn_pos():
	var i = index % 3
	index += 1
	return init_owl_pos[i]

func _on_timer_timeout():
	for i in get_node("Utils").get_children():
		i.queue_free()
		
	add_utils()
	timer.start()

# function for all utils
func speed_up_snake():
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://eat.wav")
	player.play()
	score = score + 1
	lab.set_text(str(score))
	snake.change_speed(2)
	
func speed_up_owl():
	score = score - 1
	lab.set_text(str(score))
	for i in get_node("Owls").get_children():
		i.change_speed(1.5)
	
func speed_down_snake():
	var player = AudioStreamPlayer.new()
	self.add_child(player) 
	player.stream = load("res://eat.wav")
	player.play()
	score = score + 1
	lab.set_text(str(score))
	snake.change_speed(0.8)
	
func speed_down_owl():
	score = score - 1
	lab.set_text(str(score))
	for i in get_node("Owls").get_children():
		i.change_speed(0.6)