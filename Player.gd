extends VehicleBody3D

@export var leftcam: Node3D
@export var rightcam: Node3D
@export var leftc: ColorRect
@export var rightc: ColorRect

const MAX_STEER_ANGLE = 0.6
const STEER_SPEED = 1.5
const MAX_ENGINE_FORCE = 50
const MAX_BRAKE_FORCE = 5
const MAX_SPEED = 6
var steer_target = 0.0
var steer_angle = 0.0
var turnk

	
	

func _physics_process(delta):
	drive(delta)
	autopilot(delta)
	
	
func drive(delta):
	var forward = Input.get_action_strength("forward")
	var backward = Input.get_action_strength("backward")
	var left = Input.get_action_strength("left")
	var right = Input.get_action_strength("right")
	
	#steer_target = left - right
	steer_target *= MAX_STEER_ANGLE
	if forward and linear_velocity.length() < MAX_SPEED:
		engine_force = MAX_ENGINE_FORCE
	elif backward:
		engine_force = -MAX_ENGINE_FORCE
	else:
		engine_force = 0
		brake=0.1
	
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
	
func autopilot(delta):
	var leftsensor=leftcam.get_viewport().get_texture().get_image()
	leftsensor.resize(16,16)
	leftsensor=leftsensor.get_data()
	var leftsensorC = 0.0
	for i in leftsensor:
		leftsensorC+=i
	leftsensorC=leftsensorC/leftsensor.size()/255
	
	var rightsensor=rightcam.get_viewport().get_texture().get_image()
	rightsensor.resize(16,16)
	rightsensor=rightsensor.get_data()
	var rightsensorC = 0.0
	for i in rightsensor:
		rightsensorC+=i
	rightsensorC=rightsensorC/rightsensor.size()/255

	leftc.color=Color(leftsensorC,leftsensorC,leftsensorC)
	rightc.color=Color(rightsensorC,rightsensorC,rightsensorC)
	if not (snapped(leftsensorC,0.01)>0.5 and snapped(rightsensorC,0.01)>0.5):
		turnk = ((rightsensorC/leftsensorC)-(leftsensorC/rightsensorC))/2
	#print(snapped(leftsensorC,0.01),"    ",snapped(rightsensorC,0.01),"    ",snapped(turnk,0.01))
	steer_target=turnk
	if linear_velocity.length() < MAX_SPEED/1:
		engine_force = MAX_ENGINE_FORCE
	
	
		
	
