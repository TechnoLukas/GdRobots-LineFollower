extends Path3D

var prevangle
var pointpos
@export var robot: VehicleBody3D
@export var counter: Label
var gate
var gate_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	gate=load("res://gate.tscn")
	genarate_path(3)

func create_point(distance,angle):
	var prevpointpos=curve.get_point_position(curve.point_count-2)
	var currentpointpos=curve.get_point_position(curve.point_count-1)
	var x_axis = Vector3.RIGHT
	var cur = 10#abs(angle/2)
	prevangle=snapped(rad_to_deg(x_axis.angle_to(currentpointpos-prevpointpos)),0.01)
	pointpos=Vector3(distance*cos(deg_to_rad(prevangle+angle))+currentpointpos.x,0,distance*sin(deg_to_rad(prevangle+angle))+currentpointpos.z)
	
	curve.add_point(pointpos,Vector3(-cur,0,-abs(angle/3)),Vector3(cur,0,abs(angle/3)))
	#print("n:"+str(curve.point_count)+"\n"+"current angle:"+str(angle)+"\n")

func genarate_path(n):
	var ang = randi_range(-20,20)
	while curve.point_count>2:
		curve.remove_point(curve.point_count-1)
	if gate_instance:
		gate_instance.queue_free()
	for i in range(n):
		create_point(20,ang)
	gate_instance = gate.instantiate()
	gate_instance.position=curve.get_point_position(curve.point_count-2)
	gate_instance.rotation_degrees=Vector3(0,90+ang,0)
	add_child(gate_instance)
		#create_point(20,randi_range(-35,30))
		
	
func _process(delta):
	print($"../Robot".position.distance_to(curve.get_point_position(curve.point_count-1)))
	if $"../Robot":
		if $"../Robot".position.distance_to(curve.get_point_position(curve.point_count-1))<20:
			reload()
			counter.text=str(int(counter.text)+1)
		if $"../Robot".position.y<0.44:
			counter.text="0"
			reload()


func _on_button_pressed():
	genarate_path(3)
	
func reload():
	robot.position=Vector3(0,0.5,0)
	robot.rotation_degrees=Vector3(0,90,0)
	robot.engine_force=0
	robot.brake=0.1
	robot.steering=move_toward(robot.steering, 0, 1)
	genarate_path(6)
	
