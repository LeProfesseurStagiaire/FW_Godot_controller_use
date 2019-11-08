extends Node2D

onready var time = $spawners/spawn.wait_time
onready var spawns = $spawners.get_children()
onready var enemi = preload("res://gamepad/zombie.tscn")
var score = -1

func _ready():
	point()

func _on_spawn_timeout():
	if time >= 0.6:
		time -=0.1
	var zomb = enemi.instance()
	add_child(zomb)
	zomb.position = get_node("spawners/p" + str(int(rand_range(1,spawns.size())))).position
	$spawners/spawn.start(time)

func point():
	score += 1
	$text/score.text = "score : " + str(score)
