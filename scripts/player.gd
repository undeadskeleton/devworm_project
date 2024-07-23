extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var deal_damage_zone = $Area2D




const SPEED = 250.0
const JUMP_VELOCITY = -350.0
var current_attack :bool
var attack_type : String
var weapon_ready : bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 900


func _ready():
	GlobalScript.playerBody = self
	print(weapon_ready)
 
	
func _physics_process(delta):
	weapon_ready = GlobalScript.playerWeaponEquiped
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
			handle_attack_animation(attack_type)

	
	move_and_slide()
	handle_animation(direction)
	
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
			




func _on_animated_sprite_2d_animation_finished():
	current_attack = false
