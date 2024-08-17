extends Node2D

@onready var sceneTransitionAnimation = $scene_Transition_Animation/AnimationPlayer
@onready var player_camera = $Player/Camera2D

var current_wave : int 

@export var bat_scene : PackedScene
@export var frog_scene : PackedScene

var current_node : int 
var starting_node : int 
var wave_spawn_end 

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	sceneTransitionAnimation.play("fade_out")
	player_camera.enabled = true
	GlobalScript.playerWeaponEquiped = true
	current_wave = 0
	GlobalScript.current_wave = current_wave
	starting_node = get_child_count()
	current_node = get_child_count()
	proceed_to_next_wave()
	
func proceed_to_next_wave():
	print("currentNode: ",current_node," startingNode:",starting_node)
	if current_node == starting_node:
		print("current wave = ",current_wave)
		if current_wave!=0:
			GlobalScript.moving_to_next_wave = true
		current_wave+=1
		GlobalScript.current_wave = current_wave
		wave_spawn_end = false
		sceneTransitionAnimation.play("in_between")
		await get_tree().create_timer(1).timeout
		spawn_enemy("bat",4.0,4.0) #type,multiplier,spawns
		spawn_enemy("frog",1.5,2.0)

func spawn_enemy(type,multiplier,mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time = 4.0
	var  mob_spawn_round = mob_amount/mob_spawns
	print(type, " amount ",mob_amount," spawn round : ",mob_spawn_round)
	spawn_type(type,mob_spawn_round,mob_wait_time)

func spawn_type(type,mob_spawn_round,mob_wait_time):
	if type == "bat":
		var bat_spawn1 = $batSpawn
		var bat_spawn2 = $batSpawn2
		var bat_spawn3 = $batSpawn3
		var bat_spawn4 = $batSpawn4
		if mob_spawn_round >= 1.0:
			for i in mob_spawn_round :
				var bat1 = bat_scene.instantiate()
				bat1.global_position = bat_spawn1.global_position
				var bat2 = bat_scene.instantiate()
				bat2.global_position = bat_spawn2.global_position
				var bat3 = bat_scene.instantiate()
				bat3.global_position = bat_spawn3.global_position
				var bat4 = bat_scene.instantiate()
				bat4.global_position = bat_spawn4.global_position
				add_child(bat1)
				add_child(bat2)
				add_child(bat3)
				add_child(bat4)
				mob_spawn_round -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	elif type == "frog":
		var frog_spawn1 = $frogSpawn
		var frog_spawn2 = $frogSpawn2
		print("frog spawn_round: ",mob_spawn_round)
		if mob_spawn_round >=1.0:
			for i in mob_spawn_round:
				print(i," : frog spawn round")
				var frog1 = frog_scene.instantiate()
				frog1.global_position = frog_spawn1.global_position
				var frog2 = frog_scene.instantiate()
				frog2.global_position = frog_spawn2.global_position
				add_child(frog1)
				add_child(frog2)
				mob_spawn_round -=1
				await get_tree().create_timer(mob_wait_time).timeout
	wave_spawn_end = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !GlobalScript.playerAlive:
		sceneTransitionAnimation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/lobby_lvl.tscn")
	current_node = get_child_count()
	if wave_spawn_end:
			proceed_to_next_wave()
			
	

