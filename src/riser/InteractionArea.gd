# InteractionArea.gd
extends Area2D

# Signals to notify the parent (the Riser script)
signal player_entered_range
signal player_exited_range

# We only need to know if the body entering/leaving is the player.
# The actual player reference management happens elsewhere (e.g., the Riser or Player script).

func _ready():
	# Ensure the signals are connected to this script's methods.
	# This could also be done in the editor.
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	# Check if the entering body is in the "player" group.
	if body.is_in_group("player"):
		player_entered_range.emit()

func _on_body_exited(body: Node2D):
	# Check if the exiting body is in the "player" group.
	if body.is_in_group("player"):
		player_exited_range.emit()
