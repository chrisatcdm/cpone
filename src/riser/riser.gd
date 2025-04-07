extends StaticBody2D

@export var riser_native_potential: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# func _on_area_2d_area_entered(area:Area2D) -> void:
# 	print("Area entered")
# 	pass # Replace with function body.


func _on_area_2d_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int) -> void:
	print("Area shape entered")
	pass # Replace with function body.
