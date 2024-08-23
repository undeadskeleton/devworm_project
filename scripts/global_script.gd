extends Node


var playerWeaponEquiped : bool
var playerBody : CharacterBody2D

var playerDamageZone : Area2D
var playerDamage: int 
var playerAlive : bool

var batDamageZone : Area2D
var batDamage : int

var frogHitBox : Area2D
var frogDamageZone :Area2D
var frogDamage :int

var current_wave : int
var moving_to_next_wave : bool

var current_score : int 
var previous_score : int 
var high_score : int 
