extends Area2D

@export var text_key: String = ""
@onready var pipe_00: Node2D = $"../Pipe_00"

var area_active: bool = false


func _input(event):
	if area_active and event.is_action_pressed("interact"):
		SignalBus.emit_signal("display_dialog", text_key)
		SignalBus.emit_signal("display_potential", "123456")
		print("this fired.")
		
func _on_DialogArea_area_entered(_area):
	area_active = true
	
func _on_DialogArea_area_exited(_area):
	area_active = false
