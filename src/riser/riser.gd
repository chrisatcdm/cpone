# Riser.gd
extends StaticBody2D

# --- Riser Properties ---
var pipe_to_soil_potential: int

# --- Node References ---
@onready var interaction_area: Area2D = $InteractionArea
@onready var potential_label: Label = $PotentialLabel # Reference to the Label node
@onready var label_display_timer: Timer = $LabelDisplayTimer # Reference to the Timer node

# --- Interaction State ---
var player_is_in_range: bool = false

# --- Initialization ---
func _ready():
	# Randomize potential
	pipe_to_soil_potential = randf_range(-500, -520)
	# Debug print using % formatting
	print("Riser '%s' initialized with potential: %s mV" % [self.name, pipe_to_soil_potential])

	# Connect signals from child nodes
	if interaction_area:
		interaction_area.player_entered_range.connect(_on_player_entered_interaction_range)
		interaction_area.player_exited_range.connect(_on_player_exited_interaction_range)
	else:
		# Using % formatting for printerr
		printerr("Riser (%s): InteractionArea node not found." % self.name)

	if label_display_timer:
		# Connect the timer's timeout signal to our hiding function
		label_display_timer.timeout.connect(_on_label_display_timer_timeout)
	else:
		# Using % formatting for printerr
		printerr("Riser (%s): LabelDisplayTimer node not found." % self.name)

# --- Signal Handlers ---
func _on_player_entered_interaction_range():
	player_is_in_range = true
	get_tree().call_group("player", "set_interactable", self)

func _on_player_exited_interaction_range():
	player_is_in_range = false
	get_tree().call_group("player", "clear_interactable", self)
	# Option: Hide label immediately when player leaves range, even if timer is running
	# if potential_label:
	#    potential_label.visible = false

# --- Public Method for Player Interaction ---
func read_potential() -> float:
	if player_is_in_range:
		# Print to console using % formatting
		print("--- Reading Riser '%s' --- Potential: %s mV ---" % [self.name, pipe_to_soil_potential])

		# Update and Show Label
		if potential_label and label_display_timer:
			# Format the text for display using % formatting (single value doesn't need array)
			potential_label.text = "%s mV" % pipe_to_soil_potential
			# Make the label visible
			potential_label.visible = true
			# Start the timer to hide it after a delay
			label_display_timer.start()

		return pipe_to_soil_potential
	else:
		# Using % formatting for printerr
		printerr("Riser (%s): Attempted to read potential, but player reported as out of range!" % self.name)
		return NAN # Return Not A Number for error state

# --- Timer Timeout Handler ---
# This function is called when the LabelDisplayTimer finishes counting down.
func _on_label_display_timer_timeout():
	# Hide the label
	if potential_label:
		potential_label.visible = false
