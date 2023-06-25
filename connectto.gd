extends Node3D

@export var target: Node3D
@export var posshift: Vector3
@export var rotshift: Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position=target.global_position+posshift
	global_rotation_degrees=target.global_rotation_degrees+rotshift
