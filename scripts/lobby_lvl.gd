extends Node2D

@onready var sceneTransitionAnimation = $scene_Transition_Animation/AnimationPlayer
@onready var player_camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	sceneTransitionAnimation.play("fade_out")
	player_camera.enabled = false
	GlobalScript.playerWeaponEquiped = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_game_detection_body_entered(body):
	if body is PlayerBody:
		sceneTransitionAnimation.play("fade_in")
		await  get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/stage_lvl.tscn")
