extends Node2D

@onready var entities_node = get_node_or_null("Entities") # Assuming your organizational Node2D is named "Entities"
@onready var player = _find_player()
@onready var areas = _find_areas()

func _ready():
	if player:
		print("Player node found in the world scene (via Entities node).")
		for area_node in areas:
			print("Area node found: ", area_node.name)
			var area_2d = area_node.get_node("Area2D")
			if area_2d:
				print("Connecting body_entered signal for area: ", area_node.name)
				area_2d.body_entered.connect(_on_body_entered)
			else:
				printerr("Error: Area2D node not found in: ", area_node.name)
	else:
		printerr("Error: Player node not found within the Entities node in the world scene.")

func _find_player() -> Node2D:
	if entities_node and entities_node.has_node("Player"):
		return entities_node.get_node("Player")
	else:
		return null

func _find_areas() -> Array: # Changed the return type hint to generic Array
	var found_areas = []
	if entities_node:
		for child in entities_node.get_children():
			if child is StaticBody2D and child.has_node("Area2D"):
				found_areas.append(child)
	return found_areas

func _on_body_entered(body: PhysicsBody2D):
	print("Body entered area: ", body.name) # Should now fire if setup is correct
	if body == player:
		print("Player's body entered an area!")
