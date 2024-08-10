extends Node2D

@onready var sceneTransitionAnimation = $scene_Transition_Animation/AnimationPlayer
@onready var player_camera = $Player/Camera2D


var current_wave : int
@export var bat_scene : PackedScene
@export var frog_scene : PackedScene

var starting_node : int 
var current_node : int 
var wave_spawn_ended
# Called when the node enters the scene tree for the first time.
func _ready():
	sceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	sceneTransitionAnimation.play("fade_out")
	player_camera.enabled = true
	GlobalScript.playerWeaponEquiped = true
	current_wave = 0
	GlobalScript.currentWave = current_wave
	starting_node = get_child_count()
	current_node = get_child_count()
	positon_to_next_wave()

func _process(delta):
	if !GlobalScript.playerAlive:
		sceneTransitionAnimation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/lobby_lvl.tscn")
		
	current_node = get_child_count()
	
	if wave_spawn_ended:
			positon_to_next_wave()
			
func positon_to_next_wave():
	if current_node == starting_node:
		if current_wave != 0:
			GlobalScript.moving_to_next_wave = true 
		wave_spawn_ended = false
		sceneTransitionAnimation.play("between_wave_animation")
		current_wave += 1
		GlobalScript.currentWave = current_wave
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("bats",4.0,4.0)
		prepare_spawn("frogs",1.5,2.0)
		print(current_wave)
		
		

func prepare_spawn(type ,multiplier,mob_spawn):
	var mob_amount = float(current_wave) * multiplier
	var mob_waitTime : float = 2.0
	print("mob_amount : ", mob_amount)
	var mob_spawn_rounds = mob_amount/mob_spawn
	spawn_type(type,mob_spawn_rounds,mob_waitTime)
	
func spawn_type(type,mob_spawn_rounds,mob_waitTime):
	if type == "bats":
		var bat_spawn1 = $batRespawnNode
		var bat_spawn2 = $batRespawnNode2
		var bat_spawn3 = $batRespawnNode3
		var bat_spawn4 = $batRespawnNode4
		if mob_spawn_rounds >=1:
			for i in mob_spawn_rounds:
				var bat1 = bat_scene.instantiate()
				bat1.global_position = bat_spawn1.global_position
				var bat2 = bat_scene.instantiate()
				bat2.global_position = bat_spawn2.global_position
				var bat3 =  bat_scene.instantiate()
				bat3.global_position = bat_spawn3.global_position
				var bat4 = bat_scene.instantiate()
				bat4.global_position = bat_spawn4.global_position
				add_child(bat1)
				add_child(bat2)
				add_child(bat3)
				add_child(bat4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_waitTime).timeout
	elif type == "frogs":
		var frog1_spawn = $frogRespawnNode
		var frog2_spawn = $frogRespawnNode2
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var frog1 = frog_scene.instantiate()
				frog1.global_position = frog1_spawn.global_position
				var frog2 = frog_scene.instantiate()
				frog2.global_position = frog2_spawn.global_position
				add_child(frog1)
				add_child(frog2)
				mob_spawn_rounds -=1
				await get_tree().create_timer(mob_waitTime).timeout
	wave_spawn_ended = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
