extends Node


var playerWeaponEquiped : bool
var playerBody : CharacterBody2D

var playerDamageZone : Area2D
var playerDamage: int 
var playerAlive : bool
var playerHitBox : Area2D

var batDamageZone : Area2D
var batDamage : int

var frogDamageZone : Area2D
var frogDamage : int 

var currentWave : int
var moving_to_next_wave : bool
