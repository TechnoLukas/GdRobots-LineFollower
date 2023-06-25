extends Path3D

var prevangle
var pointpos

# Called when the node enters the scene tree for the first time.
func _ready():
	genarate_path(6)

func create_point(distance,angle):
	var prevpointpos=curve.get_point_position(curve.point_count-2)
	var currentpointpos=curve.get_point_position(curve.point_count-1)
	var x_axis = Vector3.RIGHT
	var cur = 10#abs(angle/2)
	prevangle=snapped(rad_to_deg(x_axis.angle_to(currentpointpos-prevpointpos)),0.01)
	pointpos=Vector3(distance*cos(deg_to_rad(prevangle+angle))+currentpointpos.x,0,distance*sin(deg_to_rad(prevangle+angle))+currentpointpos.z)
	
	curve.add_point(pointpos,Vector3(-cur,0,-abs(angle/3)),Vector3(cur,0,abs(angle/3)))
	print("n:"+str(curve.point_count)+"\n"+"current angle:"+str(angle)+"\n")

func genarate_path(n):
	while curve.point_count>2:
		curve.remove_point(curve.point_count-1)
	for i in range(n):
		create_point(20,randi_range(-20,20))
		#create_point(20,randi_range(-35,30))
		
	
func _process(delta):
	if $"../Robot":
		if $"../Robot".position.distance_to(curve.get_point_position(curve.point_count-1))<10:
			get_tree().reload_current_scene()


func _on_button_pressed():
	genarate_path(3)
