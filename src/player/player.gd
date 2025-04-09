extends CharacterBody2D

@export var speed = 100
@export var friction = 0.5
@export var acceleration = 0.1

@onready var animated_sprite = $AnimatedSprite2D

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
		animated_sprite.flip_h = false
	if Input.is_action_pressed('move_left'):
		input.x -= 1
		animated_sprite.flip_h = true
	if Input.is_action_pressed('move_down'):
		input.y += 1
	if Input.is_action_pressed('move_up'):
		input.y -= 1
	if input == Vector2.ZERO:
		animated_sprite.play('idle')
	else:
		animated_sprite.play('run')

	return input

# Variable to store the Riser node that is currently in range and interactable.
var current_interactable: Node = null # Start with nothing interactable

# Called every physics frame. Delta is time since last frame.
func _physics_process(delta):
	# --- Add your player movement code here (handle input, move_and_slide, etc.) ---
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()

	# In Player.gd (inside _physics_process or _process)

	# --- Handle Interaction Input ---
	if Input.is_action_just_pressed("interact"): # Use your main interact action name
		if current_interactable != null:
			# --- UPDATED LOGIC ---
			# Priority 1: Check if it has the 'interact()' method (used by Anode)
			if current_interactable.has_method("interact"):
				current_interactable.interact() # Call the Anode's connect/disconnect toggle

			# Priority 2: If not interact(), check if it has 'read_potential()' (used by Riser)
			elif current_interactable.has_method("read_potential"):
				current_interactable.read_potential() # Call the Riser's read function

			# Fallback: If neither known method is found
			else:
				printerr("Player: Target '%s' has no known interaction method ('interact' or 'read_potential')." % current_interactable.name)
		# --- END UPDATED LOGIC ---

	# else:
		# Optional: print("Player: Interact pressed, but nothing in range.")

# --- Methods Called by Risers via call_group ---

# Called by a Riser when the player enters its InteractionArea.
func set_interactable(riser_node: Node):
	current_interactable = riser_node
	print("Player: Can now interact with '%s'." % riser_node.name)
	# TODO: Show UI prompt like "[E] Read Potential"

# Called by a Riser when the player exits its InteractionArea.
func clear_interactable(riser_node: Node):
	# Important Check: Only clear if the object telling us to clear
	# IS the one we are currently targeting. Avoids race conditions if player
	# quickly moves between two overlapping interaction areas.
	if current_interactable == riser_node:
		print("Player: No longer interacting with '%s'." % riser_node.name)
		current_interactable = null
		# TODO: Hide UI prompt
