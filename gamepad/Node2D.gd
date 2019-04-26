extends Sprite

enum NamedEnum {Player_01 = 0, Player_02 = 1, Player_03 = 2, Player_04 = 3}
export (NamedEnum) var nb_P

var deadZone = 0.2

onready var CrHair = $hit

# Speed Multiplier is what you would use to implement a sensitivity setting.  Higher == more movement per press
var speedMultiplier = 3

func _ready():
	
	#----------------------------------------------
	# Connexion du signal du branchement d'une manette
	
	# Controller signal conection
	#----------------------------------------------
	
	Input.connect("joy_connection_changed",self,"joy_con_changed")

func _process(delta):
	
	#----------------------------------------------
	# gestion déplacement analog gauche
	
	#left analog move management
	#----------------------------------------------
	
	var left_analog_axis = Vector2(Input.get_joy_axis(nb_P, JOY_AXIS_0), Input.get_joy_axis(nb_P, JOY_AXIS_1))
	if Input.get_connected_joypads().size() > 0:
		if abs(left_analog_axis.length()) >= deadZone :
			position.x += 100 * delta * ( speedMultiplier * clamp(left_analog_axis.x,-1,1)) 
			position.y += 100 * delta * ( speedMultiplier * clamp(left_analog_axis.y,-1,1))
			print(left_analog_axis)
	
	#----------------------------------------------
	# gestion regard analog droit
	
	# right analog aim management
	#----------------------------------------------
	
	var right_analog_axis = Vector2(Input.get_joy_axis(nb_P, JOY_AXIS_2), Input.get_joy_axis(nb_P, JOY_AXIS_3))
	var joy_rot = atan2(right_analog_axis.y, right_analog_axis.x)
	
	if right_analog_axis.length() >= deadZone:
		rotation = joy_rot
	var ma = 300
	CrHair.rect_position.x = ma * (clamp(right_analog_axis.length(),0.2, 1) * 100) / 100
	
	#----------------------------------------------
	# Gestion du bouton pressé trigger de gauche et de l'axis de son analog
	
	# Left trigger pressure and analog axis management 
	#----------------------------------------------
	
	var trigger_left_axis = Input.get_joy_axis(nb_P,JOY_AXIS_6)
	if Input.is_joy_button_pressed(nb_P,JOY_AXIS_6): # Same as JOY_XBOX_A
		if trigger_left_axis >= 0: 
			trigger_action(trigger_left_axis, true)
			vibrate(Vector3(0.0,clamp(trigger_left_axis,0,1),0.1))
			print(clamp(trigger_left_axis,0,1))
	else:
		trigger_action(1,false)
	
	#----------------------------------------------
	# Affiche le bouton pressé
	
	# Show the pressed button
	#----------------------------------------------
	
	for i in range(16):
		if Input.is_joy_button_pressed(nb_P,i):
			print("Button at " + str(i) + " pressed, should be button: " + Input.get_joy_button_string(i))

	#----------------------------------------------
	# Modifie la couleur du cross hair
	
	# Change the cross hair color
	#----------------------------------------------

func trigger_action(n,r):
	if r == true :
		CrHair.modulate = Color(rand(0,n),rand(0,n),rand(0,n),clamp(n, 0.1, 1))
	else :
		CrHair.modulate = Color(n,n,n,0.1)

	#----------------------------------------------
	# renvoie un nombre aléatoire en min et max
	
	# Send a min and max random number 
	#----------------------------------------------

func rand(b,r):
	return(rand_range(b, r))

	#----------------------------------------------
	# gère la puissance de la vibration
	
	# Manage the vibration strong
	#----------------------------------------------

func vibrate(intentisy) :
	Input.start_joy_vibration(nb_P,intentisy.x, intentisy.y, intentisy.z)

	#----------------------------------------------
	# Print toutes les info d'une manette branchée
	
	# Print all stuff of a plugged controller
	#----------------------------------------------

func joy_con_changed(deviceid,isConnected):
	if isConnected:
		if deviceid == nb_P:
			show()
		print("Joystick " + str(deviceid) + " connected")
	if Input.is_joy_known(nb_P):
		print("Recognized and compatible joystick")
		print(Input.get_joy_name(nb_P) + " device connected")
	else:
		print("Joystick " + str(deviceid) + " disconnected")
		if deviceid == nb_P:
			hide()