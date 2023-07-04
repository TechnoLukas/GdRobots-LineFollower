extends ColorRect

var err_graph
var turn_graph
var err_graph_pointlist = []
var turn_graph_pointlist = []

var nsteps=50
var ystep = size.y/4
var xstep = size.x/nsteps
var count = 0
var robot
# Called when the node enters the scene tree for the first time.
func _ready():
	print(size.x)
	
	for i in range (nsteps+1):
		err_graph_pointlist.append(0)
		turn_graph_pointlist.append(0)

	for i in range (5):
		var line = Line2D.new() # Create a new Sprite2D.
		line.width=2
		line.add_point(Vector2(0,ystep*i))
		line.add_point(Vector2(size.x,ystep*i))
		add_child(line)
		
	err_graph = Line2D.new()
	add_child(err_graph)
	turn_graph = Line2D.new()
	add_child(turn_graph)
	
	robot=$".."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	robot=$".."
	
	count+=1
	if count>=0:
		count=0
		
		#print(robot.ERR, "   ", robot.steer_target)
		err_graph.queue_free()
		err_graph_pointlist.pop_front()
		if robot!=null:
			err_graph_pointlist.append(robot.ERR*30)#randf_range(size.y/3,-size.y/3)
		else:
			err_graph_pointlist.append(0)
		err_graph = Line2D.new()
		err_graph.width=6
		err_graph.default_color=Color(0.5, 0, 0)#Color(0, 0.5, 0.6)
		for i in range(nsteps+1):
			if(abs(err_graph_pointlist[i])<size.y/2):
				err_graph.add_point(Vector2(xstep*i,size.y/2+err_graph_pointlist[i]))
			elif err_graph_pointlist[i]>size.y/2:
				err_graph.add_point(Vector2(xstep*i,size.y))
			else:
				err_graph.add_point(Vector2(xstep*i,0))
		add_child(err_graph)
		
		
		turn_graph.queue_free()
		turn_graph_pointlist.pop_front()
		if robot!=null:
			turn_graph_pointlist.append(robot.steer_target*30)#randf_range(size.y/3,-size.y/3)
		else:
			turn_graph_pointlist.append(0)
		turn_graph = Line2D.new()
		turn_graph.width=6
		turn_graph.default_color=Color(0, 0.5, 0.6)
		for i in range(nsteps+1):
			if(abs(turn_graph_pointlist[i])<size.y/2):
				turn_graph.add_point(Vector2(xstep*i,size.y/2+turn_graph_pointlist[i]))
			elif turn_graph_pointlist[i]>size.y/2:
				turn_graph.add_point(Vector2(xstep*i,size.y))
			else:
				turn_graph.add_point(Vector2(xstep*i,0))
		add_child(turn_graph)
		
	#draw_graph(robot.ERR*30,err_graph_pointlist,err_graph,Color(0, 0.5, 0.6),1)
	
"""		
func draw_graph(val, list, graph, col, tick):
	if is_instance_valid(graph): graph.queue_free()
	list.pop_front()
	if robot!=null:
		list.append(val)#randf_range(size.y/3,-size.y/3)
	else:
		list.append(0)
	graph = Line2D.new()
	graph.width=6
	graph.default_color=col
	for i in range(nsteps+1):
		if(abs(list[i])<size.y/2):
			graph.add_point(Vector2(xstep*i,size.y/2+list[i]))
	add_child(graph)
	
	print(val)"""
	
