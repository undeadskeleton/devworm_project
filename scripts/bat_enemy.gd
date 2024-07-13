extends CharacterBody2D


const speed = 30
var dir: Vector2

var is_bat_chase: bool



func _on_timer_timeout():
	$Timer.wait_time = chose ([1.0,1.5,2.0])
	
func chose(array):
	array.shuffle()
	return array.front()


