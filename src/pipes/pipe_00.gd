extends Node2D

# native potential in mV wrt CSE
@export var native_potential = -504

# depol rate is from 0 to 100
@export var depol_rate = 50

# structure resistance in ohms
@export var resistance = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
