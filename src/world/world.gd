extends Node2D

@onready var pipe_00: Node2D = $Dialog/Pipe_00

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		#print(str(delta))
		print(str(pipe_00.native_potential))
