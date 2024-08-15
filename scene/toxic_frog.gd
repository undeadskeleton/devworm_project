extends CharacterBody2D
class_name FrogEnemy
var health = 80

var speed = 40
@onready var animatedsprite = $AnimatedSprite2D
var damage_to_deal : int = 40
var dir : Vector2
var is_chasing : bool


var player 

var dead : bool
var is_attacking : bool
var is_taking_damage : bool
var knockback : int = -150
const gravity : int = 900

var is_roaming : bool
var damage_taken : int
var damage_done : int


func _ready():
	dead = false
	is_chasing = true
	is_attacking = false
	is_taking_damage = false
	player = GlobalScript.playerBody
	
func _process(delta):
	if GlobalScript.playerAlive:
		is_chasing = true
	elif !GlobalScript.playerAlive:
		is_chasing = false
		
	if !is_on_floor():
		velocity.y += gravity
	move(delta)
	handle_animation()
	
		
func move(delta):
	if !dead:
		is_roaming = true
		if !is_chasing:
			velocity += dir * speed * delta
		elif is_chasing and !is_taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x)/velocity.x
		elif is_taking_damage:
			print("frog is knockbacked")
			var knockback_dir = position.direction_to(player.position) * knockback
			velocity.x = knockback_dir.x
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
	elif is_taking_damage:
		animatedsprite.play("hurt")
		await get_tree().create_timer(0.4).timeout
		is_taking_damage = false
	elif is_attacking:
		animatedsprite.play("attack")
		await get_tree().create_timer(1).timeout
		is_attacking = false
		

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = chose([0.5,1,1.6])
	dir = chose([Vector2.RIGHT,Vector2.LEFT])
	velocity.x = 0
	
func chose(array):
	array.shuffle()
	return array.front()


func _on_frog_hit_box_area_entered(area):
	if area == GlobalScript.playerDamageZone:
		damage_taken = GlobalScript.playerDamage
		is_taking_damage = true
		
		taking_damage(damage_taken)
		
func taking_damage(damage):
	if !dead:
		health -= damage
		print("current health : ",health)



func _on_frog_damage_zone_body_entered(body):
	if body == GlobalScript.playerBody:
		is_attacking = true
		GlobalScript.frogDamage = damage_to_deal
		
