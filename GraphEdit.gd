extends GraphEdit

func _ready():
	# Create the first GraphNode
	var node1 = GraphNode.new()
	add_child(node1)

	# Customize the appearance of node1
	var label1 = Label.new()
	label1.text = "Node 1"
	node1.add_child(label1)

	# Configure the input and output ports of node1
	node1.set_slot(0, true, 0, Color(0, 1, 0), false, -1, Color(0, 0, 0))
	node1.set_slot(1, false, -1, Color(0, 0, 0), true, 0, Color(1, 0, 0))

	# Create the second GraphNode
	var node2 = GraphNode.new()
	add_child(node2)

	# Customize the appearance of node2
	var label2 = Label.new()
	label2.text = "Node 2"
	node2.add_child(label2)

	# Configure the input and output ports of node2
	node2.set_slot(0, true, 0, Color(0, 1, 0), false, -1, Color(0, 0, 0))
	node2.set_slot(1, false, -1, Color(0, 0, 0), true, 0, Color(1, 0, 0))

	# Connect the output port of node1 to the input port of node2
	#node1.connect_to
	#node1.connect(1, node2, 0)
