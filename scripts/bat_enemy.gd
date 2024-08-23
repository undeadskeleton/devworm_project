extends CharacterBody2D

class_name Batenemy

const speed = 30
var dir: Vector2
var player : CharacterBody2D
var is_bat_chase: bool

var max_health : int = 60
var min_health :int = 0
var health = 60
var damage : int
var dead = false
var is_talking_damage = false
var is_roaming : bool
var batDamage = 20

var points_for_kill : int = 100

func _ready():
	pass

func _process(delta):
	GlobalScript.batDamageZone = $batDamageZone
	GlobalScript.batDamage = batDamage
	
	if GlobalScript.playerAlive:
		is_bat_chase = true
	elif !GlobalScript.playerAlive:
		is_bat_chase = false
		
	if dead and is_on_floor_only():
		await get_tree().create_timer(3.0).timeout
		GlobalScript.current_score +=points_for_kill
		self.queue_free()
	move(delta)
	handle_animation()
	
func _on_timer_timeout():
	$Timer.wait_time = chose ([0.3,0.5])
	if !is_bat_chase:
		dir = chose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
		
func move(delta):
	player = GlobalScript.playerBody
	if !dead:
		is_roaming = true
		if is_bat_chase and !is_talking_damage and GlobalScript.playerAlive:
			velocity = position.direction_to(player.position) * speed
			dir.x = abs(velocity.x)/velocity.x
		elif is_talking_damage:
			var knockback = position.direction_to(player.position) * -250
			velocity = knockback
		else:
			velocity += speed * dir * delta
	elif dead:
		velocity.y -= delta * -100 
		velocity.x = 0
	move_and_slide()

		
		
func handle_animation():
	var animatied_sprite = $AnimatedSprite2D
	if !dead and !is_talking_damage:
		animatied_sprite.play("fly")
		if dir.x == 1:
			animatied_sprite.flip_h = false
		if dir.x == -1:
			animatied_sprite.flip_h = true
	elif !dead and is_talking_damage:
		animatied_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		is_talking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animatied_sprite.play("death")
		set_collision_layer_value(1,true)
		set_collision_layer_value(2,false)
		set_collision_mask_value(1,true)
		set_collision_mask_value(2,false)
		
	
func chose(array):
	array.shuffle()
	return array.front()




func _on_area_2d_area_entered(area):
	if area == GlobalScript.playerDamageZone:
		damage = GlobalScript.playerDamage
		taking_damage()
	
func taking_damage():
	health -= damage
	is_talking_damage = true
	if health <= 0:
		health = 0
		dead = true
		
		
		
	
