extends CharacterBody2D

var health = 80

var speed = 60

var damage_to_deal : int = 20
var dir : Vector2
var is_chasing : bool

var dead : bool
var is_attacking : bool
var knockback : int = 50
const gravity : int = 900

func _ready():
	dead = false
	is_chasing = false
	
func _process(delta):
	if !is_on_floor():
		velocity.y += gravity
	move(delta)
	move_and_slide()

func move(delta):
	if !dead:
		if !is_chasing:
			velocity += dir * speed * delta
	elif dead:
		velocity.x = 0

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = chose([0.5,1,1.6])
	dir = chose([Vector2.RIGHT,Vector2.LEFT])
	velocity.x = 0
	
func chose(array):
	array.shuffle()
	return array.front()
