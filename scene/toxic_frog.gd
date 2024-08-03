extends CharacterBody2D

class_name toxicFrog

var player = CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D

var health = 80

var speed = 60

var damage_to_deal : int = 20
var damage_taken : int 
var dir : Vector2
var is_chasing : bool

var dead : bool
var is_attacking : bool
var is_taking_damage : bool
var is_roaming : bool
var knockback_force: int = -50
const gravity : int = 900

func _ready():
	dead = false
	is_chasing = true
	is_taking_damage = false
	
func _process(delta):
	if !is_on_floor():
		velocity.y += gravity
	
	player = GlobalScript.playerBody
	handle_animation()
	move(delta)
	move_and_slide()

func move(delta):
	if !dead:
		if !is_chasing and !is_taking_damage and !is_attacking:
			velocity += dir * speed * delta
		elif is_chasing and !is_taking_damage:
			var chase = position.direction_to(player.position) * speed
			velocity.x = chase.x
			dir.x = abs(velocity.x) / velocity.x
		elif is_taking_damage:
			print("frog taking damage")
			var knockback_dir = position.direction_to(player.position) * knockback_force 
			velocity.x = knockback_dir.x
			is_taking_damage = false
		is_roaming = true
	elif dead:
		velocity.x = 0

		
func take_damage(damage):
	if !dead:
		if damage_taken > 0:
			health -= damage_taken
			is_taking_damage = true
			print("Current frog health is :",health)
			if health <= 0:
				health =0 
				dead = true
				

func handle_death_animation():
	animatedSprite.play("death")
	await get_tree().create_timer(1).timeout
	self.queue_free()

func handle_animation():
	if !dead and !is_taking_damage and !is_chasing:
		animatedSprite.play("idle")
	elif is_chasing:
		animatedSprite.play("run")
		if dir.x == 1:
			animatedSprite.flip_h = false
		elif dir.x == -1:
			animatedSprite.flip_h = true
	elif is_taking_damage:
		animatedSprite.play("hurt")
	elif dead and is_roaming:
		is_roaming = false
		animatedSprite.play("death")
		await get_tree().create_timer(1).timeout
		self.queue_free()
	
func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = chose([0.5,1,1.6])
	dir = chose([Vector2.RIGHT,Vector2.LEFT])
	velocity.x = 0
	
func chose(array):
	array.shuffle()
	return array.front()


func _on_frog_hit_box_area_entered(area):
	if area == GlobalScript.playerDamageZone:
		damage_taken=GlobalScript.playerDamage
		take_damage(damage_taken)
	
