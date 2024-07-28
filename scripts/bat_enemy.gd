extends CharacterBody2D


const speed = 30
var dir: Vector2
var player : CharacterBody2D
var is_bat_chase: bool
var health = 60
var damage : int
var dead = false
var is_talking_damage = false
var is_roaming : bool

func _ready():
	is_bat_chase = true
	
func _process(delta):
	move(delta)
	handle_animation()
		
func move(delta):
	player = GlobalScript.playerBody
	if !dead:
		is_roaming = true
		if is_bat_chase:
			if !is_talking_damage:
				velocity = position.direction_to(player.position) * speed
				dir.x = abs(velocity.x)/velocity.x
			elif is_talking_damage:
				velocity = position.direction_to(player.position) * -50
		elif !is_bat_chase and !is_talking_damage:
			velocity += speed * dir * delta
	elif dead:
		velocity.y -= delta * -100 
		velocity.x = 0
	move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = chose ([0.3,0.5])
	if !is_bat_chase:
		dir = chose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
		
		
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
		
	
func chose(array):
	array.shuffle()
	return array.front()




func _on_area_2d_area_entered(area):
	if area == GlobalScript.playerDamageZone:
		damage = GlobalScript.playerDamage
		taking_damage(damage)
	
func taking_damage(damage):
	health -= damage
	is_talking_damage = true
	if health <= 0:
		health = 0
		dead = true
		print(str(self)," the current health is " , health, "and is_taking_damage", str(is_talking_damage))
		
		
	
