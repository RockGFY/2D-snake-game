extends Node2D

# constants
const SNAKE_COLOR = Color( 0, 0, 1, 1 ) #blue
const BODY_COLOR = Color( 0.53, 0.81, 0.98, 1 )#lightskyblue 
const ENEMY_COLOR = Color( 1, 0.84, 0, 1 )	#gold
const FOOD_COLOR = Color(1, 0, 0, 1)	#red
const RECT_SIZE = Vector2(20, 20)
const INIT_POS = Vector2(10, 10)
const DIRECTION = {
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1),
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0)
}

# variables
var snake
var food
var elapsed_time = 0
var tick = 0.15
var score = 0
onready var lab = get_node("ScoreLabel")

# Called when the node enters the scene tree for the first time.
func _ready():	
	spawn()

func _draw():
	# draw snake
	var cur = snake.head
	while cur != null:		
		if(cur != snake.head):
			draw_rect(Rect2(cur.pos, RECT_SIZE), BODY_COLOR)
			cur = cur.next
		else:
			draw_rect(Rect2(cur.pos, RECT_SIZE), SNAKE_COLOR)
			cur = cur.next
	# draw food
	draw_rect(Rect2(food.pos, RECT_SIZE), FOOD_COLOR)

func _input(event):
	if Input.is_action_pressed("ui_up") and snake.head.dir != DIRECTION.DOWN:
		snake.head.dir = DIRECTION.UP
	elif Input.is_action_pressed("ui_down") and snake.head.dir != DIRECTION.UP:
		snake.head.dir = DIRECTION.DOWN
	elif Input.is_action_pressed("ui_left") and snake.head.dir != DIRECTION.RIGHT:
		snake.head.dir = DIRECTION.LEFT
	elif Input.is_action_pressed("ui_right") and snake.head.dir != DIRECTION.LEFT:
		snake.head.dir = DIRECTION.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	if elapsed_time > tick:
		elapsed_time = 0
		move()
		update()

func spawn():
	tick = 0.15
	snake = Snake.new(INIT_POS * RECT_SIZE, DIRECTION.UP)
	food = Food.new(random_pos())

func random_pos():
	return Vector2(randi() % 64, randi() % 40) * RECT_SIZE

func random_dir():
	var num = randi() % 100
	if num < 25:
		return DIRECTION.UP
	elif num < 50:
		return DIRECTION.DOWN
	elif num < 75:
		return DIRECTION.LEFT
	elif num < 100:
		return DIRECTION.RIGHT

func is_dead():
	# out of bound
	if snake.head.pos.x < 0 or snake.head.pos.x >= 1280 or snake.head.pos.y < 0 or snake.head.pos.y >=800:
		return true

	# collide self
	var cur = snake.tail
	while cur != snake.head:
		if snake.head.pos == cur.pos:
			return true		
		cur = cur.prev
	
	return false

func move():
	var cur = snake.tail
	while cur != snake.head:
		cur.pos += cur.dir * RECT_SIZE
		cur.dir = cur.prev.dir
		cur = cur.prev
	cur.pos += cur.dir * RECT_SIZE

	# check for encountering food
	if food.pos == snake.head.pos:
		snake.append_node()
		food = Food.new(random_pos())
		score = score + 1
		lab.set_text(str(score))
	# 
	if is_dead():
		score = 0
		lab.set_text(str(score))
		spawn()
		

class Food: 
	var pos

	func _init(pos):
		self.pos = pos

class Snake:
	var head
	var tail

	func _init(pos, dir):
		head = Snake_Node.new(pos, dir)
		tail = head

	func append_node():
		var new_node = Snake_Node.new(tail.pos - tail.dir * RECT_SIZE, tail.dir)
		new_node.prev = tail
		new_node.prev.next = new_node
		tail = new_node

	class Snake_Node:
		var pos
		var dir
		var prev
		var next

		func _init(pos, dir):
			self.pos = pos
			self.dir = dir
