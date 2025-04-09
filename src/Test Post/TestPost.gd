# TestPost.gd
extends Node2D # Or StaticBody2D if you used that

# --- Node References ---
@onready var interaction_area: Area2D = $InteractionArea

# --- Initialization ---
func _ready():
	# Connect to signals from our child InteractionArea
	if interaction_area:
		interaction_area.player_entered_range.connect(_on_player_entered_interaction_range)
		interaction_area.player_exited_range.connect(_on_player_exited_interaction_range)
	else:
		printerr("TestPost (%s): InteractionArea node not found." % self.name)

# --- Signal Handlers from InteractionArea ---
func _on_player_entered_interaction_range():
	# Tell the player this test post is interactable
	get_tree().call_group("player", "set_interactable", self)
	# print("TestPost (%s): Player entered range." % self.name) # Optional debug

func _on_player_exited_interaction_range():
	# Tell the player this test post is no longer the target
	get_tree().call_group("player", "clear_interactable", self)
	# print("TestPost (%s): Player exited range." % self.name) # Optional debug

# --- Player Interaction ---
# Called by Player script when interact key is pressed near this post
func interact():
	# Check the current global state and toggle it
	if CPSystemManager.system_interrupted:
		print("TestPost (%s): Player action -> Restoring system." % self.name)
		CPSystemManager.restore_system()
	else:
		print("TestPost (%s): Player action -> Interrupting system." % self.name)
		CPSystemManager.interrupt_system()

	# Optional: Add visual feedback on the test post itself later (e.g., change sprite color)
