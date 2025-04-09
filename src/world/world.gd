extends Node2D

@onready var entities_node = get_node_or_null("Entities") # Assuming your organizational Node2D is named "Entities"
@onready var player = _find_player()
@onready var areas = _find_areas()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check if the entities node is valid
	if player:
		print("Player node found in the world scene (via Entities node).")
		# Connect the body_entered signal for each area
		for area_node in areas:
			print("Area node found: ", area_node.name)
			var area_2d = area_node.get_node("Area2D")
			# Check if the area_2d node is valid
			if area_2d:
				print("Connecting body_entered signal for area: ", area_node.name)
				# Connect the body_entered signal to a specific instance of _on_body_entered
				area_2d.body_entered.connect(Callable(self._on_body_entered).bind(area_2d))
			else:
				printerr("Error: Area2D node not found in: ", area_node.name)
	else:
		printerr("Error: Player node not found within the Entities node in the world scene.")



# This function finds the Player node within the Entities node
func _find_player() -> Node2D:
	if entities_node and entities_node.has_node("Player"):
		return entities_node.get_node("Player")
	else:
		return null

# This function finds all StaticBody2D nodes that have an Area2D child node
func _find_areas() -> Array: # Changed the return type hint to generic Array
	var found_areas = []
	if entities_node:
		for child in entities_node.get_children():
			if child is StaticBody2D and child.has_node("Area2D"):
				found_areas.append(child)
	return found_areas

# This function is called when a body enters an area
func _on_body_entered(body: PhysicsBody2D, area: Area2D):
	print("Body entered area: ", area.name)
	print("Entering body name: ", body.name)
	if body == player:
		print("Player's body entered area: ", area.name)
		# Get the root node of the scene that owns the Area2D
		var root_of_area_scene = area
		while root_of_area_scene .get_parent():
			root_of_area_scene = root_of_area_scene.get_parent()

		print("Root node of the scene containing this area: ", root_of_area_scene.name)
		# Now you can access variables of this root node, e.g.,
		if "native_riser_potential" in root_of_area_scene:
			var potential = root_of_area_scene.native_riser_potential
			print("Native Riser Potential (from root): ", potential)
		else:
			print("Warning: 'native_riser_potential' not found on the root node of this scene.")
