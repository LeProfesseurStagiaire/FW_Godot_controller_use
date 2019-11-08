extends KinematicBody2D

var target

func _ready():
	add_to_group("enemi")
	change_target()

func _process(delta):
	if target:
		look_at(get_node(target).position)
		move_and_collide((get_node(target).global_position - global_position).normalized() * 150 * delta)

func change_target():
	randomize()
	var a = get_tree().get_current_scene().get_node("Players").get_children()
	if a :
		target = a[int(rand_range(0,a.size()))].get_path()
		get_node(target).connect(get_node(target).name,self,"signal_func")

func die():
	get_tree().get_current_scene().point()
	queue_free()

func signal_func():
	if get_node(target):
		get_node(target).queue_free()
		target = null
	$Timer.start(0.3)

func _on_Timer_timeout():
	change_target()
