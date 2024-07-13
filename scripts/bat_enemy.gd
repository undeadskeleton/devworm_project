extends CharacterBody2D


const speed = 30
var dir: Vector2
var player : CharacterBody2D
var is_bat_chase: bool

func _ready():
	is_bat_chase = true
	
func _process(delta):
	move(delta)
	handle_animation()
	
func move(delta):
	if is_bat_chase:
		player = GlobalScript.playerBody
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x)/velocity.x
	elif !is_bat_chase:
		velocity += speed * dir * delta
	move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = chose ([0.3,0.5])
	if !is_bat_chase:
		dir = chose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
		
		
func handle_animation():
	var animatied_sprite = $AnimatedSprite2D
	animatied_sprite.play("fly")
	
	if dir.x == 1:
		animatied_sprite.flip_h = false
	if dir.x == -1:
		animatied_sprite.flip_h = true
	
func chose(array):
	array.shuffle()
	return array.front()


