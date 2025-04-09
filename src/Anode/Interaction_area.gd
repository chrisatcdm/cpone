# InteractionArea.gd (Ensure this is attached to the Area2D in Anode.tscn)
extends Area2D

signal player_entered_range
signal player_exited_range

# No player reference needed here, just detect group
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_entered_range.emit()

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_exited_range.emit()
