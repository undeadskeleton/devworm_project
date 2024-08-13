extends CharacterBody2D

var health = 80

var speed = 40
@onready var animatedsprite = $AnimatedSprite2D
var damage_to_deal : int = 20
var dir : Vector2
var is_chasing : bool

var player 

var dead : bool
var is_attacking : bool
var is_taking_damage : bool
var knockback : int = 50
const gravity : int = 900

func _ready():
	dead = false
	is_chasing = true
	is_attacking = false
	is_taking_damage = false
	player = GlobalScript.playerBody
	
func _process(delta):
	if !is_on_floor():
		velocity.y += gravity
	move(delta)
	handle_animation()

func move(delta):
	if !dead:
		if !is_chasing:
			velocity += dir * speed * delta
		elif is_chasing:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x)/velocity.x
		move_and_slide()
	elif dead:
		velocity.x = 0
		
func handle_animation():
	if !dead and !is_attacking and !is_taking_damage:
		animatedsprite.play("run")
		if dir.x == 1:
			animatedsprite.flip_h = false
		elif dir.x == -1:
			animatedsprite.flip_h = true

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = chose([0.5,1,1.6])
	dir = chose([Vector2.RIGHT,Vector2.LEFT])
	velocity.x = 0
	
func chose(array):
	array.shuffle()
	return array.front()
