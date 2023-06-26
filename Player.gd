extends VehicleBody3D

@export var leftcam: Node3D
@export var rightcam: Node3D
@export var leftc: ColorRect
@export var rightc: ColorRect
@export var KPl: Slider
@export var KIl: Slider
@export var KDl: Slider


const MAX_STEER_ANGLE = 0.6
const STEER_SPEED = 1.5
const MAX_ENGINE_FORCE = 50
const MAX_BRAKE_FORCE = 5
const MAX_SPEED = 6
var steer_target = 0.0
var steer_angle = 0.0
var stastdir

var ERR: float = 0.0
var PREVERR: float = 0.0
var INT: float = 0.0

var KP = 0.5
var KI = 0.01
var KD = 0.5

func _ready():
	stastdir=JSON.parse_string(loadc())
	KP=stastdir["KP"]
	KI=stastdir["KI"]
	KD=stastdir["KD"]
	KPl.value=KP
	KIl.value=KI
	KDl.value=KD

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

	
	if not (snappedf(leftsensorC,0.01)>0.5 and snappedf(rightsensorC,0.01)>0.5):
		ERR = (rightsensorC/leftsensorC)-(leftsensorC/rightsensorC)
	
		if !is_nan(ERR):
			INT = INT+ERR
		if is_inf(INT):
			INT=0.0
	
	print("KP:",KP,"    KI:",KI,"    KD:",KD)
	steer_target=ERR*KP+(PREVERR-ERR)*KD+INT*KI
	
	PREVERR=ERR
	#print(snapped(leftsensorC,0.01),"    ",snapped(rightsensorC,0.01),"    ",snapped(ERR,0.01))
	if linear_velocity.length() < MAX_SPEED:
		engine_force = MAX_ENGINE_FORCE
	
	
func _on_pl_value_changed(value):
	KP=value
	stastdir=JSON.parse_string(loadc())
	stastdir["KP"]=KP
	savec(str(stastdir))


func _on_il_value_changed(value):
	KI=value
	stastdir=JSON.parse_string(loadc())
	stastdir["KI"]=KI
	savec(str(stastdir))


func _on_dl_value_changed(value):
	KD=value
	stastdir=JSON.parse_string(loadc())
	stastdir["KD"]=KD
	savec(str(stastdir))

func savec(content):
	var file = FileAccess.open("res://stats.txt", FileAccess.WRITE)
	file.store_string(content)

func loadc():
	var file = FileAccess.open("res://stats.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content
	
