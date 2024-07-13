extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D




const SPEED = 250.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 900


func _ready():
	GlobalScript.playerBody = self

func _physics_process(delta):
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

	move_and_slide()
	handle_animation(direction)
	
func handle_animation(dir):
	var weapon_ready = GlobalScript.playerWeaponEquiped
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
		if is_on_floor():
			if !velocity:
				animated_sprite.play("weapon_idle")
			if velocity:
				animated_sprite.play("weapon_run")
		if !is_on_floor():
			if velocity.y < 0:
				animated_sprite.play("jump_up")
				
			else:
				animated_sprite.play("weapon_fall")
		
				
	toggle_flip_sprite(dir)

func toggle_flip_sprite(dir):
	if dir == 1:
		animated_sprite.flip_h = false
	if dir == -1:
		animated_sprite.flip_h = true
