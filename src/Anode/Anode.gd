# Anode.gd
extends Node2D

# --- Anode Properties ---
@export var current_output: float = -1000.0
@export var target_pipeline_group: StringName = &""

# --- State ---
var is_connected: bool = false

# --- Node References ---
@onready var interaction_area: Area2D = $InteractionArea

# --- Lifecycle Methods ---
func _ready():
	# Connect to signals from our child InteractionArea
	if interaction_area:
		interaction_area.player_entered_range.connect(_on_player_entered_interaction_range)
		interaction_area.player_exited_range.connect(_on_player_exited_interaction_range)
	else:
		printerr("Anode (%s): InteractionArea node not found." % self.name)

# --- Remove Temporary Test Code ---
# Delete or comment out the _process function if you added it for testing:
# func _process(delta):
#     if Input.is_action_just_pressed("interact_anode"):
#         interact()

# --- Signal Handlers from InteractionArea --- NEW ---
func _on_player_entered_interaction_range():
	# Tell the player character that THIS anode is now available for interaction.
	get_tree().call_group("player", "set_interactable", self)
	# print("Anode (%s): Player entered range." % self.name) # Optional debug

func _on_player_exited_interaction_range():
	# Tell the player character that THIS anode is no longer the interaction target.
	get_tree().call_group("player", "clear_interactable", self)
	# print("Anode (%s): Player exited range." % self.name) # Optional debug

# --- Connection Logic (As before) ---
func connect_to_system():
	# ... (keep existing code here) ...
	if is_connected or target_pipeline_group == &"":
		if target_pipeline_group == &"":
			printerr("Anode '%s': Cannot connect, Target Pipeline Group not set." % self.name)
		return
	is_connected = true
	print("Anode '%s' connecting to system '%s'." % [self.name, target_pipeline_group])
	var risers = get_tree().get_nodes_in_group(target_pipeline_group)
	printerr("DEBUG: Found %d nodes in group '%s'" % [risers.size(), target_pipeline_group]) # Keep debug prints for now
	for riser in risers:
		printerr("DEBUG: Processing node from group: %s" % riser.name)
		if riser.has_method("add_anode_influence"):
			printerr("DEBUG: Riser '%s' HAS add_anode_influence method. Calling it." % riser.name)
			riser.add_anode_influence(current_output)
		else:
			printerr("ERROR: Node '%s' in group '%s' does NOT have add_anode_influence method!" % [riser.name, target_pipeline_group])

func disconnect_from_system():
	# ... (keep existing code here) ...
	if not is_connected or target_pipeline_group == &"":
		return
	is_connected = false
	print("Anode '%s' disconnecting from system '%s'." % [self.name, target_pipeline_group])
	var risers = get_tree().get_nodes_in_group(target_pipeline_group)
	for riser in risers:
		if riser.has_method("remove_anode_influence"):
			riser.remove_anode_influence(current_output)

# --- Player Interaction ---
# This is now called by the Player script when interact key is pressed
func interact():
	print("Player interaction triggered connect/disconnect on Anode '%s'." % self.name)
	if is_connected:
		disconnect_from_system()
	else:
		if target_pipeline_group != &"":
			connect_to_system()
		else:
			printerr("Anode '%s': Cannot connect, Target Pipeline Group not set." % self.name)
