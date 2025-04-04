extends CharacterBody2D


@export var speed = 130 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#func _ready():
	#screen_size = get_viewport_rect().size
	#hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
		animated_sprite.flip_h = false
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
		animated_sprite.flip_h = true
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
