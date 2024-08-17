extends CharacterBody2D

class_name PlayerBody

@onready var animated_sprite = $AnimatedSprite2D
@onready var deal_damage_zone = $playerDamageZone

const SPEED = 250.0
const JUMP_VELOCITY = -350.0
var current_attack :bool
var attack_type : String
var weapon_ready : bool
var health : int = 2000
var is_alive : bool
var is_allowed_to_take_damage : bool
var damage : int 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 900


func _ready():
	GlobalScript.playerBody = self
	GlobalScript.playerAlive = true
	is_alive = true
	is_allowed_to_take_damage = true
	print(weapon_ready)
 
func _physics_process(delta):
	weapon_ready = GlobalScript.playerWeaponEquiped
	GlobalScript.playerDamageZone =deal_damage_zone
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	if is_alive:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		

		if weapon_ready and !current_attack:
			if Input.is_action_just_pressed("right_mouse") or Input.is_action_just_pressed("left_mouse"):
				current_attack = true
				if Input.is_action_just_pressed("right_mouse") and is_on_floor():
					attack_type = "single"
				elif Input.is_action_just_pressed("left_mouse") and is_on_floor():
					attack_type = "double"
				else:
					attack_type = "air"
				set_damage(attack_type)
				handle_attack_animation(attack_type)
		handle_animation(direction)
		check_hitbox()
	move_and_slide()
	
func check_hitbox():
	var area_hitbox = $playerHitBox.get_overlapping_areas()
	if area_hitbox:
		var hitbox = area_hitbox.front()
		if hitbox.get_parent() is Batenemy:
			damage = GlobalScript.batDamage
		elif hitbox.get_parent() is FrogEnemy:
			damage = GlobalScript.frogDamage
	
	if is_allowed_to_take_damage:
		take_damage(damage)

func take_damage(damage):
	if damage != 0: 
		if health > 0:
			health -= damage
			if health <= 0:
				health = 0
				print("dead")
				is_alive = false
				handle_death_animation()
			take_damage_cooldown(1.5)

func handle_death_animation():
	$CollisionShape2D.position.y = 5
	velocity.x=0
	animated_sprite.play("death")
	await get_tree().create_timer(0.5).timeout
	$Camera2D.zoom.x = 4
	$Camera2D.zoom.y = 4
	await get_tree().create_timer(3).timeout
	GlobalScript.playerAlive = false
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
	


func take_damage_cooldown(wait_time):
	is_allowed_to_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	is_allowed_to_take_damage = true
	damage = 0



func handle_animation(dir):
	if !weapon_ready:
		if is_on_floor():
			if !velocity:
				animated_sprite.play("idle")
			if velocity:
				animated_sprite.play("run")
		if !is_on_floor():
			if velocity.y < 0:
				animated_sprite.play("jump_up")
			else:
				animated_sprite.play("fall")
	elif weapon_ready:
		if is_on_floor() and !current_attack:
			if !velocity:
				animated_sprite.play("weapon_idle")
			if velocity:
				animated_sprite.play("weapon_run")
		elif !is_on_floor() and !current_attack:
			if velocity.y < 0:
				animated_sprite.play("jump_up")
			else:
				animated_sprite.play("weapon_fall")
		
				
	toggle_flip_sprite(dir)

func toggle_flip_sprite(dir):
	if dir == 1:
		animated_sprite.flip_h = false
		deal_damage_zone.scale.x = 1
	if dir == -1:
		animated_sprite.flip_h = true
		deal_damage_zone.scale.x = -1
		
func handle_attack_animation(attack_type):
	if weapon_ready:
		if current_attack:
			var animation = str(attack_type,"_attack")
			animated_sprite.play(animation)
			toogle_damage_collision(attack_type)
			
func toogle_damage_collision(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time : float
	
	if attack_type == "air":
		wait_time = 0.6
	elif attack_type == "single":
		wait_time = 0.4
	elif attack_type == "double":
		wait_time = 0.6
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true



func _on_animated_sprite_2d_animation_finished():
	current_attack = false
	
func set_damage(attack_type):
	var current_damage_dealt : int
	if attack_type == "single":
		current_damage_dealt = 8
	elif attack_type == "double":
		current_damage_dealt = 16
	elif attack_type == "air":
		current_damage_dealt = 20
	GlobalScript.playerDamage = current_damage_dealt

