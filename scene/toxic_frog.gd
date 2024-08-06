extends CharacterBody2D

class_name toxicFrog

var player = CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D

var health = 200

var speed = 30

var damage_to_deal : int = 50
var damage_taken : int 
var dir : Vector2
var is_chasing : bool

var is_free_roaming : bool

var dead : bool
var is_attacking : bool
var is_taking_damage : bool
var is_roaming : bool
var knockback_force: int = -70
const gravity : int = 900

func _ready():
	dead = false
	is_chasing = true
	is_taking_damage = false
	is_roaming = false
	print("enemy chase at ready is : ",is_chasing)

func _process(delta):
	if !is_on_floor():
		velocity.y += gravity
		
	GlobalScript.frogDamageZone = $frogDamageZone
	GlobalScript.frogDamage = damage_to_deal
	move(delta)
	handle_animation()
	move_and_slide()
	
func move(delta):
	player = GlobalScript.playerBody
	if !dead:
		if !is_chasing and !is_taking_damage:
			velocity += speed * delta * dir
		elif is_chasing and !is_taking_damage:
			var dir_to_player= position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir = abs(velocity)/velocity
		elif is_taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		#await get_tree().create_timer(10).timeout
		velocity.x = 0
		

func handle_animation():
	if !dead and !is_taking_damage and !is_attacking:
		animatedSprite.play("run")
		if dir.x == -1:
			animatedSprite.flip_h = true
		if dir.x == 1:
			animatedSprite.flip_h = false
	elif !dead and is_taking_damage:
		animatedSprite.play("hurt")
		await get_tree().create_timer(0.3).timeout
		is_taking_damage = false
	elif !dead and  is_attacking:
		animatedSprite.play("attack")
	

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = chose([1,2,1.5])
	if !is_chasing:
		dir = chose([Vector2.RIGHT,Vector2.LEFT])
		velocity.x = 0

func chose(array):
	array.shuffle()
	return array.front()



func _on_frog_hit_box_area_entered(area):
	if area == GlobalScript.playerDamageZone:
		damage_taken = GlobalScript.playerDamage
		take_damage(damage_taken)


func take_damage(damage):
	if damage > 0:
		if !dead:
			health -= damage
			is_taking_damage = true
			print("current health of frog : ",health)
			if health <= 0 :
				health = 0
				dead = true
				handle_death_animation()

func handle_death_animation():   
	animatedSprite.play("death")
	await get_tree().create_timer(0.8).timeout
	self.queue_free()


func _on_frog_damage_zone_area_entered(area):
		while area == GlobalScript.playerHitBox:
			is_attacking = true
			await get_tree().create_timer(2.0).timeout
			is_attacking = false
			if area != GlobalScript.playerHitBox:
				break
			print(area)
			
