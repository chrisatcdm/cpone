# Riser.gd
extends StaticBody2D

# --- Riser Properties ---
var native_potential: float # Initial random value
var current_potential: float # Changes based on CP system state
var total_anode_influence: float = 0.0 # Keep track of summed influence from anodes

# --- Node References ---
@onready var interaction_area: Area2D = $InteractionArea
@onready var potential_label: Label = $PotentialLabel
@onready var label_display_timer: Timer = $LabelDisplayTimer

# --- Interaction State ---
var player_is_in_range: bool = false

# --- Initialization ---
func _ready():
	native_potential = randf_range(-600.0, -500.0)
	current_potential = native_potential # Start with native potential
	print("Riser '%s' initialized with potential: %.1f mV" % [self.name, native_potential]) # Print native at start

	# Connect signals... (rest of _ready as before)
	if interaction_area:
		interaction_area.player_entered_range.connect(_on_player_entered_interaction_range)
		interaction_area.player_exited_range.connect(_on_player_exited_interaction_range)
	else:
		printerr("Riser (%s): InteractionArea node not found." % self.name)

	if label_display_timer:
		label_display_timer.timeout.connect(_on_label_display_timer_timeout)
	else:
		printerr("Riser (%s): LabelDisplayTimer node not found." % self.name)

# --- Signal Handlers ---
func _on_player_entered_interaction_range():
	player_is_in_range = true
	get_tree().call_group("player", "set_interactable", self)

func _on_player_exited_interaction_range():
	player_is_in_range = false
	get_tree().call_group("player", "clear_interactable", self)
	# if potential_label: potential_label.visible = false

# --- NEW: Methods for Anode Interaction ---
func add_anode_influence(influence: float):
	total_anode_influence += influence
	# Recalculate current potential based on native and total influence
	current_potential = native_potential + total_anode_influence
	print("Riser '%s' received influence %.1f, new potential: %.1f mV" % [self.name, influence, current_potential])

func remove_anode_influence(influence: float):
	total_anode_influence -= influence
	# Prevent influence from going negative if multiple anodes disconnect improperly
	total_anode_influence = max(0.0, total_anode_influence)
	# Recalculate current potential
	current_potential = native_potential + total_anode_influence
	print("Riser '%s' removed influence %.1f, new potential: %.1f mV" % [self.name, influence, current_potential])

# --- Public Method for Player Interaction ---
func read_potential() -> float:
	if player_is_in_range:
		var potential_to_display : float
		var label_text : String
		var console_text : String

		# Check the global interruption state from the Autoload script
		if CPSystemManager.system_interrupted:
			# System IS Interrupted - Read "Off" potential (Native)
			potential_to_display = native_potential
			label_text = "%.1f mV (Off)" % potential_to_display
			console_text = "Potential: %s (Instant Off)" % label_text
		else:
			# System is NOT Interrupted - Read "On" potential (Current)
			potential_to_display = current_potential
			label_text = "%.1f mV (On)" % potential_to_display
			console_text = "Potential: %s (System On)" % label_text

		# Print to console with state indication
		print("--- Reading Riser '%s' --- %s ---" % [self.name, console_text])

		# Update and Show Label (common logic for both states)
		if potential_label and label_display_timer:
			potential_label.text = label_text # Show "On" or "Off" state on label
			potential_label.visible = true
			label_display_timer.start()

		return potential_to_display # Return the relevant potential value
	else:
		printerr("Riser (%s): Attempted to read potential, but player reported as out of range!" % self.name)
		return NAN

# --- Timer Timeout Handler ---
func _on_label_display_timer_timeout():
	if potential_label:
		potential_label.visible = false
